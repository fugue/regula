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
	_ "embed"
	"fmt"
	"math/rand"
	"strings"
	"text/template"

	"github.com/fatih/color"
)

var textTemplate *template.Template

//go:embed text.tmpl
var textTemplateDefinition string

//go:embed praise.txt
var praiseText string

func getSeverityColor(severity string) *color.Color {
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

func createTextReporterTemplate(tmpl string) *template.Template {
	// We'll use a Go template to describe and create the friendly output
	var err error
	var compiledTemplate *template.Template

	compiledTemplate, err = template.New("friendly").Funcs(
		template.FuncMap{
			"Bold": func(items ...interface{}) string {
				return color.New(color.Bold).Sprint(items...)
			},
			"Italic": func(items ...interface{}) string {
				return color.New(color.Italic).Sprint(items...)
			},
			"Cyan": func(items ...interface{}) string {
				return color.New(color.FgCyan).Sprint(items...)
			},
			"Green": func(items ...interface{}) string {
				return color.New(color.FgGreen).Sprint(items...)
			},
			"Red": func(items ...interface{}) string {
				return color.New(color.FgRed).Sprint(items...)
			},
			"Link": func(items ...interface{}) string {
				return color.New(color.FgHiBlue).Sprint(items...)
			},
			"LinkedText": func(url string, text string) string {
				return fmt.Sprintf("\x1b]8;;%s\x1b\\%s\x1b]8;;\x1b\\", url, text)
			},
			"Praise": func() string {
				return randomPraise()
			},
			"ResultIndex": func(rr *RuleResult, index int) string {
				severity := rr.RuleSeverity
				if severity == "Critical" {
					// The critical color scheme doesn't work well for the index
					severity = "High"
				}
				return getSeverityColor(severity).Sprintf("[%d]:", index+1)
			},
			"PadIndex": func(rr *RuleResult, index int) string {
				// Used to adjust vertical alignment for rule result data
				if index < 9 {
					return strings.Repeat(" ", 4)
				}
				return strings.Repeat(" ", 5)
			},
			"LocationStack": func(rr *RuleResult) []string {
				loc := rr.SourceLocation
				if loc == nil || len(loc) == 0 {
					return []string{"in " + rr.Filepath}
				}
				lines := []string{}
				lines = append(lines, "in "+loc[0].String())
				for i := 1; i < len(loc); i++ {
					lines = append(lines, "included at "+loc[i].String())
				}
				return lines
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
				return color.New(color.FgCyan).Sprint(num)
			},
			"Severity": func(severity string) string {
				c := getSeverityColor(severity)
				return c.Sprintf("[%s]", severity)
			},
		},
	).Parse(tmpl)

	if err != nil {
		// This will only happen during development, if the template is invalid
		panic(fmt.Errorf("unable to parse friendly format template: %w", err))
	}

	return compiledTemplate
}

func init() {
	textTemplate = createTextReporterTemplate(textTemplateDefinition)
}

func textReporterWithTemplate(o *RegulaOutput, tmpl *template.Template) (string, error) {
	buf := &bytes.Buffer{}
	if err := tmpl.Execute(buf, o); err != nil {
		return "", err
	}
	return buf.String(), nil
}

// TextReporter returns the Regula report in a human-friendly format
func TextReporter(o *RegulaOutput) (string, error) {
	return textReporterWithTemplate(o, textTemplate)
}

func randomPraise() string {
	lines := strings.Split(praiseText, "\n")
	return lines[rand.Intn(len(lines))]
}
