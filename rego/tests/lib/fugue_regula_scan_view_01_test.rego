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
package fugue.regula_scan_view_01_test

import data.fugue.regula
import data.fugue.regula_report_01_test as base
import data.tests.lib.inputs.volume_encrypted_infra_tf

# Mock the output from the regula loaders
mock_input = [
  {
    "filepath": "tests/lib/inputs",
    "content": volume_encrypted_infra_tf.mock_config
  }
]

# We construct some mock rules as well.
mock_rules = {
  "always_pass": {
    "__rego__metadoc__": {
      "custom": {
        "controls": {
          "MOCK": ["MOCK_1.2.3"]
        },
        "severity": "hIgH"
      },
      "id": "FG_R00001",
      "title": "Always pass",
      "description": "This rule always passes"
    },
    "resource_type": "aws_ebs_volume",
    "allow": true
  },
  "always_fail": {
    "resource_type": "aws_ebs_volume",
    "deny": true
  }
}

# Produce a scan view
output = ret {
  ret = regula.scan_view with input as mock_input with data.rules as mock_rules
}

contains_result(arr, result) {
  r = arr[_]
  result == r
}

# Test the report.
test_scan_view {
  count(expected_scan_view.report.rule_results) == count(output.report.rule_results)
  all([c | r = expected_scan_view.report.rule_results[_]; c = contains_result(output.report.rule_results, r)])
  expected_scan_view.report.summary == output.report.summary
  expected_scan_view.inputs == output.inputs
  expected_scan_view.scan_view_version == output.scan_view_version
}

expected_scan_view = {
  "inputs": [
    {
      "filepath": "tests/lib/inputs",
      "input_type": "tf",
      "resources": {
        "aws_ebs_volume.bad": {
          "_filepath": "tests/lib/inputs/volume_encrypted_infra.tf",
          "_provider": "aws",
          "_type": "aws_ebs_volume",
          "availability_zone": "us-west-2a",
          "encrypted": false,
          "id": "aws_ebs_volume.bad",
          "size": 40
        },
        "aws_ebs_volume.good": {
          "_filepath": "tests/lib/inputs/volume_encrypted_infra.tf",
          "_provider": "aws",
          "_type": "aws_ebs_volume",
          "availability_zone": "us-west-2a",
          "encrypted": true,
          "id": "aws_ebs_volume.good",
          "size": 40
        },
        "aws_ebs_volume.missing": {
          "_filepath": "tests/lib/inputs/volume_encrypted_infra.tf",
          "_provider": "aws",
          "_type": "aws_ebs_volume",
          "availability_zone": "us-west-2a",
          "id": "aws_ebs_volume.missing",
          "size": 40
        }
      }
    }
  ],
  "scan_view_version": "v1",
  "report": {
    "rule_results": [
      {
        "controls": [
          "MOCK_1.2.3"
        ],
        "filepath": "tests/lib/inputs/volume_encrypted_infra.tf",
        "input_type": "tf",
        "provider": "aws",
        "resource_id": "aws_ebs_volume.bad",
        "resource_type": "aws_ebs_volume",
        "rule_description": "This rule always passes",
        "rule_id": "FG_R00001",
        "rule_message": "",
        "rule_name": "always_pass",
        "rule_result": "PASS",
        "rule_severity": "High",
        "rule_summary": "Always pass",
        "rule_valid": true
      },
      {
        "controls": [
          "MOCK_1.2.3"
        ],
        "filepath": "tests/lib/inputs/volume_encrypted_infra.tf",
        "input_type": "tf",
        "provider": "aws",
        "resource_id": "aws_ebs_volume.good",
        "resource_type": "aws_ebs_volume",
        "rule_description": "This rule always passes",
        "rule_id": "FG_R00001",
        "rule_message": "",
        "rule_name": "always_pass",
        "rule_result": "PASS",
        "rule_severity": "High",
        "rule_summary": "Always pass",
        "rule_valid": true
      },
      {
        "controls": [
          "MOCK_1.2.3"
        ],
        "filepath": "tests/lib/inputs/volume_encrypted_infra.tf",
        "input_type": "tf",
        "provider": "aws",
        "resource_id": "aws_ebs_volume.missing",
        "resource_type": "aws_ebs_volume",
        "rule_description": "This rule always passes",
        "rule_id": "FG_R00001",
        "rule_message": "",
        "rule_name": "always_pass",
        "rule_result": "PASS",
        "rule_severity": "High",
        "rule_summary": "Always pass",
        "rule_valid": true
      },
      {
        "controls": [],
        "filepath": "tests/lib/inputs/volume_encrypted_infra.tf",
        "input_type": "tf",
        "provider": "aws",
        "resource_id": "aws_ebs_volume.bad",
        "resource_type": "aws_ebs_volume",
        "rule_description": "",
        "rule_id": "",
        "rule_message": "",
        "rule_name": "always_fail",
        "rule_result": "FAIL",
        "rule_severity": "Unknown",
        "rule_summary": "",
        "rule_valid": false
      },
      {
        "controls": [],
        "filepath": "tests/lib/inputs/volume_encrypted_infra.tf",
        "input_type": "tf",
        "provider": "aws",
        "resource_id": "aws_ebs_volume.good",
        "resource_type": "aws_ebs_volume",
        "rule_description": "",
        "rule_id": "",
        "rule_message": "",
        "rule_name": "always_fail",
        "rule_result": "FAIL",
        "rule_severity": "Unknown",
        "rule_summary": "",
        "rule_valid": false
      },
      {
        "controls": [],
        "filepath": "tests/lib/inputs/volume_encrypted_infra.tf",
        "input_type": "tf",
        "provider": "aws",
        "resource_id": "aws_ebs_volume.missing",
        "resource_type": "aws_ebs_volume",
        "rule_description": "",
        "rule_id": "",
        "rule_message": "",
        "rule_name": "always_fail",
        "rule_result": "FAIL",
        "rule_severity": "Unknown",
        "rule_summary": "",
        "rule_valid": false
      }
    ],
    "summary": {
      "filepaths": [
        "tests/lib/inputs/volume_encrypted_infra.tf"
      ],
      "rule_results": {
        "FAIL": 3,
        "PASS": 3,
        "WAIVED": 0
      },
      "severities": {
        "Critical": 0,
        "High": 0,
        "Informational": 0,
        "Low": 0,
        "Medium": 0,
        "Unknown": 3
      }
    }
  }
}
