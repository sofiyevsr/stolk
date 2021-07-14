package utils

import (
	"database/sql"
	"os"

	"github.com/jmoiron/sqlx"
)

type LastPubDateForSource struct {
	Source  int            `db:"source"`
	PubDate sql.NullString `db:"pub_date"`
}

type Feed struct {
	Id   int    `db:"id"`
	Name string `db:"name"`
	Feed string `db:"link"`
}

type StartupData struct {
	CatAliases   []CatAlias
	LastPubDates []LastPubDateForSource
	Feeds        []Feed
}

func Startup() (StartupData, error) {
	// assign parsed feeds
	data := StartupData{}
	err := getLastPubDateOfSources(&data.LastPubDates)
	if err != nil {
		return StartupData{}, err
	}
	e := getFeedsFromDB(&data.Feeds)
	if e != nil {
		return StartupData{}, e
	}

	data.CatAliases, e = getCategoryAliasesFromDB()

	if e != nil {
		return StartupData{}, e
	}
	return data, nil
}

// Startup:
// Get feeds to be parsed later
func getFeedsFromDB(feeds *[]Feed) error {

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
func getLastPubDateOfSources(sources *[]LastPubDateForSource) error {
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
