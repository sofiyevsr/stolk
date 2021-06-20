package main

import (
	"database/sql"
	"db-migrations/seeds"
	"fmt"
	"log"
	"os"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/jackc/pgx/v4/stdlib"
	"github.com/joho/godotenv"
)

func main() {
	func() {
		if r := recover(); r != nil {
			log.Fatalln(r)
		}
	}()
	err := godotenv.Load()
	if err != nil {
		panic(err)
	}
	db, err := sql.Open("pgx", os.Getenv("DATABASE_URL"))
	if err != nil {
		panic(err)
	}
	driver, err := postgres.WithInstance(db, &postgres.Config{})
	m, err := migrate.NewWithDatabaseInstance("file://migrations", "pgx", driver)
	if err != nil {
		panic(err)
	}
	if len(os.Args) > 1 && os.Args[1] == "--drop" {
		if e := m.Down(); e != nil {
			fmt.Printf("cannot drop error: %v", e)
		}
	}
	if e := m.Up(); e != nil {
		fmt.Printf("cannot up error: %v", e)
	}

	dbErr := seeds.Run(db)
	if dbErr != nil {
		log.Fatalln(dbErr)
	}
}
