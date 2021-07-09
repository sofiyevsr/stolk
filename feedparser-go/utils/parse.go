package utils

import (
	"errors"
	"feedparser/types"
	"fmt"
	"os"
	"time"

	"github.com/jmoiron/sqlx"
	"github.com/mmcdole/gofeed"
)

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
			fmt.Printf("error %v \n", r)
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
	// lookup for source and its last pub_date
	var current time.Time
	for _, source := range *sources {
		if source.Source == v.Id {
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
		if feedResult, err := ProcessFeed(item, &current, &v); err == nil {
			addCatAlias(&cats, feedResult.feed.CatAliasName)
			feeds = append(feeds, feedResult.feed)
		}
	}
	// send feeds array through channel
	c <- types.Result{
		Feed: feeds,
		Err:  nil,
	}

	// TODO send through channel and save to db in one time
	saveCategoryAlias(cats)
	return
}

func addCatAlias(aliases *[]types.CatAlias, alias string) {
	arr := *aliases
	var exists bool
	for i := 0; i < len(arr); i++ {
		if arr[i].Alias == alias {
			exists = true
		}
	}
	if !exists {
		arr = append(arr, types.CatAlias{Alias: alias})
	}
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
	 news_category_alias(alias)
	 VALUES(:alias) ON CONFLICT(alias) DO NOTHING;
`, cats)
	if e != nil {
		fmt.Printf("error while cats save: %v", e)
	}
	return nil
}
