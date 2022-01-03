package arm

import (
	"fmt"

	"github.com/zclconf/go-cty/cty"
)

type EvalContext struct {
	parameters map[string]cty.Value
	variables  map[string]cty.Value
	builtins   map[string]Function
}

func (c *EvalContext) evalValue(v ArmValue) (cty.Value, error) {
	if v.Integer != nil {
		return cty.NumberFloatVal(*v.Integer), nil
	}
	if v.Variable != nil {
		return cty.StringVal(*v.Variable), nil
	}
	if v.String != nil {
		return cty.StringVal(*v.String), nil
	}
	return cty.NullVal(cty.DynamicPseudoType), nil
}

func (c *EvalContext) evalCall(call ArmCall) (cty.Value, error) {
	args := make([]cty.Value, len(call.Args))
	for idx, x := range call.Args {
		evaluated, err := c.evalExpression(*x)
		if err != nil {
			return cty.NilVal, err
		}
		args[idx] = evaluated
	}
	f, ok := c.builtins[call.Name]
	if !ok {
		return cty.NilVal, fmt.Errorf("Unknown function %s", call.Name)
	}
	return f.Apply(args)
}

func (c *EvalContext) evalExpression(x ArmExpression) (cty.Value, error) {
	if x.Call != nil {
		return c.evalCall(*x.Call)
	}
	if x.Value != nil {
		return c.evalValue(*x.Value)
	}
	if x.Subexpression != nil {
		return c.evalExpression(*x.Subexpression)
	}
	return cty.NilVal, nil
}

func (c *EvalContext) Eval(p ArmProgram) (cty.Value, error) {
	return c.evalExpression(*p.Expression)
}

func NewEvalContext() *EvalContext {
	return &EvalContext{
		builtins: map[string]Function{
			"array": NewBuiltIn(
				"array",
				NewImplementation(
					Array,
					NewArgument(
						false,
						cty.Number,
						cty.String,
						cty.Tuple([]cty.Type{cty.DynamicPseudoType}),
						cty.Map(cty.DynamicPseudoType),
					),
				),
			),
			"concat": NewBuiltIn(
				"concat",
				NewImplementation(
					ConcatArray,
					NewArgument(
						true,
						cty.Tuple([]cty.Type{cty.DynamicPseudoType}),
					),
				),
				NewImplementation(
					ConcatString,
					NewArgument(
						true,
						cty.String,
					),
				),
			),
		},
	}
}
