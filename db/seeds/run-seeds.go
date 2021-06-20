package seeds

import (
	"database/sql"
	"db-migrations/seeds/sources"
	"fmt"
)

func Run(db *sql.DB) error {
	data, err := sources.Sources()
	if err != nil {
		return err
	}
	fmt.Printf("%v", data)
	for _, v := range data {
		_, err := db.Exec("insert into source(id,name,feed) values($1,$2,$3);", v.Id, v.Name, v.Link)
		if err != nil {
			return err
		}
	}
	return nil
}
