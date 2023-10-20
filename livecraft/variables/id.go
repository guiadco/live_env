package variables

import (
	"fmt"
	"log"
	"os"

	git "github.com/go-git/go-git/v5"
)

func gitInfos() {
	// Chemin du dépôt Git local
	dir, err := os.Getwd()
	if err != nil {
		log.Fatal(err)
	}
	// Ouvrir le dépôt local
	repo, err := git.PlainOpen(dir)
	if err != nil {
		log.Fatal(err)
	}

	// Récupérer la référence HEAD
	ref, err := repo.Head()
	if err != nil {
		log.Fatal(err)
	}

	// Récupérer le commit
	commit, err := repo.CommitObject(ref.Hash())
	if err != nil {
		log.Fatal(err)
	}
	current_branch := ref.Name().Short()

	if current_branch == "main" || current_branch == "master" {
		hashShort := "prod"
		fmt.Println("Commit ID:", commit.ID())
		fmt.Println("CURRENT_BRANCH:", current_branch)
		os.Setenv("CURRENT_BRANCH", current_branch)
		fmt.Println("STAGE:", hashShort)
		os.Setenv("STAGE", hashShort)
	} else {
		hashLong := ref.Hash().String()
		hashShort := hashLong[:7]
		fmt.Println("Commit ID:", commit.ID())
		fmt.Println("CURRENT_BRANCH:", current_branch)
		os.Setenv("CURRENT_BRANCH", current_branch)
		fmt.Println("STAGE:", hashShort)
		os.Setenv("STAGE", hashShort)
	}
}
