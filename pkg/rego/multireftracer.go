package rego

import (
	"strings"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/topdown"
	"github.com/sirupsen/logrus"
)

type InputRef struct {
	LocationInVar    ast.Ref
	LocationsInInput []ast.Ref
}

func (i *InputRef) IsParent(r ast.Ref) bool {
	return r.HasPrefix(i.LocationInVar)
}

type InputRefs []*InputRef

type InputVars map[ast.Var]InputRefs

func (i InputVars) Contains(v ast.Var) bool {
	_, contains := i[v]
	return contains
}

func (i InputVars) AddInputRef(v ast.Var, pathInVar ast.Ref, head ast.Var, tail ast.Ref, locals *ast.ValueMap) {
	expanded := i.ExpandRef(head, tail, locals)
	if len(expanded) < 1 {
		return
	}
	inputRef := &InputRef{
		LocationInVar:    pathInVar,
		LocationsInInput: expanded,
	}
	if _, ok := i[v]; !ok {
		i[v] = InputRefs{inputRef}
	} else {
		i[v] = append(i[v], inputRef)
	}
}

func (i InputVars) RenderRefToString(ref ast.Ref, locals *ast.ValueMap) string {
	// rendered := ast.Ref{}
	rendered := []string{}
	for _, t := range ref {
		if t.Equal(ast.InputRootDocument) {
			rendered = append(rendered, t.String())
			continue
		}
		switch val := t.Value.(type) {
		case ast.String, ast.Number:
			rendered = append(rendered, val.String())
		case ast.Var:
			if v := locals.Get(val); v != nil {
				switch vVal := v.(type) {
				case ast.String, ast.Number:
					rendered = append(rendered, vVal.String())
				}
			} else {
				// logrus.Infof("Could not render %s because I don't have a value for %s", ref.String(), val.String())
				return ""
			}
		}
	}
	joined := strings.Join(rendered, ".")
	logrus.Info(joined)
	return joined
}

func (i InputVars) RenderVarToStrings(v ast.Var, locals *ast.ValueMap) []string {
	rendered := []string{}
	if inputRefs, ok := i[v]; ok {
		for _, inputRef := range inputRefs {
			for _, ref := range inputRef.LocationsInInput {
				if r := i.RenderRefToString(ref, locals); r != "" {
					rendered = append(rendered, r)
				}
			}
		}
	}
	return rendered
}

func (i InputVars) RenderRef(ref ast.Ref, locals *ast.ValueMap) ast.Ref {
	rendered := ast.Ref{}
	for _, t := range ref {
		if t.Equal(ast.InputRootDocument) {
			rendered = append(rendered, t)
			continue
		}
		switch val := t.Value.(type) {
		case ast.String, ast.Number:
			rendered = append(rendered, t)
		case ast.Var:
			if v := locals.Get(val); v != nil {
				rendered = append(rendered, ast.NewTerm(v))
			} else {
				rendered = append(rendered, t)
			}
		}
	}
	return rendered
}

func (i InputVars) ExpandRef(head ast.Var, tail ast.Ref, locals *ast.ValueMap) []ast.Ref {
	expanded := []ast.Ref{}
	if head.Equal(ast.InputRootDocument.Value) {
		expanded = []ast.Ref{append(ast.InputRootRef, tail...)}
	} else {
		for _, inputRef := range i[head] {
			if inputRef.IsParent(tail) {
				accessor := tail[len(inputRef.LocationInVar):]
				for _, l := range inputRef.LocationsInInput {
					expanded = append(expanded, append(l, accessor...))
				}
			}
		}
	}

	// rendered := []ast.Ref{}
	// for _, e := range expanded {
	// 	r := i.RenderRef(e, locals)
	// 	if r != nil {
	// 		rendered = append(rendered, r)
	// 	}
	// }
	return expanded
}

type Query struct {
	ID              uint64
	ParentID        uint64
	InputVars       InputVars
	Locals          *ast.ValueMap
	LocalMetadata   map[ast.Var]topdown.VarMetadata
	Head            *ast.Head
	NextInputVar    ast.Var
	Failed          bool
	ReturnInputRefs InputRefs
	InputAccesses   map[string]bool
}

func (q *Query) HandleEvent(e topdown.Event) {
	q.Locals = e.Locals
	q.LocalMetadata = e.LocalMetadata
	switch e.Op {
	case topdown.EnterOp:
		if rule, ok := e.Node.(*ast.Rule); ok {
			q.Head = rule.Head
		}
	case topdown.ExitOp:
		if q.Head == nil {
			break
		}
		if ret, ok := q.Head.Value.Value.(ast.Var); ok {
			// This can be nil if the var was not in
			// our map
			q.ReturnInputRefs = q.InputVars[ret]
		}
	case topdown.FailOp:
		q.Failed = true
	case topdown.EvalOp:
		q.ExtractInputVars(e)
	case topdown.IndexOp:
		q.ExtractInputAccessFromEvent(e)
		// q.ExtractInputVars(e)
	}
}

func (q *Query) ExtractInputAccess(t *ast.Term) {
	switch v := t.Value.(type) {
	// case *ast.ArrayComprehension:
	// case *ast.Array:
	case ast.Ref:
		h := v[0]
		tail := v[1:]
		if head, ok := h.Value.(ast.Var); ok {
			if !q.InputVars.Contains(head) {
				return
			}
			expanded := q.InputVars.ExpandRef(head, tail, q.Locals)
			for _, x := range expanded {
				if r := q.InputVars.RenderRefToString(x, q.Locals); r != "" {
					q.InputAccesses[r] = true
				}
			}
		}
		// if rendered := q.InputVars.RenderRefToString(v, q.Locals); rendered != "" {
		// 	q.InputAccesses[rendered] = true
		// }
		// if
	case ast.Var:
		if !q.InputVars.Contains(v) {
			return
		}
		expanded := q.InputVars.ExpandRef(v, ast.EmptyRef(), q.Locals)
		for _, x := range expanded {
			if r := q.InputVars.RenderRefToString(x, q.Locals); r != "" {
				q.InputAccesses[r] = true
			}
		}
		// case *ast.
		// case ast.Call:

	}
}

func (q *Query) ExtractInputVars(e topdown.Event) {
	switch n := e.Node.(type) {
	case *ast.Expr:
		if n.Operator().Equal(EQ_OP) {
			v, ref := coerceAssignmentOperands(n.Operands())
			if v == "" || ref == nil {
				break
			}
			if r0, ok := ref[0].Value.(ast.Var); ok {
				if q.InputVars.Contains(r0) {
					// TODO: path in var will be non-empty in cases where
					// an object is created with input pieces in its body
					q.InputVars.AddInputRef(v, ast.EmptyRef(), r0, ref[1:], q.Locals)
					logrus.Info("Here")
				}
			}
		}
		for _, operand := range n.Operands() {
			q.ExtractInputAccess(operand)
		}
	}
}

func (q *Query) ExtractInputAccessFromEvent(e topdown.Event) {
	switch n := e.Node.(type) {
	case *ast.Expr:
		for _, operand := range n.Operands() {
			q.ExtractInputAccess(operand)
		}
	}
}

func (q *Query) MergeInputAccesses(o *Query) {
	for p := range o.InputAccesses {
		q.InputAccesses[p] = true
	}
}

// TODO: Take input from nextInput
func NewQuery(e topdown.Event) *Query {
	return &Query{
		ID:       e.QueryID,
		ParentID: e.ParentID,
		InputVars: InputVars{
			"input": InputRefs{
				&InputRef{
					LocationInVar: ast.EmptyRef(),
					LocationsInInput: []ast.Ref{
						ast.EmptyRef(),
					},
				},
			},
		},
		InputAccesses: map[string]bool{},
	}
}

type QueryStack struct {
	*Stack
}

func (s *QueryStack) First() *Query {
	return s.Front().Value.(*Query)
}

func (s *QueryStack) Last() *Query {
	return s.Back().Value.(*Query)
}

func (s *QueryStack) Push(q *Query) {
	s.Stack.Push(q)
}

func (s *QueryStack) Pop() *Query {
	return s.Stack.Pop().(*Query)
}

func NewQueryStack() *QueryStack {
	return &QueryStack{NewStack()}
}

type QueryTracer struct {
	QueryStack *QueryStack
}

func (t *QueryTracer) Enabled() bool {
	return true
}

func (t *QueryTracer) Config() topdown.TraceConfig {
	return topdown.TraceConfig{
		PlugLocalVars: true,
	}
}

var breakpoints = []struct {
	file string
	line int
}{
	// {"lib/fugue/regula.rego", 156},
	// {"lib/fugue/resource_view.rego", 33},
	// {"lib/fugue/resource_view/cloudformation.rego", 23},
}

func (t *QueryTracer) TraceEvent(e topdown.Event) {
	for _, b := range breakpoints {
		if e.Location.File == b.file && e.Location.Row == b.line {
			logrus.Infof("Breakpoint %s:%d", b.file, b.line)
			continue
		}
	}
	var current *Query
	if t.QueryStack.Len() < 1 {
		current = NewQuery(e)
		t.QueryStack.Push(current)
	} else {
		current = t.QueryStack.Last()
	}
	if e.QueryID != current.ID {
		for e.QueryID != current.ID && e.ParentID != current.ID {
			if len(current.InputVars) > 1 {
				logrus.Info("Got some inputs!")
			}

			// TODO: we'll want to inspect queries on the way back up later
			t.QueryStack.Pop()
			next := t.QueryStack.Last()
			if !current.Failed {
				next.MergeInputAccesses(current)
			}
			current = next

		}
		if e.ParentID == current.ID {
			next := NewQuery(e)
			t.QueryStack.Push(next)
			current = next
		}
	}
	current.HandleEvent(e)
}

func NewQueryTracer() *QueryTracer {
	return &QueryTracer{
		QueryStack: NewQueryStack(),
	}
}

func coerceAssignmentOperands(terms []*ast.Term) (ast.Var, ast.Ref) {
	if t1, ok := terms[0].Value.(ast.Var); ok {
		if t2, ok := terms[1].Value.(ast.Ref); ok {
			return t1, t2
		}
	} else if t1, ok := terms[0].Value.(ast.Ref); ok {
		if t2, ok := terms[1].Value.(ast.Var); ok {
			return t2, t1
		}
	}
	return "", nil
}
