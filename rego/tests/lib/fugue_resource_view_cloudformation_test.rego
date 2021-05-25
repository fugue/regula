# Copyright 2021 Fugue, Inc.
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
package fugue.resource_view.cloudformation

test_getatt_arn {
  cfn := yaml.unmarshal(`
Resources:
  MySecurityGroup:
    Type: SecurityGroupId
    Properties:
      Vpc: {Fn::GetAtt: [MyVpc, Arn]}
  MyVpc:
    Type: Vpc
    Properties:
      Name: bar`)
  rv := resource_view with input as cfn
  rv == {
    "MySecurityGroup": {
      "id": "MySecurityGroup",
      "Vpc": "MyVpc",
      "_type": "SecurityGroupId",
      "_provider": "aws",
    },
    "MyVpc": {
      "id": "MyVpc",
      "Name": "bar",
      "_type": "Vpc",
      "_provider": "aws",
    }
  }
}

test_param {
  cfn := yaml.unmarshal(`
Parameters:
  Port:
    Default: 80
  Host:
    AllowedValues:
    - '0.0.0.0'
    - localhost
Resources:
  MyServer:
    Type: Server
    Properties:
      ThePort: {Ref: Port}
      TheHost: {Ref: Host}`)
  rv := resource_view with input as cfn
  rv == {
    "MyServer": {
      "id": "MyServer",
      "TheHost": "0.0.0.0",
      "ThePort": 80,
      "_type": "Server",
      "_provider": "aws",
    }
  }
}

test_resource_references_01 {
  cfn := yaml.unmarshal(`
Resources:
  CloudTrailLogging:
    Type: AWS::CloudTrail::Trail
    Properties:
      IsLogging: true
      S3BucketName:
        Ref: LoggingBucket
      TrailName: cf-fuguetest-trail
      EventSelectors:
        - ReadWriteType: All
          DataResources:
            - Type: AWS::S3::Object
              Values:
                - Fn::Sub: "${LoggingBucket.Arn}/"
  LoggingBucket:
    Type: AWS::S3::Bucket`)
  rv := resource_view with input as cfn
  rv == {
    "LoggingBucket": {
      "_type": "AWS::S3::Bucket",
      "_provider": "aws",
      "id": "LoggingBucket"
    },
    "CloudTrailLogging": {
      "_type": "AWS::CloudTrail::Trail",
      "_provider": "aws",
      "EventSelectors": [
        {
          "DataResources": [
            {
              "Values": ["LoggingBucket"],
              "Type": "AWS::S3::Object"
            }
          ],
          "ReadWriteType": "All"
        }
      ],
      "IsLogging": true,
      "TrailName": "cf-fuguetest-trail",
      "id": "CloudTrailLogging",
      "S3BucketName": "LoggingBucket"
    }
  }
}

test_resource_references_02 {
  cfn := yaml.unmarshal(`
Resources:
  CloudTrailLogging:
    Type: AWS::CloudTrail::Trail
    Properties:
      IsLogging: true
      S3BucketName:
        Ref: LoggingBucket
      TrailName: cf-fuguetest-trail
      EventSelectors:
      - ReadWriteType: All
        DataResources:
        - Type: AWS::S3::Object
          Values:
            - Fn::Join:
              - ''
              - Fn::Join:
                - 'arn:aws:s3:::'
                - Fn::Join:
                  - '-'
                  - Ref: AWS::Region
                  - Ref: AWS::AccountId`)
  rv := resource_view with input as cfn
  rv == {
    "CloudTrailLogging": {
      "_type": "AWS::CloudTrail::Trail",
      "_provider": "aws",
      "EventSelectors": [
        {
          "DataResources": [
            {
              "Values": [
                ["AWS::Region", "AWS::AccountId"]
              ],
              "Type": "AWS::S3::Object"
            }
          ],
          "ReadWriteType": "All"
        }
      ],
      "IsLogging": true,
      "TrailName": "cf-fuguetest-trail",
      "id": "CloudTrailLogging",
      "S3BucketName": "LoggingBucket"
    }
  }
}
