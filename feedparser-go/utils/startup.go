package utils

import (
	"database/sql"

	"github.com/jmoiron/sqlx"
)

type Feed struct {
	Id            int            `db:"id"`
	Name          string         `db:"name"`
	Link          string         `db:"link"`
	CategoryAlias sql.NullString `db:"category_alias_name"`
	PubDate       sql.NullString `db:"pub_date"`
}

type StartupData struct {
	CatAliases []CatAlias
	Feeds      []Feed
}

func Startup(db *sqlx.DB) (StartupData, error) {
	// assign parsed feeds
	data := StartupData{}

	var err error
	data.Feeds, err = getFeedsFromDB(db)
	if err != nil {
		return StartupData{}, err
	}

	data.CatAliases, err = getCategoryAliasesFromDB(db)
	if err != nil {
		return StartupData{}, err
	}
	return data, nil
}

// Startup:
// Get feeds to be parsed later
func getFeedsFromDB(db *sqlx.DB) ([]Feed, error) {
	var feeds []Feed
	e := db.Select(&feeds, `SELECT s.id, s.name, s.category_alias_name, s.link, MAX(n.pub_date) AS pub_date FROM news_source AS s
		LEFT JOIN news_feed AS n on n.source_id=s.id GROUP BY s.id;`)
	if e != nil {
		return feeds, e
	}
	return feeds, nil
}

func getCategoryAliasesFromDB(db *sqlx.DB) ([]CatAlias, error) {
	var aliases []CatAlias

	e := db.Select(&aliases, "SELECT id,alias FROM news_category_alias;")
	if e != nil {
		return nil, e
	}
	return aliases, nil
}

// --END Startup
