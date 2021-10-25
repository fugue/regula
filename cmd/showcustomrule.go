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
	"fmt"

	"github.com/fugue/regula/pkg/fugue"
	"github.com/fugue/regula/pkg/rego"
	"github.com/spf13/cobra"
)

func NewShowCustomRuleCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "custom-rule <rule ID>",
		Short: "Show a custom rule from your Fugue account",
		RunE: func(cmd *cobra.Command, args []string) error {
			if len(args) > 1 {
				return fmt.Errorf("Only one Rule ID can be specified at a time.")
			}
			if len(args) < 1 {
				return fmt.Errorf("A Rule ID must be specified.")
			}
			cmd.SilenceUsage = true
			ruleID := args[0]
			client, err := fugue.NewFugueClient()
			if err != nil {
				return err
			}
			cb := func(r rego.RegoFile) error {
				fmt.Print(r.String())
				return nil
			}
			provider := client.CustomRuleProvider(ruleID)
			ctx := context.Background()
			if err := provider(ctx, cb); err != nil {
				return err
			}
			return nil
		},
	}

	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	showCommand.AddCommand(NewShowCustomRuleCommand())
}
