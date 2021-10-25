// Copyright 2021 Fugue, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
