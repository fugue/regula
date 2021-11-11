package regulatf

import (
	"encoding/json"
	"fmt"

	"github.com/zclconf/go-cty/cty"
)

// A ValTree is a mutable, dynamic tree.  Values will be either of these three
// things:
//
//  -  a map with int keys (which represents a sparse array)
//  -  a map with string keys
//  -  a cty.Value (at the leafs only)
//
type ValTree = interface{}

// Build a val tree consisting of a subtree nested under a given name.
func BuildValTree(name LocalName, sub ValTree) ValTree {
	var tree ValTree = sub

	for i := len(name) - 1; i >= 0; i-- {
		switch v := name[i].(type) {
		case string:
			tree = map[string]ValTree{v: tree}
		case int:
			tree = map[int]ValTree{v: tree}
		}
	}

	return tree
}

// Look up a given subtree, returns nil if not found
func LookupValTree(tree ValTree, name LocalName) ValTree {
	cursor := tree
	for _, p := range name {
		switch k := p.(type) {
		case string:
			switch m := cursor.(type) {
			case map[string]ValTree:
				if child, ok := m[k]; ok {
					cursor = child
				} else {
					return nil
				}
			default:
				return nil
			}
		case int:
			switch m := cursor.(type) {
			case map[int]ValTree:
				if child, ok := m[k]; ok {
					cursor = child
				} else {
					return nil
				}
			default:
				return nil
			}
		default:
			return nil
		}
	}
	return cursor
}

func EmptyObjectValTree() ValTree {
	return map[string]ValTree{}
}

// Create a nested ValTree consisting of a single value
func SingletonValTree(name LocalName, leaf cty.Value) ValTree {
	return BuildValTree(name, leaf)
}

// Create a sparse tree, only containing the value with the given name.  Returns
// nil if this does not exist.
func SparseValTree(original ValTree, name LocalName) ValTree {
	if sub := LookupValTree(original, name); sub != nil {
		return BuildValTree(name, sub)
	} else {
		return nil
	}
}

// Merge all values from the right valtree into the left.
func MergeValTree(left ValTree, right ValTree) ValTree {
	switch l := left.(type) {
	case map[string]ValTree:
		switch r := right.(type) {
		case map[string]ValTree:
			for k, rv := range r {
				if lv, ok := l[k]; ok {
					l[k] = MergeValTree(lv, rv)
				} else {
					l[k] = rv
				}
			}
			return l
		case cty.Value:
			if r.Type().Equals(cty.EmptyObject) {
				return l
			}
			return r
		default:
			return r
		}
	case map[int]ValTree:
		switch r := right.(type) {
		case map[int]ValTree:
			for k, rv := range r {
				if lv, ok := l[k]; ok {
					l[k] = MergeValTree(lv, rv)
				} else {
					l[k] = rv
				}
			}
			return l
		case cty.Value:
			if r.Type().Equals(cty.EmptyObject) {
				return l
			}
			return r
		default:
			return r
		}
	default:
		return right
	}
}

// Convert a ValTree to an immutable cty.Value.  Since this is expensive, it
// should only be used for relatively sparse trees, if possible.
func ValTreeToValue(tree ValTree) cty.Value {
	switch t := tree.(type) {
	case cty.Value:
		return t
	case map[string]ValTree:
		m := map[string]cty.Value{}
		for k, v := range t {
			m[k] = ValTreeToValue(v)
		}
		return cty.ObjectVal(m)
	case map[int]ValTree:
		length := 0
		for k := range t {
			if k >= length {
				length = k + 1
			}
		}
		arr := make([]cty.Value, length)
		for i := 0; i < length; i++ {
			if v, ok := t[i]; ok {
				arr[i] = ValTreeToValue(v)
			} else {
				arr[i] = cty.NilVal
			}
		}
		return cty.TupleVal(arr)
	default:
		return cty.NullVal(cty.DynamicPseudoType)
	}
}

// Some HCL functions require it to be a map.  Returns an empty map if we
// have anything but an object at the root.
func ValTreeToVariables(tree ValTree) map[string]cty.Value {
	variables := map[string]cty.Value{}
	switch t := tree.(type) {
	case map[string]ValTree:
		for k, v := range t {
			variables[k] = ValTreeToValue(v)
		}
	}
	return variables
}

// For debugging.
func PrettyValTree(tree ValTree) string {
	native := ValueToInterface(ValTreeToValue(tree))
	bytes, err := json.MarshalIndent(native, "", "  ")
	if err != nil {
		return fmt.Sprintf("Could not ValTree to JSON: %s\n", err)
	}
	return string(bytes)
}
