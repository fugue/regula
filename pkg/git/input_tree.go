package git

import (
	"os"
	"strings"
)

type TreeNode struct {
	Children map[string]*TreeNode
}

func NewTreeNode(splitPath []string) *TreeNode {
	t := &TreeNode{
		Children: map[string]*TreeNode{},
	}
	if len(splitPath) > 0 {
		t.Children[splitPath[0]] = NewTreeNode(splitPath[1:])
	}
	return t
}

func (t *TreeNode) Contains(splitPath []string) bool {
	if pathLen := len(splitPath); pathLen < 1 {
		return true
	} else {
		if child, ok := t.Children[splitPath[1]]; ok {
			return child.Contains(splitPath[1:])
		} else {
			return false
		}
	}
}

func NewTree(paths []string) *TreeNode {
	rootNode := NewTreeNode(nil)
	for _, path := range paths {
		splitPath := strings.Split(path, string(os.PathSeparator))
		if len(splitPath) < 1 {
			continue
		}
		rootNode.Children[splitPath[0]] = NewTreeNode(splitPath[1:])
	}

	return rootNode

	// if len(splitPath) < 1 {
	// 	return nil, fmt.Errorf("Got an empty path when initializing input tree")
	// }
	// rootNode := NewTreeNode()
	// currChild := NewTreeNode()
	// rootNode.Children[splitPath[0]] = currChild
	// for len(splitPath) > 1 {
	// 	splitPath = splitPath[1:]
	// 	nextChild := NewTreeNode()
	// 	currChild.Children[splitPath[0]] = nextChild
	// 	currChild = nextChild
	// }
	// return
}
