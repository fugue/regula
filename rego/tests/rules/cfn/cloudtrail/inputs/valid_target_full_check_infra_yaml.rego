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
package tests.rules.cfn.cloudtrail.inputs.valid_target_full_check_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "Valid CloudTrail target configuration",
  "Resources": {
    "CloudTrailLogging": {
      "Properties": {
        "EnableLogFileValidation": true,
        "IncludeGlobalServiceEvents": true,
        "IsLogging": true,
        "S3BucketName": {
          "Ref": "LoggingBucket"
        },
        "S3KeyPrefix": "prefix",
        "TrailName": "cf-fuguetest-trail"
      },
      "Type": "AWS::CloudTrail::Trail"
    },
    "CloudTrailLogging2": {
      "Properties": {
        "EnableLogFileValidation": true,
        "IncludeGlobalServiceEvents": true,
        "IsLogging": true,
        "S3BucketName": {
          "Ref": "LoggingBucket2"
        },
        "S3KeyPrefix": "prefix",
        "TrailName": "cf-fuguetest-trail2"
      },
      "Type": "AWS::CloudTrail::Trail"
    },
    "LoggingBucket": {
      "Properties": {
        "AccessControl": "AuthenticatedRead",
        "BucketName": "cf-fuguetest-bucket"
      },
      "Type": "AWS::S3::Bucket"
    },
    "LoggingBucket2": {
      "Properties": {
        "AccessControl": "BucketOwnerFullControl",
        "BucketName": "cf-fuguetest-bucket2"
      },
      "Type": "AWS::S3::Bucket"
    },
    "LoggingBucketPolicy": {
      "Properties": {
        "Bucket": {
          "Ref": "LoggingBucket"
        },
        "PolicyDocument": {
          "Statement": [
            {
              "Action": "s3:GetBucketAcl",
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudtrail.amazonaws.com"
              },
              "Resource": [
                {
                  "Fn::GetAtt": [
                    "LoggingBucket",
                    "Arn"
                  ]
                }
              ],
              "Sid": "AWSCloudTrailAclCheck"
            },
            {
              "Action": "s3:PutObject",
              "Condition": {
                "StringEquals": {
                  "s3:x-amz-acl": "bucket-owner-full-control"
                }
              },
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudtrail.amazonaws.com"
              },
              "Resource": [
                {
                  "Fn::Sub": "${LoggingBucket.Arn}/*"
                }
              ],
              "Sid": "AWSCloudTrailWrite"
            }
          ]
        }
      },
      "Type": "AWS::S3::BucketPolicy"
    },
    "LoggingBucketPolicy2": {
      "Properties": {
        "Bucket": {
          "Ref": "LoggingBucket2"
        },
        "PolicyDocument": {
          "Statement": [
            {
              "Action": "s3:GetBucketAcl",
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudtrail.amazonaws.com"
              },
              "Resource": [
                {
                  "Fn::GetAtt": [
                    "LoggingBucket2",
                    "Arn"
                  ]
                }
              ],
              "Sid": "AWSCloudTrailAclCheck"
            },
            {
              "Action": "s3:PutObject",
              "Condition": {
                "StringEquals": {
                  "s3:x-amz-acl": "bucket-owner-full-control"
                }
              },
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudtrail.amazonaws.com"
              },
              "Resource": [
                {
                  "Fn::Sub": "${LoggingBucket2.Arn}/*"
                }
              ],
              "Sid": "AWSCloudTrailWrite"
            }
          ]
        }
      },
      "Type": "AWS::S3::BucketPolicy"
    }
  }
}

