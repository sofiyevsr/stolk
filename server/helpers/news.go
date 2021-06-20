package helpers

import (
	"database/sql"
	"fmt"
	"os"
	"time"

	"feed-server/utils"

	_ "github.com/jackc/pgx/v4/stdlib"
	"github.com/jmoiron/sqlx"
)

type news struct {
	ID          uint           `db:"id" json:"id"`
	SourceID    uint           `db:"source_id" json:"source_id"`
	Title       string         `db:"title" json:"title"`
	Description string         `db:"description" json:"description"`
	SourceName  string         `db:"source_name" json:"source_name"`
	PubDate     *time.Time     `db:"pub_date" json:"pub_date"`
	Link        string         `db:"feed_link" json:"link"`
	ImageLink   sql.NullString `db:"image_link" json:"image_link"`
}

func GetNews(lastID, limit uint) (map[string]interface{}, error) {
	query := `SELECT s.id as source_id, s.name AS source_name, n.id, n.title, COALESCE(n.description,'')
	AS description,n.image_link,n.pub_date,n.feed_link FROM news AS n
	LEFT JOIN source AS s ON s.id = n.source `
	args := []interface{}{}
	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		panic(err)
	}
	if lastID > 0 {
		query = query + "WHERE n.id < $1 "
		args = append(args, lastID)
	}
	if limit <= 0 || limit > utils.DEFAULT_NEWS_LIMIT_UPPER_BOUND {
		// +1 to check if has_reached_end
		limit = utils.DEFAULT_NEWS_LIMIT + 1
	} else {
		limit += 1
	}

	if len(args) == 0 {
		query = query + "ORDER BY n.id DESC LIMIT $1"
	} else {
		query = query + "ORDER BY n.id DESC LIMIT $2"
	}
	args = append(args, limit)
	var newsDB []news
	fmt.Println(query)
	e := db.Select(&newsDB, query, args...)
	if e != nil {
		return nil, e
	}
	var hasReachedEnd bool
	if uint(len(newsDB)) < limit {
		hasReachedEnd = true
	} else {
		// remove last item if news has reached end
		newsDB = newsDB[:len(newsDB)-1]
	}
	return map[string]interface{}{"news": newsDB, "has_reached_end": hasReachedEnd}, nil
}
