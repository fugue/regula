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
package tests.rules.cfn.s3.inputs.valid_https_access_bucket_policy_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "Valid S3 HTTPS access configuration",
  "Resources": {
    "Bucket1": {
      "Type": "AWS::S3::Bucket"
    },
    "Bucket1Policy": {
      "Properties": {
        "Bucket": {
          "Ref": "Bucket1"
        },
        "PolicyDocument": {
          "Statement": [
            {
              "Action": "s3:Get*",
              "Effect": "Allow",
              "Principal": "*",
              "Resource": [
                {
                  "Fn::GetAtt": [
                    "Bucket1",
                    "Arn"
                  ]
                }
              ]
            },
            {
              "Action": "*",
              "Condition": {
                "Bool": {
                  "aws:SecureTransport": false
                }
              },
              "Effect": "Deny",
              "Principal": "*",
              "Resource": [
                {
                  "Fn::GetAtt": [
                    "Bucket1",
                    "Arn"
                  ]
                }
              ]
            }
          ]
        }
      },
      "Type": "AWS::S3::BucketPolicy"
    },
    "Bucket2": {
      "Type": "AWS::S3::Bucket"
    },
    "Bucket2Policy": {
      "Properties": {
        "Bucket": {
          "Ref": "Bucket2"
        },
        "PolicyDocument": {
          "Statement": [
            {
              "Action": "*",
              "Condition": {
                "Bool": {
                  "aws:SecureTransport": false
                }
              },
              "Effect": "Deny",
              "Principal": "*",
              "Resource": [
                {
                  "Fn::Sub": "${Bucket2.Arn}/*"
                }
              ]
            }
          ]
        }
      },
      "Type": "AWS::S3::BucketPolicy"
    }
  }
}

