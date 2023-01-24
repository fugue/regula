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

package loader_test

import (
	"testing"

	"github.com/fugue/regula/v3/pkg/loader"
	"github.com/stretchr/testify/assert"
)

func TestLoadPathsDirAuto(t *testing.T) {
	loadedConfigs, err := loader.LocalConfigurationLoader(loader.LoadPathsOptions{
		Paths:      []string{"test_inputs/data"},
		InputTypes: []loader.InputType{loader.Auto},
	})()
	assert.Nil(t, err)
	assert.NotNil(t, loadedConfigs)
	assert.Greater(t, loadedConfigs.Count(), 0)
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/tfplan.0.15.json"))
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/cfn.yaml"))
}

func TestLoadPathsFiles(t *testing.T) {
	loadedConfigs, err := loader.LocalConfigurationLoader(loader.LoadPathsOptions{
		Paths: []string{
			"test_inputs/data/cfn.yaml",
			"test_inputs/data/tfplan.0.15.json",
		},
		InputTypes: []loader.InputType{loader.Auto},
	})()
	assert.Nil(t, err)
	assert.NotNil(t, loadedConfigs)
	assert.Equal(t, 2, loadedConfigs.Count())
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/tfplan.0.15.json"))
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/cfn.yaml"))
}

func TestLoadPathsDirWithType(t *testing.T) {
	loadedConfigs, err := loader.LocalConfigurationLoader(loader.LoadPathsOptions{
		Paths:      []string{"test_inputs/data"},
		InputTypes: []loader.InputType{loader.TfPlan},
	})()
	assert.Nil(t, err)
	assert.NotNil(t, loadedConfigs)
	assert.Greater(t, loadedConfigs.Count(), 0)
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/tfplan.0.15.json"))
	assert.False(t, loadedConfigs.AlreadyLoaded("test_inputs/data/cfn.yaml"))
}
