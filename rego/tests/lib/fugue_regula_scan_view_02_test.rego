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
package fugue.regula_scan_view_02_test

import data.fugue.regula
import data.tests.lib.inputs.invalid_encryption_infra_yaml as input1
import data.tests.lib.inputs.valid_encryption_infra_yaml as input2

mock_input := [
  {
    "filepath": "tests/lib/inputs/invalid_encryption_infra.yaml",
    "content": input1.mock_config
  },
  {
    "filepath": "tests/lib/inputs/valid_encryption_infra.yaml",
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

mock_rule_config := {
  {"rule_name": "deny_cloudtrails", "status": "DISABLED"},
  {"rule_id": "TEST_123", "status": "DISABLED"}
}

output = ret {
  ret := regula.scan_view with
    data.rules as mock_rules with
    data.fugue.regula.config.rules as mock_rule_config with
    input as mock_input
}

test_scan_view {
  count([r | 
    r = output.report.rule_results[_]
    r.rule_name == "allow_buckets"
    r.rule_enabled == false
  ]) == 0
  # deny_cloudtrails and deny_buckets are present, but are marked as disabled
  count([r | 
    r = output.report.rule_results[_]
    r.rule_name == "deny_cloudtrails"
    r.rule_enabled == true
  ]) == 0
  count([r | 
    r = output.report.rule_results[_]
    r.rule_name == "deny_buckets"
    r.rule_enabled == true
  ]) == 0
}
