package reporter

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestGHActionOutput(t *testing.T) {
	o := testOutput()
	// With annotations disabled
	result, err := GHActionReporter(".", true, Unknown, &o)
	require.Nil(t, err)
	expected := []string{
		"::set-output name=rules_passed::1",
		"::set-output name=rules_failed::2",
		"::set-output name=rules_waived::0",
	}
	actual := strings.Split(result, "\n")
	assert.ElementsMatch(t, expected, actual)

	// With annotations enabled
	result, err = GHActionReporter(".", false, Unknown, &o)
	require.Nil(t, err)
	expected = append(
		expected,
		"::notice file=src/infra/database.yaml,line=20,col=10,title=Regula rule failed%3A RULE_002::checks databases",
		"::notice file=src/infra/compute.yaml,line=30,col=5,title=Regula rule failed%3A RULE_001::checks tags%0A%0Ahttps://example.com/RULE_001",
	)
	actual = strings.Split(result, "\n")
	assert.ElementsMatch(t, expected, actual)
}
