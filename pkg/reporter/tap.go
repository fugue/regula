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
	"fmt"
	"sort"
	"strings"
)

func TapReporter(o *RegulaReport) (string, error) {
	results := o.RuleResults
	sort.SliceStable(results, func(i, j int) bool {
		if results[i].ResourceID == results[j].ResourceID {
			return results[i].RuleID < results[j].RuleID
		}
		return results[i].ResourceID < results[j].ResourceID
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
		Resource:  r.ResourceID,
	}
}
