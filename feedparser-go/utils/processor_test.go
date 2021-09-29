package utils

import (
	"testing"
	"time"

	"github.com/mmcdole/gofeed"
	"github.com/stretchr/testify/assert"
)

func TestTitleNotEmpty(t *testing.T) {
	feed := Feed{}
	item := gofeed.Item{
		Title: "",
	}
	lastTime := time.Now()
	_, err := ProcessFeed(&item, lastTime, &feed)
	assert.NotNil(t, err)
}

func TestIfOldNewsIgnored(t *testing.T) {
	feed := Feed{}
	currentTime := time.Now()
	item := gofeed.Item{
		Title:           "test",
		PublishedParsed: &currentTime,
		Link:            "https://example.com",
	}
	lastTime := time.Now().Add(time.Minute * 1)
	_, err := ProcessFeed(&item, lastTime, &feed)
	assert.NotNil(t, err)
	assert.EqualError(t, err, "old_feed")
}

func TestNewsProcessedTimeIsNil(t *testing.T) {
	feed := Feed{}
	currentTime := time.Now()
	item := gofeed.Item{
		Title:           "test",
		PublishedParsed: &currentTime,
		Link:            "https://example.com",
	}
	lastTime := time.Time{}
	_, err := ProcessFeed(&item, lastTime, &feed)
	assert.Nil(t, err)
}
