package utils

import (
	"testing"
	"time"

	"github.com/mmcdole/gofeed"
	"github.com/stretchr/testify/assert"
)

func TestFeedHaveTitle(t *testing.T) {
	item := &gofeed.Item{
		Title: "",
	}
	_, err := ProcessFeed(item, time.Time{}, &Feed{})
	assert.NotNil(t, err)
}

func TestFeedLink(t *testing.T) {
	item := &gofeed.Item{
		Link: "",
	}
	_, err := ProcessFeed(item, time.Time{}, &Feed{})
	assert.NotNil(t, err)
}

func TestParseLink(t *testing.T) {
	// musavat
	link := "//cdn.test.com"
	parsedLink, err := tryParseLink(link)
	assert.Nil(t, err)
	assert.Equal(t, "http://cdn.test.com", parsedLink)

	_, err = tryParseLink("test")
	assert.NotNil(t, err)
	// some sites has such link
	str, err := tryParseLink("https:https://test.com")
	assert.Nil(t, err)
	assert.Equal(t, "https://test.com", str)
}

func TestSpecificLinkFixes(t *testing.T) {
	// lent.az
	item := gofeed.Item{
		Link: "https://lent.az/blabla/1",
	}
	prepareFeed(&item, "lent.az")
	assert.Equal(t, "https://lent.az/blabla", item.Link)
	item = gofeed.Item{
		Link: "https://apa.az/blabla",
	}
	prepareFeed(&item, "apa.az/az")
	assert.Equal(t, "https://apa.az/az/blabla", item.Link)
}
