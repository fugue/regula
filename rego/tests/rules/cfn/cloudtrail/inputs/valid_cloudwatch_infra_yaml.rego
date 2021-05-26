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
package tests.rules.cfn.cloudtrail.inputs.valid_cloudwatch_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "Valid CloudTrail cloudwatch integration",
  "Resources": {
    "CloudTrailCloudWatchRole": {
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
                  "cloudtrail.amazonaws.com"
                ]
              }
            }
          ],
          "Version": "2012-10-17"
        },
        "Path": "/",
        "Policies": [
          {
            "PolicyDocument": {
              "Statement": [
                {
                  "Action": "logs:CreateLogStream",
                  "Effect": "Allow",
                  "Resource": "*"
                },
                {
                  "Action": "logs:PutLogEvents",
                  "Effect": "Allow",
                  "Resource": "*"
                }
              ],
              "Version": "2012-10-17"
            },
            "PolicyName": "watch-policy"
          }
        ]
      },
      "Type": "AWS::IAM::Role"
    },
    "CloudTrailLogGroup": {
      "Type": "AWS::Logs::LogGroup"
    },
    "CloudTrailLogging": {
      "Properties": {
        "CloudWatchLogsLogGroupArn": {
          "Fn::GetAtt": [
            "CloudTrailLogGroup",
            "Arn"
          ]
        },
        "CloudWatchLogsRoleArn": {
          "Fn::GetAtt": [
            "CloudTrailCloudWatchRole",
            "Arn"
          ]
        },
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

