package regulatf

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/zclconf/go-cty/cty"
)

func TestValTree(t *testing.T) {
	vt := SingletonValTree(LocalName{"menu", 1, "name"}, cty.StringVal("pizza"))
	vt = MergeValTree(vt, SingletonValTree(LocalName{"menu", 1, "price"}, cty.NumberIntVal(10)))
	assert.Equal(t,
		cty.ObjectVal(map[string]cty.Value{
			"menu": cty.TupleVal([]cty.Value{
				cty.NilVal,
				cty.ObjectVal(map[string]cty.Value{
					"name":  cty.StringVal("pizza"),
					"price": cty.NumberIntVal(10),
				}),
			}),
		}),
		ValTreeToValue(vt),
	)

	vt = MergeValTree(vt, SingletonValTree(LocalName{"menu", 0, "name"}, cty.StringVal("cake")))
	assert.Equal(t,
		cty.ObjectVal(map[string]cty.Value{
			"menu": cty.TupleVal([]cty.Value{
				cty.ObjectVal(map[string]cty.Value{
					"name": cty.StringVal("cake"),
				}),
				cty.ObjectVal(map[string]cty.Value{
					"name":  cty.StringVal("pizza"),
					"price": cty.NumberIntVal(10),
				}),
			}),
		}),
		ValTreeToValue(vt),
	)

	assert.Equal(t,
		cty.ObjectVal(map[string]cty.Value{
			"menu": cty.TupleVal([]cty.Value{
				cty.NilVal,
				cty.ObjectVal(map[string]cty.Value{
					"price": cty.NumberIntVal(10),
				}),
			}),
		}),
		ValTreeToValue(SparseValTree(vt, LocalName{"menu", 1, "price"})),
	)
}
