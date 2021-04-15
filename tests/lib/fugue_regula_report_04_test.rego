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

# This test case is about waivers.
package fugue.regula_report_04_test

import data.fugue.regula
import data.tests.rules.cfn.cloudtrail.inputs.invalid_encryption_infra as input1
import data.tests.rules.cfn.s3.inputs.valid_encryption_infra as input2

mock_input := [
  {
    "filepath": "template1.yaml",
    "content": input1.mock_plan_input
  },
  {
    "filepath": "template2.yaml",
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

test_report_01 {
  report := regula.report with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"rule_name": "deny_buckets"}
    }

  num := count([r | r := report.rule_results[_]; r.rule_name == "deny_buckets"])
  num == count([r | r := report.rule_results[_]; r.rule_result == "WAIVED"])
  num == report.summary.rule_results.WAIVED
  num > 0
}

test_report_02 {
  report := regula.report with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"filepath": "template2.yaml"}
    }

  report.summary.rule_results.WAIVED == 2
}

test_report_03 {
  report := regula.report with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"rule_id": "TEST_123"}
    }

  report.summary.rule_results.WAIVED == 2
}

test_report_04 {
  report := regula.report with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"rule_name": "deny_buckets", "resource_id": "LoggingBucket"}
    }

  report.summary.rule_results.WAIVED == 1
}

test_report_05 {
  report := regula.report with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      # Completey empty waivers should be ignored rather than waive everything.
      {}
    }

  report.summary.rule_results.WAIVED == 0
}

test_report_06 {
  report := regula.report with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"resource_type": "AWS::S3::Bucket"}
    }

  report.summary.rule_results.WAIVED == 4
}
