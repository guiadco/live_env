package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"

	"github.com/guiadco/live/variables"
)

func main() {
	variables.CheckVariables()
	arguments := os.Args
	bash_script := arguments[1]
	option := arguments[2]
	cmd, err := exec.Command(bash_script, option).Output()

	if err != nil {
		log.Printf("Error: %v", err.Error())
		return
	}

	fmt.Print(string(cmd))

	os.Exit(0)
}
