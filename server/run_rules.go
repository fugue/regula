package main

import (
	"context"
	"fmt"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/reporter"
)

// Run rules as part of a single Regula evaluation. This is called once per
// HTTP request to the service. Update the parameters here as necessary.
// Currently this accepts an array of input file paths which will be treated
// as IaC templates. These files must exist on disk and be accessible to this
// service. If the HTTP request accepts an archive containing multiple IaC
// templates, the HTTP handler could unpack the archive to a temporary directory
// and then call this function with the paths to the files in that directory.
func runRules(
	ctx context.Context,
	inputPaths []string,
	inputType loader.InputType,
	format reporter.Format,
) (string, error) {

	// Process the input files. This converts HCL to JSON, for example.
	loadedFiles, err := loader.LoadPaths(loader.LoadPathsOptions{
		Paths:       inputPaths,
		InputType:   inputType,
		NoGitIgnore: true,
	})
	if err != nil {
		return "", fmt.Errorf("failed to load input files: %s", err)
	}

	// Run all loaded rules against the input files. There is some configuration
	// that can be done here to load rules selectively and the like.
	result, err := rego.RunRules(&rego.RunRulesOptions{
		Ctx:      ctx,
		UserOnly: false,
		Includes: []string{},
		Input:    loadedFiles.RegulaInput(),
	})
	if err != nil {
		return "", fmt.Errorf("failed to run rules: %s", err)
	}

	// The output here contains all rule results and a summary
	output, err := reporter.ParseRegulaOutput(loadedFiles, *result)
	if err != nil {
		return "", fmt.Errorf("failed to parse regula output: %s", err)
	}

	// Format and return the result report
	reporterFunc, err := reporter.GetReporter(format)
	if err != nil {
		return "", fmt.Errorf("failed to get reporter: %s", err)
	}
	report, err := reporterFunc(output)
	if err != nil {
		return "", fmt.Errorf("failed to run reporter: %s", err)
	}
	return report, nil
}
