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
package tests.rules.cfn.s3.inputs.invalid_cloudtrail_s3_data_logging_write_one_bucket_read_all_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "Invalid CloudTrail S3 data logging configuration",
  "Resources": {
    "Bucket1": {
      "Type": "AWS::S3::Bucket"
    },
    "Bucket2": {
      "Type": "AWS::S3::Bucket"
    },
    "Bucket3": {
      "Type": "AWS::S3::Bucket"
    },
    "CloudTrailLogging": {
      "Properties": {
        "EventSelectors": [
          {
            "DataResources": [
              {
                "Type": "AWS::S3::Object",
                "Values": [
                  "arn:aws:s3:::"
                ]
              }
            ],
            "ReadWriteType": "ReadOnly"
          },
          {
            "DataResources": [
              {
                "Type": "AWS::S3::Object",
                "Values": [
                  {
                    "Fn::Sub": "${LoggingBucket.Arn}/"
                  }
                ]
              }
            ],
            "ReadWriteType": "All"
          }
        ],
        "IsLogging": true,
        "S3BucketName": {
          "Ref": "LoggingBucket"
        },
        "TrailName": "cf-fuguetest-trail"
      },
      "Type": "AWS::CloudTrail::Trail"
    },
    "LoggingBucket": {
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
    }
  }
}

