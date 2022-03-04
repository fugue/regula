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
	"bytes"
	"context"
	"crypto/sha1"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/fugue/regula/v2/pkg/rego"
	"github.com/fugue/regula/v2/pkg/reporter"
	"github.com/fugue/regula/v2/pkg/rule_waivers"
	"github.com/fugue/regula/v2/pkg/swagger/client"
	apiclient "github.com/fugue/regula/v2/pkg/swagger/client"
	"github.com/fugue/regula/v2/pkg/swagger/client/environments"
	"github.com/fugue/regula/v2/pkg/swagger/client/rule_bundles"
	waivers "github.com/fugue/regula/v2/pkg/swagger/client/rule_waivers"
	"github.com/fugue/regula/v2/pkg/swagger/models"
	"github.com/fugue/regula/v2/pkg/version"
	"github.com/go-openapi/runtime"
	httptransport "github.com/go-openapi/runtime/client"
	"github.com/go-openapi/strfmt"
	"github.com/sirupsen/logrus"
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
	RuleBundleProvider(rootDir string) rego.RegoProvider
	CustomRulesProvider() rego.RegoProvider
	CustomRuleProvider(ruleID string) rego.RegoProvider
	EnvironmentRegulaConfigProvider(environmentID string) rego.RegoProvider
	PostProcessReport(ctx context.Context, environmentID string, report *reporter.RegulaReport) error
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

	// Explicitly set this for downloading the rules bundle.
	transport.Consumers["application/gzip"] = runtime.ByteStreamConsumer()

	auth := httptransport.BasicAuth(clientID, clientSecret)

	return &fugueClient{
		client: client,
		auth:   auth,
	}, nil
}

func (c *fugueClient) RuleBundleProvider(rootDir string) rego.RegoProvider {
	cacheDir := filepath.Join(rootDir, ".regula/cache")
	bundlePath := filepath.Join(cacheDir, "bundle.tar.gz")

	return func(ctx context.Context, p rego.RegoProcessor) error {
		// Read the old bundle and store its hash.
		var etag *string
		oldBundle, err := os.ReadFile(bundlePath)
		if err == nil {
			hasher := sha1.New()
			hasher.Write(oldBundle)
			str := "\"" + hex.EncodeToString(hasher.Sum(nil)) + "\""
			etag = &str
			logrus.Infof("Found old bundle at %s with sha1 %s", bundlePath, str)
		} else if errors.Is(err, os.ErrNotExist) {
			logrus.Infof("No old bundle at %s", bundlePath)
		} else {
			return err
		}

		// Retrieve latest rule bundle
		var buffer bytes.Buffer
		var ruleBundle []byte
		getLatestRuleBundleParams := rule_bundles.GetLatestRuleBundleParams{
			RegulaVersion: version.PlainVersion(),
			Context:       ctx,
			IfNoneMatch:   etag,
		}
		logrus.Infof("Requesting rule bundle for version %s", getLatestRuleBundleParams.RegulaVersion)
		_, err = c.client.RuleBundles.GetLatestRuleBundle(&getLatestRuleBundleParams, c.auth, &buffer)
		if err == nil {
			ruleBundle = buffer.Bytes()

			// Write to filesystem.
			if err = os.MkdirAll(cacheDir, 0755); err != nil {
				return err
			}
			if err = os.WriteFile(bundlePath, ruleBundle, 0644); err != nil {
				return err
			}
		} else {
			if _, ok := err.(*rule_bundles.GetLatestRuleBundleNotModified); ok {
				logrus.Infof("Rule bundle not modified, using %s", bundlePath)
				ruleBundle = oldBundle
			} else if _, ok := err.(*rule_bundles.GetLatestRuleBundleForbidden); ok {
				logrus.Infof("Regula will sync rules and metadata locally, as your Fugue tenant is on a Developer plan")
				return rego.RegulaRulesProvider()(ctx, p)
			} else {
				return err
			}
		}

		return rego.TarGzProvider(bytes.NewReader(ruleBundle))(ctx, p)
	}
}

func (c *fugueClient) EnvironmentRegulaConfigProvider(environmentID string) rego.RegoProvider {
	provider := func(ctx context.Context, p rego.RegoProcessor) error {
		getEnvironmentRulesParams := &environments.GetEnvironmentRulesParams{
			EnvironmentID: environmentID,
			Context:       ctx,
		}
		result, err := c.client.Environments.GetEnvironmentRules(getEnvironmentRulesParams, c.auth)
		if err != nil {
			return err
		}

		numFugueRules := 0
		numCustomRules := 0
		rules := []string{}
		for _, item := range result.Payload.Items {
			if item.ID != nil {
				ruleID := *item.ID
				if strings.HasPrefix(ruleID, "FG_") {
					numFugueRules += 1
				} else {
					numCustomRules += 1
				}
				rules = append(rules, ruleID)
			}
		}
		logrus.Infof(
			"Selected %d Fugue rules and %d custom rules for environment %s",
			numFugueRules,
			numCustomRules,
			environmentID,
		)
		return rego.RegulaConfigProvider([]string{}, rules)(ctx, p)
	}
	return provider
}

func (c *fugueClient) listRuleWaivers(
	ctx context.Context,
	environmentID string,
) ([]rule_waivers.RuleWaiver, error) {
	isTruncated := true
	offset := int64(0)
	ruleWaivers := []*models.RuleWaiver{}

	query := []string{
		fmt.Sprintf("status:%s", "active"),
		fmt.Sprintf("environment_id:%s", environmentID),
	}
	queryBytes, err := json.Marshal(query)
	if err != nil {
		return nil, err
	}
	queryString := string(queryBytes)

	for isTruncated {
		listWaiversParams := &waivers.ListRuleWaiversParams{
			Offset:  &offset,
			Context: ctx,
			Query:   &queryString,
		}

		result, err := c.client.RuleWaivers.ListRuleWaivers(listWaiversParams, c.auth)
		if err != nil {
			return nil, err
		}
		logrus.Infof("Retrieved %d rule waivers...", len(result.Payload.Items))

		ruleWaivers = append(ruleWaivers, result.Payload.Items...)
		isTruncated = result.Payload.IsTruncated
		offset = result.Payload.NextOffset
	}

	waivers := []rule_waivers.RuleWaiver{}
	tagWaiversSkipped := 0
	for _, ruleWaiver := range ruleWaivers {
		waiver := ruleWaiverFromModel(ruleWaiver)
		if !(waiver.ResourceTag == "*" || waiver.ResourceTag == "") {
			tagWaiversSkipped += 1
		}
		waivers = append(waivers, waiver)
	}
	if tagWaiversSkipped > 0 {
		logrus.Infof("Skipped %d tag-based rule waivers...", tagWaiversSkipped)
	}

	return waivers, nil
}

func ruleWaiverFromModel(model *models.RuleWaiver) rule_waivers.RuleWaiver {
	nilToWildcard := func(val *string) string {
		if val == nil {
			return "*"
		} else {
			return *val
		}
	}

	rule_waiver := rule_waivers.RuleWaiver{
		ResourceTag:      model.ResourceTag,
		ResourceID:       nilToWildcard(model.ResourceID),
		ResourceProvider: nilToWildcard(model.ResourceProvider),
		ResourceType:     nilToWildcard(model.ResourceType),
		RuleID:           nilToWildcard(model.RuleID),
	}

	if model.ID != nil {
		rule_waiver.ID = *model.ID
	}

	return rule_waiver
}

func (c *fugueClient) PostProcessReport(
	ctx context.Context,
	environmentID string,
	report *reporter.RegulaReport,
) error {
	waivers, err := c.listRuleWaivers(ctx, environmentID)
	if err != nil {
		return err
	}

	rule_waivers.ApplyRuleWaivers(report, waivers)

	return nil
}
