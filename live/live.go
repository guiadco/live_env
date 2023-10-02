package main

import (
	"live/variables"
	"os"
)

func main() {
	// arguments := os.Args
	// switch arguments[1] {
	// case "help":
	// 	fmt.Println("Help yourself!")
	// }

	variables.CheckVariables()

	os.Exit(0)
}
