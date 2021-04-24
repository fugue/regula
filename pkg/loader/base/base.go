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

type OpaInput map[string]interface{}

type Location struct {
	Line int
	Col  int
}

type Loader interface {
	Load(filePath string) error
	OpaInput() (OpaInput, error)
	Location(attributePath string) (*Location, error)
}

type Detector interface {
	DetectLoader(filePath string) (Loader, error)
}
