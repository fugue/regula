package cmd

import (
	"context"
	"fmt"
	"os"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/loader/base"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/spf13/cobra"
	"github.com/thediveo/enumflag"
)

func NewRunCommand() *cobra.Command {
	var inputType base.InputType
	cmd := &cobra.Command{
		Use:   "run",
		Short: "Run Regula rules on inputs",
		Run: func(cmd *cobra.Command, args []string) {
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

			loadedFiles, err := loader.LoadPaths(args, inputType)
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}

			results, err := ruleRunner.Run(loadedFiles.RegulaInput())
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}

			reporterFunc, _ := reporter.GetReporter("json")
			for _, r := range results {
				output, err := reporter.ParseRegulaOutput(r)
				if err != nil {
					fmt.Println(err)
					os.Exit(1)
				}
				report, err := reporterFunc(loadedFiles, output)
				if err != nil {
					fmt.Println(err)
					os.Exit(1)
				}
				fmt.Println(report)
			}
		},
	}

	cmd.Flags().StringSliceP("include", "i", nil, "Select rego libraries to include")
	cmd.Flags().BoolP("user-only", "u", false, "Disable built-in rules")
	cmd.Flags().VarP(
		enumflag.New(&inputType, "input-type", base.InputTypeIds, enumflag.EnumCaseInsensitive),
		"input-type", "t",
		"Explicitly set the input type")
	return cmd
}

func init() {
	rootCmd.AddCommand(NewRunCommand())
}
