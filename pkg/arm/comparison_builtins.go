package arm

import (
	"github.com/zclconf/go-cty/cty"
)

var Coalesce = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		for _, a := range args {
			if !a.IsNull() {
				return a, nil
			}
		}
		return cty.NullVal(cty.DynamicPseudoType), nil
	},
	NewArgument(true, false, Type(cty.Number), Type(cty.String), AnyArray, AnyObject),
	NewArgument(false, true, Type(cty.Number), Type(cty.String), AnyArray, AnyObject),
)
var Equals = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].Equals(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number), Type(cty.String), AnyArray, AnyObject),
	NewArgument(true, false, Type(cty.Number), Type(cty.String), AnyArray, AnyObject),
)
var Greater = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].GreaterThan(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number), Type(cty.String)),
	NewArgument(true, false, Type(cty.Number), Type(cty.String)),
)
var GreaterOrEquals = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].GreaterThanOrEqualTo(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number), Type(cty.String)),
	NewArgument(true, false, Type(cty.Number), Type(cty.String)),
)
var Less = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].LessThan(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number), Type(cty.String)),
	NewArgument(true, false, Type(cty.Number), Type(cty.String)),
)
var LessOrEquals = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].LessThanOrEqualTo(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number), Type(cty.String)),
	NewArgument(true, false, Type(cty.Number), Type(cty.String)),
)
