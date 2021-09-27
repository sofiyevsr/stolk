package main

import (
	"database/sql"
	"feedparser/utils"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	_ "github.com/jackc/pgx/v4/stdlib"
	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
)

const (
	TOTAL_PARSE_TIME_LIMIT = time.Millisecond * 15000
	SINGLE_PARSE_LIMIT     = time.Millisecond * 4500
)

func main() {
	env := os.Getenv("GO_ENV")
	if env == "development" || env == "staging" {
		err := godotenv.Load()
		// if default dotenv not found try env_path variable
		if err != nil {
			err := godotenv.Load(os.Getenv("ENV_PATH"))
			if err != nil {
				log.Fatalf("couldn't load env %v \n", err)
			}
		}
		data, err := handleLambda()
		if err != nil {
			log.Fatalf("lambda error %v", err)
		}
		fmt.Println(data)
		os.Exit(0)
	} else if env == "production" {
		lambda.Start(handleLambda)
	} else {
		log.Fatalln("GO_ENV not found")
	}
}

func handleLambda() (string, error) {

	startTime := time.Now()

	fmt.Printf("start time %s \n", startTime.UTC())

	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		return "DB connection failed", err
	}

	// get Data from db
	data, err := utils.Startup(db)

	if err != nil {
		return "Startup failed", err
	}

	ch := make(chan utils.Result)
	for i, v := range data.Feeds {
		go utils.ParseFeed(i, v, data.CatAliases, ch)
	}

	var (
		items    []utils.CustomFeed
		catsColl []utils.CatAlias
	)

	uniqueFeedLinks := make(map[string]bool)
	processedFeeds := utils.ConvertFeedsToLogFeeds(data.Feeds)

	timeout := time.After(TOTAL_PARSE_TIME_LIMIT)

	for i := 0; i < len(data.Feeds); i++ {
		var br bool
		select {
		case feed := <-ch:
			filteredItems := saveFeedInMemory(feed, &uniqueFeedLinks)
			items = append(items, filteredItems...)
			// mark source as processed
			if len(feed.Feed) > 0 {
				utils.MarkFeedAsProcessed(feed.Feed[0].Source, &processedFeeds)
			}
			if len(feed.Aliases) > 0 {
				catsColl = append(catsColl, feed.Aliases...)
			}
			// Skips single channel
			// useful to skip long taking channel
			// allows to make total timeout longer
		case <-time.After(SINGLE_PARSE_LIMIT):
			fmt.Printf("didn't get single result in %s, so skipping...\n", SINGLE_PARSE_LIMIT.String())
		case <-timeout:
			fmt.Printf("couldn't finish in %s finishing...\n", TOTAL_PARSE_TIME_LIMIT.String())
			br = true
		}
		if br == true {
			break
		}
	}
	utils.SaveCategoryAlias(db, catsColl)

	result := saveToDB(db, items)
	duration := time.Since(startTime)
	fmt.Printf("execution time: %v \n", duration)
	fmt.Printf("sources that wasn't processed %v \n", processedFeeds)
	var affectedRows int64
	if result != nil {
		affectedRows, _ = result.RowsAffected()
	}
	return fmt.Sprintf("inserted rows: %d \n", affectedRows), nil
}

// Save only feeds with unique feed_link
func saveFeedInMemory(feed utils.Result, uniqueLinks *map[string]bool) []utils.CustomFeed {
	var items []utils.CustomFeed
	if feed.Err != nil {
		fmt.Printf("feed received error %s \n", feed.Err)
	} else {
		for _, v := range feed.Feed {
			if _, ok := (*uniqueLinks)[v.Link]; !ok {
				(*uniqueLinks)[v.Link] = true
				items = append(items, v)
			}
		}
	}
	return items
}

// Last Step
func saveToDB(db *sqlx.DB, items []utils.CustomFeed) sql.Result {
	if items == nil || len(items) == 0 {
		return nil
	}

	// Map id of category_alias from string
	// TODO Not best way, improve
	catAliases := make(map[string]int32)
	rows, err := db.Query(`SELECT id, alias FROM news_category_alias;`)
	if err != nil {
		return nil
	}
	for rows.Next() {
		var key string
		var val int32
		rows.Scan(&val, &key)
		if key != "" && val != 0 {
			catAliases[key] = val
		}
	}

	// map cat alias to id in each news
	for i := 0; i < len(items); i++ {
		if items[i].CatAliasName != "" {
			val, ok := catAliases[items[i].CatAliasName]
			if ok {
				items[i].CatAlias = sql.NullInt32{
					Valid: true,
					Int32: val,
				}
			}
		}
	}
	fmt.Printf("length %d\n", len(items))

	// Insert new news
	// when feed_link is same update pub_date
	inserts, err := db.NamedExec(`INSERT INTO
	 news_feed(title,source_id,image_link,pub_date,feed_link,category_alias_id)
	 VALUES(:title,:source_id,:image_link,:pub_date,:feed_link,:category_alias_id)
	 ON CONFLICT(feed_link) DO UPDATE SET pub_date=EXCLUDED.pub_date, title=EXCLUDED.title;
	`, items)
	if err != nil {
		log.Fatalln(err)
	}
	return inserts
}
