package loader

import (
	"encoding/json"
	"fmt"
)

var JsonTypeDetector = NewTypeDetector(&TypeDetector{
	DetectFile: func(i *InputFile) (Loader, error) {
		if i.Ext != ".json" {
			return nil, fmt.Errorf("File does not have .json extension: %v", i.Path)
		}
		l, err := i.DetectType(*TfPlanDetector)
		if err == nil {
			return l, nil
		}
		l, err = i.DetectType(*CfnJsonDetector)
		if err == nil {
			return l, nil
		}
		return nil, fmt.Errorf("JSON file %v not a recognized type", i.Path)
	},
})

var TfPlanDetector = NewTypeDetector(&TypeDetector{
	DetectFile: func(i *InputFile) (Loader, error) {
		contents, err := i.ReadContents()
		if err != nil {
			return nil, err
		}
		c := &map[string]interface{}{}
		if err := json.Unmarshal(contents, c); err != nil {
			return nil, fmt.Errorf("Failed to parse JSON file %v: %v", i.Path, err)
		}
		_, hasTerraformVersion := (*c)["terraform_version"]

		if !hasTerraformVersion {
			return nil, fmt.Errorf("Input file is not Terraform Plan JSON: %v", i.Path)
		}

		return &jsonLoader{
			path:    i.Path,
			content: c,
		}, nil
	},
})

var CfnJsonDetector = NewTypeDetector(&TypeDetector{
	DetectFile: func(i *InputFile) (Loader, error) {
		contents, err := i.ReadContents()
		if err != nil {
			return nil, err
		}

		c := &map[string]interface{}{}
		if err := json.Unmarshal(contents, c); err != nil {
			return nil, fmt.Errorf("Failed to parse JSON file %v: %v", i.Path, err)
		}
		_, hasTemplateFormatVersion := (*c)["AWSTemplateFormatVersion"]
		_, hasResources := (*c)["Resources"]

		if !hasTemplateFormatVersion && !hasResources {
			return nil, fmt.Errorf("Input file is not CloudFormation JSON: %v", i.Path)
		}

		return &jsonLoader{
			path:    i.Path,
			content: c,
		}, nil
	},
})

type jsonLoader struct {
	path    string
	content *map[string]interface{}
}

func (l *jsonLoader) RegulaInput() RegulaInput {
	return RegulaInput{
		"filepath": l.path,
		"content":  l.content,
	}
}
