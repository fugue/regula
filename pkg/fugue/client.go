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

package fugue

import (
	"context"
	"fmt"
	"os"

	"github.com/fugue/regula/pkg/rego"
	"github.com/fugue/regula/pkg/reporter"
	"github.com/fugue/regula/pkg/swagger/client"
	apiclient "github.com/fugue/regula/pkg/swagger/client"
	"github.com/go-openapi/runtime"
	httptransport "github.com/go-openapi/runtime/client"
	"github.com/go-openapi/strfmt"
)

const (
	// DefaultHost is the default hostname of the Fugue API
	DefaultHost = "api.riskmanager.fugue.co"

	// DefaultBase is the base path of the Fugue API
	DefaultBase = "v0"
)

func mustGetEnv(name string) (string, error) {
	value := os.Getenv(name)
	if value == "" {
		return "", fmt.Errorf("Missing environment variable: %s\n", name)
	}
	return value, nil
}

func getEnvWithDefault(name, defaultValue string) string {
	value := os.Getenv(name)
	if value == "" {
		return defaultValue
	}
	return value
}

type FugueClient interface {
	CustomRulesProvider() rego.RegoProvider
	CustomRuleProvider(ruleID string) rego.RegoProvider
	UploadScan(ctx context.Context, environmentId string, scanView reporter.ScanView) error
}

type fugueClient struct {
	client *client.Fugue
	auth   runtime.ClientAuthInfoWriter
}

func NewFugueClient() (FugueClient, error) {
	clientID, err := mustGetEnv("FUGUE_API_ID")
	if err != nil {
		return nil, err
	}
	clientSecret, err := mustGetEnv("FUGUE_API_SECRET")
	if err != nil {
		return nil, err
	}

	host := getEnvWithDefault("FUGUE_API_HOST", DefaultHost)
	base := getEnvWithDefault("FUGUE_API_BASE", DefaultBase)

	transport := httptransport.New(host, base, []string{"https"})
	client := apiclient.New(transport, strfmt.Default)

	auth := httptransport.BasicAuth(clientID, clientSecret)

	return &fugueClient{
		client: client,
		auth:   auth,
	}, nil
}
