package yaml

import (
	"fmt"
	"os"

	yaml "gopkg.in/yaml.v3"

	"github.com/fugue/regula/pkg/loader/base"
	"github.com/fugue/regula/pkg/loader/cfn"
)

type yamlDetector struct {
	AWSTemplateFormatVersion string `yaml:"AWSTemplateFormatVersion"`
}

func DetectYamlLoader(path string, contents []byte) (base.Loader, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	d := &yamlDetector{}
	if err := yaml.NewDecoder(f).Decode(d); err != nil {
		return nil, err
	}
	if d.AWSTemplateFormatVersion != "" {
		return cfn.NewCfnYamlLoader(path, contents)
	}

	return nil, fmt.Errorf("Unknown input type in file %s", path)
}
