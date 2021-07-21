package utils

import (
	"context"
	"errors"
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
	defer func() {
		if r := recover(); r != nil {
			c <- Result{
				Feed: []CustomFeed{},
				Err:  errors.New("parsing error"),
			}
			fmt.Printf("error occured inside goroutine %s \n", v.Name)
			fmt.Printf("error %v \n", r)
		}
	}()
	fp := gofeed.NewParser()
	beforeParse := time.Now()

	// -- Timeout Feed Parser
	bctx := context.Background()
	ctx, cancel := context.WithTimeout(bctx, PARSE_TIMEOUT)
	defer cancel()
	remoteFeed, err := fp.ParseURLWithContext(v.Feed, ctx)
	fmt.Printf("parsing %s took %v \n", v.Name, time.Since(beforeParse))

	if err != nil {
		panic(fmt.Errorf("error while parsing %s \n", v.Name))
	}
	fmt.Printf("parsing feed: %s, len: %d \n", v.Name, remoteFeed.Len())

	// lookup for source and its last pub_date
	var current time.Time
	for _, source := range sources {
		if source.Source == v.Id {
			if source.PubDate.Valid {
				temp, err := time.Parse(time.RFC3339, source.PubDate.String)
				if err != nil {
					panic(err)
				}
				current = temp
			}
		}
	}

	var cats []CatAlias
	var feeds []CustomFeed

	for _, item := range remoteFeed.Items {
		if feedResult, err := ProcessFeed(item, current, &v); err == nil {
			addCatAlias(&cats, feedResult.CatAliasName)
			feeds = append(feeds, feedResult)
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
