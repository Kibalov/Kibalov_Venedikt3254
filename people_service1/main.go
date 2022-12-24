package main

import (
	"fmt"

	_ "github.com/jackc/pgx/stdlib"

	"github.com/Kibalov/Kibalov_Venedikt3254/people_service1/service"
	"github.com/Kibalov/Kibalov_Venedikt3254/people_service1/service/store"
)

func main() {
	db := store.NewStore("http://95.217.232.188:7777/kibalov?sslmode=enable")

	serv := service.Service{
		Store: db,
		Tax:   &t{},
	}

	fmt.Println(serv.GetPeopleByID(1)) // example
}

// simple fake tax realization
type t struct{}

func (t *t) GetTaxStatusByID(id int) (string, error) {
	return "", nil
}
