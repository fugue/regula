package arm

import (
	"fmt"
	"strings"

	"github.com/zclconf/go-cty/cty"
)

type Parameter struct {
	Name         string
	Type         cty.Type
	DefaultValue cty.Value
	// AllowedValues []cty.Value
	// MinLength     int
	// MaxLength     int
	// MinValue      int
	// MaxValue      int
}

// func ParseParemeter(name string, raw map[string]interface{}) (*Parameter, error) {
// 	t, ok := raw["type"]
// 	if !ok {
// 		return nil, fmt.Errorf("Invalid parameter '%s': missing type property")
// 	}
// 	pType, ok := t.(string)
// 	if !ok {
// 		return nil, fmt.Errorf("Invalid parameter '%s': invalid type property")
// 	}
// 	d, hasDefault := raw["defaultValue"]
// 	switch pType {
// 	case "array":

// 	case "bool":
// 	case "int":
// 	case "object", "secureObject":
// 	case "string", "secureString":
// 	}

// 	}
// }

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
	f, ok := c.builtins[strings.ToLower(call.Name)]
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
			"add":             NewBuiltIn("add", Add),
			"array":           NewBuiltIn("array", Array),
			"base64":          NewBuiltIn("base64", Base64),
			"base64tojson":    NewBuiltIn("base64ToJson", Base64ToJson),
			"base64tostring":  NewBuiltIn("base64ToString", Base64ToString),
			"coalesce":        NewBuiltIn("coalesce", Coalesce),
			"concat":          NewBuiltIn("concat", ConcatArray, ConcatString),
			"contains":        NewBuiltIn("contains", ContainsArray, ContainsObject, ContainsString),
			"createarray":     NewBuiltIn("createArray", CreateArray),
			"createobject":    NewBuiltIn("createObject", CreateObject),
			"datetimeadd":     NewBuiltIn("dateTimeAdd", DateAdd),
			"div":             NewBuiltIn("div", Div),
			"empty":           NewBuiltIn("empty", Empty),
			"endswith":        NewBuiltIn("endsWith", EndsWith),
			"equals":          NewBuiltIn("equals", Equals),
			"first":           NewBuiltIn("first", FirstArray, FirstString),
			"float":           NewBuiltIn("float", FloatFromInt, FloatFromString),
			"format":          NewBuiltIn("format", Format),
			"greater":         NewBuiltIn("greater", Greater),
			"greaterorequals": NewBuiltIn("greaterOrEquals", GreaterOrEquals),
			"int":             NewBuiltIn("int", IntFromInt, IntFromString),
			"intersection":    NewBuiltIn("intersection", IntersectionArray, IntersectionObject),
			"json":            NewBuiltIn("json", JSON),
			"last":            NewBuiltIn("last", LastArray),
			"length":          NewBuiltIn("length", Length),
			"less":            NewBuiltIn("less", Less),
			"lessorequals":    NewBuiltIn("lessOrEquals", LessOrEquals),
			"max":             NewBuiltIn("max", MaxArray, MaxNumeric),
			"min":             NewBuiltIn("min", MinArray, MinNumeric),
			"mod":             NewBuiltIn("mod", Mod),
			"mul":             NewBuiltIn("mul", Mul),
			"null":            NewBuiltIn("null", Null),
			"range":           NewBuiltIn("range", Range),
			"skip":            NewBuiltIn("skip", SkipArray),
			"sub":             NewBuiltIn("sub", Sub),
			"take":            NewBuiltIn("take", TakeArray),
			"union":           NewBuiltIn("union", UnionArray, UnionObject),
			"utcnow":          NewBuiltIn("utcNow", UTCNow),
		},
	}
}
