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
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

//go:embed run.txt
var runDescription string

func NewRunCommand() *cobra.Command {
	inputTypes := []loader.InputType{loader.Auto}
	format := reporter.Text
	severity := reporter.Unknown
	cmd := &cobra.Command{
		Use:   "run [input...]",
		Short: "Evaluate rules against infrastructure as code with Regula.",
		Long: joinDescriptions(
			runDescription,
			inputTypeDescriptions,
			formatDescriptions,
			severityDescriptions),
		Run: func(cmd *cobra.Command, paths []string) {
			includes, err := cmd.Flags().GetStringSlice(includeFlag)
			if err != nil {
				logrus.Fatal(err)
			}
			userOnly, err := cmd.Flags().GetBool(userOnlyFlag)
			if err != nil {
				logrus.Fatal(err)
			}
			noIgnore, err := cmd.Flags().GetBool(noIgnoreFlag)
			if err != nil {
				logrus.Fatal(err)
			}
			ctx := context.TODO()
			if err != nil {
				logrus.Fatal(err)
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
				Paths:       paths,
				InputTypes:  inputTypes,
				NoGitIgnore: noIgnore,
			})
			if err != nil {
				logrus.Fatal(err)
			}
			result, err := rego.RunRules(&rego.RunRulesOptions{
				Ctx:      ctx,
				UserOnly: userOnly,
				Includes: includes,
				Input:    loadedFiles.RegulaInput(),
			})
			if err != nil {
				logrus.Fatal(err)
			}
			reporterFunc, err := reporter.GetReporter(format)
			if err != nil {
				logrus.Fatal(err)
			}
			output, err := reporter.ParseRegulaOutput(loadedFiles, *result)
			if err != nil {
				logrus.Fatal(err)
			}
			report, err := reporterFunc(output)
			if err != nil {
				logrus.Fatal(err)
			}
			if report != "" {
				fmt.Println(report)
			}
			if output.ExceedsSeverity(severity) {
				os.Exit(1)
			}
		},
	}

	addIncludeFlag(cmd)
	addUserOnlyFlag(cmd)
	addNoIgnoreFlag(cmd)
	addInputTypeFlag(cmd, &inputTypes)
	addSeverityFlag(cmd, &severity)
	addFormatFlag(cmd, &format)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	rootCmd.AddCommand(NewRunCommand())
}
