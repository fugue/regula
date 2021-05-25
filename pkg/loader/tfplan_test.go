package loader_test

import (
	"testing"

	"github.com/fugue/regula/pkg/loader"
	inputs "github.com/fugue/regula/pkg/loader/test_inputs"
	"github.com/fugue/regula/pkg/mocks"
	"github.com/golang/mock/gomock"
	"github.com/stretchr/testify/assert"
)

func TestTfPlanDetector(t *testing.T) {
	ctrl := gomock.NewController(t)
	testInputs := []struct {
		path     string
		ext      string
		contents []byte
	}{
		{path: "tfplan.json", ext: ".json", contents: inputs.Contents(t, "tfplan.0.12.json")},
		{path: "tfplan.json", ext: ".json", contents: inputs.Contents(t, "tfplan.0.13.json")},
		{path: "tfplan.json", ext: ".json", contents: inputs.Contents(t, "tfplan.0.14.json")},
		{path: "tfplan.json", ext: ".json", contents: inputs.Contents(t, "tfplan.0.15.json")},
	}
	detector := &loader.TfPlanDetector{}

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

func TestTfPlanDetectorNotTfContents(t *testing.T) {
	ctrl := gomock.NewController(t)
	detector := &loader.TfPlanDetector{}
	f := makeMockFile(ctrl, "other.json", ".json", inputs.Contents(t, "other.json"))
	loader, err := detector.DetectFile(f, loader.DetectOptions{
		IgnoreExt: false,
	})
	assert.NotNil(t, err)
	assert.Nil(t, loader)
}

func TestTfPlanDetectorNotJsonExt(t *testing.T) {
	ctrl := gomock.NewController(t)
	detector := &loader.TfPlanDetector{}
	f := mocks.NewMockInputFile(ctrl)
	f.EXPECT().Ext().Return(".tfplan")
	f.EXPECT().Path().Return("plan.tfplan")
	loader, err := detector.DetectFile(f, loader.DetectOptions{
		IgnoreExt: false,
	})
	assert.NotNil(t, err)
	assert.Nil(t, loader)
}

func TestTfPlanDetectorIgnoreExt(t *testing.T) {
	ctrl := gomock.NewController(t)
	detector := &loader.TfPlanDetector{}
	f := mocks.NewMockInputFile(ctrl)
	f.EXPECT().Path().Return("plan.tfplan")
	f.EXPECT().Contents().Return(inputs.Contents(t, "tfplan.0.15.json"), nil)
	loader, err := detector.DetectFile(f, loader.DetectOptions{
		IgnoreExt: true,
	})
	assert.Nil(t, err)
	assert.NotNil(t, loader)
	assert.Equal(t, loader.LoadedFiles(), []string{"plan.tfplan"})
}

func TestTfPlanDetectorNotYAML(t *testing.T) {
	ctrl := gomock.NewController(t)
	detector := &loader.TfPlanDetector{}
	f := makeMockFile(ctrl, "not_tfplan.json", ".json", inputs.Contents(t, "text.txt"))
	loader, err := detector.DetectFile(f, loader.DetectOptions{
		IgnoreExt: false,
	})
	assert.NotNil(t, err)
	assert.Nil(t, loader)
}
