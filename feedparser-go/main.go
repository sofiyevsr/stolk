package main

import (
	"database/sql"
	"feedparser/types"
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
	startTime := time.Now()
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("%v", r)
		}
	}()

	// assign parsed feeds
	var feeds []types.Feed
	var sources []types.LastPubDateForSource
	err := getLastPubDateOfSources(&sources)
	if err != nil {
		return "", err
	}
	e := getFeedsFromDB(&feeds)
	if e != nil {
		return "", e
	}
	ch := make(chan types.Result)
	for i, v := range feeds {
		go utils.ParseFeed(i, v, &sources, ch)
	}

	var items []types.CustomFeed
	processedFeeds := feeds

	timeout := time.After(TOTAL_PARSE_TIME_LIMIT)
	for i := 0; i < len(feeds); i++ {
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

// Startup:
// Get feeds to be parsed later
func getFeedsFromDB(feeds *[]types.Feed) error {

	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		return err
	}

	e := db.Select(feeds, "SELECT id,name,link FROM news_source;")
	if e != nil {
		return e
	}
	return nil
}

// Get last pub date of sources to avoid overriding
func getLastPubDateOfSources(sources *[]types.LastPubDateForSource) error {
	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		return err
	}

	e := db.Select(sources, `SELECT s.id AS source, MAX(n.pub_date) AS pub_date FROM news_source AS s
		LEFT JOIN news_feed AS n on n.source_id=s.id GROUP BY s.id;
	`)

	if e != nil {
		return e
	}

	return nil
}

// --END Startup

// Last Step
func saveToDB(items []types.CustomFeed) {
	if items == nil || len(items) == 0 {
		return
	}
	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		panic(err)
	}

	catAliases := make(map[string]int64)
	rows, e := db.Query(`SELECT id, alias FROM news_category_alias;`)
	for rows.Next() {
		var key string
		var val int64
		rows.Scan(&val, &key)
		if key != "" && val != 0 {
			catAliases[key] = val
		}
	}

	// map cat alias to id in each news
	for _, v := range items {
		val, ok := catAliases[v.CatAliasName]
		if ok {
			v.CatAlias = sql.NullInt64{
				Valid: true,
				Int64: val,
			}
		}
	}

	if e != nil {
		return
	}
	_, e = db.NamedExec(`INSERT INTO 
	 news_feed(title,description,source_id,image_link,pub_date,feed_link,category_alias_id)
	 VALUES(:title,:description,:source_id,:image_link,:pub_date,:feed_link,:category_alias_id)
	 ON CONFLICT(feed_link) DO NOTHING;
`, items)
	if e != nil {
		log.Fatalln(e)
	}
}
