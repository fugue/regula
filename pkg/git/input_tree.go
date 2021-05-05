package git

import (
	"os"
	"path/filepath"
	"strings"
)

type Relation int

const (
	None Relation = iota
	IsParent
	IsChild
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
	// fmt.Println("Checking relation", strings.Join(splitPath, "/"))
	if pathLen := len(splitPath); pathLen < 1 {
		// In this case the splitPath is a parent of the tree node
		return IsParent
	} else {
		if len(t.Children) == 0 {
			// In this case the tree node is a parent of the split path
			return IsChild
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

func NewInputTree(paths []string) *InputTreeNode {
	rootNode := NewInputTreeNode(nil)
	for _, path := range paths {
		absPath, err := filepath.Abs(path)
		if err != nil {
			// This case can happen for the stdin path "-"
			absPath = path
		}
		splitPath := strings.Split(absPath, string(os.PathSeparator))
		rootNode.AddChild(splitPath)
	}

	return rootNode
}
