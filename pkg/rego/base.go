package rego

import (
	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
)

type RegoFile interface {
	Raw() []byte
	String() string
	AstModule() (*ast.Module, error)
	RegoModule() func(r *rego.Rego)
	Path() string
}
