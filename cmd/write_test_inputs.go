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
	_ "embed"
	"os"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/thediveo/enumflag"
)

func NewWriteTestInputsCommand() *cobra.Command {
	var inputType loader.InputType
	cmd := &cobra.Command{
		Use:   "write-test-inputs [input...]",
		Short: "Persist dynamically-generated test inputs for use with other Rego interpreters",
		Run: func(cmd *cobra.Command, paths []string) {
			cb := func(r rego.RegoFile) error {
				return os.WriteFile(r.Path(), r.Raw(), 0644)
			}
			if err := rego.LoadTestInputs(paths, inputType, cb); err != nil {
				logrus.Fatal(err)
			}
		},
	}

	cmd.Flags().VarP(
		enumflag.New(&inputType, "input-type", loader.InputTypeIDs, enumflag.EnumCaseInsensitive),
		"input-type", "t",
		"Set the input type for the given paths")
	return cmd
}

func init() {
	rootCmd.AddCommand(NewWriteTestInputsCommand())
}
