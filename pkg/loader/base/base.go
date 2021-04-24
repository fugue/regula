package base

type InputType int

const (
	TfPlan InputType = iota
	CfnJson
	CfnYaml
)

var InputTypeIds = map[InputType][]string{
	TfPlan:  {"tf-plan"},
	CfnJson: {"cfn-json"},
	CfnYaml: {"cfn-yaml"},
}

type Location struct {
	Line int
	Col  int
}

type RegulaInput map[string]interface{}

type Loader interface {
	RegulaInput() RegulaInput
	Location(attributePath string) (*Location, error)
}
