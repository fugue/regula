package arm

import (
	"fmt"
	"strings"
	"time"

	// "github.com/araddon/dateparse"
	"github.com/zclconf/go-cty/cty"
	"github.com/zclconf/go-cty/cty/gocty"
)

type Apply func(args []cty.Value) (cty.Value, error)

type Function interface {
	// CanApply(args []cty.Value) bool
	Apply(args []cty.Value) (cty.Value, error)
}

type Argument struct {
	Types    []cty.Type
	Variadic bool
}

func (a *Argument) Matches(v cty.Value) bool {
	vType := v.Type()
	for _, t := range a.Types {
		if t.Equals(vType) {
			return true
		}
	}
	return false
}

func NewArgument(variadic bool, types ...cty.Type) *Argument {
	return &Argument{
		Types:    types,
		Variadic: variadic,
	}
}

type Implementation struct {
	Arguments []*Argument
	Apply     Apply
}

func (i *Implementation) Matches(args []cty.Value) bool {
	// Arity 0
	if len(i.Arguments) == 0 {
		return len(args) == 0
	}
	// Too few args
	if len(args) < len(i.Arguments) {
		return false
	}
	var argSpec *Argument
	for idx, a := range args {
		if argSpec == nil || !argSpec.Variadic {
			if idx > len(i.Arguments)-1 {
				return false
			}
			argSpec = i.Arguments[idx]
		}
		if !argSpec.Matches(a) {
			return false
		}
	}
	return true
}

func NewImplementation(apply Apply, arguments ...*Argument) *Implementation {
	return &Implementation{
		Arguments: arguments,
		Apply:     apply,
	}
}

type BuiltIn struct {
	name string
	// arity           int
	// argTypes        []cty.Type
	implementations []*Implementation
	// lastArgTypeIdx  int
}

// func (b *BuiltIn) CanApply(args []cty.Value) bool {
// 	if b.arity >= 0 {
// 		if len(args) != b.arity {
// 			return false
// 			// return false, fmt.Errorf(
// 			// 	"%s takes %d arguments. Received %d.",
// 			// 	b.name,
// 			// 	b.arity,
// 			// 	len(args),
// 			// )
// 		}
// 	} else if b.arity < 0 {
// 		return false
// 		// return false, fmt.Errorf(
// 		// 	"%s takes at least 1 argument. Received 0 arguments.",
// 		// 	b.name,
// 		// )
// 	}

// 	for idx, a := range args {
// 		argTypeIdx := idx
// 		if argTypeIdx > b.lastArgTypeIdx {
// 			argTypeIdx = b.lastArgTypeIdx
// 		}
// 		expectedType := b.argTypes[argTypeIdx]
// 		argType := a.Type()
// 		if !expectedType.Equals(argType) {
// 			return false
// 			// return false, fmt.Errorf(
// 			// 	"%s got bad argument in position %d. Expected %s, got %s",
// 			// 	b.name,
// 			// 	idx,
// 			// 	expectedType.FriendlyName(),
// 			// 	argType.FriendlyName(),
// 			// )
// 		}
// 	}

// 	return true
// }

func (b *BuiltIn) Apply(args []cty.Value) (cty.Value, error) {
	for _, i := range b.implementations {
		if i.Matches(args) {
			return i.Apply(args)
		}
	}
	typeNames := make([]string, len(args))
	for idx, a := range args {
		typeNames[idx] = a.Type().FriendlyName()
	}
	argTypesString := strings.Join(typeNames, ", ")
	return cty.NilVal, fmt.Errorf(
		"Could not find a matching implementation for %s(%s)",
		b.name,
		argTypesString,
	)
}

func NewBuiltIn(name string, implementations ...*Implementation) Function {
	return &BuiltIn{
		name: name,
		// arity:          arity,
		// argTypes:       argTypes,
		implementations: implementations,
	}
}

var ArrayType = cty.Tuple([]cty.Type{cty.DynamicPseudoType})
var ObjectType = cty.Map(cty.DynamicPseudoType)

var Array = NewBuiltIn("array",
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			return cty.TupleVal([]cty.Value{args[0]}), nil
		},
		NewArgument(false, cty.Number, cty.String, ArrayType, ObjectType),
	),
)
var Concat = NewBuiltIn("concat",
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			combined := []cty.Value{}
			for _, a := range args {
				combined = append(combined, a.AsValueSlice()...)
			}
			return cty.TupleVal(combined), nil
		},
		NewArgument(true, ArrayType),
	),
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			s := make([]string, len(args))
			for idx, v := range args {
				s[idx] = v.AsString()
			}
			return cty.StringVal(strings.Join(s, "")), nil
		},
		NewArgument(true, cty.String),
	),
)
var Contains = NewBuiltIn("contains",
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			for _, v := range args[0].AsValueSlice() {
				if v.Equals(args[1]) == cty.True {
					return cty.True, nil
				}
			}
			return cty.False, nil
		},
		NewArgument(false, ArrayType),
		NewArgument(false, cty.String, cty.Number),
	),
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			if strings.Contains(args[0].AsString(), args[1].AsString()) {
				return cty.True, nil
			}
			return cty.False, nil
		},
		NewArgument(false, cty.String),
		NewArgument(false, cty.String),
	),
	NewImplementation(
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
		NewArgument(false, ObjectType),
		NewArgument(false, cty.String),
	),
)
var CreateArray = NewBuiltIn("createArray",
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			if len(args) < 1 {
				return cty.EmptyTupleVal, nil
			}

			return cty.TupleVal(args), nil
		},
		NewArgument(true, cty.String, cty.Number, ArrayType, ObjectType),
	),
)
var Empty = NewBuiltIn("empty",
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			if len(args[0].AsValueSlice()) == 0 {
				return cty.True, nil
			}
			return cty.False, nil
		},
		NewArgument(false, ArrayType),
	),
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			if len(args[0].AsValueMap()) == 0 {
				return cty.True, nil
			}
			return cty.False, nil
		},
		NewArgument(false, ObjectType),
	),
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			if len(args[0].AsString()) == 0 {
				return cty.True, nil
			}
			return cty.False, nil
		},
		NewArgument(false, cty.String),
	),
)
var First = NewBuiltIn("first",
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			asSlice := args[0].AsValueSlice()
			if len(asSlice) < 1 {
				return cty.NullVal(cty.DynamicPseudoType), nil
			}
			return asSlice[0], nil
		},
		NewArgument(false, ArrayType),
	),
	NewImplementation(
		func(args []cty.Value) (cty.Value, error) {
			runes := []rune(args[0].AsString())
			if len(runes) < 1 {
				return cty.StringVal(""), nil
			}
			return cty.StringVal(string(runes[0:1])), nil
		},
		NewArgument(false, cty.String),
	),
)

// Array functions
// func Array(args []cty.Value) (cty.Value, error) {
// 	return cty.TupleVal([]cty.Value{args[0]}), nil
// }

// func ConcatArray(args []cty.Value) (cty.Value, error) {
// 	combined := []cty.Value{}
// 	for _, a := range args {
// 		combined = append(combined, a.AsValueSlice()...)
// 	}
// 	return cty.TupleVal(combined), nil
// }

// func ContainsArray(args []cty.Value) (cty.Value, error) {
// 	for _, v := range args[0].AsValueSlice() {
// 		if v.Equals(args[1]) == cty.True {
// 			return cty.True, nil
// 		}
// 	}
// 	return cty.False, nil
// }

// func CreateArray(args []cty.Value) (cty.Value, error) {
// 	if len(args) < 1 {
// 		return cty.EmptyTupleVal, nil
// 	}

// 	return cty.TupleVal(args), nil
// }

// func EmptyArray(args []cty.Value) (cty.Value, error) {
// 	if len(args[0].AsValueSlice()) == 0 {
// 		return cty.True, nil
// 	}
// 	return cty.False, nil
// }

// func FirstArray(args []cty.Value) (cty.Value, error) {
// 	asSlice := args[0].AsValueSlice()
// 	if len(asSlice) < 1 {
// 		return cty.NullVal(cty.DynamicPseudoType), nil
// 	}
// 	return asSlice[0], nil
// }

func IntersectionArray(args []cty.Value) (cty.Value, error) {
	currSet := args[0].AsValueSet()
	if len(args) > 1 {
		for _, a := range args[1:] {
			currSet = a.AsValueSet().Intersection(currSet)
		}
	}
	return cty.TupleVal(currSet.Values()), nil
}

func LastArray(args []cty.Value) (cty.Value, error) {
	asSlice := args[0].AsValueSlice()
	if len(asSlice) < 1 {
		return cty.NullVal(cty.DynamicPseudoType), nil
	}
	return asSlice[len(asSlice)-1], nil
}

func Length(args []cty.Value) (cty.Value, error) {
	return args[0].Length(), nil
}

// func LengthArray(args []cty.Value) (cty.Value, error) {
// 	l := len(args[0].AsValueSlice())
// 	return cty.NumberIntVal(int64(l)), nil
// }

func MaxArray(args []cty.Value) (cty.Value, error) {
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
}

func MinArray(args []cty.Value) (cty.Value, error) {
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
}

func Range(args []cty.Value) (cty.Value, error) {
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
}

func SkipArray(args []cty.Value) (cty.Value, error) {
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
}

func TakeArray(args []cty.Value) (cty.Value, error) {
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
}

func UnionArray(args []cty.Value) (cty.Value, error) {
	currSet := args[0].AsValueSet()
	if len(args) > 1 {
		for _, a := range args[1:] {
			currSet = a.AsValueSet().Union(currSet)
		}
	}
	return cty.TupleVal(currSet.Values()), nil
}

// Comparison functions
func Coalesce(args []cty.Value) (cty.Value, error) {
	for _, a := range args {
		if !a.IsNull() {
			return a, nil
		}
	}
	return cty.NullVal(cty.DynamicPseudoType), nil
}

func Equals(args []cty.Value) (cty.Value, error) {
	return args[0].Equals(args[1]), nil
}

func Greater(args []cty.Value) (cty.Value, error) {
	return args[0].GreaterThan(args[1]), nil
}

func GreaterOrEquals(args []cty.Value) (cty.Value, error) {
	return args[0].GreaterThanOrEqualTo(args[1]), nil
}

func Less(args []cty.Value) (cty.Value, error) {
	return args[0].LessThan(args[1]), nil
}

func LessOrEquals(args []cty.Value) (cty.Value, error) {
	return args[0].LessThanOrEqualTo(args[1]), nil
}

// Date functions
// These are fake for now. We'll add implementations if they're needed for
// some rules.

func DateAdd(args []cty.Value) (cty.Value, error) {
	return args[0], nil
}

func UTCNow(args []cty.Value) (cty.Value, error) {
	t := time.Now().UTC().Format(time.RFC3339)
	return cty.StringVal(t), nil
}

// String functions
// func ConcatString(args []cty.Value) (cty.Value, error) {
// 	s := make([]string, len(args))
// 	for idx, v := range args {
// 		s[idx] = v.AsString()
// 	}
// 	return cty.StringVal(strings.Join(s, "")), nil
// }

// func ContainsString(args []cty.Value) (cty.Value, error) {
// 	if strings.Contains(args[0].AsString(), args[1].AsString()) {
// 		return cty.True, nil
// 	}
// 	return cty.False, nil
// }

// func EmptyString(args []cty.Value) (cty.Value, error) {
// 	if len(args[0].AsValueMap()) == 0 {
// 		return cty.True, nil
// 	}
// 	return cty.False, nil
// }

// func FirstString(args []cty.Value) (cty.Value, error) {
// 	runes := []rune(args[0].AsString())
// 	if len(runes) < 1 {
// 		return cty.StringVal(""), nil
// 	}
// 	return cty.StringVal(string(runes[0:1])), nil
// }

func LastString(args []cty.Value) (cty.Value, error) {
	runes := []rune(args[0].AsString())
	if len(runes) < 1 {
		return cty.StringVal(""), nil
	}
	return cty.StringVal(string(runes[len(runes)-1])), nil
}

func SkipString(args []cty.Value) (cty.Value, error) {
	r := []rune(args[0].AsString())
	var skip int
	if err := gocty.FromCtyValue(args[1], &skip); err != nil {
		return cty.NilVal, err
	}
	if skip < 1 {
		return cty.StringVal(string(r)), nil
	}
	if skip > len(r) {
		return cty.EmptyTupleVal, nil
	}
	return cty.StringVal(string(r[skip:])), nil
}

func TakeString(args []cty.Value) (cty.Value, error) {
	r := []rune(args[0].AsString())
	var take int
	if err := gocty.FromCtyValue(args[1], &take); err != nil {
		return cty.NilVal, err
	}
	if take < 1 {
		return cty.EmptyTupleVal, nil

	}
	if take > len(r) {
		return cty.StringVal(string(r)), nil
	}
	return cty.StringVal(string(r[:take])), nil
}

// Object functions
// func ContainsObject(args []cty.Value) (cty.Value, error) {
// 	f := strings.ToLower(args[1].AsString())
// 	containerMap := args[0].AsValueMap()
// 	for k, _ := range containerMap {
// 		if f == strings.ToLower(k) {
// 			return cty.True, nil
// 		}
// 	}
// 	return cty.False, nil
// }

// func EmptyObject(args []cty.Value) (cty.Value, error) {
// 	if len(args[0].AsValueMap()) == 0 {
// 		return cty.True, nil
// 	}
// 	return cty.False, nil
// }

func IntersectionObject(args []cty.Value) (cty.Value, error) {
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
}

func UnionObject(args []cty.Value) (cty.Value, error) {
	union := args[0].AsValueMap()
	if len(args) > 1 {
		for _, a := range args[1:] {
			for k, aVal := range a.AsValueMap() {
				union[k] = aVal
			}
		}
	}
	return cty.MapVal(union), nil
}

// Numeric functions

func MaxNumeric(args []cty.Value) (cty.Value, error) {
	max := args[0]
	for _, next := range args[1:] {
		if next.GreaterThan(max) == cty.True {
			max = next
		}
	}
	return max, nil
}

func MinNumeric(args []cty.Value) (cty.Value, error) {
	min := args[0]
	for _, next := range args[1:] {
		if next.LessThan(min) == cty.True {
			min = next
		}
	}
	return min, nil
}

// func LengthObject(args []cty.Value) (cty.Value, error) {
// 	l := len(args[0].AsValueMap())
// 	return cty.NumberIntVal(int64(l)), nil
// }

// func Concat(args []cty.Value) (cty.Value, error) {
// 	if allOfType(args, cty.String) {
// 		s := make([]string, len(args))
// 		for idx, v := range args {
// 			if !v.Type().Equals(cty.String) {
// 				return cty.NilVal, fmt.Errorf("Non-string argument given to concat in position %d", idx)
// 			}
// 			s[idx] = v.AsString()
// 		}
// 		return cty.StringVal(strings.Join(s, "")), nil
// 	}

// 	if allAreTuples(args) {
// 		combined := []cty.Value{}
// 		for _, a := range args {
// 			combined = append(combined, a.AsValueSlice()...)
// 		}
// 		return cty.TupleVal(combined), nil
// 	}

// 	types := make([]string, len(args))
// 	for idx, a := range args {
// 		types[idx] = a.Type().FriendlyName()
// 	}
// 	return cty.NilVal, fmt.Errorf("Unsupported types in concat(): %v", types)
// }

// func Contains(args []cty.Value) (cty.Value, error) {
// 	if len(args) != 2 {
// 		return cty.NilVal, fmt.Errorf("contains() takes 2 arguments. Received %v", len(args))
// 	}

// 	container := args[0]
// 	itemToFind := args[1]
// 	containerType := container.Type()
// 	findType := itemToFind.Type()

// 	if containerType.IsTupleType() {
// 		if !findType.Equals(cty.String) || !findType.Equals(cty.Number) {
// 			return cty.NilVal, fmt.Errorf("Unsupported types given to contains(): %v and %v", containerType.FriendlyName(), findType.FriendlyName())
// 		}
// 		for _, v := range container.AsValueSlice() {
// 			if v.Equals(itemToFind) == cty.True {
// 				return cty.True, nil
// 			}
// 		}
// 		return cty.False, nil
// 	}

// 	if containerType.IsMapType() {
// 		if !findType.Equals(cty.String) {
// 			return cty.NilVal, fmt.Errorf("Unsupported types given to contains(): %v and %v", containerType.FriendlyName(), findType.FriendlyName())
// 		}
// 		f := strings.ToLower(itemToFind.AsString())
// 		containerMap := container.AsValueMap()
// 		for k, _ := range containerMap {
// 			if f == strings.ToLower(k) {
// 				return cty.True, nil
// 			}
// 		}
// 		return cty.False, nil
// 	}

// 	if containerType.Equals(cty.String) {
// 		if !findType.Equals(cty.String) {
// 			return cty.NilVal, fmt.Errorf("Unsupported types given to contains(): %v and %v", containerType.FriendlyName(), findType.FriendlyName())
// 		}
// 		f := strings.ToLower(itemToFind.AsString())
// 		c := container.AsString()
// 		if strings.Contains(c, f) {
// 			return cty.True, nil
// 		}
// 	}

// 	return cty.NilVal, fmt.Errorf("Unsupported types given to contains(): %v and %v", containerType.FriendlyName(), findType.FriendlyName())
// }

// func CreateArray(args []cty.Value) (cty.Value, error) {
// 	if len(args) < 1 {
// 		return cty.EmptyTupleVal, nil
// 	}

// 	return cty.TupleVal(args), nil
// }

// func Empty(args []cty.Value) (cty.Value, error) {
// 	if len(args) != 1 {
// 		return cty.NilVal, fmt.Errorf("empty() expects one argument, got %v", len(args))
// 	}
// 	item := args[0]
// 	itemType := item.Type()

// 	if itemType.IsTupleType() {
// 		if len(item.AsValueSlice()) == 0 {
// 			return cty.True, nil
// 		}
// 		return cty.False, nil
// 	}

// 	if itemType.IsMapType() {
// 		if len(item.AsValueMap()) == 0 {
// 			return cty.True, nil
// 		}
// 		return cty.False, nil
// 	}

// 	if itemType.Equals(cty.String) {
// 		if len(item.AsString()) == 0 {
// 			return cty.True, nil
// 		}
// 		return cty.False, nil
// 	}

// 	return cty.NilVal, fmt.Errorf("Unsupported type given to empty(): %v", itemType.FriendlyName())
// }

// Helpers
// func all(args []cty.Value, condition func(a cty.Value) bool) bool {
// 	for _, a := range args {
// 		if !condition(a) {
// 			return false
// 		}
// 	}
// 	return true
// }

// func allOfType(args []cty.Value, t cty.Type) bool {
// 	return all(args, func(a cty.Value) bool {
// 		return t.Equals(a.Type())
// 	})
// }

// func allAreCollections(args []cty.Value) bool {
// 	return all(args, func(a cty.Value) bool {
// 		return a.Type().IsCollectionType()
// 	})
// }

// func allAreTuples(args []cty.Value) bool {
// 	return all(args, func(a cty.Value) bool {
// 		return a.Type().IsTupleType()
// 	})
// }
