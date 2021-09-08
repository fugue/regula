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

package reporter

import (
	"encoding/json"
	"sort"

	"github.com/fugue/regula/pkg/loader"
	embedded "github.com/fugue/regula/rego"
	"github.com/open-policy-agent/opa/rego"
)

type Severity int

const (
	Unknown Severity = iota
	Informational
	Low
	Medium
	High
	Critical
	Off
)

var SeverityIds = map[Severity][]string{
	Unknown:       {"unknown"},
	Informational: {"informational"},
	Low:           {"low"},
	Medium:        {"medium"},
	High:          {"high"},
	Critical:      {"critical"},
	Off:           {"off"},
}

type Format int

const (
	JSON Format = iota
	Table
	Junit
	Tap
	None
	Text
)

var FormatIds = map[Format][]string{
	JSON:  {"json"},
	Table: {"table"},
	Junit: {"junit"},
	Tap:   {"tap"},
	None:  {"none"},
	Text:  {"text"},
}

type Result int

const (
	WAIVED Result = iota
	PASS
	FAIL
)

var regulaResults map[string]Result = map[string]Result{
	"WAIVED": WAIVED,
	"PASS":   PASS,
	"FAIL":   FAIL,
}

type RegulaOutput struct {
	RuleResults []RuleResult `json:"rule_results"`
	Summary     Summary      `json:"summary"`
}

var regulaSeverities map[string]Severity = map[string]Severity{
	"Unknown":       Unknown,
	"Informational": Informational,
	"Low":           Low,
	"Medium":        Medium,
	"High":          High,
	"Critical":      Critical,
}

func (o RegulaOutput) ExceedsSeverity(severity Severity) bool {
	if o.Summary.RuleResults["FAIL"] < 1 {
		return false
	}
	maxSeverity := Unknown
	for s, count := range o.Summary.Severities {
		if count < 1 {
			continue
		}
		level, ok := regulaSeverities[s]
		if !ok {
			continue
		}
		if level > maxSeverity {
			maxSeverity = level
		}
	}

	return maxSeverity >= severity
}

type ResourceResults struct {
	Filepath     string
	ResourceID   string
	ResourceType string
	Results      []RuleResult
	Pass         bool
}

type FilepathResults struct {
	Filepath string
	Results  map[string]ResourceResults
	Pass     bool
}

func (f FilepathResults) SortedKeys() []string {
	keys := []string{}
	for k := range f.Results {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return keys
}

type ResultsByFilepath map[string]FilepathResults

func (r ResultsByFilepath) SortedKeys() []string {
	keys := []string{}
	for k := range r {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return keys
}

func (o RegulaOutput) AggregateByFilepath() ResultsByFilepath {
	byFilepath := ResultsByFilepath{}
	for _, r := range o.RuleResults {
		filepathResults, ok := byFilepath[r.Filepath]
		if !ok {
			filepathResults = FilepathResults{
				Filepath: r.Filepath,
				Results:  map[string]ResourceResults{},
				Pass:     !r.IsFail(),
			}
		}
		resourceResults, ok := filepathResults.Results[r.ResourceID]
		if !ok {
			resourceResults = ResourceResults{
				Filepath:     r.Filepath,
				ResourceID:   r.ResourceID,
				ResourceType: r.ResourceType,
				Results:      []RuleResult{},
				Pass:         !r.IsFail(),
			}
		}
		resourceResults.Results = append(resourceResults.Results, r)
		resourceResults.Pass = resourceResults.Pass && !r.IsFail()
		filepathResults.Results[r.ResourceID] = resourceResults
		filepathResults.Pass = filepathResults.Pass && resourceResults.Pass
		byFilepath[r.Filepath] = filepathResults
	}
	return byFilepath
}

// Get the URL of the remediation documenation, or "" if no such documentation
// exists (to our knowledge).
func getRemediationDoc(RuleID string) string {
	if val, ok := embedded.RegulaRemediations[RuleID]; ok {
		return val.URL
	}

	return ""
}

// AggregateByRule returns all rule results grouped by rule
func (o RegulaOutput) AggregateByRule() ResultsByRule {

	// Collect all results by rule name
	byRule := map[string][]*RuleResult{}
	for i, rr := range o.RuleResults {
		byRule[rr.RuleName] = append(byRule[rr.RuleName], &o.RuleResults[i])
	}

	// Sort rule results for each rule individually by:
	// result > filepath > resource ID
	var output ResultsByRule
	for _, results := range byRule {
		sort.Slice(results, func(a, b int) bool {
			resultA := results[a]
			resultB := results[b]
			if resultA.RuleResult != resultB.RuleResult {
				return ResultCompare(resultA.RuleResult, resultB.RuleResult)
			}
			if resultA.Filepath != resultB.Filepath {
				return resultA.Filepath < resultB.Filepath
			}
			return resultA.ResourceID < resultB.ResourceID
		})
		output = append(output, RuleResults{
			RuleID:             results[0].RuleID,
			RuleName:           results[0].RuleName,
			RuleSummary:        results[0].RuleSummary,
			RuleSeverity:       results[0].RuleSeverity,
			RuleRemediationDoc: getRemediationDoc(results[0].RuleID),
			Results:            results,
		})
	}

	// Sort the rules themselves by:
	// severity > rule id > rule name
	sort.SliceStable(output, func(a, b int) bool {
		ruleA := output[a]
		ruleB := output[b]
		if ruleA.RuleSeverity != ruleB.RuleSeverity {
			return SeverityCompare(ruleA.RuleSeverity, ruleB.RuleSeverity)
		}
		if ruleA.RuleID != ruleB.RuleID {
			return ruleA.RuleID < ruleB.RuleID
		}
		return ruleA.RuleName < ruleB.RuleName
	})
	return output
}

// FailuresByRule returns failing rule results grouped by rule
func (o RegulaOutput) FailuresByRule() ResultsByRule {
	results := o.AggregateByRule()
	for i, rule := range results {
		var filtered []*RuleResult
		for _, result := range rule.Results {
			if result.RuleResult == "FAIL" {
				filtered = append(filtered, result)
			}
		}
		results[i].Results = filtered
	}
	return results
}

type RuleResult struct {
	Controls        []string `json:"controls"`
	Filepath        string   `json:"filepath"`
	InputType       string   `json:"input_type"`
	Provider        string   `json:"provider"`
	ResourceID      string   `json:"resource_id"`
	ResourceType    string   `json:"resource_type"`
	RuleDescription string   `json:"rule_description"`
	RuleID          string   `json:"rule_id"`
	RuleMessage     string   `json:"rule_message"`
	RuleName        string   `json:"rule_name"`
	RuleResult      string   `json:"rule_result"`
	RuleSeverity    string   `json:"rule_severity"`
	RuleSummary     string   `json:"rule_summary"`
	// List of source code locations this rule result pertains to.  The first
	// element of the list always refers to the most specific source code site,
	// and further elements indicate modules in which this was included, like
	// a call stack.
	SourceLocation loader.LocationStack `json:"source_location,omitempty"`
}

func (r RuleResult) IsWaived() bool {
	return r.RuleResult == "WAIVED"
}

func (r RuleResult) IsPass() bool {
	return r.RuleResult == "PASS"
}

func (r RuleResult) IsFail() bool {
	return r.RuleResult == "FAIL"
}

func (r RuleResult) Message() string {
	if r.RuleMessage != "" {
		return r.RuleMessage
	}
	if r.RuleSummary != "" {
		return r.RuleSummary
	}
	return r.RuleDescription
}

type Summary struct {
	Filepaths   []string       `json:"filepaths"`
	RuleResults map[string]int `json:"rule_results"`
	Severities  map[string]int `json:"severities"`
}

func ParseRegulaOutput(conf loader.LoadedConfigurations, r rego.Result) (*RegulaOutput, error) {
	j, err := json.Marshal(r.Expressions[0].Value)
	if err != nil {
		return nil, err
	}
	output := &RegulaOutput{}
	if err = json.Unmarshal(j, output); err != nil {
		return nil, err
	}

	for i, result := range output.RuleResults {
		filepath := result.Filepath
		location, err := conf.Location(filepath, []string{result.ResourceID})
		if err == nil {
			output.RuleResults[i].SourceLocation = location
		}
	}

	return output, nil
}

type Reporter func(r *RegulaOutput) (string, error)

// RuleResults carries a slice of RuleResults associated with a specific rule.
// A minimal amount of rule metadata is duplicated here for convenience.
type RuleResults struct {
	RuleID             string
	RuleName           string
	RuleSummary        string
	RuleSeverity       string
	RuleRemediationDoc string
	Results            []*RuleResult
}

// ResultsByRule is used to carry all rule results grouped by rule
type ResultsByRule []RuleResults

// SeverityCompare returns true if the first severity is more important than
// the second. E.g. SeverityCompare("High", "Medium") yields true.
func SeverityCompare(sevA, sevB string) bool {
	return int(regulaSeverities[sevA]) > int(regulaSeverities[sevB])
}

// ResultCompare orders "FAIL" > "PASS" > "WAIVED"
func ResultCompare(resA, resB string) bool {
	return int(regulaResults[resA]) > int(regulaResults[resB])
}
