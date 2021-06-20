package main

import (
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

func main() {
	env := os.Getenv("GO_ENV")
	if env == "dev" {
		err := godotenv.Load()
		if err != nil {
			log.Fatalf("couldn't load env %v \n", err)
		}
		data, err := handleLambda()
		if err != nil {
			log.Fatalf("lambda error %v", err)
		}
		fmt.Println(data)
		os.Exit(0)
	} else if env == "prod" {
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
	serr := getLastPubDateOfSources(&sources)
	if serr != nil {
		return "", serr
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

	for i := 0; i < len(feeds); i++ {
		feed := <-ch
		if feed.Err == nil {
			items = append(items, feed.Feed...)
		} else {
			fmt.Println("no error adding...")
		}
	}
	saveToDB(items)
	duration := time.Since(startTime)
	fmt.Printf("execution time: %v \n", duration)
	return fmt.Sprintf("inserted rows: %d \n", len(items)), nil
}

// Startup:
// Get feeds to be parsed later
func getFeedsFromDB(feeds *[]types.Feed) error {

	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		return err
	}

	e := db.Select(feeds, "SELECT id,name,feed FROM source;")
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

	e := db.Select(sources, `SELECT s.id AS source, MAX(n.pub_date) AS pub_date FROM source AS s
		LEFT JOIN news AS n on n.source=s.id GROUP BY s.id;
	`)

	if e != nil {
		return e
	}

	return nil
}

// --END Startup

// Last Step
func saveToDB(items []types.CustomFeed) {
	if items == nil {
		return
	}
	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		panic(err)
	}
	_, e := db.NamedExec(`INSERT INTO 
	 news(title,description,source,image_link,pub_date,feed_link)
	 VALUES(:title,:description,:source,:image_link,:pub_date,:feed_link)
	 ON CONFLICT(feed_link) DO NOTHING;
`, items)
	if e != nil {
		log.Fatalln(e)
	}
}
