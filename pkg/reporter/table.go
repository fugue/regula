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
		tableRow := TableRow{
			Resource: r.ResourceID,
			Type:     r.ResourceType,
			Filepath: r.Filepath,
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
			{Align: simpletable.AlignRight, Text: colorizeResult(overall)},
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

var waivedColor func(...interface{}) string = color.New(color.FgBlack).SprintFunc()
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
	case "WAIVED":
		return waivedColor(result)
	default:
		return result
	}
}

func colorizeSeverity(r RuleResult) string {
	if r.RuleResult == "PASS" {
		return r.RuleSeverity
	}

	if r.RuleResult == "WAIVED" {
		return waivedColor(r.RuleSeverity)
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