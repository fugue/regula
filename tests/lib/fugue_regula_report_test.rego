# Copyright 2020 Fugue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This is a larger test case that mocks the whole `data.rules` tree as well
# as the `input`.
package fugue.regula_report_test

import data.fugue.regula
import data.tests.rules.aws.inputs.ebs_volume_encrypted_infra

# We reuse the mock input from another test case.
mock_plan_input = ebs_volume_encrypted_infra.mock_plan_input

# We construct some mock rules as well.
mock_rules = {
  "always_pass": {
    "__rego__metadoc__": {
      "custom": {
        "controls": {
          "MOCK": ["MOCK_1.2.3"]
        }
      }
    },
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
  ret = regula.report with input as mock_plan_input with data.rules as mock_rules
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
