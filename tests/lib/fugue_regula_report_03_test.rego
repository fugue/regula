# Copyright 2020-2021 Fugue, Inc.
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

# This test case tests disabled rules.
package fugue.regula_report_03_test

import data.fugue.regula
import data.tests.rules.cfn.cloudtrail.inputs.invalid_encryption_infra as input1
import data.tests.rules.cfn.s3.inputs.valid_encryption_infra as input2

mock_input := [
  {
    "filename": "template1.yaml",
    "content": input1.mock_plan_input
  },
  {
    "filename": "template2.yaml",
    "content": input2.mock_plan_input
  }
]

mock_rules := {
  "deny_cloudtrails": {
    "resource_type": "AWS::CloudTrail::Trail",
    "input_type": "cloudformation",
    "allow": false
  },
  "deny_buckets": {
    "__rego__metadoc__": {"id": "TEST_123"},
    "resource_type": "AWS::S3::Bucket",
    "input_type": "cloudformation",
    "allow": false
  },
  "allow_buckets": {
    "resource_type": "AWS::S3::Bucket",
    "input_type": "cloudformation",
    "deny": false
  }
}

mock_rule_config := {
  {"rule_name": "deny_cloudtrails", "status": "DISABLED"},
  {"rule_id": "TEST_123", "status": "DISABLED"}
}

report = ret {
  ret := regula.report with
    data.rules as mock_rules with
    data.fugue.regula.config.rules as mock_rule_config with
    input as mock_input
}

test_report {
  # Only a single rule remains.
  {r.rule_name | r := report.rule_results[_]} == {"allow_buckets"}
  report.summary.rule_results.FAIL == 0
  report.summary.rule_results.PASS == 2
}
