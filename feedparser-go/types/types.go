package types

import (
	"database/sql"
	"time"
)

// Implement categories
type CustomFeed struct {
	Name         string         `db:"title"`
	Description  sql.NullString `db:"description"`
	PubDate      time.Time      `db:"pub_date"`
	ImageLink    sql.NullString `db:"image_link"`
	Link         string         `db:"feed_link"`
	Source       int            `db:"source_id"`
	CatAlias     sql.NullInt64  `db:"category_alias_id"`
	CatAliasName string         `db:"-"`
}

// Result Type for feed parser
type Result struct {
	Feed []CustomFeed
	Err  error
}

type Feed struct {
	Id   int    `db:"id"`
	Name string `db:"name"`
	Feed string `db:"link"`
}

type CatAlias struct {
	Alias    string         `db:"alias"`
	Category sql.NullString `db:"category_id"`
}

type LastPubDateForSource struct {
	Source  int            `db:"source"`
	PubDate sql.NullString `db:"pub_date"`
}

type StartupData struct {
	CatAliases   []CatAlias
	LastPubDates []LastPubDateForSource
}
