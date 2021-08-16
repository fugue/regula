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

	"github.com/fugue/regula/pkg/rego"

	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

func NewTestCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "test [paths containing rego or test inputs]",
		Short: "Run OPA test with Regula.",
		Run: func(cmd *cobra.Command, includes []string) {
			trace, err := cmd.Flags().GetBool(traceFlag)
			if err != nil {
				logrus.Fatal(err)
			}
			noTestInputs, err := cmd.Flags().GetBool(noTestInputsFlag)
			if err != nil {
				logrus.Fatal(err)
			}
			ctx := context.Background()
			err = rego.RunTest(&rego.RunTestOptions{
				Ctx:          ctx,
				Includes:     includes,
				Trace:        trace,
				NoTestInputs: noTestInputs,
			})
			if err != nil {
				logrus.Fatal(err)
			}
		},
	}
	addTraceFlag(cmd)
	addNoTestInputsFlag(cmd)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	rootCmd.AddCommand(NewTestCommand())
}
