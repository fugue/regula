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
	"archive/tar"
	"bytes"
	"compress/gzip"
	"context"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/fugue/regula/pkg/loader"
	embedded "github.com/fugue/regula/rego"
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
	"github.com/sirupsen/logrus"
)

var opaExts map[string]bool = map[string]bool{
	".rego": true,
}

type regoFile struct {
	path     string
	contents []byte
}

func (r *regoFile) Raw() []byte {
	return r.contents
}

func (r *regoFile) String() string {
	return string(r.contents)
}

func (r *regoFile) AstModule() (*ast.Module, error) {
	return ast.ParseModule(r.Path(), r.String())
}

func (r *regoFile) RegoModule() func(r *rego.Rego) {
	return rego.Module(r.Path(), r.String())
}

func (r *regoFile) Path() string {
	return r.path
}

func newRegoFile(fsys fs.FS, path string) (RegoFile, error) {
	contents, err := fs.ReadFile(fsys, path)
	if err != nil {
		return nil, err
	}
	return &regoFile{
		path:     path,
		contents: contents,
	}, nil
}

func RegoFileFromString(path string, contents string) RegoFile {
	return &regoFile{
		path:     path,
		contents: []byte(contents),
	}
}

func FSProvider(fsys fs.FS, path string) RegoProvider {
	return func(_ context.Context, p RegoProcessor) error {
		walkDirFunc := func(path string, d fs.DirEntry, err error) error {
			if err != nil {
				return err
			}
			if d.IsDir() {
				return nil
			}
			if ext := filepath.Ext(path); !opaExts[ext] {
				return nil
			}
			regoFile, err := newRegoFile(fsys, path)
			if err != nil {
				return err
			}
			if err := p(regoFile); err != nil {
				return err
			}
			return nil
		}

		if err := fs.WalkDir(fsys, path, walkDirFunc); err != nil {
			return err
		}

		return nil
	}
}

func LocalProvider(paths []string) RegoProvider {
	return func(ctx context.Context, p RegoProcessor) error {
		fsys := &osFs{}
		for _, path := range paths {
			info, err := os.Stat(path)
			if err != nil {
				return err
			}
			if info.IsDir() {
				err := FSProvider(fsys, path)(ctx, p)
				if err != nil {
					return err
				}
				continue
			}
			if ext := filepath.Ext(path); !opaExts[ext] {
				continue
			}
			file, err := newRegoFile(fsys, path)
			if err != nil {
				return err
			}
			if err := p(file); err != nil {
				return err
			}
		}
		return nil
	}
}

func TarGzProvider(reader io.Reader) RegoProvider {
	return func(ctx context.Context, p RegoProcessor) error {
		gzf, err := gzip.NewReader(reader)
		if err != nil {
			return err
		}

		tarReader := tar.NewReader(gzf)
		for true {
			header, err := tarReader.Next()
			if err == io.EOF {
				break
			} else if err != nil {
				return err
			}

			path := header.Name

			switch header.Typeflag {
			case tar.TypeReg:
				if ext := filepath.Ext(path); !opaExts[ext] {
					continue
				}
				buffer := bytes.NewBuffer([]byte{})
				if _, err := io.Copy(buffer, tarReader); err != nil {
					return fmt.Errorf("Error reading file %s in tar: %s", path, err)
				}
				p(&regoFile{
					path:     path,
					contents: buffer.Bytes(),
				})
			}
		}
		return nil
	}
}

func RegulaBundleProvider() RegoProvider {
	return func(ctx context.Context, p RegoProcessor) error {
		f, err := os.Open("/home/jasper/Luminal/risk-manager/src/iac_rules/build/rego.tar.gz")
		if err != nil {
			return err
		}
		defer f.Close()
		return TarGzProvider(f)(ctx, p)
	}
}

func RegulaLibProvider() RegoProvider {
	return FSProvider(embedded.RegulaLib, "lib")
}

func RegulaRulesProvider() RegoProvider {
	return FSProvider(embedded.RegulaRules, "rules")
}

func TestInputsProvider(paths []string, inputTypes []loader.InputType) RegoProvider {
	return func(_ context.Context, p RegoProcessor) error {
		filteredPaths := []string{}
		for _, p := range paths {
			if !opaExts[filepath.Ext(p)] {
				filteredPaths = append(filteredPaths, p)
			}
		}
		if len(filteredPaths) < 1 {
			return nil
		}
		configs, err := loader.LocalConfigurationLoader(loader.LoadPathsOptions{
			Paths:      filteredPaths,
			IgnoreDirs: true,
			InputTypes: inputTypes,
		})()
		if err != nil {
			// Ignore if we can't load any configs
			if _, ok := err.(*loader.NoLoadableConfigsError); ok {
				logrus.Warning("No IaC configurations found in input paths")
				return nil
			}
			return err
		}
		logrus.Infof("Loaded %v IaC configurations as test inputs\n", configs.Count())
		for _, regulaInput := range configs.RegulaInput() {
			r, err := NewTestInput(regulaInput)
			if err != nil {
				return err
			}
			p(r)
		}
		return nil
	}
}

type osFs struct {
	fs.FS
	fs.GlobFS
	fs.ReadDirFS
	fs.ReadFileFS
	fs.StatFS
}

func (o *osFs) Open(name string) (fs.File, error) {
	return os.Open(name)
}

func (o *osFs) Glob(pattern string) ([]string, error) {
	return filepath.Glob(pattern)
}

func (o *osFs) ReadDir(name string) ([]fs.DirEntry, error) {
	return os.ReadDir(name)
}

func (o *osFs) ReadFile(name string) ([]byte, error) {
	return os.ReadFile(name)
}

func (o *osFs) Stat(name string) (fs.FileInfo, error) {
	return os.Stat(name)
}
