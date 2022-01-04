package arm

import (
	"encoding/base64"
	"fmt"
	"strconv"
	"strings"

	"github.com/alecthomas/participle/v2"
	"github.com/zclconf/go-cty/cty"
	"github.com/zclconf/go-cty/cty/gocty"
	ctyjson "github.com/zclconf/go-cty/cty/json"
)

var Base64 = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		data := []byte(args[0].AsString())
		encoded := base64.StdEncoding.EncodeToString(data)
		return cty.StringVal(encoded), nil
	},
	NewArgument(true, false, Type(cty.String)),
)
var Base64ToJson = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		decoded, err := base64.StdEncoding.DecodeString(args[0].AsString())
		if err != nil {
			return cty.NilVal, err
		}
		t, err := ctyjson.ImpliedType(decoded)
		if err != nil {
			return cty.NilVal, err
		}
		return ctyjson.Unmarshal(decoded, t)
	},
	NewArgument(true, false, Type(cty.String)),
)
var Base64ToString = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		decoded, err := base64.StdEncoding.DecodeString(args[0].AsString())
		if err != nil {
			return cty.NilVal, err
		}
		return cty.StringVal(string(decoded)), nil
	},
	NewArgument(true, false, Type(cty.String)),
)
var ConcatString = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		s := make([]string, len(args))
		for idx, v := range args {
			s[idx] = v.AsString()
		}
		return cty.StringVal(strings.Join(s, "")), nil
	},
	NewArgument(true, false, Type(cty.String)),
	NewArgument(false, true, Type(cty.String)),
)
var ContainsString = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		if strings.Contains(args[0].AsString(), args[1].AsString()) {
			return cty.True, nil
		}
		return cty.False, nil
	},
	NewArgument(true, false, Type(cty.String)),
	NewArgument(true, false, Type(cty.String)),
)

// var DataURI
// var DataURIToString
var EndsWith = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		s := args[0].AsString()
		suffix := args[1].AsString()
		return cty.BoolVal(strings.HasSuffix(s, suffix)), nil
	},
	NewArgument(true, false, Type(cty.String)),
	NewArgument(true, false, Type(cty.String)),
)
var FirstString = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		runes := []rune(args[0].AsString())
		if len(runes) < 1 {
			return cty.StringVal(""), nil
		}
		return cty.StringVal(string(runes[0:1])), nil
	},
	NewArgument(true, false, Type(cty.String)),
)
var Format = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		parser, err := participle.Build(&FormatString{})
		if err != nil {
			return cty.NilVal, err
		}
		formatString := &FormatString{}
		if err := parser.ParseString("", args[0].AsString(), formatString); err != nil {
			return cty.NilVal, err
		}
		formatArgs := args[1:]
		// formatArgIdx := 0
		fragments := make([]string, len(formatString.Tokens))
		for idx, t := range formatString.Tokens {
			if t.Fragment != nil {
				fragments[idx] = *t.Fragment
			} else if t.FormatItem != nil {
				if t.FormatItem.Index == nil {
					return cty.NilVal, fmt.Errorf("Malformed format string")
				}
				formatArgIdx := *t.FormatItem.Index
				if formatArgIdx >= len(formatArgs) {
					return cty.NilVal, fmt.Errorf("Missing arguments for format string")
				}
				s, err := stringifyPrimitive(formatArgs[formatArgIdx])
				if err != nil {
					return cty.NilVal, err
				}
				fragments[idx] = s
			}
		}
		return cty.StringVal(strings.Join(fragments, "")), nil
	},
	NewArgument(true, false, Type(cty.String)),
	NewArgument(true, false, Type(cty.String), Type(cty.Number), Type(cty.Bool)),
	NewArgument(false, true, Type(cty.String), Type(cty.Number), Type(cty.Bool)),
)

type FormatString struct {
	Tokens []*FormatToken `@@*`
}

type FormatToken struct {
	FormatItem *FormatItem `"{" @@ "}"`
	Fragment   *string     `| @(String|Ident|Int)+`
}

type FormatItem struct {
	Index     *int    `@Int`
	Alignment *int    `(","@Int)?`
	Format    *string `(":"@(Ident|Int)+)?`
}

func stringifyPrimitive(v cty.Value) (string, error) {
	switch v.Type() {
	case cty.Bool:
		return strconv.FormatBool(v.True()), nil
	case cty.Number:
		var n int64
		if err := gocty.FromCtyValue(v, &n); err != nil {
			return "", err
		}
		return strconv.FormatInt(n, 10), nil
	case cty.String:
		return v.AsString(), nil
	default:
		return "", fmt.Errorf("Invalid type: %s", v.Type().FriendlyName())
	}
}
