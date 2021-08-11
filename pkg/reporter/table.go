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
	"sort"

	"github.com/alexeyco/simpletable"
	"github.com/fatih/color"
)

func TableReporter(o *RegulaOutput) (string, error) {
	tableData := []TableRow{}
	var overall string
	if o.Summary.RuleResults["FAIL"] > 0 {
		overall = "FAIL"
	} else {
		overall = "PASS"
	}
	for _, r := range o.RuleResults {
		message := r.RuleMessage
		if message == "" {
			message = r.RuleSummary
		}
		filepath := r.Filepath
		if r.SourceLocation != nil && len(r.SourceLocation) > 0 {
			filepath = r.SourceLocation[0].String()

		}
		tableRow := TableRow{
			Resource: r.ResourceID,
			Type:     r.ResourceType,
			Filepath: filepath,
			Severity: colorizeSeverity(r),
			RuleID:   r.RuleID,
			RuleName: r.RuleName,
			Message:  message,
			Result:   colorizeResult(r.RuleResult),
		}
		tableData = append(tableData, tableRow)
	}

	sort.SliceStable(tableData, func(i, j int) bool {
		if tableData[i].Filepath == tableData[j].Filepath {
			if tableData[i].Resource == tableData[j].Resource {
				return tableData[i].RuleID < tableData[j].RuleID
			}
			return tableData[i].Resource < tableData[j].Resource
		}
		return tableData[i].Filepath < tableData[j].Filepath
	})

	table := simpletable.New()
	table.Header = &simpletable.Header{
		Cells: []*simpletable.Cell{
			{Align: simpletable.AlignCenter, Text: "Resource"},
			{Align: simpletable.AlignCenter, Text: "Type"},
			{Align: simpletable.AlignCenter, Text: "Filepath"},
			{Align: simpletable.AlignCenter, Text: "Severity"},
			{Align: simpletable.AlignCenter, Text: "Rule ID"},
			{Align: simpletable.AlignCenter, Text: "Rule Name"},
			{Align: simpletable.AlignCenter, Text: "Message"},
			{Align: simpletable.AlignCenter, Text: "Result"},
		},
	}
	for _, row := range tableData {
		table.Body.Cells = append(table.Body.Cells, row.toCell())
	}
	table.Footer = &simpletable.Footer{
		Cells: []*simpletable.Cell{
			{},
			{},
			{},
			{},
			{},
			{},
			{Align: simpletable.AlignRight, Text: "Overall"},
			{Align: simpletable.AlignLeft, Text: colorizeResult(overall)},
		},
	}

	table.SetStyle(simpletable.StyleDefault)
	return table.String(), nil
}

type TableRow struct {
	Resource string
	Type     string
	Filepath string
	Severity string
	RuleID   string
	RuleName string
	Message  string
	Result   string
}

func (r TableRow) toCell() []*simpletable.Cell {
	return []*simpletable.Cell{
		{Text: r.Resource},
		{Text: r.Type},
		{Text: r.Filepath},
		{Text: r.Severity},
		{Text: r.RuleID},
		{Text: r.RuleName},
		{Text: r.Message},
		{Text: r.Result},
	}
}

var failedColor func(...interface{}) string = color.New(color.FgRed).SprintFunc()
var passedColor func(...interface{}) string = color.New(color.FgGreen).SprintFunc()
var unknownColor func(...interface{}) string = color.New(color.FgMagenta).SprintFunc()
var lowColor func(...interface{}) string = color.New(color.FgBlue).SprintFunc()
var mediumColor func(...interface{}) string = color.New(color.FgYellow).SprintFunc()
var highColor func(...interface{}) string = color.New(color.FgRed).SprintFunc()
var criticalColor func(...interface{}) string = color.New(color.BgRed, color.FgBlack).SprintFunc()

func colorizeResult(result string) string {
	switch result {
	case "PASS":
		return passedColor(result)
	case "FAIL":
		return failedColor(result)
	default:
		return result
	}
}

func colorizeSeverity(r RuleResult) string {
	if r.RuleResult == "PASS" || r.RuleResult == "WAIVED" {
		return r.RuleSeverity
	}

	switch r.RuleSeverity {
	case "Low":
		return lowColor(r.RuleSeverity)
	case "Medium":
		return mediumColor(r.RuleSeverity)
	case "High":
		return highColor(r.RuleSeverity)
	case "Critical":
		return criticalColor(r.RuleSeverity)
	default:
		return r.RuleSeverity
	}
}
