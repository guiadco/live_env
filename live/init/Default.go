package init

import (
	"fmt"
	"os"
)

func Default() {
	workDir, err := os.Getwd()
	if err != nil {
		panic(err)
	}
	// Define where we are
	fmt.Println("We are here:", workDir)
	fmt.Println("Creating live directory structure...")
	CreateDir(".live")
	CreateDir("infra/terraform")
}
