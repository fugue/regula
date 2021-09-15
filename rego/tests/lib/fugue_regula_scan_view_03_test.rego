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
package fugue.regula_scan_view_03_test

import data.fugue.scan_view
import data.tests.lib.inputs.invalid_encryption_infra_yaml as input1
import data.tests.lib.inputs.valid_encryption_infra_yaml as input2

mock_input := [
  {
    "filepath": "invalid_encryption_infra.yaml",
    "content": input1.mock_config
  },
  {
    "filepath": "valid_encryption_infra.yaml",
    "content": input2.mock_config
  }
]

mock_rules := {
  "deny_cloudtrails": {
    "resource_type": "AWS::CloudTrail::Trail",
    "input_type": "cfn",
    "allow": false
  },
  "deny_buckets": {
    "__rego__metadoc__": {"id": "TEST_123"},
    "resource_type": "AWS::S3::Bucket",
    "input_type": "cfn",
    "allow": false
  },
  "allow_buckets": {
    "resource_type": "AWS::S3::Bucket",
    "input_type": "cfn",
    "deny": false
  }
}

test_scan_view_01 {
  output := scan_view.scan_view with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"rule_name": "deny_buckets"}
    }

  num := count([r | r := output.report.rule_results[_]; r.rule_name == "deny_buckets"])
  num == count([r | r := output.report.rule_results[_]; r.rule_waived == true])
  num > 0
}

test_report_02 {
  output := scan_view.scan_view with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"filepath": "invalid_encryption_infra.yaml"}
    }

  num := count([r | r := output.report.rule_results[_]; r.filepath == "invalid_encryption_infra.yaml"])
  num == count([r | r := output.report.rule_results[_]; r.rule_waived == true])
  num == 3
}

test_report_03 {
  output := scan_view.scan_view with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"rule_id": "TEST_123"}
    }

  num := count([r | r := output.report.rule_results[_]; r.rule_id == "TEST_123"])
  num == count([r | r := output.report.rule_results[_]; r.rule_waived == true])
  num == 2
}

test_report_04 {
  output := scan_view.scan_view with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"rule_name": "deny_buckets", "resource_id": "LoggingBucket"}
    }

  num := count([r | 
    r := output.report.rule_results[_]
    r.rule_name == "deny_buckets"
    r.resource_id == "LoggingBucket"
  ])
  num == count([r | r := output.report.rule_results[_]; r.rule_waived == true])
  num == 1
}

test_report_05 {
  output := scan_view.scan_view with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      # Completey empty waivers should be ignored rather than waive everything.
      {}
    }

  count([r | r := output.report.rule_results[_]; r.rule_waived == true]) == 0
}

test_report_06 {
  output := scan_view.scan_view with
    data.rules as mock_rules with
    input as mock_input with
    data.fugue.regula.config.waivers as {
      {"resource_type": "AWS::S3::Bucket"}
    }

  num := count([r | r := output.report.rule_results[_]; r.resource_type == "AWS::S3::Bucket"])
  num == count([r | r := output.report.rule_results[_]; r.rule_waived == true])
  num == 4
}
