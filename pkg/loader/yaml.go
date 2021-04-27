package loader

// import (
// 	"fmt"

// 	"gopkg.in/yaml.v3"
// )

var YamlTypeDetector = NewTypeDetector(&TypeDetector{
	DetectFile: func(i InputFile) (Loader, error) {
		if i.Ext != ".yaml" && i.Ext != ".yml" {
			return nil, nil
		}

		return i.DetectType(CfnYamlDetector)
	},
})

// func YamlLoaderFactory(path string, contents []byte) (Loader, error) {
// 	d := &yamlDetector{}
// 	if err := yaml.Unmarshal(contents, d); err != nil {
// 		return nil, fmt.Errorf("Unable to parse %v as yaml: %v", path, err)
// 	}
// 	if d.AWSTemplateFormatVersion != "" {
// 		return CfnYamlLoaderFactory(path, contents)
// 	}

// 	return nil, fmt.Errorf("Unrecognized yaml file: %v", path)
// }

// type yamlDetector struct {
// 	AWSTemplateFormatVersion string `yaml:"AWSTemplateFormatVersion"`
// }
