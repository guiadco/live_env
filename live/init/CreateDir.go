package init

import (
	"log"
	"os"
)

func CreateDir(dir string) {
	if err := os.MkdirAll(dir, os.ModePerm); err != nil {
		log.Fatal(err)
	}
}
