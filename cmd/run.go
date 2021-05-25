// Copyright 2021 Fugue, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	"context"
	_ "embed"
	"fmt"
	"os"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/spf13/cobra"
	"github.com/thediveo/enumflag"
)

//go:embed run.txt
var longDescription string

func NewRunCommand() *cobra.Command {
	var inputType loader.InputType
	var format reporter.Format
	severity := reporter.Unknown
	cmd := &cobra.Command{
		Use:   "run [input...]",
		Short: "Evaluate rules against infrastructure-as-code with Regula.",
		Long:  longDescription,
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
			ctx := context.TODO()
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			if len(paths) < 1 {
				stat, _ := os.Stdin.Stat()
				if (stat.Mode() & os.ModeCharDevice) == 0 {
					paths = []string{"-"}
				} else {
					// Not using os.Getwd here so that we get relative paths.
					// A single dot should mean the same on windows.
					paths = []string{"."}
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
			result, err := rego.RunRules(&rego.RunRulesOptions{
				Ctx:      ctx,
				UserOnly: userOnly,
				Includes: includes,
				Input:    loadedFiles.RegulaInput(),
			})
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			reporterFunc, err := reporter.GetReporter(format)
			if err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			output, err := reporter.ParseRegulaOutput(loadedFiles, *result)
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

	cmd.Flags().StringSliceP("include", "i", nil, "Specify additional rego files or directories to include")
	cmd.Flags().BoolP("user-only", "u", false, "Disable built-in rules")
	cmd.Flags().BoolP("no-ignore", "n", false, "Disable use of .gitignore")
	cmd.Flags().VarP(
		enumflag.New(&inputType, "input-type", loader.InputTypeIDs, enumflag.EnumCaseInsensitive),
		"input-type", "t",
		"Set the input type for the given paths")
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
