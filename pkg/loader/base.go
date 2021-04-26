package loader

type InputType int

const (
	Auto InputType = iota
	TfPlan
	CfnJson
	CfnYaml
)

var InputTypeIds = map[InputType][]string{
	Auto:    {"auto"},
	TfPlan:  {"tf-plan"},
	CfnJson: {"cfn-json"},
	CfnYaml: {"cfn-yaml"},
}

type RegulaInput map[string]interface{}

type Loader interface {
	RegulaInput() RegulaInput
}

type Location struct {
	Line int
	Col  int
}

type LocationAwareLoader interface {
	Location(attributePath string) (*Location, error)
}

type LoaderFactory func(path string, contents []byte) (Loader, error)
