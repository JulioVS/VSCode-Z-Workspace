package main

import (
	// Below is the list of packages for the import statement.
	// It lists packages that are part of the standard library.

	"fmt"
	"os"
	"os/signal"
	"syscall"
)

func main() {

	// As you have seen from the jobs menu there is a lot of information that comes from running jobs
	// For this demonstration a simple error check will suffice so for the following we will remove the extra information for now
	signal.Ignore(syscall.SIGIOERR)

	// os.Args represents the commands entered on the command line.
	// If there are less than two, we know that there isn't enough information and we stop the program
	if len(os.Args) < 2 {
		fmt.Println("Provide an argument of the form \"//'HLQ.DBNAME.KEY.PATH'\"")
		return
	}

	// We are expecting that the command to run the program is ./people "//'HLQ.DBNAME.KEY.PATH'\"
	// This places the dataset name at position 1 and so we save that as dname to be reused again
	Dname := os.Args[1]

	// Call the function from one.go here
	part1(Dname)
	// Once part one is done call the two.go function here
	part2(Dname)
	// Once part two is done call the three.go function here
	part3(Dname)	

}