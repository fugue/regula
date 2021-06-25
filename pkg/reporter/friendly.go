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
	"bytes"
	"fmt"
	"text/template"

	"github.com/fatih/color"
)

var friendlyTemplate *template.Template

func init() {
	friendlyTemplate = template.New("friendly").Funcs(template.FuncMap{
		"Highlight": func(item interface{}) string {
			return color.New(color.Bold).Sprint(item)
		},
		"Colorize": func(rr *RuleResult, item interface{}) string {
			if rr.RuleResult == "PASS" {
				return color.New(color.FgGreen).Sprint(item)
			} else if rr.RuleResult == "FAIL" {
				return color.New(color.FgRed).Sprint(item)
			} else if rr.RuleResult == "WAIVED" {
				return color.New(color.FgBlue).Sprint(item)
			}
			return fmt.Sprintf("%v", item)
		},
	})
	tmpl := `
Passed: {{.Summary.RuleResults.PASS}}, Failed: {{.Summary.RuleResults.FAIL}}, Waived: {{.Summary.RuleResults.WAIVED}}
{{range $ruleFailures := .FailuresByRule}}{{with (index $ruleFailures 0)}}
{{.RuleID}}: {{Highlight .RuleSummary}}{{end}}
{{range $ruleResult := $ruleFailures}}
    {{Colorize $ruleResult $ruleResult.RuleResult}}: {{$ruleResult.ResourceType}}.{{$ruleResult.ResourceID}}
    File: {{$ruleResult.Filepath}}
    {{if $ruleResult.RuleMessage}}{{$ruleResult.RuleMessage}}
{{end}}{{end}}{{end}}
	`
	friendlyTemplate.Parse(tmpl)
}

type friendlyReport struct {
	*RegulaOutput
}

func (r *friendlyReport) FailuresByRule() map[string][]*RuleResult {
	result := map[string][]*RuleResult{}
	for i, rr := range r.RuleResults {
		if rr.RuleResult == "FAIL" {
			result[rr.RuleID] = append(result[rr.RuleID], &r.RuleResults[i])
		}
	}
	return result
}

func FriendlyReporter(o *RegulaOutput) (string, error) {
	fr := &friendlyReport{o}
	buf := &bytes.Buffer{}
	if err := friendlyTemplate.Execute(buf, fr); err != nil {
		return "", err
	}
	return buf.String(), nil
}
