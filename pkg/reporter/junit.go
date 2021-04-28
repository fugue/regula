package reporter

import (
	"encoding/xml"
	"fmt"
	"sort"
)

func JUnitReporter(o *RegulaOutput) (string, error) {
	testSuites := o.AggregateByFilepath().ToTestSuites()
	x, err := xml.MarshalIndent(testSuites, "", "  ")
	if err != nil {
		return "", err
	}
	return string(x), nil
}

func (r ResourceResults) ToTestCase() JUnitTestCase {
	results := r.Results
	sort.SliceStable(results, func(i, j int) bool {
		return results[i].RuleName < results[j].RuleName
	})
	skips := []JUnitSkipMessage{}
	failures := []JUnitFailure{}
	for _, result := range results {
		if result.IsWaived() {
			skips = append(skips, JUnitSkipMessage{
				Message: result.Message(),
			})
		} else if result.IsFail() {
			failures = append(failures, JUnitFailure{
				Message:  result.Message(),
				Type:     result.RuleName,
				Contents: failureMessage(result),
			})
		}
	}
	testCase := JUnitTestCase{
		Name:       r.ResourceID,
		ClassName:  r.ResourceType,
		Assertions: len(r.Results),
	}
	if len(skips) > 0 {
		testCase.SkipMessage = &skips
	}
	if len(failures) > 0 {
		testCase.Failures = &failures
	}
	return testCase
}

func (r FilepathResults) ToTestSuite() JUnitTestSuite {
	testCases := []JUnitTestCase{}
	for _, k := range r.SortedKeys() {
		testCases = append(testCases, r.Results[k].ToTestCase())
	}
	return JUnitTestSuite{
		Name:      r.Filepath,
		Tests:     len(testCases),
		TestCases: testCases,
	}
}

func (r ResultsByFilepath) ToTestSuites() JUnitTestSuites {
	testSuites := []JUnitTestSuite{}
	for _, k := range r.SortedKeys() {
		testSuites = append(testSuites, r[k].ToTestSuite())
	}
	return JUnitTestSuites{
		Name:       "Regula",
		TestSuites: testSuites,
	}
}

func failureMessage(r RuleResult) string {
	return fmt.Sprintf(
		"Rule ID: %v\nRule Name: %v\nSeverity: %v\nMessage: %v",
		r.RuleID,
		r.RuleName,
		r.RuleSeverity,
		r.Message(),
	)
}

type JUnitTestSuites struct {
	XMLName    xml.Name         `xml:"testsuites"`
	Name       string           `xml:"name,attr"`
	TestSuites []JUnitTestSuite `xml:"testsuite"`
}

type JUnitTestSuite struct {
	XMLName   xml.Name        `xml:"testsuite"`
	Name      string          `xml:"name,attr"`
	Tests     int             `xml:"tests,attr"`
	TestCases []JUnitTestCase `xml:"testcase"`
}

type JUnitTestCase struct {
	XMLName     xml.Name            `xml:"testcase"`
	Name        string              `xml:"name,attr"`
	ClassName   string              `xml:"classname,attr"`
	Assertions  int                 `xml:"assertions,attr"`
	SkipMessage *[]JUnitSkipMessage `xml:"skipped,omitempty"`
	Failures    *[]JUnitFailure     `xml:"failure,omitempty"`
}

type JUnitFailure struct {
	Message  string `xml:"message,attr"`
	Type     string `xml:"type,attr"`
	Contents string `xml:",chardata"`
}

type JUnitSkipMessage struct {
	Message string `xml:"message,attr"`
}
