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

package rule_waivers

import (
	"strings"

	"github.com/fugue/regula/v2/pkg/reporter"
)

func ExactMatchOrWildcards(waiverElem string, resourceElem string) bool {
	var matchElem bool
	// if elem is fully escaped do a exact match
	if strings.HasPrefix(waiverElem, "`") && strings.HasSuffix(waiverElem, "`") {
		matchElem = strings.Trim(waiverElem, "`") == resourceElem
	} else {
		matchElem = Match(waiverElem, resourceElem)
	}
	return matchElem
}

type RuleWaiver struct {
	ResourceID       string
	ResourceProvider string
	ResourceTag      string
	ResourceType     string
	RuleID           string
}

// TODO: Add an interface for results/resources so we can apply this to both.
func (waiver RuleWaiver) Match(result reporter.RuleResult) bool {
	return ExactMatchOrWildcards(waiver.ResourceID, result.ResourceID) &&
		ExactMatchOrWildcards(waiver.ResourceProvider, result.Filepath) &&
		ExactMatchOrWildcards(waiver.ResourceType, result.ResourceType) &&
		ExactMatchOrWildcards(waiver.RuleID, result.RuleID)
}

func ApplyRuleWaivers(report *reporter.RegulaReport, waivers []RuleWaiver) {
	for i := range report.RuleResults {
		for _, waiver := range waivers {
			if waiver.Match(report.RuleResults[i]) {
				report.RuleResults[i].RuleResult = "WAIVED"
			}
		}
	}

	report.RecomputeSummary()
}
