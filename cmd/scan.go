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
	"fmt"
	"net/http"
	"os"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/swagger/client"
	apiclient "github.com/fugue/regula/pkg/swagger/client"
	"github.com/fugue/regula/pkg/swagger/client/scans"
	"github.com/go-openapi/runtime"
	httptransport "github.com/go-openapi/runtime/client"
	"github.com/go-openapi/strfmt"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
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

func NewScanCommand() *cobra.Command {
	inputTypes := []loader.InputType{loader.Auto}
	cmd := &cobra.Command{
		Use:   "scan [input...]",
		Short: "Run regula and upload results to Fugue SaaS",
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
			environmentId, err := cmd.Flags().GetString("environment-id")
			if err != nil {
				logrus.Fatal(err)
			}
			ctx := context.Background()
			if err != nil {
				logrus.Fatal(err.Error())
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

			// Check that we can construct a client.
			client, auth := getFugueClient()

			// Load files first.
			loadedFiles, err := loader.LoadPaths(loader.LoadPathsOptions{
				Paths:       paths,
				InputTypes:  inputTypes,
				NoGitIgnore: noIgnore,
			})
			if err != nil {
				logrus.Fatal(err)
			}

			// Produce scan view.
			result, err := rego.ScanView(&rego.ScanViewOptions{
				Ctx:      ctx,
				UserOnly: userOnly,
				Includes: includes,
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

	addIncludeFlag(cmd)
	addUserOnlyFlag(cmd)
	addNoIgnoreFlag(cmd)
	addInputTypeFlag(cmd, &inputTypes)
	addEnvironmentIdFlag(cmd)
	cmd.Flags().SetNormalizeFunc(normalizeFlag)
	return cmd
}

func init() {
	rootCmd.AddCommand(NewScanCommand())
}
