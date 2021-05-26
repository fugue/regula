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
package tests.rules.cfn.iam.inputs.admin_policy_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "InvalidGroup01": {
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
            "PolicyName": "invalid_group_01"
          }
        ]
      },
      "Type": "AWS::IAM::Group"
    },
    "InvalidPolicy01": {
      "Properties": {
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
        "PolicyName": "invalid_policy_01",
        "Roles": [
          {
            "Ref": "InvalidRole01"
          }
        ]
      },
      "Type": "AWS::IAM::Policy"
    },
    "InvalidPolicy02": {
      "Properties": {
        "PolicyDocument": {
          "Statement": [
            {
              "Action": [
                "*",
                "elasticache:DescribeCacheClusters"
              ],
              "Effect": "Allow",
              "Resource": [
                "*"
              ]
            }
          ],
          "Version": "2012-10-17"
        },
        "PolicyName": "invalid_policy_02",
        "Roles": [
          {
            "Ref": "InvalidRole01"
          }
        ]
      },
      "Type": "AWS::IAM::Policy"
    },
    "InvalidPolicy03": {
      "Properties": {
        "PolicyDocument": {
          "Statement": {
            "Action": [
              "*",
              "elasticache:DescribeCacheClusters"
            ],
            "Effect": "Allow",
            "Resource": [
              "*"
            ]
          },
          "Version": "2012-10-17"
        },
        "PolicyName": "invalid_policy_03",
        "Roles": [
          {
            "Ref": "InvalidRole01"
          }
        ]
      },
      "Type": "AWS::IAM::Policy"
    },
    "InvalidRole01": {
      "Properties": {
        "AssumeRolePolicyDocument": {
          "Statement": [
            {
              "Action": [
                "sts:AssumeRole"
              ],
              "Effect": "Allow",
              "Principal": {
                "Service": [
                  "ec2.amazonaws.com"
                ]
              }
            }
          ],
          "Version": "2012-10-17"
        },
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
            "PolicyName": "invalid_role_01"
          }
        ]
      },
      "Type": "AWS::IAM::Role"
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
    "ValidPolicy01": {
      "Properties": {
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
        "PolicyName": "valid_policy_01",
        "Roles": [
          {
            "Ref": "ValidRole01"
          }
        ]
      },
      "Type": "AWS::IAM::Policy"
    },
    "ValidPolicy02": {
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
            },
            {
              "Action": "*",
              "Effect": "Allow",
              "Resource": {
                "Fn::GetAtt": [
                  "ValidRole01",
                  "Arn"
                ]
              }
            }
          ],
          "Version": "2012-10-17"
        },
        "PolicyName": "valid_policy_02",
        "Roles": [
          {
            "Ref": "ValidRole01"
          }
        ]
      },
      "Type": "AWS::IAM::Policy"
    },
    "ValidPolicy03": {
      "Properties": {
        "PolicyDocument": {
          "Statement": {
            "Action": "*",
            "Effect": "Deny",
            "Resource": "*"
          },
          "Version": "2012-10-17"
        },
        "PolicyName": "valid_policy_03",
        "Roles": [
          {
            "Ref": "ValidRole01"
          }
        ]
      },
      "Type": "AWS::IAM::Policy"
    },
    "ValidRole01": {
      "Properties": {
        "AssumeRolePolicyDocument": {
          "Statement": [
            {
              "Action": [
                "sts:AssumeRole"
              ],
              "Effect": "Allow",
              "Principal": {
                "Service": [
                  "ec2.amazonaws.com"
                ]
              }
            }
          ],
          "Version": "2012-10-17"
        }
      },
      "Type": "AWS::IAM::Role"
    }
  }
}

