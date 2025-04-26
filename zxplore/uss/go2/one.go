package main

import (
	"fmt"
	"log"

	// Represent the path to the module with an alias: zosrecordio
	// Conveniently and to keep things simple, the package in the path is also called zosrecordio

	zosrecordio "github.com/ibmruntimes/go-recordio/v2"
	"github.com/ibmruntimes/go-recordio/v2/utils"

	// This allows one.go to use functions created in tools.go
	"people/tools"
)

func part1(Dname string) {

	// Use the struct definition in the tools package to declare a variable called 'staff'
	// You can find the struct type 'PeopleHeader' in the tools package
	var staff tools.PeopleHeader

	// We are using buffbytes as a way to convert the given type (which in this case is a struct) to a slice
	// A slice is a flexible data type that is dynamically sized
	// Utils is a part of zosrecordio referenced above
	buffbytes := utils.ConvertTypeToSlice(&staff)

	// OpenRecord uses the util package we imported earlier
	// Record open order is  rb+,type=record
	// rb+ = Opens a binary file for both reading and writing
	stream := tools.OpenRecord(Dname, "rb+,type=record")
	tools.WriteStruct(&staff, "001", "Fname", "Lname", "TestPosition", "SampleDepartment")
	stream.Fwrite(buffbytes)
	stream.Fclose()

	// Clear the buffer slice so that we know we are not re-reading old data
	// This way we can confidently resue the buffer
	tools.ClearRecord(&staff)

	stream = zosrecordio.Fopen(Dname, "rb+,type=record")
	if stream.Nil() {
		log.Fatal("zero stream")
	}
	_ = stream.Fread(buffbytes)

	// Print struct
	tools.PrintStruct(&staff)

	// We do not have to read and print to verify that our data has been saved or if it exists
	// Flocate can confirm that a record exists
	fl := stream.Flocate([]byte("001"), zosrecordio.Loc_KEY_EQ_BWD)
	if fl == 0 {
		fmt.Println("Flocate succesful")
	} else {
		fmt.Println("Err: Flocate returns:", fl)
	}
	stream.Fclose()

	// The buffer still contains the read data
	// It has not been cleared so try printing buffbytes to see what is in it
	// Print buffer here
	fmt.Println("slice", string(buffbytes))

	fmt.Printf("\nEnd: Part one.\n\n")
}