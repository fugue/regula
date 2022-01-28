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
	"strings"

	"github.com/fugue/regula/v2/pkg/rego"
	"github.com/fugue/regula/v2/pkg/regotools/doublequote"
	"github.com/fugue/regula/v2/pkg/regotools/metadoc"
	"github.com/fugue/regula/v2/pkg/swagger/client/custom_rules"
	"github.com/fugue/regula/v2/pkg/swagger/models"
	"github.com/sirupsen/logrus"
)

func processCustomRule(rule *models.CustomRule) (rego.RegoFile, error) {
	regometa, err := metadoc.RegoMetaFromString(rule.RuleText)
	if err != nil {
		return nil, err
	}

	// Construct package name
	regometa.PackageName = "rules.rule_" + strings.ReplaceAll(rule.ID, "-", "_")

	// Copy info from SaaS into metadoc
	regometa.Id = rule.ID
	regometa.Title = rule.Name
	regometa.Description = rule.Description
	regometa.Severity = rule.Severity

	// Follow custom rule control scheme used in SaaS.
	regometa.Controls = map[string][]string{
		"Custom": {"custom/" + rule.Name},
	}
	regometa.Families = rule.Families

	// Only set resource_type if not set explicitly.
	if regometa.ResourceType == "" {
		if rule.ResourceType == "MULTIPLE" {
			regometa.ResourceType = "MULTIPLE"
		} else if rule.TfResourceType != "" {
			regometa.ResourceType = rule.TfResourceType
		} else {
			return nil, fmt.Errorf("Unknown resource type: %s", rule.ResourceType)
		}
	}

	// Ensure data.fugue import is there.
	regometa.Imports[metadoc.Import{Path: "data.fugue"}] = struct{}{}

	// Turn single quotes into double quotes.
	text := doublequote.Doublequote(regometa.String())

	ruleName := fmt.Sprintf("Custom rule %s", rule.ID)

	return rego.RegoFileFromString(ruleName, text), nil
}

func (c *fugueClient) CustomRulesProvider() rego.RegoProvider {
	return func(ctx context.Context, p rego.RegoProcessor) error {
		ruleStatus := "ENABLED"
		isTruncated := true
		offset := int64(0)
		for isTruncated {
			listCustomRulesParams := &custom_rules.ListCustomRulesParams{
				Offset:  &offset,
				Status:  &ruleStatus,
				Context: ctx,
			}
			result, err := c.client.CustomRules.ListCustomRules(listCustomRulesParams, c.auth)
			if err != nil {
				return err
			}
			logrus.Infof("Retrieved %d custom rules...", len(result.Payload.Items))
			for _, item := range result.Payload.Items {
				rule, err := processCustomRule(item)
				if err != nil {
					logrus.Warningf("Could not load rule %s: %d", item.ID, err)
				}
				if err := p(rule); err != nil {
					return err
				}
			}
			isTruncated = result.Payload.IsTruncated
			offset = result.Payload.NextOffset
		}

		return nil
	}
}

func (c *fugueClient) CustomRuleProvider(ruleID string) rego.RegoProvider {
	return func(ctx context.Context, p rego.RegoProcessor) error {
		getCustomRuleParams := &custom_rules.GetCustomRuleParams{
			RuleID:  ruleID,
			Context: ctx,
		}
		result, err := c.client.CustomRules.GetCustomRule(getCustomRuleParams, c.auth)
		if err != nil {
			return err
		}
		rule, err := processCustomRule(result.Payload)
		if err != nil {
			logrus.Warningf("Could not load rule %s: %d", ruleID, err)
		}
		if err := p(rule); err != nil {
			return err
		}

		return nil
	}
}
