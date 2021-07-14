package utils

import (
	"database/sql"
	"errors"
	"fmt"
	"os"

	"github.com/jmoiron/sqlx"
)

type CatAlias struct {
	Alias    string         `db:"alias"`
	Category sql.NullString `db:"category_id"`
	Id       int            `db:"id"`
}

func getCategoryAliasesFromDB() ([]CatAlias, error) {
	var aliases []CatAlias

	db, err := sqlx.Connect("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		return nil, err
	}

	e := db.Select(&aliases, "SELECT id,alias FROM news_category_alias;")
	if e != nil {
		return nil, e
	}
	return aliases, nil
}

func addCatAlias(aliases *[]CatAlias, alias string) {
	var exists bool
	for _, v := range *aliases {
		if v.Alias == alias {
			exists = true
		}
	}
	if !exists && alias != "" {
		*aliases = append(*aliases, CatAlias{Alias: alias})
	}
}

func saveCategoryAlias(cats []CatAlias) error {
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
