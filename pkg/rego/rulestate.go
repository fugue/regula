package rego

import (
	"container/list"
	"strings"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/topdown"
	"github.com/sirupsen/logrus"
)

type EvalState int

const (
	OutsideJudgement EvalState = iota
	InsideJudgement
)

var judgementStates = map[string]bool{
	"allow":  true,
	"deny":   true,
	"policy": true,
}

type ResourceGraphNode struct {
	Children ResourceGraph
}

type ResourceGraph map[string]*ResourceGraphNode

type RuleMeta struct {
	Package    string
	Judgements []*ast.Rule
}

func (m *RuleMeta) IsJudgement(l *ast.Location) bool {
	for _, j := range m.Judgements {
		if j.Location.Equal(l) {
			return true
		}
	}
	return false
}

type EvalStateTracer struct {
	currentRule  *RuleMeta
	evalState    EvalState
	isRuleCache  map[string]bool
	packageCache map[string]string
	ruleMetas    map[string]*RuleMeta
	Modules      map[string]*ast.Module
	queryStack   *Stack
}

func (t *EvalStateTracer) Enabled() bool {
	return true
}

func (t *EvalStateTracer) Config() topdown.TraceConfig {
	return topdown.TraceConfig{
		PlugLocalVars: true,
	}
}

func (t *EvalStateTracer) ruleMetaFor(path string) *RuleMeta {
	if t.ruleMetas == nil {
		t.ruleMetas = map[string]*RuleMeta{}
	}
	if meta, ok := t.ruleMetas[path]; ok {
		return meta
	}
	mod := t.Modules[path]
	if mod == nil {
		return nil
	}
	judgements := []*ast.Rule{}
	for _, rule := range mod.Rules {
		if isJudgement := judgementStates[rule.Head.Name.String()]; isJudgement {
			judgements = append(judgements, rule)
		}
	}
	meta := &RuleMeta{
		Package:    t.packageFor(path),
		Judgements: judgements,
	}
	t.ruleMetas[path] = meta
	return meta
}

func (t *EvalStateTracer) packageFor(path string) string {
	if path == "" {
		return ""
	}
	if t.packageCache == nil {
		t.packageCache = map[string]string{}
	}
	if ans, ok := t.packageCache[path]; ok {
		return ans
	}
	var ans string
	if mod, ok := t.Modules[path]; ok {
		ans = mod.Package.Path.String()
	}
	t.packageCache[path] = ans
	return ans
}

func (t *EvalStateTracer) isRule(path string) bool {
	if path == "" {
		return false
	}
	if t.isRuleCache == nil {
		t.isRuleCache = map[string]bool{}
	}
	if ans, ok := t.isRuleCache[path]; ok {
		return ans
	}
	p := t.packageFor(path)
	ans := strings.HasPrefix(p, "data.rules")
	t.isRuleCache[path] = ans
	return ans
}

func (t *EvalStateTracer) inJudgement(e topdown.Event) {
	switch e.Op {
	case topdown.EvalOp:
	case topdown.EnterOp:
		t.queryStack.Push(e.QueryID)
	case topdown.ExitOp:
		if ele := t.queryStack.Pop(); ele == nil {
			logrus.Info("Exiting judgement")
			t.evalState = OutsideJudgement
			t.currentRule = nil
		}
	case topdown.FailOp:
		if ele := t.queryStack.Pop(); ele == nil {
			logrus.Info("Failing judgement")
			t.evalState = OutsideJudgement
			t.currentRule = nil
		}
	default:
		return
	}
}

func (t *EvalStateTracer) inRule(e topdown.Event) {
	// if e.QueryID == 43 {
	// 	logrus.Info(e)
	// }
	// if e.QueryID
	// e.Location.
	// loc := string(e.Location.Text)
	// if !t.isRule(e.Location.File) {
	// 	return
	// }
	// t.currentRule =
	// meta := t.ruleMetaFor(e.Location.File)
	if t.evalState == InsideJudgement {
		t.inJudgement(e)
		return
	}
	switch e.Op {
	case topdown.EvalOp:
		return
		// logrus.Infof("Op: %s, Loc: %s", e.Op, loc)
	case topdown.EnterOp:
		if t.currentRule.IsJudgement(e.Location) {
			logrus.Infof("Entering judgement: %s", string(e.Location.Text))
			t.evalState = InsideJudgement
			t.queryStack = NewStack()
			t.inJudgement(e)
			return
		}
		// if strings.Contains(loc, "policy[j]") {
		// 	logrus.Info(e.QueryID)
		// }
		return
		// logrus.Infof("Op: %s, Loc: %s", e.Op, loc)
	case topdown.ExitOp:
		// return
		// if strings.Contains(loc, "not valid_buckets[id]") {
		// 	logrus.Info(e.QueryID)
		// 	// logrus.Infof("Op: %s, Loc: %s", e.Op, loc)
		// }
		// logrus.Infof("Op: %s, Loc: %s", e.Op, loc)
		return
	case topdown.FailOp:
		// return
		// logrus.Infof("Op: %s, Loc: %s", e.Op, loc)
		return
	default:
		return
	}
}

func (t *EvalStateTracer) TraceEvent(e topdown.Event) {
	if t.currentRule != nil {
		t.inRule(e)
		return
	}
	// loc := string(e.Location.Text)
	file := e.Location.File
	if t.isRule(file) {
		currentRule := t.ruleMetaFor(file)
		if len(currentRule.Judgements) < 1 {
			logrus.Infof("Rule has no judgements: %s", currentRule.Package)
		}
		logrus.Infof("Entered rule: %s", currentRule.Package)
		t.currentRule = currentRule
		t.inRule(e)
		return
	}
	// switch e.Op {
	// case topdown.EvalOp:
	// 	logrus.Infof("Op: %s, Loc: %s", e.Op, loc)
	// case topdown.EnterOp:
	// 	logrus.Infof("Op: %s, Loc: %s", e.Op, loc)
	// case topdown.ExitOp:
	// 	logrus.Infof("Op: %s, Loc: %s", e.Op, loc)
	// case topdown.FailOp:
	// 	logrus.Infof("Op: %s, Loc: %s", e.Op, loc)
	// default:
	// 	return
	// }
}

func extractInputRef(n ast.Node) string {
	expr, ok := n.(*ast.Expr)
	if !ok {
		return ""
	}
	terms, ok := expr.Terms.([]*ast.Term)
	if !ok {
		return ""
	}
	for _, t := range terms {
		ref, ok := t.Value.(ast.Ref)
		if !ok {
			return ""
		}
		for _, term := range ref {
			if term.Equal(ast.InputRootDocument) {
				return ref.String()
			}
		}
	}
	return ""
}

type Stack struct {
	dll *list.List
}

func NewStack() *Stack {
	return &Stack{dll: list.New()}
}

func (s *Stack) Push(x interface{}) {
	s.dll.PushBack(x)
}

func (s *Stack) Pop() interface{} {
	if s.dll.Len() == 0 {
		return nil
	}
	tail := s.dll.Back()
	val := tail.Value
	s.dll.Remove(tail)
	return val
}
