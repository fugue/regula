package rego

import (
	"strings"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/topdown"
	"github.com/sirupsen/logrus"
)

type ResourceGraphNode struct {
	Children              ResourceGraph
	Unresolved            bool
	UnresolvedDescendents int
}

func (n *ResourceGraphNode) AddPath(path []string, unresolved bool) *ResourceGraphNode {
	if len(path) < 1 {
		n.Unresolved = unresolved
		return n
	}
	n.UnresolvedDescendents += 1
	head := path[0]
	nextPath := path[1:]
	if child, ok := n.Children[head]; ok {
		return child.AddPath(nextPath, unresolved)
	}
	child := NewResourceGraphNode()
	n.Children[head] = child
	return child.AddPath(nextPath, unresolved)
}

// func (n *ResourceGraphNode) AddPath(path []string, unresolved bool) *ResourceGraphNode {
// 	if unresolved {
// 		n.UnresolvedDescendents += 1
// 	}
// 	if len(path) < 1 {

// 	}
// 	head := path[0]
// 	nextPath := path[1:]

// 	if _, ok := n.Children[head]; !ok {
// 		unresolvedDescendents := 0
// 		if unresolved && len(nextPath) > 0 {
// 			unresolvedDescendents += 1
// 		}
// 		n.Children[head] = NewResourceGraphNode(unresolved, unresolvedDescendents)
// 	}

// 	if child, ok := n.Children[head]; ok {
// 		return child.AddPath(path[1:], unresolved)
// 	} else {
// 		unresolvedDescendents := 0
// 		if unresolved && len(path) > 1 {
// 			unresolvedDescendents += 1
// 		}
// 		n.Children[head] = NewResourceGraphNode(unresolved, unresolvedDescendents)
// 		path = path[1:]
// 		if len(path) > 0 {
// 			return n.Children[head].AddPath()
// 		}
// 	}
// }

func NewResourceGraphNode() *ResourceGraphNode {
	return &ResourceGraphNode{
		Children: ResourceGraph{},
	}
}

type ResourceGraph map[string]*ResourceGraphNode

type evalContext struct {
	queryID    uint64
	inputGraph ResourceGraph
	child      *evalContext
	nextInput  ast.Ref

	locals        ResourceGraph
	traversed     ResourceGraph
	inputVars     map[ast.Var]ast.Ref
	accessedPaths map[string]bool
	failed        bool
}

// var EQ_OP = ast.RefTerm(ast.VarTerm("eq"))
var EQ_OP = ast.Ref{ast.VarTerm("eq")}

func (c *evalContext) extractVarAndRef(terms []*ast.Term) (ast.Var, ast.Ref) {
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

// func (c *evalContext)

func (c *evalContext) renderInputPathFromVar(v ast.Var, e topdown.Event) string {
	// fullRef := []*ast.Term{}
	path := []string{}
	for _, t := range c.inputVars[v][1:] {
		switch val := t.Value.(type) {
		case ast.Var:
			if _, ok := c.inputVars[val]; ok {
				ele := c.renderInputPathFromVar(val, e)
				if ele == "" {
					logrus.Infof("Exiting from render, because %s is unknown", val)
					return ""
				}
				path = append(path, ele)
			} else {
				if varVal := e.Locals.Get(val); varVal != nil {
					path = append(path, varVal.String())
				} else {
					logrus.Infof("Exiting from render, because %s is unknown", val)
					return ""
				}
			}
		case ast.String, ast.Number:
			path = append(path, val.String())
		default:
			logrus.Error("Unhandled ref element")
		}
	}
	return strings.Join(path, ".")
}

func (c *evalContext) extractInputVarsFromAssignment(terms []*ast.Term, e topdown.Event) {
	// switch v := terms[1].Value.(type) {
	// case ast.Var:
	// 	switch v2 := terms[2].Value.(type) {
	// 	case ast.Ref:
	// 		asVar, ok := v2
	// 		if !ok {
	// 			return
	// 		}
	// 		if _, ok := c.inputVars[]
	// 	}
	// }
	v, ref := c.extractVarAndRef(terms)
	if v == "" || ref == nil {
		return
	}
	if r0, ok := ref[0].Value.(ast.Var); ok {
		if _, isInput := c.inputVars[r0]; isInput {
			c.inputVars[v] = ref
		}
	}
}

func (c *evalContext) extractAccessedPaths(terms []*ast.Term, e topdown.Event) {
	for _, term := range terms {
		ref, ok := term.Value.(ast.Ref)
		if !ok {
			continue
		}
		if len(ref) < 1 {
			continue
		}
		v, ok := ref[0].Value.(ast.Var)
		if !ok {
			continue
		}
		if _, inLocalVars := c.inputVars[v]; inLocalVars {
			if path := c.renderInputPathFromVar(v, e); path != "" {
				logrus.Infof("Adding accessed path: %s", path)
				c.accessedPaths[path] = true
			}
		}
	}
}

func (c *evalContext) extractInputVars(e topdown.Event) {
	switch n := e.Node.(type) {
	case *ast.Expr:
		if n.Operator().Equal(EQ_OP) {
			c.extractInputVarsFromAssignment(n.Operands(), e)
		}
		// Iterate through operands and check for refs where first ele is in our
		// variable map. If it is, then use renderInputPathFromVar. If that returns a
		// blank string, then return, otherwise add it to accessedPaths.
		c.extractAccessedPaths(n.Operands(), e)
	}
	// expr, ok := e.Node.(*ast.Expr)
	// if !ok {
	// 	return
	// }

	// exprTerms, ok := expr.Terms.([]*ast.Term)
	// if !ok {
	// 	return
	// }
	// // Case where some input path is assigned to a variable
	// // should be:
	// //   first term is the operator
	// //   second term is the variable name
	// //   third term is the input reference
	// if exprTerm
	// if expr.Operator() == EQ_OP {

	// } exprTerms[0].Equal(EQ_OP) {
	// 	c.extractInputVarsFromAssignment(exprTerms, e)
	// }
	// for _, t := range exprTerms {
	// 	logrus.Debug(t)
	// }
}

func (c *evalContext) expandRef(ref ast.Ref, e topdown.Event) ast.Ref {
	expanded := []*ast.Term{}
	for _, t := range ref {
		if t.Equal(ast.InputRootDocument) {
			expanded = append(expanded, t)
			continue
		}
		switch val := t.Value.(type) {
		case ast.Var:
			if r, ok := c.inputVars[val]; ok {
				expanded = append(expanded, c.expandRef(r, e)...)
				// r :=
				// if ele == "" {
				// 	logrus.Infof("Exiting from render, because %s is unknown", val)
				// 	return ""
				// }
				// path = append(path, ele)
			} else {
				if varVal := e.Locals.Get(val); varVal != nil {
					expanded = append(expanded, ast.StringTerm(varVal.String()))
					// path = append(path, varVal.String())
				} else {
					expanded = append(expanded, t)
				}
			}
		case ast.String, ast.Number:
			expanded = append(expanded, ast.StringTerm(val.String()))
		default:
			logrus.Error("Unhandled ref element")
		}
	}
	return expanded
}

func (c *evalContext) extractNextInput(e topdown.Event) {
	expr, ok := e.Node.(*ast.Expr)
	if !ok {
		return
	}
	if len(expr.With) < 1 {
		return
	}
	for _, w := range expr.With {
		target, ok := w.Target.Value.(ast.Ref)
		if !ok {
			continue
		}
		if !target.Equal(ast.InputRootRef) {
			continue
		}
		val, ok := w.Value.Value.(ast.Var)
		if !ok {
			continue
		}
		if ref, ok := c.inputVars[val]; ok {
			c.nextInput = c.expandRef(ref, e)
		} else {
			c.nextInput = ast.Ref{w.Value}
		}
	}

	// if !ok {
	// 	return
	// }
	// if ref.Equal(ast.InputRootRef) {
	// 	logrus.Info("Boring")
	// } else {
	// 	logrus.Info("Exciting")
	// }
	// c.nextInput = ref
	// if len(ref) < 1 {
	// 	return
	// }
	// head, ok := ref[0].Value.(ast.Var)
	// if !ok {
	// 	return
	// }

}

// func (c *evalContext) extractInputRefs(e topdown.Event) []*ResourceGraphNode {
// 	inputRefs := []*ResourceGraphNode{}
// 	expr, ok := e.Node.(*ast.Expr)
// 	if !ok {
// 		return inputRefs
// 	}
// 	exprTerms, ok := expr.Terms.([]*ast.Term)
// 	if !ok {
// 		return inputRefs
// 	}
// 	for _, t := range exprTerms {
// 		ref, ok := t.Value.(ast.Ref)
// 		if !ok {
// 			continue
// 		}
// 		if len(ref) < 1 {
// 			continue
// 		}
// 		v, ok := ref[0].Value.(ast.Var)
// 		if !ok {
// 			continue
// 		}
// 		if n, ok := c.inputGraph[string(v)]; ok {
// 			path := []string{}
// 			for _, p := range ref[1:] {
// 				if pathEleAsVar, ok := p.Value.(ast.Var); ok {
// 					pathEleAsString := string(pathEleAsVar)
// 					if pathEleAsString == "input" {
// 						path = append(path, pathEleAsString)
// 					} else if meta, ok := e.LocalMetadata[pathEleAsVar]; ok {
// 						val := e.Locals.Get(meta.Name)
// 						path = append(path, val.String())
// 					} else {
// 						path = append(path, pathEleAsString)
// 						n.AddPath(path, true)
// 					}
// 				} else {
// 					path = append(path, p.String())
// 				}
// 			}
// 			inputRefs = append(inputRefs, n.AddPath(path, false))
// 		}
// 	}
// 	return inputRefs
// }

func newEvalContext(queryID uint64, inputRef ast.Ref) *evalContext {
	return &evalContext{
		queryID: queryID,
		// inputGraph: ResourceGraph{
		// 	ast.InputRootDocument.String(): inputNode,
		// },
		inputVars: map[ast.Var]ast.Ref{
			"input": inputRef,
		},
		nextInput:     inputRef,
		accessedPaths: map[string]bool{},
	}
}

type listener func(c *evalContext, e topdown.Event) (matched bool)

type inputTracer struct {
	contextStack   *Stack
	currentContext *evalContext
	listeners      []listener
}

func newInputTracer() *inputTracer {
	return &inputTracer{
		contextStack: NewStack(),
	}
}

func (t *inputTracer) Enabled() bool {
	return true
}

func (t *inputTracer) Config() topdown.TraceConfig {
	return topdown.TraceConfig{
		PlugLocalVars: true,
	}
}

// var breakpoints = []struct {
// 	file string
// 	line int
// }{
// 	// {"lib/fugue/regula.rego", 156},
// 	// {"lib/fugue/resource_view.rego", 33},
// 	{"lib/fugue/resource_view/cloudformation.rego", 23},
// }

func (t *inputTracer) TraceEvent(e topdown.Event) {
	for _, b := range breakpoints {
		if e.Location.File == b.file && e.Location.Row == b.line {
			logrus.Infof("Breakpoint %s:%d", b.file, b.line)
			continue
		}
	}
	t.callListeners(e)
	if t.contextStack.Len() < 1 {
		// logrus.Infof("Initialized at query %d", e.QueryID)
		t.currentContext = newEvalContext(e.QueryID, ast.InputRootRef)
		t.contextStack.Push(t.currentContext)
		return
	}
	if e.QueryID != t.currentContext.queryID {
		for e.QueryID != t.currentContext.queryID && e.ParentID != t.currentContext.queryID {

			t.contextStack.Pop()
			nextContext := t.contextStack.Back().Value.(*evalContext)
			logrus.Infof("Copying %d paths from query %d to %d", len(t.currentContext.accessedPaths), t.currentContext.queryID, nextContext.queryID)
			for p := range t.currentContext.accessedPaths {
				nextContext.accessedPaths[p] = true
			}
			t.currentContext = nextContext
			// logrus.Infof("Popped back up to %d", t.currentContext.queryID)
		}
		if e.ParentID == t.currentContext.queryID {
			// logrus.Infof("Entered new query %d which is a child of %d", e.QueryID, t.currentContext.queryID)
			nextContext := newEvalContext(e.QueryID, t.currentContext.nextInput)
			t.contextStack.Push(nextContext)
			t.currentContext.child = nextContext
			t.currentContext = nextContext
			// if input := e.Input(); input != nil {
			// 	return
			// }
			// input := e.Input()
		}
	}
	switch e.Op {
	case topdown.EnterOp:
		return
	case topdown.IndexOp:
		t.addListener(e)
	case topdown.EvalOp:
		t.currentContext.extractInputVars(e)
		t.currentContext.extractNextInput(e)
		// refs := t.currentContext.extractInputRefs(e)
		// if len(refs) > 0 {
		// 	logrus.Info("Got %d refs", len(refs))
		// }
		// if strings.Contains(string(e.Location.Text), "with input as") {
		// 	logrus.Infof("Input modified (op type %s): %s", e.Op, e.Location.Text)
		// } else if strings.Contains(string(e.Location.Text), "input") {

		// 	logrus.Infof("Input accessed (op type %s): %s", e.Op, e.Location.Text)
		// }
	case topdown.ExitOp:
		// if e.Location.File == "lib/fugue/resource_view.rego" {
		// 	return
		// }
		return
	case topdown.FailOp:
		t.currentContext.failed = true
	case topdown.RedoOp:
		return
	}
}

func (t *inputTracer) addListener(e topdown.Event) {
	switch n := e.Node.(type) {
	case *ast.Expr:
		if n.Operator().Equal(EQ_OP) {
			v, ref := t.currentContext.extractVarAndRef(n.Operands())
			if v == "" || ref == nil {
				return
			}
			parent := t.currentContext
			l := func(c *evalContext, next topdown.Event) (matched bool) {
				if next.ParentID != parent.queryID {
					return
				}
				switch next.Op {
				case topdown.FailOp:
					matched = true
				case topdown.ExitOp:
					matched = true
					rule, ok := next.Node.(*ast.Rule)
					if !ok {
						return
					}
					// What is VarSet?
					if rule.Head.Value == nil {
						return
					}
					ret, ok := rule.Head.Value.Value.(ast.Var)
					if !ok {
						return
					}
					if ref, ok := c.inputVars[ret]; ok {
						logrus.Info("This worked!")
						parent.inputVars[v] = c.expandRef(ref, next)
					}
				}
				return
			}
			t.listeners = append(t.listeners, l)
		}
	}
}

func (t *inputTracer) callListeners(e topdown.Event) {
	unmatched := []listener{}
	for _, l := range t.listeners {
		if !l(t.currentContext, e) {
			unmatched = append(unmatched, l)
		}
	}
	t.listeners = unmatched
}

// func extractInputRef(n ast.Node) string {
// 	expr, ok := n.(*ast.Expr)
// 	if !ok {
// 		return ""
// 	}
// 	terms, ok := expr.Terms.([]*ast.Term)
// 	if !ok {
// 		return ""
// 	}
// 	for _, t := range terms {
// 		ref, ok := t.Value.(ast.Ref)
// 		if !ok {
// 			continue
// 		}
// 		for _, term := range ref {
// 			if term.Equal(ast.InputRootDocument) {
// 				return ref.String()
// 			}
// 		}
// 	}
// 	return ""
// }
