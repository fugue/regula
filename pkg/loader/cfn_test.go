package loader_test

import (
	_ "embed"
	"testing"

	"github.com/fugue/regula/pkg/loader"
	"github.com/fugue/regula/pkg/mocks"
	"github.com/golang/mock/gomock"
	"github.com/stretchr/testify/assert"
)

//go:embed test_inputs/cfn/cfn.yaml
var cfnYAMLContents []byte

//go:embed test_inputs/cfn/cfn.json
var cfnJSONContents []byte

//go:embed test_inputs/cfn/cfn_resources.yaml
var cfnYAMLResourcesContents []byte

//go:embed test_inputs/cfn/other.json
var otherJSONContents []byte

//go:embed test_inputs/cfn/not_yaml.txt
var notYAMLContents []byte

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
		{path: "cfn.yaml", ext: ".yaml", contents: cfnYAMLContents},
		{path: "cfn.yml", ext: ".yml", contents: cfnYAMLContents},
		{path: "cfn.json", ext: ".yaml", contents: cfnJSONContents},
		{path: "cfn_resources.yaml", ext: ".yaml", contents: cfnYAMLResourcesContents},
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
	f := makeMockFile(ctrl, "other.json", ".json", otherJSONContents)
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
	f.EXPECT().Contents().Return(cfnYAMLContents, nil)
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
	f := makeMockFile(ctrl, "not_cfn.yaml", ".yaml", notYAMLContents)
	loader, err := detector.DetectFile(f, loader.DetectOptions{
		IgnoreExt: false,
	})
	assert.NotNil(t, err)
	assert.Nil(t, loader)
}
