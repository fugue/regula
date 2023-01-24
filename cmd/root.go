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
	"math/rand"
	"os"
	"time"

	"github.com/fugue/regula/v3/pkg/rego"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

var verbose bool

var rootCmd = &cobra.Command{
	Use:   "regula",
	Short: "Regula",
	PersistentPreRun: func(cmd *cobra.Command, paths []string) {
		if verbose {
			logrus.SetLevel(logrus.DebugLevel)
		}
	},
	PersistentPreRunE: func(cmd *cobra.Command, paths []string) error {
		if verbose {
			logrus.SetLevel(logrus.DebugLevel)
		}
		cmd.SilenceErrors = true
		return nil
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		if _, ok := err.(*ExceedsSeverityError); ok {
			os.Exit(1)
		}
		if _, ok := err.(*rego.TestsFailedError); ok {
			os.Exit(1)
		}
		logrus.Fatal(err)
	}
}

func init() {

	rand.Seed(time.Now().Unix())

	logrus.SetFormatter(&logrus.TextFormatter{
		DisableTimestamp:       true,
		DisableLevelTruncation: true,
	})

	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false, "verbose output")
}
