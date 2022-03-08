// Utilities for working with expressions.
package regulatf

import (
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
)

// ExprAttributes tries to gather all attributes that are being used in a given
// expression.  For example, for:
//
//     aws_s3_bucket.bucket[count.index].acl
//
// It would return [acl].
func ExprAttributes(expr hcl.Expression) []LocalName {
	names := []LocalName{}
	if syn, ok := expr.(hclsyntax.Expression); ok {
		hclsyntax.VisitAll(syn, func(node hclsyntax.Node) hcl.Diagnostics {
			switch e := node.(type) {
			case *hclsyntax.RelativeTraversalExpr:
				if name, err := TraversalToLocalName(e.Traversal); err == nil {
					names = append(names, name)
				}
			case *hclsyntax.IndexExpr:
				if key := ExprToLiteralString(e.Key); key != nil {
					name := LocalName{*key}
					names = append(names, name)
				}
			}
			return nil
		})
	}
	return names
}

func ExprToLiteralString(expr hcl.Expression) *string {
	if e, ok := expr.(*hclsyntax.LiteralValueExpr); ok {
		return ValueToString(e.Val)
	}
	return nil
}
