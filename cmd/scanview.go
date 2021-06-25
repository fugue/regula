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
	"bytes"
	"context"
	_ "embed"
	"encoding/json"
	"fmt"
	"os"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	opa "github.com/open-policy-agent/opa/rego"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/thediveo/enumflag"
)

func NewScanViewCommand() *cobra.Command {
	var inputType loader.InputType
	cmd := &cobra.Command{
		Use:   "scan-view [input...]",
		Short: "Produce a Regula scan view for Fugue SaaS",
		Long:  longDescription,
		Run: func(cmd *cobra.Command, paths []string) {
			includes, err := cmd.Flags().GetStringSlice("include")
			if err != nil {
				logrus.Fatal(err)
			}
			userOnly, err := cmd.Flags().GetBool("user-only")
			if err != nil {
				logrus.Fatal(err)
			}
			noIgnore, err := cmd.Flags().GetBool("no-ignore")
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
				InputType:   inputType,
				NoGitIgnore: noIgnore,
			})
			if err != nil {
				logrus.Fatal(err)
			}
			result, err := rego.ScanView(&rego.ScanViewOptions{
				Ctx:      ctx,
				UserOnly: userOnly,
				Includes: includes,
				Input:    loadedFiles.RegulaInput(),
			})
			report, err := jsonMarshal(result)
			if err != nil {
				logrus.Fatal(err)
			}
			if report != "" {
				fmt.Println(report)
			}
		},
	}

	cmd.Flags().StringSliceP("include", "i", nil, "Specify additional rego files or directories to include")
	cmd.Flags().BoolP("user-only", "u", false, "Disable built-in rules")
	cmd.Flags().BoolP("no-ignore", "n", false, "Disable use of .gitignore")
	cmd.Flags().VarP(
		enumflag.New(&inputType, "string", loader.InputTypeIDs, enumflag.EnumCaseInsensitive),
		"input-type", "t",
		"Set the input type for the given paths")
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func jsonMarshal(r *opa.Result) (string, error) {
	buf := &bytes.Buffer{}
	enc := json.NewEncoder(buf)
	enc.SetEscapeHTML(false)
	enc.SetIndent("", "  ")
	if err := enc.Encode(r.Expressions[0].Value); err != nil {
		return "", err
	}
	return buf.String(), nil
}

func init() {
	rootCmd.AddCommand(NewScanViewCommand())
}
