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
#     tests/rules/cfn/s3/inputs/valid_cloudtrail_s3_data_logging_write_one_bucket_read_all_infra.cfn
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
#
# It provides three inputs for testing:
# - mock_input: The resource view input as passed to advanced rules
# - mock_resources: The resources present as a convenience for tests
# - mock_plan_input: The original plan input as generated by terraform
package tests.rules.cfn.s3.inputs.valid_cloudtrail_s3_data_logging_write_one_bucket_read_all_infra
import data.fugue.resource_view.resource_view_input
mock_input = ret {
  ret = resource_view_input with input as mock_plan_input
}
mock_resources = mock_input.resources
mock_plan_input = {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "Valid CloudTrail S3 data logging configuration",
  "Resources": {
    "CloudTrailLogging": {
      "Type": "AWS::CloudTrail::Trail",
      "Properties": {
        "IsLogging": true,
        "S3BucketName": {
          "Ref": "LoggingBucket"
        },
        "TrailName": "cf-fuguetest-trail",
        "EventSelectors": [
          {
            "ReadWriteType": "ReadOnly",
            "DataResources": [
              {
                "Type": "AWS::S3::Object",
                "Values": [
                  "arn:aws:s3:::"
                ]
              }
            ]
          },
          {
            "ReadWriteType": "All",
            "DataResources": [
              {
                "Type": "AWS::S3::Object",
                "Values": [
                  {
                    "Fn::Sub": "${LoggingBucket.Arn}/"
                  }
                ]
              }
            ]
          }
        ]
      }
    },
    "LoggingBucket": {
      "Type": "AWS::S3::Bucket"
    },
    "LoggingBucketPolicy": {
      "Type": "AWS::S3::BucketPolicy",
      "Properties": {
        "Bucket": {
          "Ref": "LoggingBucket"
        },
        "PolicyDocument": {
          "Statement": [
            {
              "Sid": "AWSCloudTrailAclCheck",
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudtrail.amazonaws.com"
              },
              "Action": "s3:GetBucketAcl",
              "Resource": [
                {
                  "Fn::GetAtt": [
                    "LoggingBucket",
                    "Arn"
                  ]
                }
              ]
            },
            {
              "Sid": "AWSCloudTrailWrite",
              "Effect": "Allow",
              "Principal": {
                "Service": "cloudtrail.amazonaws.com"
              },
              "Action": "s3:PutObject",
              "Resource": [
                {
                  "Fn::Sub": "${LoggingBucket.Arn}/*"
                }
              ],
              "Condition": {
                "StringEquals": {
                  "s3:x-amz-acl": "bucket-owner-full-control"
                }
              }
            }
          ]
        }
      }
    },
    "Bucket1": {
      "Type": "AWS::S3::Bucket"
    },
    "Bucket2": {
      "Type": "AWS::S3::Bucket"
    },
    "Bucket3": {
      "Type": "AWS::S3::Bucket"
    }
  }
}
