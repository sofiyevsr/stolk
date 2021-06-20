package utils

import (
	"database/sql"
	"errors"
	"feedparser/types"
	"fmt"
	"net/url"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/jmoiron/sqlx"
	"github.com/mmcdole/gofeed"
)

func tryParseDate(date string) (time.Time, error) {
	if date != "" && string(date[10]) == "+" {
		newDate := []byte(date)
		newDate[10] = 'T'
		newDate[len(newDate)-2] = ':'
		newDate = append(newDate, '0')
		parsedDate, err := time.Parse(time.RFC3339, string(newDate))
		if err == nil {
			return parsedDate.UTC(), nil
		}
	}
	return time.Time{}, errors.New("can't parse date")
}

func tryParseLink(link string) (string, error) {
	if link != "" {
		imageUrl, imageErr := url.Parse(link)
		if imageErr != nil {
			return "", errors.New("link is invalid")
		}
		imageUrl.Scheme = "https"
		return imageUrl.String(), nil
	}
	return "", errors.New("link is nil")
}

// i int -> index of feed.item aka "a news"
// v Feed -> a news object
// fp Parser
// c chan CustomFeed -> channel to receive feeds

func ParseFeed(i int, v types.Feed, sources *[]types.LastPubDateForSource, c chan types.Result) {
	defer func() {
		if r := recover(); r != nil {
			c <- types.Result{
				Feed: []types.CustomFeed{},
				Err:  errors.New("parsing error"),
			}
			fmt.Printf("error occured inside goroutine %s \n", v.Name)
		}
	}()
	fp := gofeed.NewParser()
	beforeParse := time.Now()
	remoteFeed, err := fp.ParseURL(v.Feed)
	fmt.Printf("parsing %s took %v \n", v.Name, time.Since(beforeParse))
	if err != nil {
		panic(errors.New(fmt.Sprintf("error while parsing %s \n", v.Name)))
	}
	fmt.Printf("parsing feed: %s, len: %d \n", v.Name, remoteFeed.Len())
	id, parseErr := strconv.ParseInt(v.Id, 10, 64)
	if parseErr != nil {
		panic(errors.New(""))
	}
	// lookup for source and its last pub_date
	var current time.Time
	for _, source := range *sources {
		if source.Source == int(id) {
			if source.PubDate.Valid {
				temp, err := time.Parse(time.RFC3339, source.PubDate.String)
				if err == nil {
					current = temp
				}
			}
		}
	}

	var cats []types.CatAlias
	var feeds []types.CustomFeed

	for _, item := range remoteFeed.Items {

		if item.Title == "" {
			continue
		}

		feed := types.CustomFeed{
			Name:   item.Title,
			Source: int(id),
		}

		link, linkError := tryParseLink(item.Link)
		if linkError != nil || link == "" {
			continue
		}
		feed.Link = link

		if item.Description == "" {
			feed.Description = sql.NullString{}
		}

		if item.PublishedParsed != nil {
			feed.PubDate = item.PublishedParsed.UTC()
		} else {
			parsedTime, err := tryParseDate(item.Published)
			if err != nil {
				continue
			}
			feed.PubDate = parsedTime
		}

		if feed.PubDate.Equal(current) || feed.PubDate.Before(current) {
			continue
		}

		var parsedImage string
		if item.Image != nil {
			imageLink, imageError := tryParseLink(item.Image.URL)
			if imageError != nil || imageLink == "" {
				continue
			}
			parsedImage = imageLink
		}

		// Look for image in enclosures
		allFiles := item.Enclosures
		if allFiles != nil && parsedImage == "" {
			for _, v := range allFiles {
				if strings.Contains(v.Type, "image") {
					parsedImage = v.URL
					break
				}
			}
		}
		if parsedImage == "" {
			feed.ImageLink = sql.NullString{String: parsedImage, Valid: false}
		} else {
			feed.ImageLink = sql.NullString{String: parsedImage, Valid: true}
		}

		if item.Categories != nil && item.Categories[0] != "" {
			cats = append(cats, types.CatAlias{
				Alias: strings.ToLower(strings.TrimSpace(item.Categories[0])),
			})
		}
		feeds = append(feeds, feed)
	}
	// send feeds array through channel
	c <- types.Result{
		Feed: feeds,
		Err:  nil,
	}

	saveCategoryAlias(cats)
	return
}

func saveCategoryAlias(cats []types.CatAlias) error {
	if cats == nil || len(cats) == 0 {
		return errors.New("empty cats")
	}
	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		return err
	}
	_, e := db.NamedExec(`INSERT INTO 
	 category_alias(alias,category)
	 VALUES(:alias,:category) ON CONFLICT(alias) DO NOTHING;
`, cats)
	if e != nil {
		fmt.Printf("error while cats save: %v", e)
	}
	return nil
}
