package arm

import (
	"strconv"

	"github.com/zclconf/go-cty/cty"
)

var Add = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].Add(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number)),
	NewArgument(true, false, Type(cty.Number)),
)
var Div = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].Divide(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number)),
	NewArgument(true, false, Type(cty.Number)),
)
var FloatFromString = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		f, err := strconv.ParseFloat(args[0].AsString(), 64)
		if err != nil {
			return cty.NilVal, err
		}
		return cty.NumberFloatVal(f), nil
	},
	NewArgument(true, false, Type(cty.String)),
)
var FloatFromInt = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		// go-cty uses the same type for ints and floats, so
		// this can be a no-op.
		return args[0], nil
	},
	NewArgument(true, false, Type(cty.Number)),
)
var IntFromString = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		i, err := strconv.ParseInt(args[0].AsString(), 10, 64)
		if err != nil {
			return cty.NilVal, err
		}
		return cty.NumberIntVal(i), nil
	},
	NewArgument(true, false, Type(cty.String)),
)
var IntFromInt = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		// This needs to be supported
		return args[0], nil
	},
	NewArgument(true, false, Type(cty.Number)),
)
var MaxNumeric = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		max := args[0]
		for _, next := range args[1:] {
			if next.GreaterThan(max) == cty.True {
				max = next
			}
		}
		return max, nil
	},
	NewArgument(true, true, Type(cty.Number)),
)
var MinNumeric = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		min := args[0]
		for _, next := range args[1:] {
			if next.LessThan(min) == cty.True {
				min = next
			}
		}
		return min, nil
	},
	NewArgument(true, true, Type(cty.Number)),
)
var Mod = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].Modulo(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number)),
	NewArgument(true, false, Type(cty.Number)),
)
var Mul = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].Multiply(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number)),
	NewArgument(true, false, Type(cty.Number)),
)
var Sub = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].Subtract(args[1]), nil
	},
	NewArgument(true, false, Type(cty.Number)),
	NewArgument(true, false, Type(cty.Number)),
)
