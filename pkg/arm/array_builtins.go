package arm

import (
	"fmt"

	"github.com/zclconf/go-cty/cty"
	"github.com/zclconf/go-cty/cty/gocty"
)

var Array = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return cty.TupleVal([]cty.Value{args[0]}), nil
	},
	NewArgument(true, false, Type(cty.Number), Type(cty.String), AnyArray, AnyObject),
)
var ConcatArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		combined := []cty.Value{}
		for _, a := range args {
			combined = append(combined, a.AsValueSlice()...)
		}
		return cty.TupleVal(combined), nil
	},
	NewArgument(true, false, AnyArray),
	NewArgument(false, true, AnyArray),
)
var ContainsArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		for _, v := range args[0].AsValueSlice() {
			if v.Equals(args[1]) == cty.True {
				return cty.True, nil
			}
		}
		return cty.False, nil
	},
	NewArgument(true, false, AnyArray),
	NewArgument(true, false, Type(cty.String), Type(cty.Number)),
)
var CreateArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		if len(args) < 1 {
			return cty.EmptyTupleVal, nil
		}

		return cty.TupleVal(args), nil
	},
	NewArgument(false, true, Type(cty.String), Type(cty.Number), AnyArray, AnyObject),
)
var Empty = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return cty.BoolVal(args[0].LengthInt() == 0), nil
	},
	NewArgument(true, false, AnyArray, AnyObject, Type(cty.String)),
)
var FirstArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		asSlice := args[0].AsValueSlice()
		if len(asSlice) < 1 {
			return cty.NullVal(cty.DynamicPseudoType), nil
		}
		return asSlice[0], nil
	},
	NewArgument(true, false, AnyArray),
)
var IntersectionArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		currSet := args[0].AsValueSet()
		if len(args) > 1 {
			for _, a := range args[1:] {
				currSet = a.AsValueSet().Intersection(currSet)
			}
		}
		return cty.TupleVal(currSet.Values()), nil
	},
	NewArgument(true, false, AnyArray),
	NewArgument(true, false, AnyArray),
	NewArgument(false, true, AnyArray),
)
var LastArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		asSlice := args[0].AsValueSlice()
		if len(asSlice) < 1 {
			return cty.NullVal(cty.DynamicPseudoType), nil
		}
		return asSlice[len(asSlice)-1], nil
	},
	NewArgument(true, false, AnyArray),
)
var Length = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0].Length(), nil
	},
	NewArgument(true, false, AnyArray, AnyObject, Type(cty.String)),
)
var MaxArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		a := args[0].AsValueSlice()
		if len(a) < 1 {
			return cty.NullVal(cty.Number), nil
		}
		max := a[0]
		for _, next := range a {
			if next.GreaterThan(max) == cty.True {
				max = next
			}
		}
		return max, nil
	},
	NewArgument(true, false, ArrayOf(cty.Number)),
)
var MinArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		a := args[0].AsValueSlice()
		if len(a) < 1 {
			return cty.NullVal(cty.Number), nil
		}
		min := a[0]
		for _, next := range a {
			if next.LessThan(min) == cty.True {
				min = next
			}
		}
		return min, nil
	},
	NewArgument(true, false, ArrayOf(cty.Number)),
)
var Range = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		var start int64
		var count int64
		if err := gocty.FromCtyValue(args[0], &start); err != nil {
			return cty.NilVal, err
		}
		if err := gocty.FromCtyValue(args[0], &count); err != nil {
			return cty.NilVal, err
		}
		if count < 0 {
			return cty.NilVal, fmt.Errorf("Invalid count given to range(). Must be positive.")
		}
		if count > 1000 {
			return cty.NilVal, fmt.Errorf("Invalid count given to range(). Maximum is 1000.")
		}
		if start+count > 2147483647 {
			return cty.NilVal, fmt.Errorf("Invalid arguments given to range(). Sum of start and count must be no greater than 2147483647.")
		}
		output := make([]cty.Value, count)
		for idx, _ := range output {
			output[idx] = cty.NumberIntVal(start + int64(idx))
		}
		return cty.TupleVal(output), nil
	},
	NewArgument(true, false, Type(cty.Number)),
	NewArgument(true, false, Type(cty.Number)),
)
var SkipArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		arr := args[0].AsValueSlice()
		var skip int
		if err := gocty.FromCtyValue(args[1], &skip); err != nil {
			return cty.NilVal, err
		}
		if skip < 1 {
			return cty.TupleVal(arr), nil
		}
		if skip > len(arr) {
			return cty.EmptyTupleVal, nil
		}
		return cty.TupleVal(arr[skip:]), nil
	},
	NewArgument(true, false, AnyArray),
	NewArgument(true, false, Type(cty.Number)),
)
var TakeArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		arr := args[0].AsValueSlice()
		var take int
		if err := gocty.FromCtyValue(args[1], &take); err != nil {
			return cty.NilVal, err
		}
		if take < 1 {
			return cty.EmptyTupleVal, nil
		}
		if take > len(arr) {
			return cty.TupleVal(arr), nil
		}
		return cty.TupleVal(arr[:take]), nil
	},
	NewArgument(true, false, AnyArray),
	NewArgument(true, false, Type(cty.Number)),
)
var UnionArray = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		currSet := args[0].AsValueSet()
		if len(args) > 1 {
			for _, a := range args[1:] {
				currSet = a.AsValueSet().Union(currSet)
			}
		}
		return cty.TupleVal(currSet.Values()), nil
	},
	NewArgument(true, false, AnyArray),
	NewArgument(true, false, AnyArray),
	NewArgument(false, true, AnyArray),
)
