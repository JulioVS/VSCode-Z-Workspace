package main

import (
	"fmt"
	"people/tools"

	"github.com/ibmruntimes/go-recordio/v2/utils"
)

// This struct matches the struct in the tools package
// The difference is the that the data type here is string
// Conversion from string to byte slice will take place inside the WriteStruct function inside the tool package
// The reason for this is that this conversion requires specific steps

// Defining a struct type
// Below is an identical struct to the PeopleHeader struct.
// Note the fields here are different because they are all string
// Look at WriteStruct to see how we write them to a byte slice
// We do have the choice of using the struct defined in the tools package
type myData struct {
	Id         string
	FirstName  string
	LastName   string
	Position   string
	Department string
}

// Using the myData struct to create one called employees.
var employees = []myData{
	{
		Id:         "456",
		FirstName:  "Eric",
		LastName:   "Waters",
		Position:   "Artist",
		Department: "Anthropology",
	},
	{
		Id:         "451",
		FirstName:  "Alice",
		LastName:   "Sand",
		Position:   "Actor",
		Department: "Film",
	},
	{
		Id:         "452",
		FirstName:  "Melvin",
		LastName:   "Mainframe",
		Position:   "Librarian",
		Department: "Library",
	},
}

func part2(Dname string) {

	var staff tools.PeopleHeader

	buffbytes := utils.ConvertTypeToSlice(&staff)
	stream := tools.OpenRecord(Dname, "rb+,type=record")
	defer stream.Fclose()

	for pos, data := range employees {
		fmt.Println("Writing struct:", pos)
		tools.WriteStruct(&staff, data.Id, data.FirstName, data.LastName, data.Position, data.Department)
		stream.Fwrite(buffbytes)
		clear(buffbytes)
	}
	tools.PrintLoop(Dname)

	fmt.Printf("\nEnd: Part two.\n\n")

}

