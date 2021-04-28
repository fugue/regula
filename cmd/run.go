package cmd

import (
	"context"
	"fmt"
	"os"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/reporter"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/thediveo/enumflag"
	"golang.org/x/crypto/ssh/terminal"
)

func NewRunCommand() *cobra.Command {
	var inputType loader.InputType
	var format reporter.Format
	severity := reporter.Unknown
	cmd := &cobra.Command{
		Use:   "run",
		Short: "Run Regula rules on inputs",
		Run: func(cmd *cobra.Command, paths []string) {
			includes, err := cmd.Flags().GetStringSlice("include")
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			userOnly, err := cmd.Flags().GetBool("user-only")
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			noIgnore, err := cmd.Flags().GetBool("no-ignore")
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			debug, err := cmd.Flags().GetBool("debug")
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			if debug {
				log.SetLevel(log.DebugLevel)
			}
			ctx := context.TODO()
			ruleRunner, err := rego.NewRuleRunner(&rego.RuleRunnerOptions{
				Ctx:      ctx,
				UserOnly: userOnly,
				Includes: includes,
			})

			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}

			if len(paths) < 1 {
				if terminal.IsTerminal(int(os.Stdin.Fd())) {
					// Not using os.Getwd here so that we get relative paths.
					// A single dot should mean the same on windows.
					paths = []string{"."}
				} else {
					paths = []string{"-"}
				}
			}

			loadedFiles, err := loader.LoadPaths(loader.LoadPathsOptions{
				Paths:     paths,
				InputType: inputType,
				NoIgnore:  noIgnore,
			})
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}

			results, err := ruleRunner.Run(loadedFiles.RegulaInput())
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}

			reporterFunc, _ := reporter.GetReporter(format)
			r := results[0]
			output, err := reporter.ParseRegulaOutput(loadedFiles, r)
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			report, err := reporterFunc(output)
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			if report != "" {
				fmt.Println(report)
			}
			if output.ExceedsSeverity(severity) {
				os.Exit(1)
			}
		},
	}

	cmd.Flags().StringSliceP("include", "i", nil, "Select rego libraries to include")
	cmd.Flags().BoolP("user-only", "u", false, "Disable built-in rules")
	cmd.Flags().BoolP("no-ignore", "n", false, "Disable .gitignore rules")
	cmd.Flags().BoolP("debug", "d", false, "Enable debug output")
	cmd.Flags().VarP(
		enumflag.New(&inputType, "input-type", loader.InputTypeIds, enumflag.EnumCaseInsensitive),
		"input-type", "t",
		"Explicitly set the input type")
	cmd.Flags().VarP(
		enumflag.New(&severity, "severity", reporter.SeverityIds, enumflag.EnumCaseInsensitive),
		"severity", "s",
		"Set the minimum severity that will result in a non-zero exit code.")
	cmd.Flags().VarP(
		enumflag.New(&format, "format", reporter.FormatIds, enumflag.EnumCaseInsensitive),
		"format", "f",
		"Set the output format")
	return cmd
}

func init() {
	rootCmd.AddCommand(NewRunCommand())
}
