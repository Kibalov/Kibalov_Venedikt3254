package store

import (
	"context"

	"github.com/jackc/pgx/v4"

	"database/sql"

	_ "github.com/lib/pq"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
)

type Store struct {
	conn *pgx.Conn
}

type People struct {
	ID   int
	Name string
}

// NewStore creates new database connection
func NewStore(connString string) *Store {
	conn, err := pgx.Connect(context.Background(), connString)
	if err != nil {
		panic(err)
	}

	// make migration

	db, err := sql.Open("postgres", connString)
	if err != nil {
		panic(err)
	}
	driver, err := postgres.WithInstance(db, &postgres.Config{})
	if err != nil {
		panic(err)
	}
	m, err := migrate.NewWithDatabaseInstance("file:../migrations", "postgres", driver)
	if err != nil {
		panic(err)
	}
	m.Up()

	return &Store{
		conn: conn,
	}
}

func (s *Store) ListPeople() ([]People, error) {
	rows, err := s.conn.Query(context.Background(), "SELECT * FROM people")
	if err != nil {
		return nil, err
	}

	people := make([]People, 0)
	for rows.Next() {
		var p People
		err = rows.Scan(&p.ID, &p.Name)
		if err != nil {
			return nil, err
		}
		people = append(people, p)
	}

	return people, nil

}

func (s *Store) GetPeopleByID(id int) (People, error) {
	var p People
	err := s.conn.QueryRow(context.Background(), "SELECT * FROM people WHERE id = $1", id).Scan(&p.ID, &p.Name)
	if err != nil {
		return People{}, err
	}

	return p, nil
}
