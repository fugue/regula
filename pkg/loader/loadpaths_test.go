package loader_test

import (
	"testing"

	"github.com/fugue/regula/pkg/loader"
	"github.com/stretchr/testify/assert"
)

func TestLoadPathsDirAuto(t *testing.T) {
	loadedConfigs, err := loader.LoadPaths(loader.LoadPathsOptions{
		Paths:      []string{"test_inputs/data"},
		InputTypes: []loader.InputType{loader.Auto},
	})
	assert.Nil(t, err)
	assert.NotNil(t, loadedConfigs)
	assert.Greater(t, loadedConfigs.Count(), 0)
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/tfplan.0.15.json"))
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/cfn.yaml"))
}

func TestLoadPathsFiles(t *testing.T) {
	loadedConfigs, err := loader.LoadPaths(loader.LoadPathsOptions{
		Paths: []string{
			"test_inputs/data/cfn.yaml",
			"test_inputs/data/tfplan.0.15.json",
		},
		InputTypes: []loader.InputType{loader.Auto},
	})
	assert.Nil(t, err)
	assert.NotNil(t, loadedConfigs)
	assert.Equal(t, 2, loadedConfigs.Count())
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/tfplan.0.15.json"))
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/cfn.yaml"))
}

func TestLoadPathsDirWithType(t *testing.T) {
	loadedConfigs, err := loader.LoadPaths(loader.LoadPathsOptions{
		Paths:      []string{"test_inputs/data"},
		InputTypes: []loader.InputType{loader.TfPlan},
	})
	assert.Nil(t, err)
	assert.NotNil(t, loadedConfigs)
	assert.Greater(t, loadedConfigs.Count(), 0)
	assert.True(t, loadedConfigs.AlreadyLoaded("test_inputs/data/tfplan.0.15.json"))
	assert.False(t, loadedConfigs.AlreadyLoaded("test_inputs/data/cfn.yaml"))
}
