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
	"encoding/json"
	"fmt"

	"github.com/fugue/regula/pkg/loader"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/thediveo/enumflag"
)

func NewShowCommand() *cobra.Command {
	var inputType loader.InputType

	cmd := &cobra.Command{
		Use:   "show [item]",
		Short: "Show debug information.",
		Long: `Show debug information.  Currently the available items are:
  input [file..]   Show the JSON input being passed to regula`,
		Run: func(cmd *cobra.Command, args []string) {
			if len(args) < 1 {
				logrus.Fatal("Expected an item to show")
			}

			switch args[0] {
			case "input":
				paths := args[1:]
				loadedFiles, err := loader.LoadPaths(loader.LoadPathsOptions{
					Paths:     paths,
					InputType: inputType,
				})
				if err != nil {
					logrus.Fatal(err)
				}

				bytes, err := json.MarshalIndent(loadedFiles.RegulaInput(), "", "  ")
				if err != nil {
					logrus.Fatal(err)
				}
				fmt.Println(string(bytes))

			default:
				logrus.Fatalf("Unknown item: %s\n", args[0])
			}
		},
	}

	cmd.Flags().VarP(
		enumflag.New(&inputType, "string", loader.InputTypeIDs, enumflag.EnumCaseInsensitive),
		"input-type", "t",
		"Set the input type for the given paths")
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	rootCmd.AddCommand(NewShowCommand())
}
