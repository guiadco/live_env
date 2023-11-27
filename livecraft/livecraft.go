package main

import (
	"fmt"
	"io"
	"os"
	"os/exec"

	"github.com/guiadco/LiveCraft/variables"
)

func main() {
	variables.CheckVariables()
	arguments := os.Args
	bashScript := arguments[1]
	option := arguments[2]

	cmd := exec.Command(bashScript, option)
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		fmt.Println("Error creating stdout pipe:", err)
		return
	}

	err = cmd.Start()
	if err != nil {
		fmt.Println("Error starting command:", err)
		return
	}

	buf := make([]byte, 1024)          // Allocate a buffer to store the output
	n, err := io.ReadFull(stdout, buf) // Read all data from stdout into the buffer
	if err != nil {
		if err == io.EOF { // Handle end of file condition
			fmt.Println("File is empty")
		} else {
			fmt.Println("Error reading stdout:", err)
		}
		return
	}

	err = cmd.Wait() // Wait for the command to finish executing
	if err != nil {
		fmt.Println("Error waiting for command to finish:", err)
		return
	}

	fmt.Println("Commande terminée avec succès")
	fmt.Println("Sortie du script Bash:")
	fmt.Println(string(buf[:n])) // Print the captured output
}
