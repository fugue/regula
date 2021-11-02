// cty.Value utilities
package regulatf

import (
	"github.com/sirupsen/logrus"
	"github.com/zclconf/go-cty/cty"
)

func ValueToInt(val cty.Value) *int {
	if val.Type() == cty.Number {
		b := val.AsBigFloat()
		if b.IsInt() {
			i64, _ := b.Int64()
			i := int(i64)
			return &i
		}
	}
	return nil
}

func ValueToInterface(val cty.Value) interface{} {
	if !val.IsKnown() || val.IsNull() {
		return nil
	}

	if val.Type() == cty.Bool {
		return val.True()
	} else if val.Type() == cty.Number {
		b := val.AsBigFloat()
		if b.IsInt() {
			i, _ := b.Int64()
			return i
		} else {
			f, _ := b.Float64()
			return f
		}
	} else if val.Type() == cty.String {
		return val.AsString()
	} else if val.Type().IsTupleType() || val.Type().IsSetType() || val.Type().IsListType() {
		array := make([]interface{}, 0)
		for _, elem := range val.AsValueSlice() {
			array = append(array, ValueToInterface(elem))
		}
		return array
	} else if val.Type().IsMapType() || val.Type().IsObjectType() {
		object := make(map[string]interface{}, 0)
		for key, attr := range val.AsValueMap() {
			object[key] = ValueToInterface(attr)
		}
		return object
	}

	logrus.Warnf("Unhandled value type: %v\n", val.Type().GoString())
	return nil
}
