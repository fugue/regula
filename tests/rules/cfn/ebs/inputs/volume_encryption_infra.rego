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

# This package was automatically generated from:
#
#     tests/rules/cfn/ebs/inputs/volume_encryption_infra.cfn
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
#
# It provides three inputs for testing:
# - mock_input: The resource view input as passed to advanced rules
# - mock_resources: The resources present as a convenience for tests
# - mock_plan_input: The original plan input as generated by terraform
package tests.rules.cfn.ebs.inputs.volume_encryption_infra
import data.fugue.resource_view.resource_view_input
mock_input = ret {
  ret = resource_view_input with input as mock_plan_input
}
mock_resources = mock_input.resources
mock_plan_input = {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Parameters": {
    "AvailabilityZone": {
      "Type": "String",
      "Default": "us-east-1b"
    }
  },
  "Resources": {
    "ValidVolume01": {
      "Type": "AWS::EC2::Volume",
      "Properties": {
        "AvailabilityZone": {
          "Ref": "AvailabilityZone"
        },
        "Encrypted": true,
        "Size": 1
      }
    },
    "InvalidVolume01": {
      "Type": "AWS::EC2::Volume",
      "Properties": {
        "AvailabilityZone": {
          "Ref": "AvailabilityZone"
        },
        "Encrypted": false,
        "Size": 1
      }
    },
    "InvalidVolume02": {
      "Type": "AWS::EC2::Volume",
      "Properties": {
        "AvailabilityZone": {
          "Ref": "AvailabilityZone"
        },
        "Size": 1
      }
    }
  }
}
