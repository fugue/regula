package arm

import (
	"github.com/zclconf/go-cty/cty"
	"gopkg.in/yaml.v3"
)

type Resource struct {

}

type ArmTemplate struct {
	// Parameters map[string]cty.Value
	// Variables map[string]cty.Value
	// Functions map[string]Function
	EvalContext EvalContext
	Resources map[string]Resource
	Output map[string]cty.Value
	Content map[string]interface{}
}

func (t *ArmTemplate) UnmarshalYAML(node *yaml.Node) error {
	// content := map[string]interface{}{}
	var processParameters func () error
	// var processVariables func () error
	// var processResources func () error
	// var proessOutput func () error
	processMap(node, func(key string, valNode *yaml.Node) error {
		if key == "parameters" {
			processParameters = func() error {
				return t.UnmarshalParameters(valNode)
			}
		}
		return nil
	})

	if processParameters != nil {
		processParameters()
	}

	return nil
}

func (t *ArmTemplate) UnmarshalParameters(node *yaml.Node) error {
	evalGraph := map[string][]string{}
	resolvers := map[string]func() error{}

	func decode(node *yaml.Node) {
		
	}

	processMap(node, func(key string, valNode *yaml.Node) error {
		
	})
}


// Helpers
type MapItemProcessor func(key string, valNode *yaml.Node) error

func processMap(node *yaml.Node, process MapItemProcessor) error  {
	if len(node.Content)%2 != 0 {
		return fmt.Errorf("Malformed map at line %v, col %v", node.Line, node.Column)
	}

	for i := 0; i < len(node.Content); i += 2 {
		keyNode := node.Content[i]
		valNode := node.Content[i+1]

		if keyNode.Kind != yaml.ScalarNode || keyNode.Tag != "!!str" {
			return nil, fmt.Errorf("Malformed map key at line %v, col %v", keyNode.Line, keyNode.Column)
		}

		var key string

		if err := keyNode.Decode(&key); err != nil {
			return nil, fmt.Errorf("Failed to decode map key: %v", err)
		}

		if err := process(key, valNode); err != nil {
			return err
		}
	}

	return nil
}

type SeqItemProcessor func(idx int, valNode *yaml.Node) error

func processSeq(node *yaml.Node, process SeqItemProcessor) error {
	for idx, child := range node.Content {
		process(idx, child)
	}
}
