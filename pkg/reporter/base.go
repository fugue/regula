package reporter

import (
	"encoding/json"

	"github.com/fugue/regula/pkg/loader"
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
	maxSeverity := Unknown
	hasFailures := false
	for s, count := range o.Summary.Severities {
		if count < 1 {
			continue
		}
		level, ok := regulaSeverities[s]
		if !ok {
			continue
		}
		hasFailures = true
		if level > maxSeverity {
			maxSeverity = level
		}
	}

	return hasFailures && maxSeverity >= severity
}

type RuleResult struct {
	Controls        []string `json:"controls"`
	Filepath        string   `json:"filepath"`
	Platform        string   `json:"platform"`
	Provider        string   `json:"provider"`
	ResourceId      string   `json:"resource_id"`
	ResourceType    string   `json:"resource_type"`
	RuleDescription string   `json:"rule_description"`
	RuleId          string   `json:"rule_id"`
	RuleMessage     string   `json:"rule_message"`
	RuleName        string   `json:"rule_name"`
	RuleResult      string   `json:"rule_result"`
	RuleSeverity    string   `json:"rule_severity"`
	RuleSummary     string   `json:"rule_summary"`
}

type Summary struct {
	Filepaths   []string       `json:"filepaths"`
	RuleResults map[string]int `json:"rule_results"`
	Severities  map[string]int `json:"severities"`
}

func ParseRegulaOutput(r rego.Result) (*RegulaOutput, error) {
	j, err := json.Marshal(r.Expressions[0].Value)
	if err != nil {
		return nil, err
	}
	output := &RegulaOutput{}
	if err = json.Unmarshal(j, output); err != nil {
		return nil, err
	}
	return output, nil
}

type Reporter func(l *loader.LoadedFiles, r *RegulaOutput) (string, error)
