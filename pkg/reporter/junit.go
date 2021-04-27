package reporter

import (
	"encoding/xml"
	"fmt"
	"sort"
)

func JUnitReporter(o *RegulaOutput) (string, error) {
	byFilepath := map[string]map[string]ResourceResults{}
	for _, r := range o.RuleResults {
		fileResults, ok := byFilepath[r.Filepath]
		if !ok {
			fileResults = map[string]ResourceResults{}
		}
		resourceResults, ok := fileResults[r.ResourceId]
		if !ok {
			resourceResults = ResourceResults{
				Results:      []RuleResult{},
				ResourceId:   r.ResourceId,
				ResourceType: r.ResourceType,
			}
		}
		resourceResults.Results = append(resourceResults.Results, r)
		fileResults[r.ResourceId] = resourceResults
		byFilepath[r.Filepath] = fileResults
	}
	filePaths := []string{}
	for k := range byFilepath {
		filePaths = append(filePaths, k)
	}
	sort.Strings(filePaths)
	testSuites := []TestSuite{}
	for _, f := range filePaths {
		resourceIds := []string{}
		for k := range byFilepath[f] {
			resourceIds = append(resourceIds, k)
		}
		sort.Strings(resourceIds)
		testCases := []TestCase{}
		for _, r := range resourceIds {
			resourceResults := byFilepath[f][r]
			sort.SliceStable(resourceResults.Results, func(i, j int) bool {
				return resourceResults.Results[i].RuleName < resourceResults.Results[j].RuleName
			})
			skips := []TestSkipMessage{}
			failures := []TestFailure{}
			for _, result := range resourceResults.Results {
				if result.RuleResult == "WAIVED" {
					skips = append(skips, TestSkipMessage{
						Message: result.Message(),
					})
				} else if result.RuleResult == "FAIL" {
					failures = append(failures, TestFailure{
						Message:  result.Message(),
						Type:     result.RuleName,
						Contents: ruleMessage(result),
					})
				}
			}
			testCase := TestCase{
				Name:       r,
				ClassName:  resourceResults.ResourceType,
				Assertions: len(resourceResults.Results),
			}
			if len(skips) > 0 {
				testCase.SkipMessage = &skips
			}
			if len(failures) > 0 {
				testCase.Failures = &failures
			}
			testCases = append(testCases, testCase)
		}
		testSuites = append(testSuites, TestSuite{
			Name:      f,
			Tests:     len(testCases),
			TestCases: testCases,
		})
	}

	rootNode := TestSuites{
		Name:       "Regula",
		TestSuites: testSuites,
	}

	x, err := xml.MarshalIndent(rootNode, "", "  ")
	if err != nil {
		return "", err
	}
	return string(x), nil
}

func ruleMessage(r RuleResult) string {
	return fmt.Sprintf(
		"Rule ID: %v\nRule Name: %v\nSeverity: %v\nMessage: %v",
		r.RuleId,
		r.RuleName,
		r.RuleSeverity,
		r.Message(),
	)
}

func sortedKeys(m map[string]interface{}) []string {
	keys := []string{}
	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return keys
}

type ResultsByFilepath struct {
	Filepaths map[string]map[string]ResourceResults
}

type ResourceResults struct {
	Results      []RuleResult
	ResourceId   string
	ResourceType string
}

type TestSuites struct {
	XMLName    xml.Name    `xml:"testsuites"`
	Name       string      `xml:"name,attr"`
	TestSuites []TestSuite `xml:"testsuite"`
}

type TestSuite struct {
	XMLName   xml.Name   `xml:"testsuite"`
	Name      string     `xml:"name,attr"`
	Tests     int        `xml:"tests,attr"`
	TestCases []TestCase `xml:"testcase"`
}

type TestCase struct {
	XMLName     xml.Name           `xml:"testcase"`
	Name        string             `xml:"name,attr"`
	ClassName   string             `xml:"classname,attr"`
	Assertions  int                `xml:"assertions,attr"`
	SkipMessage *[]TestSkipMessage `xml:"skipped,omitempty"`
	Failures    *[]TestFailure     `xml:"error,omitempty"`
}

type TestFailure struct {
	Message  string `xml:"message,attr"`
	Type     string `xml:"type,attr"`
	Contents string `xml:",chardata"`
}

type TestSkipMessage struct {
	Message string `xml:"message,attr"`
}
