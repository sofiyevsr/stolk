package utils

import (
	"database/sql"
	"errors"
	"feedparser/types"
	"fmt"
	"net/url"
	"strings"
	"time"

	"github.com/microcosm-cc/bluemonday"
	"github.com/mmcdole/gofeed"
)

type result struct {
	feed types.CustomFeed
}

func tryParseDate(date string) (time.Time, error) {
	if date == "" {
		return time.Time{}, errors.New("date is empty")
	}
	if string(date[10]) == "+" {
		newDate := []byte(date)
		newDate[10] = 'T'
		newDate[len(newDate)-2] = ':'
		newDate = append(newDate, '0')
		parsedDate, err := time.Parse(time.RFC3339, string(newDate))
		if err == nil {
			return parsedDate.UTC(), nil
		}
	}
	parsedDate, err := time.Parse(time.RFC3339, date)
	if err != nil {
		return time.Time{}, err
	}
	return parsedDate.UTC(), nil
}

// Try to correct url
func tryParseLink(rawLink string) (string, error) {
	if strings.HasPrefix(rawLink, "//") {
		return "http:" + rawLink, nil
	}
	if rawLink == "" {
		return "", errors.New("link is nil")
	}
	// some sources has two scheme so replace it
	if strings.Count(rawLink, "https:") > 1 {
		rawLink = strings.Replace(rawLink, "https:", "", 1)
	}

	link, err := url.ParseRequestURI(rawLink)
	if err != nil || link.Scheme == "" || link.Host == "" {
		return "", errors.New("link is invalid")
	}
	return link.String(), nil
}

func stripHTMLTags(str string) (string, error) {
	a := bluemonday.StrictPolicy()
	escaped := a.Sanitize(str)
	if escaped == "" {
		return "", errors.New("can't parse string")
	}
	return escaped, nil
}

func prepareFeed(feed *gofeed.Item, name string) {

	if strings.Contains(feed.Link, "lent.az") && strings.HasSuffix(feed.Link, "/1") {
		feed.Link = feed.Link[:len(feed.Link)-2]
	}
	if apaIndex := strings.Index(feed.Link, "apa.az"); apaIndex != -1 {
		lang := feed.Link[apaIndex+7 : apaIndex+9]
		if lang != "az" && lang != "ru" {
			feed.Link = feed.Link[:apaIndex] + name + feed.Link[apaIndex+6:]
		}
	}
}

func ProcessFeed(item *gofeed.Item, lastTime *time.Time, v *types.Feed) (result, error) {
	prepareFeed(item, v.Name)

	if item.Title == "" {
		return result{}, errors.New("empty_title")
	}

	feed := types.CustomFeed{
		Source: v.Id,
	}

	feedName, err := stripHTMLTags(item.Title)
	if err != nil {
		return result{}, err
	}
	feed.Name = feedName

	feed.Link, err = tryParseLink(item.Link)
	if err != nil || feed.Link == "" {
		return result{}, err
	}

	if item.Description == "" {
		feed.Description = sql.NullString{}
	}

	if item.PublishedParsed != nil {
		feed.PubDate = item.PublishedParsed.UTC()
	} else {
		parsedTime, err := tryParseDate(item.Published)
		if err != nil || parsedTime.IsZero() {
			fmt.Println("error while parsing pub_date")
			return result{}, err
		}
		feed.PubDate = parsedTime
	}

	if feed.PubDate.Equal(*lastTime) || feed.PubDate.Before(*lastTime) {
		return result{}, errors.New("old_feed")
	}

	var parsedImage string
	if item.Image != nil {
		imageLink, err := tryParseLink(item.Image.URL)
		if err != nil || imageLink == "" {
			return result{}, err
		}
		parsedImage = imageLink
	}

	// Look for image in enclosures
	allFiles := item.Enclosures
	if allFiles != nil && parsedImage == "" {
		for _, ig := range allFiles {
			if strings.Contains(ig.Type, "image") {
				img, err := tryParseLink(ig.URL)
				if err == nil {
					parsedImage = img
				}
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
		catAlias := strings.ToLower(strings.TrimSpace(item.Categories[0]))
		// Set alias name in feed object to be transformed to integer on final step
		feed.CatAliasName = catAlias
	}
	return result{
		feed: feed,
	}, nil
}
