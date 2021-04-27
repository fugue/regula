package reporter

import (
	"fmt"
	"sort"
	"strings"
)

func TapReporter(o *RegulaOutput) (string, error) {
	results := o.RuleResults
	sort.SliceStable(results, func(i, j int) bool {
		if results[i].ResourceId == results[j].ResourceId {
			return results[i].RuleId < results[j].RuleId
		}
		return results[i].ResourceId < results[j].ResourceId
	})

	tapOutput := []string{}
	for idx, r := range results {
		tapOutput = append(tapOutput, r.ToTapRow(idx).String(""))
	}

	return strings.Join(tapOutput, "\n"), nil
}

type TapRow struct {
	Ok        string
	Index     int
	Message   string
	Directive string
	Resource  string
	RuleID    string
}

func (r TapRow) String(indent string) string {
	return fmt.Sprintf("%s%s %d %s: %s%s", indent, r.Ok, r.Index, r.Resource, r.Message, r.Directive)
}

func (r RuleResult) ToTapRow(idx int) TapRow {
	ok := "ok"
	if r.IsFail() {
		ok = "not ok"
	}
	directive := ""
	if r.IsWaived() {
		directive = " # SKIP: rule waived"
	}
	return TapRow{
		Ok:        ok,
		Index:     idx,
		Message:   r.Message(),
		Directive: directive,
		Resource:  r.ResourceId,
	}
}
