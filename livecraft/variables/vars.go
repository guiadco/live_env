package variables

import (
	"fmt"
	"os"
)

func CheckVariables() {
	// Check if RUNS_ON_GITHUB is present or not
	_, runs_on_github := os.LookupEnv("RUNS_ON_GITHUB")
	if runs_on_github {
		fmt.Printf("RUNS_ON_GITHUB: %t\n", runs_on_github)
	}

	_, gitlab_ci := os.LookupEnv("GITLAB_CI")
	if gitlab_ci {
		fmt.Printf("GITLAB_CI: %t\n", gitlab_ci)
	}

	if !runs_on_github && !gitlab_ci {
		fmt.Println("Local runs")
	}
	// Get git informations
	gitInfos()

}
