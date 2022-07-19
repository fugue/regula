// Copyright 2022 Snyk Ltd
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
	"path/filepath"
	"strconv"
	"strings"

	"github.com/fugue/regula/v2/pkg/loader"
)

func GHActionReporter(workspaceDir string, disableAnnotations bool, annotationSeverity Severity, o *RegulaReport) (string, error) {
	output := o.Summary.ToGHActionOutput()
	if !disableAnnotations {
		for _, r := range o.RuleResults {
			if !r.IsFail() || !r.ExceedsSeverity(annotationSeverity) {
				continue
			}
			output = append(output, r.ToGHActionOutput(workspaceDir)...)
		}
	}
	return strings.Join(output, "\n"), nil
}

func (s *Summary) ToGHActionOutput() []string {
	// zero-value is appropriate here, so don't need comma-ok
	passed := s.RuleResults["PASS"]
	failed := s.RuleResults["FAIL"]
	waived := s.RuleResults["WAIVED"]

	return []string{
		ghSetOutput("rules_passed", strconv.Itoa(passed)),
		ghSetOutput("rules_failed", strconv.Itoa(failed)),
		ghSetOutput("rules_waived", strconv.Itoa(waived)),
	}
}

func (r *RuleResult) ToGHActionOutput(workspaceDir string) []string {
	msg := r.Message()
	if r.RuleRemediationDoc != "" {
		msg = strings.Join([]string{
			msg,
			"",
			r.RuleRemediationDoc,
		}, "\n")
	}

	notices := make([]string, len(r.SourceLocation))
	ruleID := r.RuleID
	if ruleID == "" {
		ruleID = r.RuleName
	}
	for idx, loc := range r.SourceLocation {
		notices[idx] = ghNotice(workspaceDir, loc, ruleID, msg)
	}
	return notices
}

func ghSetOutput(name string, value string) string {
	return fmt.Sprintf("::set-output name=%s::%s", name, value)
}

func ghNotice(
	workspaceDir string,
	loc loader.Location,
	ruleID string,
	msg string,
) string {
	// TODO: we're relying on the fact that Regula changes directories here. We'll need
	// a different solution if / when we switch to using afero.Fs everywhere.
	path, err := filepath.Rel(workspaceDir, loc.Path)
	if err != nil {
		// Fallback to just using the path as-is
		path = loc.Path
	}
	title := fmt.Sprintf("Regula rule failed: %s", ruleID)
	return fmt.Sprintf(
		"::notice file=%s,line=%d,col=%d,title=%s::%s",
		path,
		loc.Line,
		loc.Col,
		ghEscapeProperty.Replace(title),
		ghEscapeData.Replace(msg),
	)
}

// Ported from:
// https://github.com/actions/toolkit/blob/c5278cd/packages/core/src/command.ts#L80
var ghEscapeData = strings.NewReplacer(
	"%", "%25",
	"\r", "%0D",
	"\n", "%0A",
)

// Ported from:
// https://github.com/actions/toolkit/blob/c5278cd/packages/core/src/command.ts#L87
var ghEscapeProperty = strings.NewReplacer(
	"%", "%25",
	"\r", "%0D",
	"\n", "%0A",
	":", "%3A",
	",", "%2C",
)
