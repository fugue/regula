package rego

import (
	"embed"
)

//go:embed lib
var RegulaLib embed.FS

//go:embed rules
var RegulaRules embed.FS
