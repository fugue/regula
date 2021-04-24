package cmd

import (
	"context"
	"fmt"
	"os"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/spf13/cobra"
)

func NewRunCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "run",
		Short: "Run Regula rules on inputs",
		Run: func(cmd *cobra.Command, args []string) {
			ctx := context.TODO()
			ruleRunner, err := rego.NewRuleRunner(&rego.RuleRunnerOptions{
				Ctx: ctx,
			})

			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}

			for _, input := range args {
				inputLoader, err := loader.GetLoaderByFileName(input)
				if err != nil {
					fmt.Println(err)
					os.Exit(1)
				}

				opaInput, err := inputLoader.OpaInput()
				if err != nil {
					fmt.Println(err)
					os.Exit(1)
				}

				results, err := ruleRunner.Run(opaInput)

				if err != nil {
					fmt.Println(err)
					os.Exit(1)
				}

				reporterFunc, _ := reporter.GetReporter("json")

				for _, r := range results {
					output, err := reporter.ParseRegulaOutput(r)
					report, err := reporterFunc(&inputLoader, output)
					if err != nil {
						fmt.Println(err)
						os.Exit(1)
					}
					fmt.Println(report)
				}
			}
		},
	}

	return cmd
}

func init() {
	rootCmd.AddCommand(NewRunCommand())
}
