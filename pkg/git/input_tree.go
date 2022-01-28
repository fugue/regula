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

package git

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/fugue/regula/v2/pkg/filesystems"
	"github.com/spf13/afero"
)

type Relation int

const (
	None Relation = iota
	TreeNodeIsChild
	TreeNodeIsParent
)

type InputTreeNode struct {
	Children map[string]*InputTreeNode
}

func NewInputTreeNode(splitPath []string) *InputTreeNode {
	t := &InputTreeNode{
		Children: map[string]*InputTreeNode{},
	}
	if len(splitPath) > 0 {
		t.Children[splitPath[0]] = NewInputTreeNode(splitPath[1:])
	}
	return t
}

func (t *InputTreeNode) Relation(splitPath []string) Relation {
	if pathLen := len(splitPath); pathLen < 1 {
		// In this case the splitPath is a parent of the tree node
		return TreeNodeIsChild
	} else {
		if len(t.Children) == 0 {
			// In this case the tree node is a parent of the split path
			return TreeNodeIsParent
		}
		if child, ok := t.Children[splitPath[0]]; ok {
			return child.Relation(splitPath[1:])
		}

		return None
	}
}

func (t *InputTreeNode) AddChild(splitPath []string) {
	if len(splitPath) < 1 {
		return
	}
	if child, ok := t.Children[splitPath[0]]; ok {
		child.AddChild(splitPath[1:])
		return
	}
	t.Children[splitPath[0]] = NewInputTreeNode(splitPath[1:])
}

func NewInputTree(afs afero.Fs, paths []string) *InputTreeNode {
	rootNode := NewInputTreeNode(nil)
	for _, path := range paths {
		absPath, err := filesystems.Abs(afs, path)
		if err != nil {
			// This case can happen for the stdin path "-"
			absPath = path
		}
		splitPath := strings.Split(absPath, string(os.PathSeparator))
		rootNode.AddChild(splitPath)
	}

	return rootNode
}

type SearchPath struct {
	prefix      string
	path        []string
	splitPrefix []string
}

func NewSearchPath(prefix string, path []string) SearchPath {
	splitPrefix := strings.Split(prefix, string(os.PathSeparator))
	return SearchPath{
		prefix:      prefix,
		path:        path,
		splitPrefix: splitPrefix,
	}
}

func (s SearchPath) Abs() string {
	fullPath := append([]string{s.prefix}, s.path...)
	return filepath.Join(fullPath...)
}

func (s SearchPath) WithAddedPath(path string) SearchPath {
	return SearchPath{
		prefix:      s.prefix,
		path:        append(s.path, path),
		splitPrefix: s.splitPrefix,
	}
}

func (s SearchPath) AbsSplit() []string {
	return append(s.splitPrefix, s.path...)
}

func (s SearchPath) Path() []string {
	return s.path
}
