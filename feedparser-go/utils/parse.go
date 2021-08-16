package utils

import (
	"context"
	"fmt"
	"time"

	"github.com/mmcdole/gofeed"
)

const PARSE_TIMEOUT = time.Second * 10

type Result struct {
	Feed    []CustomFeed
	Aliases []CatAlias
	Err     error
}

// i int -> index of feed.item aka "a news"
// v Feed -> a news object
// fp Parser
// c chan CustomFeed -> channel to receive feeds

func ParseFeed(i int, v Feed, sources []LastPubDateForSource, categoryAliases []CatAlias, c chan Result) {

	fp := gofeed.NewParser()
	beforeParse := time.Now()

	// -- Timeout Feed Parser
	bctx := context.Background()
	ctx, cancel := context.WithTimeout(bctx, PARSE_TIMEOUT)
	defer cancel()
	remoteFeed, err := fp.ParseURLWithContext(v.Feed, ctx)
	fmt.Printf("parsing %s took %v \n", v.Name, time.Since(beforeParse))

	if err != nil {
		fmt.Printf("error while parsing %s \n", v.Name)
		c <- Result{
			Feed: []CustomFeed{},
			Err:  err,
		}
		return
	}
	fmt.Printf("parsing feed: %s, len: %d \n", v.Name, remoteFeed.Len())

	// lookup for source and its last pub_date
	var current time.Time
	for _, source := range sources {
		if source.Source == v.Id {
			if source.PubDate.Valid {
				temp, err := time.Parse(time.RFC3339, source.PubDate.String)
				if err != nil {
					c <- Result{
						Feed: []CustomFeed{},
						Err:  err,
					}
				}
				current = temp
			}
		}
	}

	var cats []CatAlias
	var feeds []CustomFeed
	duplicateFeedTracker := make(map[string]bool)

	for _, item := range remoteFeed.Items {
		if feedResult, err := ProcessFeed(item, current, &v); err == nil {
			addCatAlias(&cats, feedResult.CatAliasName)
			if duplicateFeedTracker[feedResult.Link] == false {
				duplicateFeedTracker[feedResult.Link] = true
				feeds = append(feeds, feedResult)
			}
		}
	}
	filteredCats := filterDuplicateAliases(cats, categoryAliases)
	// send feeds array through channel
	c <- Result{
		Feed:    feeds,
		Aliases: filteredCats,
		Err:     nil,
	}

	return
}
