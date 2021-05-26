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
package tests.lib.inputs.valid_encryption_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "Valid S3 encryption configuration",
  "Resources": {
    "Bucket": {
      "Properties": {
        "BucketEncryption": {
          "ServerSideEncryptionConfiguration": [
            {
              "ServerSideEncryptionByDefault": {
                "KMSMasterKeyID": {
                  "Ref": "KMSKey"
                },
                "SSEAlgorithm": "aws:kms"
              }
            }
          ]
        }
      },
      "Type": "AWS::S3::Bucket"
    },
    "KMSKey": {
      "Properties": {
        "Description": "This key is used to encrypt bucket objects",
        "KeyPolicy": {
          "Id": "default-key-policy",
          "Statement": [
            {
              "Action": "kms:*",
              "Effect": "Allow",
              "Principal": {
                "AWS": {
                  "Fn::Sub": "arn:aws:iam::${AWS::AccountId}:root"
                }
              },
              "Resource": "*",
              "Sid": "Enable IAM User Permissions"
            }
          ],
          "Version": "2012-10-17"
        },
        "PendingWindowInDays": 10
      },
      "Type": "AWS::KMS::Key"
    }
  }
}

