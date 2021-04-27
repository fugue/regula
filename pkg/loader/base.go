package loader

import (
	"io"
	"os"
	"path/filepath"
)

type InputType int

const (
	Auto InputType = iota
	TfPlan
	CfnJson
	CfnYaml
)

var InputTypeIds = map[InputType][]string{
	Auto:    {"auto"},
	TfPlan:  {"tf-plan"},
	CfnJson: {"cfn-json"},
	CfnYaml: {"cfn-yaml"},
}

type RegulaInput map[string]interface{}

type Loader interface {
	RegulaInput() RegulaInput
}

type Location struct {
	Path string
	Line int
	Col  int
}

type LocationAwareLoader interface {
	Location(attributePath string) (*Location, error)
}

type LoaderFactory func(inputPath InputPath) (Loader, error)

type TypeDetector struct {
	DetectDirectory func(i InputDirectory) (Loader, error)
	DetectFile      func(i InputFile) (Loader, error)
}

func NewTypeDetector(t *TypeDetector) *TypeDetector {
	if t.DetectDirectory == nil {
		t.DetectDirectory = func(i InputDirectory) (Loader, error) {
			return nil, nil
		}
	}
	if t.DetectFile == nil {
		t.DetectFile = func(i InputFile) (Loader, error) {
			return nil, nil
		}
	}
	return t
}

type InputPath interface {
	DetectType(d TypeDetector) (Loader, error)
	Children() []InputPath
	IsDir() bool
	Walk(w func(i InputPath) error) error
	GetPath() string
}
type InputDirectory struct {
	Path     string
	Name     string
	Contents []InputPath
}

func (i InputDirectory) DetectType(d TypeDetector) (Loader, error) {
	return d.DetectDirectory(i)
}

func (i InputDirectory) Children() []InputPath {
	return i.Contents
}

func (i InputDirectory) IsDir() bool {
	return true
}

func (i InputDirectory) Walk(w func(i InputPath) error) error {
	for _, c := range i.Contents {
		if err := w(c); err != nil {
			return err
		}
		if err := c.Walk(w); err != nil {
			return err
		}
	}
	return nil
}

func (i InputDirectory) GetPath() string {
	return i.Path
}

func NewInputDirectory(path string, name string) (*InputDirectory, error) {
	// name := filepath.Base(path)
	contents := []InputPath{}
	entries, err := os.ReadDir(path)
	if err != nil {
		return nil, err
	}
	for _, e := range entries {
		n := e.Name()
		p := filepath.Join(path, n)
		var i InputPath
		if e.IsDir() {
			i, err = NewInputDirectory(p, n)
			if err != nil {
				return nil, err
			}

		} else {
			i = NewInputFile(p, n)
		}
		contents = append(contents, i)
	}
	return &InputDirectory{
		Path:     path,
		Name:     name,
		Contents: contents,
	}, nil
}

type InputFile struct {
	Path string
	Name string
	Ext  string
}

func (i InputFile) DetectType(d TypeDetector) (Loader, error) {
	return d.DetectFile(i)
}

func (i InputFile) Children() []InputPath {
	return nil
}

func (i InputFile) IsDir() bool {
	return false
}

func (i InputFile) Walk(w func(i InputPath) error) error {
	return nil
}

func (i InputFile) GetPath() string {
	return i.Path
}

func (i InputFile) ReadContents() ([]byte, error) {
	if i.Name == "-" {
		return io.ReadAll(os.Stdin)
	}

	return os.ReadFile(i.Path)
}

func NewInputFile(path string, name string) *InputFile {
	ext := filepath.Ext(path)
	return &InputFile{
		Path: path,
		Name: name,
		Ext:  ext,
	}
}
