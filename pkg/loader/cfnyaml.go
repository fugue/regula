package loader

import (
	"fmt"
	"strings"

	"gopkg.in/yaml.v3"
)

var CfnYAMLDetector = NewConfigurationDetector(&ConfigurationDetector{
	DetectFile: func(i *InputFile, opts DetectOptions) (IACConfiguration, error) {
		if !opts.IgnoreExt && i.Ext != ".yaml" && i.Ext != ".yml" {
			return nil, fmt.Errorf("File does not have .yaml or .yml extension: %v", i.Path)
		}
		contents, err := i.ReadContents()
		if err != nil {
			return nil, err
		}

		template := &cfnTemplate{}
		if err := yaml.Unmarshal(contents, &template); err != nil {
			return nil, fmt.Errorf("Failed to parse YAML file %v: %v", i.Path, err)
		}
		_, hasTemplateFormatVersion := template.Contents["AWSTemplateFormatVersion"]
		_, hasResources := template.Contents["Resources"]

		if !hasTemplateFormatVersion && !hasResources {
			return nil, fmt.Errorf("Input file is not CloudFormation YAML: %v", i.Path)
		}

		return &cfnYAML{
			path:     i.Path,
			template: *template,
		}, nil
	},
})

type cfnYAML struct {
	path     string
	template cfnTemplate
}

func (l *cfnYAML) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.template.Contents,
	}
}

func (l *cfnYAML) Location(attributePath []string) (*Location, error) {
	return &Location{
		Path: l.path,
		Line: 0,
		Col:  0,
	}, nil
}

func (l *cfnYAML) LoadedFiles() []string {
	return []string{l.path}
}

type cfnTemplate struct {
	Contents map[string]interface{}
}

func (t *cfnTemplate) UnmarshalYAML(node *yaml.Node) error {
	contents, err := decodeMap(node)
	if err != nil {
		return err
	}
	t.Contents = contents
	return nil
}

func decodeMap(node *yaml.Node) (map[string]interface{}, error) {
	if len(node.Content)%2 != 0 {
		return nil, fmt.Errorf("Malformed map at line %v, col %v", node.Line, node.Column)
	}

	m := map[string]interface{}{}

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

		val, err := decodeNode(valNode)

		if err != nil {
			return nil, fmt.Errorf("Failed to decode map val: %v", err)
		}

		m[key] = val
	}

	return m, nil
}

func decodeSeq(node *yaml.Node) ([]interface{}, error) {
	s := []interface{}{}
	for _, child := range node.Content {
		i, err := decodeNode(child)
		if err != nil {
			return nil, fmt.Errorf("Error decoding sequence item at line %v, col %v", child.Line, child.Column)
		}
		s = append(s, i)
	}

	return s, nil
}

var intrinsicFns map[string]string = map[string]string{
	"!And":         "Fn::And",
	"!Base64":      "Fn::Base64",
	"!Cidr":        "Fn::Cidr",
	"!Equals":      "Fn::Equals",
	"!FindInMap":   "Fn::FindInMap",
	"!GetAtt":      "Fn::GetAtt",
	"!GetAZs":      "Fn::GetAZs",
	"!If":          "Fn::If",
	"!ImportValue": "Fn::ImportValue",
	"!Join":        "Fn::Join",
	"!Not":         "Fn::Not",
	"!Or":          "Fn::Or",
	"!Ref":         "Ref",
	"!Split":       "Fn::Split",
	"!Sub":         "Fn::Sub",
	"!Transform":   "Fn::Transform",
}

func decodeIntrinsic(node *yaml.Node, name string) (map[string]interface{}, error) {
	if name == "" {
		name = strings.Replace(node.Tag, "!", "Fn::", 1)
	}
	intrinsic := map[string]interface{}{}
	switch node.Kind {
	case yaml.SequenceNode:
		val, err := decodeSeq(node)
		if err != nil {
			return nil, fmt.Errorf("Failed to decode intrinsic containing sequence: %v", err)
		}
		intrinsic[name] = val
	case yaml.MappingNode:
		val, err := decodeMap(node)
		if err != nil {
			return nil, fmt.Errorf("Failed to decode intrinsic containing map: %v", err)
		}
		intrinsic[name] = val
	default:
		var val interface{}
		if err := node.Decode(&val); err != nil {
			return nil, fmt.Errorf("Failed to decode intrinsic: %v", err)
		}
		intrinsic[name] = val
	}

	return intrinsic, nil
}

func decodeNode(node *yaml.Node) (interface{}, error) {
	switch node.Tag {
	case "!!seq":
		val, err := decodeSeq(node)
		if err != nil {
			return nil, fmt.Errorf("Failed to decode map val: %v", err)
		}
		return val, nil
	case "!!map":
		val, err := decodeMap(node)
		if err != nil {
			return nil, fmt.Errorf("Failed to decode map val: %v", err)
		}
		return val, nil
	default:
		name, isIntrinsic := intrinsicFns[node.Tag]
		if isIntrinsic {
			val, err := decodeIntrinsic(node, name)
			if err != nil {
				return nil, fmt.Errorf("Failed to decode map val: %v", err)
			}
			return val, nil
		}
		var val interface{}
		if err := node.Decode(&val); err != nil {
			return nil, fmt.Errorf("Failed to decode map val: %v", err)
		}
		return val, nil
	}
}
