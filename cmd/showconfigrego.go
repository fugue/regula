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
	"github.com/spf13/viper"
)

func NewShowConfigCommand() *cobra.Command {
	v := viper.New()
	cmd := &cobra.Command{
		Use:   "config-rego <options>",
		Short: "Show the generated config rego file",
		RunE: func(cmd *cobra.Command, _ []string) error {
			excludes, err := cmd.Flags().GetStringSlice(excludeFlag)
			if err != nil {
				return err
			}
			only, err := cmd.Flags().GetStringSlice(onlyFlag)
			if err != nil {
				return err
			}
			sync := v.GetBool(syncFlag)
			environmentId := v.GetString(environmentIDFlag)
			if sync && environmentId == "" {
				return fmt.Errorf("%s must be set", environmentIDFlag)
			}

			// Silence usage now that we're past arg parsing
			cmd.SilenceUsage = true
			cb := func(r rego.RegoFile) error {
				fmt.Print(r.String())
				return nil
			}
			var provider rego.RegoProvider
			if sync {
				client, err := fugue.NewFugueClient()
				if err != nil {
					return err
				}
				provider = client.EnvironmentRegulaConfigProvider(environmentId)
			} else {
				provider = rego.RegulaConfigProvider(excludes, only)
			}
			ctx := context.Background()
			if err := provider(ctx, cb); err != nil {
				return err
			}
			return nil
		},
	}

	addExcludeFlag(cmd, v)
	addEnvironmentIDFlag(cmd, v)
	addOnlyFlag(cmd, v)
	addSyncFlag(cmd, v)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	showCommand.AddCommand(NewShowConfigCommand())
}
