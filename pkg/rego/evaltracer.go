package rego

import (
	"strings"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/topdown"
	"github.com/sirupsen/logrus"
)

type EvalState int

const (
	Init EvalState = iota
	InEvaluateRule
	InEvaluateRuleJudgements
	InEvaluateAllowDeny
)

type evalTracer struct {
	currentRuleMeta   *RuleMeta
	currentRuleName   string
	currentResourceID string
	modules           map[string]*ast.Module
	evaluateRules     []*ast.Rule
	// evaluateAllows []*ast.Rule
	// evaluateDenies []*ast.Rule
	evaluateRuleJudgements        []*ast.Rule
	evaluateRuleQueryID           uint64
	evaluateRuleJudgementsQueryID uint64
	evaluateAllowDenyQueryID      uint64
	evalState                     EvalState
	rulePathToMetas               map[string]*RuleMeta
	rulePkgToMetas                map[string]*RuleMeta
}

func (t *evalTracer) Enabled() bool {
	return true
}

func (t *evalTracer) Config() topdown.TraceConfig {
	return topdown.TraceConfig{
		PlugLocalVars: true,
	}
}

func (t *evalTracer) traceEvaluateAllowDeny(e topdown.Event) {
	switch e.Op {
	case topdown.EvalOp:
		return
	case topdown.IndexOp:
		return
	case topdown.ExitOp:
		if e.QueryID == t.evaluateAllowDenyQueryID {
			logrus.Info("Exiting evaluate judgement")
			t.evalState = InEvaluateRuleJudgements
			t.evaluateAllowDenyQueryID = 0
		}
	case topdown.FailOp:
		if e.QueryID == t.evaluateAllowDenyQueryID {
			logrus.Info("Failing evaluate judgement")
			t.evalState = InEvaluateRuleJudgements
			t.evaluateAllowDenyQueryID = 0
		}
	}
}

func (t *evalTracer) traceEvaluateSimpleRule(e topdown.Event) {
	switch e.Op {
	case topdown.EvalOp:
		if e.QueryID == t.evaluateRuleJudgementsQueryID {
			locals := extractLocals(e)
			if pkg, ok := locals["pkg"]; ok {
				t.currentRuleName = strings.TrimPrefix(strings.TrimSuffix(pkg.String(), "\""), "\"")
				t.currentRuleMeta = t.rulePkgToMetas["data.rules."+t.currentRuleName]
				logrus.Infof("Current rule name: %s", t.currentRuleName)
			}
			if r, ok := locals["resource"]; ok {
				if resource, ok := r.(ast.Object); ok {
					if id := resource.Get(ast.StringTerm("id")); ok {
						t.currentResourceID = strings.TrimPrefix(strings.TrimSuffix(id.String(), "\""), "\"")
						logrus.Infof("Current resource ID: %s", t.currentResourceID)
					}
				}
			}
		}
	case topdown.EnterOp:
		if e.QueryID == t.evaluateRuleJudgementsQueryID {
			return
		}
		if locIsRule(e.Location, t.currentRuleMeta.Judgements) {
			t.evalState = InEvaluateAllowDeny
			t.evaluateAllowDenyQueryID = e.QueryID
			t.traceEvaluateAllowDeny(e)
		}
	// case topdown.IndexOp:
	// 	if e.QueryID == t.evaluateRuleJudgementsQueryID {
	// 		logrus.Info("Indexing evaluate_rule_judgements")
	// 		t.evalState = InEvaluateRule
	// 		t.evaluateRuleJudgementsQueryID = 0
	// 	}
	case topdown.FailOp:
		if e.QueryID == t.evaluateRuleJudgementsQueryID {
			logrus.Info("Failing evaluate_rule_judgements")
			t.evalState = InEvaluateRule
			t.evaluateRuleJudgementsQueryID = 0
		}
	case topdown.ExitOp:
		if e.QueryID == t.evaluateRuleJudgementsQueryID {
			logrus.Info("Exiting evaluate_rule_judgements")
			t.evalState = InEvaluateRule
			t.evaluateRuleJudgementsQueryID = 0
		}
	}
}

func (t *evalTracer) traceEvaluateRule(e topdown.Event) {
	switch e.Op {
	case topdown.EnterOp:
		if locIsRule(e.Location, t.evaluateRuleJudgements) {
			logrus.Info("Entering evaluate_rule_judgements")
			t.evalState = InEvaluateRuleJudgements
			t.evaluateRuleJudgementsQueryID = e.QueryID
			t.traceEvaluateSimpleRule(e)
			return
		}
	case topdown.FailOp:
		if e.QueryID == t.evaluateRuleQueryID {
			logrus.Info("Failing evaluate_rule")
			t.evalState = Init
			t.evaluateRuleQueryID = 0
		}
	case topdown.ExitOp:
		if e.QueryID == t.evaluateRuleQueryID {
			logrus.Info("Exiting evaluate_rule")
			t.evalState = Init
			t.evaluateRuleQueryID = 0
		}
	}
}

func (t *evalTracer) TraceEvent(e topdown.Event) {
	logrus.Debugf("Op: %s, ParentID: %d, QueryID: %d, Filename: %s, Loc: %s", e.Op, e.ParentID, e.QueryID, e.Location.File, e.Location.Text)
	if t.evalState == InEvaluateRule {
		t.traceEvaluateRule(e)
		return
	} else if t.evalState == InEvaluateRuleJudgements {
		t.traceEvaluateSimpleRule(e)
		return
	} else if t.evalState == InEvaluateRuleJudgements {
		t.traceEvaluateSimpleRule(e)
		return
	}

	switch e.Op {
	case topdown.EnterOp:
		if locIsRule(e.Location, t.evaluateRules) {
			logrus.Info("Entering evaluate_rule")
			t.evalState = InEvaluateRule
			t.evaluateRuleQueryID = e.QueryID
			t.traceEvaluateRule(e)
			return
		}
	}
}

func newEvalTracer(modules map[string]*ast.Module) *evalTracer {
	evaluateRules := []*ast.Rule{}
	// evaluateAllows := []*ast.Rule{}
	// evaluateDenies := []*ast.Rule{}
	evaluateRuleJudgements := []*ast.Rule{}
	rulePathToMetas := map[string]*RuleMeta{}
	rulePkgToMetas := map[string]*RuleMeta{}
	for path, m := range modules {
		pkg := m.Package.Path.String()
		if pkg == "data.fugue.regula" {
			for _, rule := range m.Rules {
				name := rule.Head.Name.String()
				if name == "evaluate_rule" {
					evaluateRules = append(evaluateRules, rule)
					// } else if name == "evaluate_allows" {
					// 	evaluateAllows = append(evaluateAllows, rule)
					// } else if name == "evaluate_denies" {
					// 	evaluateDenies = append(evaluateDenies, rule)
				} else if name == "evaluate_rule_judgements" {
					evaluateRuleJudgements = append(evaluateRuleJudgements, rule)
				}
			}
		} else if strings.HasPrefix(pkg, "data.rules.") {
			judgements := []*ast.Rule{}
			for _, rule := range m.Rules {
				name := rule.Head.Name.String()
				if isJudgement := judgementStates[name]; isJudgement {
					judgements = append(judgements, rule)
				}
			}
			if len(judgements) < 1 {
				continue
			}
			rulePathToMetas[path] = &RuleMeta{
				Package:    pkg,
				Judgements: judgements,
			}
			rulePkgToMetas[pkg] = &RuleMeta{
				Package:    pkg,
				Judgements: judgements,
			}
		}
	}
	return &evalTracer{
		modules:       modules,
		evaluateRules: evaluateRules,
		// evaluateAllows: evaluateAllows,
		// evaluateDenies: evaluateDenies,
		evaluateRuleJudgements: evaluateRuleJudgements,
		rulePathToMetas:        rulePathToMetas,
		rulePkgToMetas:         rulePkgToMetas,
	}
}

func locIsRule(loc *ast.Location, rules []*ast.Rule) bool {
	for _, r := range rules {
		if loc.Equal(r.Location) {
			return true
		}
	}
	return false
}

func extractLocals(e topdown.Event) map[string]ast.Value {
	locals := map[string]ast.Value{}
	for v, meta := range e.LocalMetadata {
		locals[string(meta.Name)] = e.Locals.Get(v)
	}
	return locals
}
