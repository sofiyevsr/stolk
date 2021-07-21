package utils

import (
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/mmcdole/gofeed"
)

type CustomFeed struct {
	Name         string         `db:"title"`
	PubDate      time.Time      `db:"pub_date"`
	ImageLink    sql.NullString `db:"image_link"`
	Link         string         `db:"feed_link"`
	Source       int            `db:"source_id"`
	CatAlias     sql.NullInt32  `db:"category_alias_id"`
	CatAliasName string         `db:"-"`
}

func ProcessFeed(item *gofeed.Item, lastTime time.Time, v *Feed) (CustomFeed, error) {
	prepareFeed(item, v.Name)

	if item.Title == "" {
		return CustomFeed{}, errors.New("empty_title")
	}

	feed := CustomFeed{
		Source: v.Id,
	}

	feedName, err := stripHTMLTags(item.Title, true)
	if err != nil {
		return CustomFeed{}, err
	}
	feed.Name = feedName

	feed.Link, err = tryParseLink(item.Link)
	if err != nil || feed.Link == "" {
		return CustomFeed{}, err
	}

	if item.PublishedParsed != nil {
		feed.PubDate = item.PublishedParsed.UTC()
	} else {
		parsedTime, err := tryParseDate(item.Published)
		if err != nil || parsedTime.IsZero() {
			fmt.Println("error while parsing pub_date")
			return CustomFeed{}, err
		}
		feed.PubDate = parsedTime.UTC()
	}

	currentDate := time.Now().UTC()

	if !feed.PubDate.IsZero() && (feed.PubDate.Equal(lastTime) || feed.PubDate.Before(lastTime) || feed.PubDate.After(currentDate)) {
		return CustomFeed{}, errors.New("old feed")
	}

	var parsedImage string
	if item.Image != nil {
		imageLink, err := tryParseLink(item.Image.URL)
		if err == nil && imageLink != "" {
			parsedImage = imageLink
		}
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

	// If single item doesn't have category
	// look if source has category
	if feed.CatAliasName == "" && v.CategoryAlias.Valid == true {
		feed.CatAliasName = v.CategoryAlias.String
	}
	return feed, nil
}
