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

	getSeverityColor := func(severity string) *color.Color {
		switch severity {
		case "Low":
			return color.New(color.FgBlue)
		case "Medium":
			return color.New(color.FgYellow)
		case "High":
			return color.New(color.FgRed)
		case "Critical":
			return color.New(color.BgRed)
		default:
			return color.New()
		}
	}

	// We'll use a Go template to describe and create the friendly output
	var err error
	friendlyTemplate, err = template.New("friendly").Funcs(
		template.FuncMap{
			"Bold": func(item interface{}) string {
				return color.New(color.Bold).Sprint(item)
			},
			"Cyan": func(item interface{}) string {
				return color.New(color.FgCyan).Sprint(item)
			},
			"ResultIndex": func(rr *RuleResult, index int) string {
				return getSeverityColor(rr.RuleSeverity).Sprintf("[%d]:", index+1)
			},
			"RedInt": func(num int) string {
				if num == 0 {
					return fmt.Sprintf("%d", num)
				}
				return color.New(color.FgRed).Sprint(num)
			},
			"GreenInt": func(num int) string {
				if num == 0 {
					return fmt.Sprintf("%d", num)
				}
				return color.New(color.FgGreen).Sprint(num)
			},
			"CyanInt": func(num int) string {
				if num == 0 {
					return fmt.Sprintf("%d", num)
				}
				return color.New(color.FgGreen).Sprint(num)
			},
			"Severity": func(severity string) string {
				c := getSeverityColor(severity)
				return c.Sprintf("[%s]", severity)
			},
		},
	).Parse(`
Passed: {{GreenInt .Summary.RuleResults.PASS}}, Failed: {{RedInt .Summary.RuleResults.FAIL}}, Waived: {{CyanInt .Summary.RuleResults.WAIVED}}
{{range $ruleResults := .FailuresByRule}}{{if $ruleResults.Results}}
{{Cyan $ruleResults.RuleID}}: {{Bold $ruleResults.RuleSummary}} {{Severity $ruleResults.RuleSeverity}}
{{range $index, $rr := $ruleResults.Results}}
    {{ResultIndex $rr $index}} {{$rr.ResourceType}}.{{$rr.ResourceID}}
         in {{$rr.Filepath}}
    {{if $rr.RuleMessage}}{{$rr.RuleMessage}}
{{end}}{{end}}{{end}}{{end}}
	`)

	if err != nil {
		// This will only happen during development, if the template is invalid
		panic(fmt.Errorf("unable to parse friendly format template: %w", err))
	}
}

// FriendlyReporter returns the Regula report in a human-friendly format
func FriendlyReporter(o *RegulaOutput) (string, error) {
	buf := &bytes.Buffer{}
	if err := friendlyTemplate.Execute(buf, o); err != nil {
		return "", err
	}
	return buf.String(), nil
}
