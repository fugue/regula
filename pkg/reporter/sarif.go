// Copyright 2022 Fugue, Inc.
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

package reporter

import (
	"bytes"

	"github.com/fugue/regula/v3/pkg/loader"
	"github.com/fugue/regula/v3/pkg/version"
	"github.com/owenrumney/go-sarif/v2/sarif"
)

func SarifReporter(o *RegulaReport) (string, error) {
	report, err := sarif.New(sarif.Version210)
	if err != nil {
		return "", err
	}

	driver := sarif.NewDriver("regula").
		WithSemanticVersion(version.PlainVersion()).
		WithInformationURI(version.Homepage)
	tool := sarif.NewTool(driver)
	run := sarif.NewRun(*tool)

	// AddDistinctArtifact is slow, use a set instead
	artifacts := map[string]struct{}{}

	// First add all rule metadata
	addedRules := map[string]struct{}{}
	for _, r := range o.RuleResults {
		if _, ok := addedRules[r.RuleID]; !ok {
			addedRules[r.RuleID] = struct{}{}
			rule := run.AddRule(r.RuleID)
			if r.RuleSummary != "" {
				rule = rule.WithShortDescription(sarif.NewMultiformatMessageString(r.RuleSummary))
			}
			if r.RuleDescription != "" {
				rule = rule.WithFullDescription(
					sarif.NewMultiformatMessageString(r.RuleDescription).
						WithMarkdown(r.RuleDescription),
				)
			}
			if r.RuleRemediationDoc != "" {
				rule = rule.WithHelpURI(r.RuleRemediationDoc)
			}
		}
	}

	// Now add all actual results
	for _, r := range o.RuleResults {
		artifacts[r.Filepath] = struct{}{}
		result := run.CreateResultForRule(r.RuleID).
			WithLevel(ToSarifLevel(r.RuleResult, r.RuleSeverity)).
			WithMessage(sarif.NewTextMessage(r.Message()))

		// Important properties that don't fit well into the sarif format.
		// SHOULD be camelCase properties.
		props := sarif.NewPropertyBag()
		props.Add("resourceId", r.ResourceID)
		props.Add("resourceType", r.ResourceType)
		props.Add("inputType", r.InputType)
		props.Add("controls", r.Controls)
		props.Add("families", r.Families)
		result.PropertyBag = *props

		if r.IsWaived() || r.IsPass() {
			result = result.WithKind("pass")
		} else {
			result = result.WithKind("fail")
		}

		if r.IsWaived() {
			result = result.WithSuppression([]*sarif.Suppression{
				sarif.NewSuppression("external"),
			})
		}

		l := r.SourceLocation
		if l != nil && len(l) > 0 {
			artifacts[l[0].Path] = struct{}{}
			result.AddLocation(ToSarifLocation(l[0]))

			for i := 1; i < len(l); i++ {
				artifacts[l[i].Path] = struct{}{}
				result.AddRelatedLocation(ToSarifLocation(l[i]))
			}
		}
	}

	for path := range artifacts {
		run.AddArtifact().WithLocation(sarif.NewSimpleArtifactLocation(path))
	}

	report.AddRun(run)
	buffer := bytes.NewBuffer([]byte{})
	if err := report.PrettyWrite(buffer); err != nil {
		return "", err
	}
	return buffer.String(), nil
}

// Turns a regula location into a sarif location
func ToSarifLocation(l loader.Location) *sarif.Location {
	var line int = l.Line
	var col int = l.Col
	region := sarif.NewRegion()
	region.StartLine = &line
	region.StartColumn = &col
	// Why does go-sarif not support fileLocations?
	// Could be worth contributing, artifacts are supposed to be URLs.
	return sarif.NewLocationWithPhysicalLocation(sarif.NewPhysicalLocation().
		WithArtifactLocation(
			sarif.NewSimpleArtifactLocation(l.Path),
		).WithRegion(region),
	)
}

// Constructs sarif level based on rule result and severity.
func ToSarifLevel(r string, s string) string {
	if result, ok := regulaResults[r]; ok {
		if result == PASS {
			return "none"
		}

		if severity, ok := regulaSeverities[s]; ok {
			switch severity {
			case Informational:
				return "warning"
			}
		}
	}

	return "error"
}
