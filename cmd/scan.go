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
	"net/http"
	"os"
	"strings"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/swagger/client"
	apiclient "github.com/fugue/regula/pkg/swagger/client"
	"github.com/fugue/regula/pkg/swagger/client/scans"
	"github.com/go-openapi/runtime"
	httptransport "github.com/go-openapi/runtime/client"
	"github.com/go-openapi/strfmt"
	opa "github.com/open-policy-agent/opa/rego"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
	"github.com/thediveo/enumflag"
)

const (
	// DefaultHost is the default hostname of the Fugue API
	DefaultHost = "api.riskmanager.fugue.co"

	// DefaultBase is the base path of the Fugue API
	DefaultBase = "v0"
)

func mustGetEnv(name string) string {
	value := os.Getenv(name)
	if value == "" {
		fmt.Fprintf(os.Stderr, "Missing environment variable: %s\n", name)
		os.Exit(1)
	}
	return value
}

func getEnvWithDefault(name, defaultValue string) string {
	value := os.Getenv(name)
	if value == "" {
		return defaultValue
	}
	return value
}

func getFugueClient() (*client.Fugue, runtime.ClientAuthInfoWriter) {
	clientID := mustGetEnv("FUGUE_API_ID")
	clientSecret := mustGetEnv("FUGUE_API_SECRET")

	host := getEnvWithDefault("FUGUE_API_HOST", DefaultHost)
	base := getEnvWithDefault("FUGUE_API_BASE", DefaultBase)

	transport := httptransport.New(host, base, []string{"https"})
	client := apiclient.New(transport, strfmt.Default)

	auth := httptransport.BasicAuth(clientID, clientSecret)

	return client, auth
}

func scanInputTypes() []loader.InputType {
	scanInputTypes := make([]loader.InputType, len(loader.InputTypeIDs)-2)
	for i := range loader.InputTypeIDs {
		if i == loader.Auto || i == loader.TfPlan {
			continue
		}
		scanInputTypes = append(scanInputTypes, i)
	}
	return scanInputTypes
}

func filterInputTypes(inputTypes []loader.InputType) []loader.InputType {
	autoTypes := scanInputTypes()
	filtered := []loader.InputType{}
	for _, i := range inputTypes {
		switch i {
		case loader.Auto:
			filtered = append(filtered, autoTypes...)
		case loader.TfPlan:
			logrus.Warn("Ignoring tf-plan in input types. Terraform plan files are not supported by regula scan at this time.")
		default:
			filtered = append(filtered, i)
		}
	}
	if len(filtered) < 1 {
		logrus.Warn("No supported input types configured. Defaulting to 'auto'.")
		return autoTypes
	}
	return filtered
}

func NewScanCommand() *cobra.Command {
	inputTypes := []loader.InputType{loader.Auto}
	cmd := &cobra.Command{
		Use:   "scan [directory with regula config]",
		Short: "Run regula and upload results to Fugue SaaS",
		Run: func(cmd *cobra.Command, paths []string) {
			if len(paths) > 1 {
				logrus.Fatal("regula scan only takes one directory that contains a regula configuration file.")
			} else if len(paths) == 1 {
				if err := os.Chdir(paths[0]); err != nil {
					logrus.Fatal(err)
				}
			}

			viper.BindEnv(environmentIdFlag, "ENVIRONMENT_ID")

			if err := loadConfigFile(""); err != nil {
				logrus.Fatal(err)
			}
			if c := viper.ConfigFileUsed(); c == "" {
				logrus.Fatal("A configuration file is required for regula scan.")
			}

			// Need to find a better long-term solution for enums with viper. These
			// libraries do not play nicely with eachother.
			flagSet := pflag.NewFlagSet("", pflag.ExitOnError)
			pf := flagSet.VarPF(
				// Still using full InputTypeIDs map here because this config file also
				// needs to work with regula run. So, we need to support all input types.
				enumflag.NewSlice(&inputTypes, "string", loader.InputTypeIDs, enumflag.EnumCaseInsensitive),
				inputTypeFlag,
				"",
				"",
			)
			if viper.IsSet(inputTypeFlag) {
				value := strings.Join(viper.GetStringSlice(inputTypeFlag), ",")
				if err := pf.Value.Set(value); err != nil {
					logrus.Fatal(fmt.Errorf("Invalid value for '%s' in config file: %s", inputTypeFlag, err))
				}
			}

			userOnly := viper.GetBool(userOnlyFlag)
			environmentId := viper.GetString(environmentIdFlag)
			if environmentId == "" {
				logrus.Fatal("An environment ID is required for regula scan. It can be set either in the regula configuration file or via the ENVIRONMENT_ID environment variable.")
			}
			var inputs []string
			if p := viper.GetStringSlice(inputsFlag); p != nil {
				// Inputs are set in config file
				inputs = p
			} else {
				// Otherwise use CWD
				inputs = []string{"."}
			}

			// Check that we can construct a client.
			client, auth := getFugueClient()

			// Load files first.
			loadedFiles, err := loader.LoadPaths(loader.LoadPathsOptions{
				Paths:      inputs,
				InputTypes: filterInputTypes(inputTypes),
			})
			if err != nil {
				logrus.Fatal(err)
			}

			// Produce scan view.
			ctx := context.Background()
			result, err := rego.ScanView(&rego.ScanViewOptions{
				Ctx:      ctx,
				UserOnly: userOnly,
				Input:    loadedFiles.RegulaInput(),
			})
			if err != nil {
				logrus.Fatal(err)
			}
			scanViewString, err := jsonMarshal(result)
			if err != nil {
				logrus.Fatal(err)
			}
			if scanViewString == "" {
				logrus.Fatal("Could not create scan view")
			}

			// Create scan.
			logrus.Infof("Creating scan for environment %s...", environmentId)
			createScanParams := &scans.CreateScanParams{
				EnvironmentID: environmentId,
				Context:       ctx,
			}
			createScanResponse, err := client.Scans.CreateScan(createScanParams, auth)
			if err != nil {
				logrus.Fatal(err)
			}

			// Get presigned S3 URL for scan view upload.
			scanId := createScanResponse.Payload.ID
			logrus.Infof("Retrieving presigned URL for scan %s...", scanId)
			uploadScanViewParams := &scans.UploadRegulaScanViewParams{
				ScanID:  scanId,
				Context: ctx,
			}
			uploadScanViewResponse, err := client.Scans.UploadRegulaScanView(uploadScanViewParams, auth)
			if err != nil {
				logrus.Fatal(err)
			}

			// Use presigned URL to upload scan view.
			logrus.Infof("Uploading to presigned URL...")
			uploadUrl := uploadScanViewResponse.Payload.URL
			httpClient := &http.Client{}
			uploadRequest, err := http.NewRequestWithContext(ctx, http.MethodPut, uploadUrl, bytes.NewBufferString(scanViewString))
			if err != nil {
				logrus.Fatal(err)
			}
			uploadRequest.Header.Set("Content-Type", "application/json")
			uploadResponse, err := httpClient.Do(uploadRequest)
			if err != nil {
				logrus.Fatal(err)
			}
			if uploadResponse.StatusCode != 200 {
				logrus.Fatalf("Upload response: %s", uploadResponse.Status)
			}

			logrus.Infof("OK")
		},
	}

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
	rootCmd.AddCommand(NewScanCommand())
}
