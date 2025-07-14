package tools

import (
	"fmt"
	"log"

	// Represent the path to the module with an alias: zosrecordio
	// Conveniently, the package in the path is also called zosrecordio
	zosrecordio "github.com/ibmruntimes/go-recordio/v2"
	"github.com/ibmruntimes/go-recordio/v2/utils"
)

// Declaring global constants
// These are available throughout this package
// This defines the size of the components of the struct such as ID and other fields of information in the struct
const Fixed_id_size = 3
const Fixed_val_size = 16

// Declaring a struct
type PeopleHeader struct {
	Id         [Fixed_id_size]byte
	FirstName  [Fixed_val_size]byte
	LastName   [Fixed_val_size]byte
	Position   [Fixed_val_size]byte
	Department [Fixed_val_size]byte
}

// Note how the functions below are defined
// If the first letter of a function, variable, or method is Capitalized it can be exported to other packages. View the helpful links section to read more about this.

// Update record and check if record exists first
func UpdateRecord(key []byte, buffbytes []byte, stream zosrecordio.RecordStream) int {
	unusedBytes := make([]byte, 65)
	err := stream.Flocate(key, zosrecordio.Loc_KEY_EQ_BWD)
	if err != 0 {
		fmt.Println("Err: Record Not Found:", err)
		return err
	} else if err == 0 {
		fmt.Println("good flocate")
	}
	stream.Fread(unusedBytes)
	num := stream.Fupdate(buffbytes)
	if num == 0 {
		fmt.Println("Err: Update Failed:", num)
	}
	return num
}

// Clear struct for reuse
func ClearRecord(staffStruct *PeopleHeader) {
	var key0 [Fixed_val_size]byte
	WriteStruct(staffStruct, string(key0[(Fixed_val_size-Fixed_id_size):]), string(key0[:]), string(key0[:]), string(key0[:]), string(key0[:]))
}

// Delete record by executing all necessary steps
func DeleteRecord(key []byte, stream *zosrecordio.RecordStream) {

	//Use these if you need a buffer
	var staff PeopleHeader
	buffslice := utils.ConvertTypeToSlice(&staff)

	// Before deleting it's good to know the record is there
	// This is not necessary
	fl := stream.Flocate(key, zosrecordio.Loc_KEY_EQ_BWD)
	if fl == 0 {
		fmt.Println("Good flocate ready for delete")
	} else if fl != 0 {
		fmt.Println("Flocate for Fdelrec failed:", fl)
	}
	///////////////////////////////////
	// Insert delete procedure below //
	///////////////////////////////////
	
	_ = stream.Fread(buffslice)
	_ = stream.Fdelrec()
	
}

// Open records with error check
func OpenRecord(Dname string, recType string) zosrecordio.RecordStream {
	stream := zosrecordio.Fopen(Dname, recType)
	if stream.Nil() {
		log.Fatal("zero stream")
	}
	return stream
}

// Print struct
func PrintStruct(staffStruct *PeopleHeader) {
	fmt.Println("Struct: ", string(staffStruct.Id[:]), " - ", 
													string(staffStruct.FirstName[:]), " - ", 
													string(staffStruct.LastName[:]), " - ", 
													string(staffStruct.Position[:]), " - ", 
													string(staffStruct.Department[:]))
}

// Print all records in database
func PrintLoop(Dname string) {
	var staffStruct = PeopleHeader{}
	buff := utils.ConvertTypeToSlice(&staffStruct)
	stream := OpenRecord(Dname, "rb+,type=record")
	defer stream.Fclose()
	for {
		_ = stream.Fread(buff)

		if stream.Feof() {
			break
		}
		PrintStruct(&staffStruct)
	}
}

// Write struct using pointer
func WriteStruct(staffStruct *PeopleHeader, a string, b string, c string, d string, e string) {
	copy(staffStruct.Id[:], a)
	copy(staffStruct.FirstName[:], b)
	copy(staffStruct.LastName[:], c)
	copy(staffStruct.Position[:], d)
	copy(staffStruct.Department[:], e)
}