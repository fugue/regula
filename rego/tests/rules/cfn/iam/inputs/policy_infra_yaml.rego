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
package tests.rules.cfn.iam.inputs.policy_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "Group01": {
      "Type": "AWS::IAM::Group"
    },
    "InvalidPolicy01": {
      "Properties": {
        "PolicyDocument": {
          "Statement": [
            {
              "Action": [
                "ec2:StartInstances"
              ],
              "Effect": "Allow",
              "Resource": [
                "*"
              ]
            }
          ],
          "Version": "2012-10-17"
        },
        "PolicyName": "invalid_policy_01",
        "Users": [
          {
            "Ref": "InvalidUser01"
          }
        ]
      },
      "Type": "AWS::IAM::Policy"
    },
    "InvalidUser01": {
      "Properties": {
        "Policies": [
          {
            "PolicyDocument": {
              "Statement": [
                {
                  "Action": "*",
                  "Effect": "Allow",
                  "Resource": "*"
                }
              ],
              "Version": "2012-10-17"
            },
            "PolicyName": "invalid_user_01"
          }
        ]
      },
      "Type": "AWS::IAM::User"
    },
    "User01": {
      "Type": "AWS::IAM::User"
    },
    "ValidPolicy01": {
      "Properties": {
        "Groups": [
          {
            "Ref": "Group01"
          }
        ],
        "PolicyDocument": {
          "Statement": {
            "Action": [
              "ec2:StartInstances"
            ],
            "Effect": "Allow",
            "Resource": [
              "*"
            ]
          },
          "Version": "2012-10-17"
        },
        "PolicyName": "valid_policy_01"
      },
      "Type": "AWS::IAM::Policy"
    }
  }
}

