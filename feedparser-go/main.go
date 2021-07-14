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

const TOTAL_PARSE_TIME_LIMIT = time.Millisecond * 10000
const SINGLE_PARSE_LIMIT = time.Millisecond * 4500

func main() {
	env := os.Getenv("GO_ENV")
	fmt.Println(env)
	if env == "development" {
		err := godotenv.Load()
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
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("%v", r)
		}
	}()
	startTime := time.Now()

	// get Data from db
	data, err := utils.Startup()

	if err != nil {
		return "", err
	}

	ch := make(chan utils.Result)
	for i, v := range data.Feeds {
		go utils.ParseFeed(i, v, &data.LastPubDates, data.CatAliases, ch)
	}

	var items []utils.CustomFeed
	processedFeeds := data.Feeds

	timeout := time.After(TOTAL_PARSE_TIME_LIMIT)

	for i := 0; i < len(data.Feeds); i++ {
		var br bool
		select {
		case feed := <-ch:
			if feed.Err != nil {
				fmt.Printf("feed received error %s \n", feed.Err)
			} else {
				items = append(items, feed.Feed...)
				// mark source as processed
				for i, fe := range processedFeeds {
					if len(feed.Feed) > 0 && fe.Id == feed.Feed[0].Source {
						processedFeeds[i] = processedFeeds[len(processedFeeds)-1]
						// We do not need to put s[i] at the end, as it will be discarded anyway
						processedFeeds = processedFeeds[:len(processedFeeds)-1]
					}
				}
			}
		case <-time.After(SINGLE_PARSE_LIMIT):
			fmt.Printf("didn't get single result in %s, so skipping...\n", TOTAL_PARSE_TIME_LIMIT.String())
		case <-timeout:
			fmt.Printf("couldn't finish in %s finishing...\n", TOTAL_PARSE_TIME_LIMIT.String())
			br = true
		}
		if br == true {
			break
		}
	}
	saveToDB(items)
	duration := time.Since(startTime)
	fmt.Printf("execution time: %v \n", duration)
	fmt.Printf("sources that wasn't processed %v", processedFeeds)
	return fmt.Sprintf("inserted rows: %d \n", len(items)), nil
}

// Last Step
func saveToDB(items []utils.CustomFeed) {
	if items == nil || len(items) == 0 {
		return
	}
	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		panic(err)
	}

	// Map id of category_alias from string
	// TODO Not best way, improve
	catAliases := make(map[string]int32)
	rows, err := db.Query(`SELECT id, alias FROM news_category_alias;`)
	if err != nil {
		return
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

	_, err = db.NamedExec(`INSERT INTO
	 news_feed(title,source_id,image_link,pub_date,feed_link,category_alias_id)
	 VALUES(:title,:source_id,:image_link,:pub_date,:feed_link,:category_alias_id)
	 ON CONFLICT(feed_link) DO NOTHING;
	`, items)
	if err != nil {
		log.Fatalln(err)
	}
}
