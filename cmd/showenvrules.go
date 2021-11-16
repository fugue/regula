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
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func NewShowEnvironmentRulesCommand() *cobra.Command {
	v := viper.New()
	cmd := &cobra.Command{
		Use:   "environment-rules",
		Short: "Show the rule IDs configured for this environment",
		RunE: func(cmd *cobra.Command, args []string) error {

			// Load config
			if err := loadConfigFile("", v); err != nil {
				return err
			}
			environmentID := v.GetString(environmentIDFlag)
			if environmentID == "" {
				return fmt.Errorf("%s must be set", environmentIDFlag)
			}

			// Silence usage now that we're past arg parsing
			cmd.SilenceUsage = true
			client, err := fugue.NewFugueClient()
			if err != nil {
				return err
			}
			ctx := context.Background()
			rules, err := client.EnvironmentRules(ctx, environmentID)
			if err != nil {
				return err
			}
			for _, rule := range rules {
				fmt.Printf("- %s\n", rule)
			}
			return nil
		},
	}

	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	showCommand.AddCommand(NewShowEnvironmentRulesCommand())
}
