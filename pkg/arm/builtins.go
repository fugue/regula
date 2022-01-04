package arm

import (
	"fmt"
	"strings"

	// "github.com/araddon/dateparse"
	"github.com/zclconf/go-cty/cty"
)

type Apply func(args []cty.Value) (cty.Value, error)

type Function interface {
	// CanApply(args []cty.Value) bool
	Apply(args []cty.Value) (cty.Value, error)
}

type Argument struct {
	Required bool
	Variadic bool
	Types    []ArgTest
}

func (a *Argument) Matches(v cty.Value) bool {
	for _, t := range a.Types {
		if t(v) {
			return true
		}
	}
	return false
}

func NewArgument(required bool, variadic bool, types ...ArgTest) *Argument {
	return &Argument{
		Required: required,
		Variadic: variadic,
		Types:    types,
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
	var argSpec *Argument
	argIdx := 0
	for _, argSpec = range i.Arguments {
		if argIdx >= len(args) {
			if argSpec.Required {
				return false
			}
			break
		}
		if !argSpec.Matches(args[argIdx]) {
			return false
		}
		argIdx++
	}
	for argIdx < len(args) {
		if !argSpec.Variadic {
			return false
		}
		if !argSpec.Matches(args[argIdx]) {
			return false
		}
		argIdx++
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
	name            string
	implementations []*Implementation
}

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

type ArgTest func(a cty.Value) bool

// Argument tests
func Type(t cty.Type) ArgTest {
	return func(a cty.Value) bool {
		return t.Equals(a.Type())
	}
}

func ArrayOf(t cty.Type) ArgTest {
	return func(a cty.Value) bool {
		if !a.Type().IsTupleType() {
			return false
		}
		for _, v := range a.AsValueSlice() {
			if !t.Equals(v.Type()) {
				return false
			}
		}
		return true
	}
}

func AnyArray(a cty.Value) bool {
	return a.Type().IsTupleType()
}

func AnyObject(a cty.Value) bool {
	return a.Type().IsObjectType()
}
