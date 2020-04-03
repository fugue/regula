# This is a larger test case that mocks the whole `data.rules` tree as well
# as the `input`.
package fugue.regula_report_test

import data.fugue.regula
import data.tests.rules.ebs_volume_encrypted

# We reuse the mock input from another test case.
mock_input = ebs_volume_encrypted.mock_input

# We construct some mock rules as well.
mock_rules = {
  "always_pass": {
    "controls": {"MOCK_1.2.3"},
    "resource_type": "aws_ebs_volume",
    "allow": true
  },
  "always_fail": {
    "resource_type": "aws_ebs_volume",
    "deny": true
  }
}

# Produce a report.
report = ret {
  ret = regula.report with input as mock_input with data.rules as mock_rules
}

# Test the report.
test_report {
  report.summary == {
    "controls_failed": 0,
    "controls_passed": 1,
    "rules_failed": 1,
    "rules_passed": 1,
    "valid": false,
  }

  report.controls == {
    "MOCK_1.2.3": {
      "rules": {"always_pass"},
      "valid": true,
    }
  }

  re_match("1 rules passed, 1 rules failed", report.message)
  re_match("Rule always_fail failed for resource", report.message)
}
