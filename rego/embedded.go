package rego

import (
	"embed"

	"gopkg.in/yaml.v3"
)

//go:embed lib
var RegulaLib embed.FS

//go:embed rules
var RegulaRules embed.FS

//go:embed remediation.yaml
var regulaRemediations string

type RemediationRuleInfo struct {
	URL string `yaml:"url"`
}

var RegulaRemediations map[string]RemediationRuleInfo = nil

func init() {
	RegulaRemediations = make(map[string]RemediationRuleInfo)
	yaml.Unmarshal([]byte(regulaRemediations), &RegulaRemediations)
}
