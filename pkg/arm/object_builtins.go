package arm

import (
	"strings"

	"github.com/zclconf/go-cty/cty"
	ctyjson "github.com/zclconf/go-cty/cty/json"
)

var ContainsObject = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		f := strings.ToLower(args[1].AsString())
		containerMap := args[0].AsValueMap()
		for k, _ := range containerMap {
			if f == strings.ToLower(k) {
				return cty.True, nil
			}
		}
		return cty.False, nil
	},
	NewArgument(true, false, AnyObject),
	NewArgument(true, false, Type(cty.String)),
)
var CreateObject = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		f := strings.ToLower(args[1].AsString())
		containerMap := args[0].AsValueMap()
		for k, _ := range containerMap {
			if f == strings.ToLower(k) {
				return cty.True, nil
			}
		}
		return cty.False, nil
	},
	NewArgument(true, false, Type(cty.String)),
	NewArgument(true, true, Type(cty.Number), Type(cty.Bool), Type(cty.String), AnyObject, AnyArray),
)
var IntersectionObject = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		currObj := args[0].AsValueMap()
		if len(args) > 1 {
			intersect := func(
				a map[string]cty.Value,
				b map[string]cty.Value,
			) map[string]cty.Value {
				next := map[string]cty.Value{}
				for k, aVal := range a {
					if bVal, ok := b[k]; ok && aVal.Equals(bVal) == cty.True {
						next[k] = aVal
					}
				}
				return next
			}
			for _, a := range args[1:] {
				currObj = intersect(currObj, a.AsValueMap())
			}
		}
		return cty.MapVal(currObj), nil
	},
	NewArgument(true, false, AnyObject),
	NewArgument(true, false, AnyObject),
	NewArgument(false, true, AnyObject),
)
var JSON = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		data := []byte(args[0].AsString())
		t, err := ctyjson.ImpliedType(data)
		if err != nil {
			return cty.NilVal, err
		}
		return ctyjson.Unmarshal(data, t)
	},
	NewArgument(true, false, Type(cty.String)),
)
var Null = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return cty.NullVal(cty.DynamicPseudoType), nil
	},
)
var UnionObject = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		union := args[0].AsValueMap()
		if len(args) > 1 {
			for _, a := range args[1:] {
				for k, aVal := range a.AsValueMap() {
					union[k] = aVal
				}
			}
		}
		return cty.MapVal(union), nil
	},
	NewArgument(true, false, AnyObject),
	NewArgument(true, false, AnyObject),
	NewArgument(false, true, AnyObject),
)
