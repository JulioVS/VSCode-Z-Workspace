package main

import (
	"fmt"
	"people/tools"

	zosrecordio "github.com/ibmruntimes/go-recordio/v2"
)

func part3(Dname string) {

	stream := tools.OpenRecord(Dname, "rb+,type=record")

	// Identify record deletion
	delKey := "001"

	// Flocate confirms records exists before we begin
	fl := stream.Flocate([]byte(delKey), zosrecordio.Loc_KEY_EQ_BWD)
	if fl == 0 {
		fmt.Println("Good flocate  test")
	} else {
		fmt.Println("Err: Flocate returns:", fl, "Please fix this")
	}
	stream.Fclose()

	//Print all
	tools.PrintLoop(Dname)

	stream = tools.OpenRecord(Dname, "rb+,type=record")

	// DeleteRecord is the function in tools to delete a record
	// You will need to add Fdelrec into the DeleteRecord function
	// Use this to delete any of the records
	tools.DeleteRecord([]byte(delKey), &stream)
	stream.Fclose()

	fmt.Printf("\nAttempting delete\n\n")
	tools.PrintLoop(Dname)

	//Confirm delete by failing Flocate
	stream = tools.OpenRecord(Dname, "rb+,type=record")
	fl = stream.Flocate([]byte(delKey), zosrecordio.Loc_KEY_EQ)
	if fl != 0 {
		fmt.Println("Confirmed record deleted")
	} else {
		fmt.Println("Record not deleted. Please fix this.")
	}
	stream.Fclose()
	fmt.Printf("\nEnd: Part three.\n")
}