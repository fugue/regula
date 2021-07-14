package reporter

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func testOutput() RegulaOutput {
	// Report with 3 rule results, 2 FAIL and 1 PASS. Two unique rules.
	return RegulaOutput{
		RuleResults: []RuleResult{
			{
				Filepath:     "src/infra/database.yaml",
				ResourceID:   "r2",
				ResourceType: "t2",
				RuleID:       "RULE_002",
				RuleName:     "myrule2",
				RuleResult:   "FAIL",
				RuleSeverity: "Medium",
				RuleSummary:  "checks databases",
			},
			{
				Filepath:     "src/infra/network.yaml",
				ResourceID:   "r3",
				ResourceType: "t3",
				RuleID:       "RULE_001",
				RuleName:     "myrule1",
				RuleResult:   "PASS",
				RuleSeverity: "High",
				RuleSummary:  "checks tags",
			},
			{
				Filepath:     "src/infra/compute.yaml",
				ResourceID:   "r1",
				ResourceType: "t1",
				RuleID:       "RULE_001",
				RuleName:     "myrule1",
				RuleResult:   "FAIL",
				RuleSeverity: "High",
				RuleSummary:  "checks tags",
			},
		},
		Summary: Summary{
			Filepaths: []string{
				"src/infra/compute.yaml",
				"src/infra/database.yaml",
				"src/infra/network.yaml",
			},
			RuleResults: map[string]int{
				"PASS": 1,
				"FAIL": 2,
			},
			Severities: map[string]int{
				"High":   1,
				"Medium": 1,
			},
		},
	}
}

func TestRuleResult(t *testing.T) {

	rr := RuleResult{
		Filepath:        "src/infra/database.yaml",
		ResourceID:      "r2",
		ResourceType:    "t2",
		RuleID:          "RULE_002",
		RuleName:        "Invalid settings 2",
		RuleDescription: "Check for such and such",
		RuleResult:      "FAIL",
		RuleSeverity:    "Medium",
	}
	assert.False(t, rr.IsWaived())
	assert.False(t, rr.IsPass())
	assert.True(t, rr.IsFail())
	assert.Equal(t, "Check for such and such", rr.Message())
}

func TestAggregateByRule(t *testing.T) {

	out := testOutput()
	byRule := out.AggregateByRule()

	// Two unique rules
	require.Len(t, byRule, 2)

	rule1 := byRule[0]
	rule2 := byRule[1]

	assert.Equal(t, "RULE_001", rule1.RuleID)
	assert.Equal(t, "RULE_002", rule2.RuleID)

	require.Len(t, rule1.Results, 2)
	require.Len(t, rule2.Results, 1)

	require.Equal(t, "r1", rule1.Results[0].ResourceID)
	require.Equal(t, "r3", rule1.Results[1].ResourceID)
	require.Equal(t, "r2", rule2.Results[0].ResourceID)
}

func TestExceedsSeverity(t *testing.T) {

	out := testOutput()

	require.True(t, out.ExceedsSeverity(Unknown))
	require.True(t, out.ExceedsSeverity(Informational))
	require.True(t, out.ExceedsSeverity(Low))
	require.True(t, out.ExceedsSeverity(Medium))
	require.True(t, out.ExceedsSeverity(High))
	require.False(t, out.ExceedsSeverity(Critical))

	empty := RegulaOutput{}
	require.False(t, empty.ExceedsSeverity(Informational))
}
