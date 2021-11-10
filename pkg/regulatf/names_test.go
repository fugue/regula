package regulatf

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestStringToFullName(t *testing.T) {
	type Test struct {
		input    string
		expected *FullName
	}

	tests := []Test{
		{
			input:    "module.foo.module.bar.aws_s3_bucket.bucket",
			expected: &FullName{ModuleName{"foo", "bar"}, LocalName{"aws_s3_bucket", "bucket"}},
		},
		{
			input:    "local.ports[1]",
			expected: &FullName{ModuleName{}, LocalName{"local", "ports", 1}},
		},
		{
			input:    "local.ingress[1].from",
			expected: &FullName{ModuleName{}, LocalName{"local", "ingress", 1, "from"}},
		},
	}

	for _, test := range tests {
		name, err := StringToFullName(test.input)
		if err != nil {
			t.Fatalf("%s", err)
		}
		assert.Equal(t, test.expected, name)
	}
}

func TestAsModuleInput(t *testing.T) {
	assert.Equal(t,
		&FullName{ModuleName{}, LocalName{"input", "child1", "myvar"}},
		FullName{ModuleName{"child1"}, LocalName{"var", "myvar"}}.AsModuleInput(),
	)
	assert.Nil(t,
		FullName{EmptyModuleName, LocalName{"var", "myvar"}}.AsModuleInput(),
	)
}
