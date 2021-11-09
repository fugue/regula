package regulatf

import (
	"fmt"
	"regexp"
	"strconv"

	"github.com/hashicorp/hcl/v2"
	"github.com/zclconf/go-cty/cty"
)

type ModuleName = []string

var EmptyModuleName = []string{}

func ModuleNameToString(moduleName ModuleName) string {
	str := ""
	for _, p := range moduleName {
		if str == "" {
			str += "module."
		} else {
			str += ".module."
		}
		str += p
	}
	return str
}

type Fragment = interface{} // Either string or int
type LocalName = []Fragment

func LocalNameToString(name LocalName) string {
	str := ""
	for _, p := range name {
		switch v := p.(type) {
		case string:
			if str != "" {
				str += "."
			}
			str += v
		case int:
			str += fmt.Sprintf("[%d]", v)
		}
	}
	return str
}

type FullName struct {
	Module ModuleName
	Local  LocalName
}

func EmptyFullName(module ModuleName) FullName {
	return FullName{module, nil}
}

func takeModulePrefix(parts []Fragment) (*string, []Fragment) {
	if len(parts) >= 2 {
		if p1, ok := parts[0].(string); ok && p1 == "module" {
			if p2, ok := parts[1].(string); ok {
				return &p2, parts[2:]
			}
		}
	}
	return nil, parts
}

func ArrayToFullName(parts []Fragment) FullName {
	module := ModuleName{}

	m, parts := takeModulePrefix(parts)
	for m != nil {
		module = append(module, *m)
		m, parts = takeModulePrefix(parts)
	}

	return FullName{Module: module, Local: parts}
}

var keyRegex *regexp.Regexp = regexp.MustCompile(`^\.?([^.[]+)`)
var indexRegex *regexp.Regexp = regexp.MustCompile(`^\[([0-9]+)\]`)

func StringToFullName(name string) (*FullName, error) {
	parts := []Fragment{}
	for len(name) > 0 {
		if match := keyRegex.FindStringSubmatch(name); match != nil {
			parts = append(parts, match[1])
			name = name[len(match[0]):]
		} else if match := indexRegex.FindStringSubmatch(name); match != nil {
			if i, err := strconv.Atoi(match[1]); err == nil {
				parts = append(parts, i)
				name = name[len(match[0]):]
			} else {
				return nil, err
			}
		} else {
			return nil, fmt.Errorf("Invalid name: %s", name)
		}
	}

	full := ArrayToFullName(parts)
	return &full, nil
}

func (name FullName) ToString() string {
	if len(name.Module) == 0 {
		return LocalNameToString(name.Local)
	} else {
		return ModuleNameToString(name.Module) + "." + LocalNameToString(name.Local)
	}
}

func (name FullName) add(p Fragment) FullName {
	local := make([]interface{}, len(name.Local)+1)
	copy(local, name.Local)
	local[len(name.Local)] = p
	return FullName{name.Module, local}
}

func (name FullName) AddKey(k string) FullName {
	return name.add(k)
}

func (name FullName) AddIndex(i int) FullName {
	return name.add(i)
}

// Parses the use of an output (e.g. "module.child.x") to the fully expanded
// output name (e.g. module.child.output.x")
func (name FullName) AsModuleOutput() *FullName {
	moduleName, tail := takeModulePrefix(name.Local)
	if moduleName != nil && len(tail) == 1 {
		if str, ok := tail[0].(string); ok {
			expandedModule := make([]string, len(name.Module)+1)
			copy(expandedModule, name.Module)
			expandedModule[len(name.Module)] = *moduleName
			local := []Fragment{"output", str}
			return &FullName{expandedModule, local}
		}
	}
	return nil
}

// Parses "module.child.var.foo" into "input.child.foo"
func (name FullName) AsModuleInput() *FullName {
	if len(name.Module) > 0 && len(name.Local) >= 2 {
		if str, ok := name.Local[0].(string); ok && str == "var" {
			parentModuleName := make(ModuleName, len(name.Module)-1)
			copy(parentModuleName, name.Module)
			local := LocalName{"input", name.Module[len(name.Module)-1]}
			local = append(local, name.Local[1:]...)
			return &FullName{parentModuleName, local}
		}
	}
	return nil
}

// Parses "var.my_var" into "variable.my_var"
func (name FullName) AsDefault() *FullName {
	if len(name.Local) >= 2 {
		if str, ok := name.Local[0].(string); ok && str == "var" {
			local := make(LocalName, len(name.Local))
			copy(local, name.Local)
			local[0] = "variable"
			return &FullName{name.Module, local}
		}
	}
	return nil
}

// Parses "aws_s3_bucket.my_bucket.bucket_prefix" into "aws_s3_bucket.my_bucket"
// and also returns the remainder.
func (name FullName) AsResourceName() (*FullName, LocalName) {
	if len(name.Local) >= 2 {
		if str, ok := name.Local[0].(string); ok {
			cut := 2
			if str == "data" && len(name.Local) >= 3 {
				cut = 3
			}
			return &FullName{name.Module, name.Local[:cut]}, name.Local[cut:]
		}
	}
	return nil, nil
}

// TODO: Refactor to TraversalToName?
func TraversalToLocalName(traversal hcl.Traversal) (LocalName, error) {
	parts := make([]Fragment, 0)

	for _, traverser := range traversal {
		switch t := traverser.(type) {
		case hcl.TraverseRoot:
			parts = append(parts, t.Name)
		case hcl.TraverseAttr:
			parts = append(parts, t.Name)
		case hcl.TraverseIndex:
			val := t.Key
			if val.IsKnown() {
				if val.Type() == cty.Number {
					n := val.AsBigFloat()
					if n.IsInt() {
						i, _ := n.Int64()
						parts = append(parts, int(i))
					} else {
						return nil, fmt.Errorf("Unsupported number in TraverseIndex: %s", val.GoString())
					}
				} else if val.Type() == cty.String {
					parts = append(parts, val.AsString())
				} else {
					return nil, fmt.Errorf("Unsupported type in TraverseIndex: %s", val.Type().GoString())
				}
			} else {
				return nil, fmt.Errorf("Unknown value in TraverseIndex")
			}
		}
	}

	return parts, nil
}
