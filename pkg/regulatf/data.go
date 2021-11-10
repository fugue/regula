// Implements the `Data` interface.  Doesn't really do anything.
package regulatf

import (
	"github.com/zclconf/go-cty/cty"

	"github.com/fugue/regula/pkg/terraform/addrs"
	"github.com/fugue/regula/pkg/terraform/tfdiags"
)

type Data struct {
}

type UnsupportedOperationDiag struct {
}

func (d UnsupportedOperationDiag) Severity() tfdiags.Severity {
	return tfdiags.Error
}

func (d UnsupportedOperationDiag) Description() tfdiags.Description {
	return tfdiags.Description{
		Summary: "Unsupported operation",
		Detail:  "This operation cannot currently be performed by regula.",
	}
}

func (d UnsupportedOperationDiag) Source() tfdiags.Source {
	return tfdiags.Source{}
}

func (d UnsupportedOperationDiag) FromExpr() *tfdiags.FromExpr {
	return nil
}

func (c *Data) StaticValidateReferences(refs []*addrs.Reference, self addrs.Referenceable) tfdiags.Diagnostics {
	return tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *Data) GetCountAttr(addrs.CountAttr, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *Data) GetForEachAttr(addrs.ForEachAttr, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *Data) GetResource(addrs.Resource, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *Data) GetLocalValue(addrs.LocalValue, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *Data) GetModule(addrs.ModuleCall, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *Data) GetPathAttr(attr addrs.PathAttr, diags tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *Data) GetTerraformAttr(addrs.TerraformAttr, tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}

func (c *Data) GetInputVariable(v addrs.InputVariable, s tfdiags.SourceRange) (cty.Value, tfdiags.Diagnostics) {
	return cty.UnknownVal(cty.DynamicPseudoType), tfdiags.Diagnostics{UnsupportedOperationDiag{}}
}
