// Programs start running in package main
package main

//Imported packages
import (
	"fmt"
	"strings"
)

// Start of main function
func main() {

	// Use the strings package to check if seafood contains the string foo
	check := strings.Contains("seafood", "fool")

	// Use Println in the fmt package to see value of check
	fmt.Println(check)

	// if check is true then we that the string was found
	if check {

		//Use Println to print result
		fmt.Println("Found: The string check is: ", check)

		// if check is false then we print that the string was not found
	} else {

		//Use Println to print result
		fmt.Println("Not found: The string check has returned: ", check)
	}
}