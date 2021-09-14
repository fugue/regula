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
	"encoding/json"
	"fmt"

	"github.com/fugue/regula/pkg/loader"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

func NewShowCommand() *cobra.Command {
	inputTypes := []loader.InputType{loader.Auto}
	longDescription := `Show debug information.  Currently the available items are:
	input [file..]   Show the JSON input being passed to regula`
	cmd := &cobra.Command{
		Use:   "show [item]",
		Short: "Show debug information.",
		Long:  longDescription,
		Run: func(cmd *cobra.Command, args []string) {
			if len(args) < 1 {
				logrus.Fatal("Expected an item to show")
			}

			switch args[0] {
			case "input":
				paths := args[1:]
				loadedFiles, err := loader.LoadPaths(loader.LoadPathsOptions{
					Paths:      paths,
					InputTypes: inputTypes,
				})
				if err != nil {
					logrus.Fatal(err)
				}

				bytes, err := json.MarshalIndent(loadedFiles.RegulaInput(), "", "  ")
				if err != nil {
					logrus.Fatal(err)
				}
				fmt.Println(string(bytes))

			case "scan-view":
				paths := args[1:]
				// Initialize config
				config := loadScanConfig(paths)

				// Check that we can construct a client.
				ctx := context.Background()
				client, auth := getFugueClient()

				// Generate scan view
				scanViewString, err := runScan(
					ctx,
					client,
					auth,
					config,
				)
				if err != nil {
					logrus.Fatal(err)
				}
				if scanViewString == "" {
					logrus.Fatal("Could not create scan view")
				}
				fmt.Println(scanViewString)
			default:
				logrus.Fatalf("Unknown item: %s\n", args[0])
			}
		},
	}

	addInputTypeFlag(cmd, &inputTypes)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	rootCmd.AddCommand(NewShowCommand())
}
