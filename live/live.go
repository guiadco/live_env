package main

import (
	"live/variables"
	"log"
	"os"
	"os/exec"
)

func main() {
	arguments := os.Args
	// switch arguments[1] {
	// case "help":
	// fmt.Println("Help yourself!")
	// }

	variables.CheckVariables()

	bash_script := arguments[1]

	cmd := exec.Command(bash_script)
	log.Printf("Running command and waiting for it to finish...")
	err := cmd.Run()
	log.Printf("Command finished with error: %v", err)

	os.Exit(0)
}
