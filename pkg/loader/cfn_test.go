package loader_test

import (
	"encoding/json"
	"testing"

	"github.com/fugue/regula/pkg/loader"
	inputs "github.com/fugue/regula/pkg/loader/test_inputs"
	"github.com/fugue/regula/pkg/mocks"
	"github.com/golang/mock/gomock"
	"github.com/stretchr/testify/assert"
)

func makeMockFile(ctrl *gomock.Controller, path, ext string, contents []byte) loader.InputFile {
	mockFile := mocks.NewMockInputFile(ctrl)
	mockFile.EXPECT().Ext().Return(ext)
	mockFile.EXPECT().Path().Return(path)
	mockFile.EXPECT().Contents().Return(contents, nil)
	return mockFile
}

func TestCfnDetector(t *testing.T) {
	ctrl := gomock.NewController(t)
	testInputs := []struct {
		path     string
		ext      string
		contents []byte
	}{
		{path: "cfn.yaml", ext: ".yaml", contents: inputs.Contents(t, "cfn.yaml")},
		{path: "cfn.yml", ext: ".yml", contents: inputs.Contents(t, "cfn.yaml")},
		{path: "cfn.json", ext: ".yaml", contents: inputs.Contents(t, "cfn.json")},
		{path: "cfn_resources.yaml", ext: ".yaml", contents: inputs.Contents(t, "cfn_resources.yaml")},
	}
	detector := &loader.CfnDetector{}

	for _, i := range testInputs {
		f := makeMockFile(ctrl, i.path, i.ext, i.contents)
		loader, err := detector.DetectFile(f, loader.DetectOptions{
			IgnoreExt: false,
		})
		assert.Nil(t, err)
		assert.NotNil(t, loader)
		assert.Equal(t, loader.LoadedFiles(), []string{i.path})
	}
}

func TestCfnDetectorNotCfnContents(t *testing.T) {
	ctrl := gomock.NewController(t)
	detector := &loader.CfnDetector{}
	f := makeMockFile(ctrl, "other.json", ".json", inputs.Contents(t, "other.json"))
	loader, err := detector.DetectFile(f, loader.DetectOptions{
		IgnoreExt: false,
	})
	assert.NotNil(t, err)
	assert.Nil(t, loader)
}

func TestCfnDetectorNotCfnExt(t *testing.T) {
	ctrl := gomock.NewController(t)
	detector := &loader.CfnDetector{}
	f := mocks.NewMockInputFile(ctrl)
	f.EXPECT().Ext().Return(".cfn")
	f.EXPECT().Path().Return("cfn.cfn")
	loader, err := detector.DetectFile(f, loader.DetectOptions{
		IgnoreExt: false,
	})
	assert.NotNil(t, err)
	assert.Nil(t, loader)
}

func TestCfnDetectorIgnoreExt(t *testing.T) {
	ctrl := gomock.NewController(t)
	detector := &loader.CfnDetector{}
	f := mocks.NewMockInputFile(ctrl)
	f.EXPECT().Path().Return("cfn.cfn")
	f.EXPECT().Contents().Return(inputs.Contents(t, "cfn.yaml"), nil)
	loader, err := detector.DetectFile(f, loader.DetectOptions{
		IgnoreExt: true,
	})
	assert.Nil(t, err)
	assert.NotNil(t, loader)
	assert.Equal(t, loader.LoadedFiles(), []string{"cfn.cfn"})
}

func TestCfnDetectorNotYAML(t *testing.T) {
	ctrl := gomock.NewController(t)
	detector := &loader.CfnDetector{}
	f := makeMockFile(ctrl, "not_cfn.yaml", ".yaml", inputs.Contents(t, "text.txt"))
	loader, err := detector.DetectFile(f, loader.DetectOptions{
		IgnoreExt: false,
	})
	assert.NotNil(t, err)
	assert.Nil(t, loader)
}

func TestCfnIntrinsics(t *testing.T) {
	ctrl := gomock.NewController(t)
	detector := &loader.CfnDetector{}
	yamlFile := makeMockFile(ctrl, "cfn.yaml", ".yaml", inputs.Contents(t, "cfn_intrinsics.yaml"))
	// This JSON file was produced with cfn-flip. The transformations performed by the
	// loader should be identical to the output of cfn-flip.
	jsonFile := makeMockFile(ctrl, "cfn.json", ".json", inputs.Contents(t, "cfn_intrinsics.json"))
	yamlLoader, err := detector.DetectFile(yamlFile, loader.DetectOptions{})
	assert.Nil(t, err)
	assert.NotNil(t, yamlLoader)

	jsonLoader, err := detector.DetectFile(jsonFile, loader.DetectOptions{})
	assert.Nil(t, err)
	assert.NotNil(t, jsonLoader)

	yamlInput := coerceRegulaInput(t, yamlLoader.RegulaInput())
	jsonInput := coerceRegulaInput(t, jsonLoader.RegulaInput())

	assert.Equal(t, jsonInput["content"], yamlInput["content"])
}

// This is annoying, but we care about the values (not the types)
func coerceRegulaInput(t *testing.T, regulaInput loader.RegulaInput) loader.RegulaInput {
	coerced := loader.RegulaInput{}
	bytes, err := json.Marshal(regulaInput)
	assert.Nil(t, err)
	err = json.Unmarshal(bytes, &coerced)

	return coerced
}
