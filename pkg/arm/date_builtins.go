package arm

import (
	"time"

	"github.com/zclconf/go-cty/cty"
)

// These are fake for now. We'll add implementations if they're needed for
// some rules.
var DateAdd = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		return args[0], nil
	},
	NewArgument(true, false, Type(cty.String)),
	NewArgument(false, true, Type(cty.String)),
)
var UTCNow = NewImplementation(
	func(args []cty.Value) (cty.Value, error) {
		t := time.Now().UTC().Format(time.RFC3339)
		return cty.StringVal(t), nil
	},
	NewArgument(false, false, Type(cty.String)),
)
