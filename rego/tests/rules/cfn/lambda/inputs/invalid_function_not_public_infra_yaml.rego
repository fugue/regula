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
package tests.rules.cfn.lambda.inputs.invalid_function_not_public_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "Invalid public function configuration",
  "Resources": {
    "Function": {
      "Properties": {
        "Code": {
          "ZipFile": "exports.handler = (event, context) => {\n  console.log(JSON.stringify(event))\n}\n"
        },
        "Handler": "index.handler",
        "Role": {
          "Fn::GetAtt": [
            "FunctionRole",
            "Arn"
          ]
        },
        "Runtime": "nodejs12.x"
      },
      "Type": "AWS::Lambda::Function"
    },
    "Function2": {
      "Properties": {
        "Code": {
          "ZipFile": "exports.handler = (event, context) => {\n  console.log(JSON.stringify(event))\n}\n"
        },
        "Handler": "index.handler",
        "Role": {
          "Fn::GetAtt": [
            "FunctionRole",
            "Arn"
          ]
        },
        "Runtime": "nodejs12.x"
      },
      "Type": "AWS::Lambda::Function"
    },
    "Function3": {
      "Properties": {
        "Code": {
          "ZipFile": "exports.handler = (event, context) => {\n  console.log(JSON.stringify(event))\n}\n"
        },
        "Handler": "index.handler",
        "Role": {
          "Fn::GetAtt": [
            "FunctionRole",
            "Arn"
          ]
        },
        "Runtime": "nodejs12.x"
      },
      "Type": "AWS::Lambda::Function"
    },
    "Function4": {
      "Properties": {
        "Code": {
          "ZipFile": "exports.handler = (event, context) => {\n  console.log(JSON.stringify(event))\n}\n"
        },
        "FunctionName": "function4",
        "Handler": "index.handler",
        "Role": {
          "Fn::GetAtt": [
            "FunctionRole",
            "Arn"
          ]
        },
        "Runtime": "nodejs12.x"
      },
      "Type": "AWS::Lambda::Function"
    },
    "Function5": {
      "Properties": {
        "Code": {
          "ZipFile": "exports.handler = (event, context) => {\n  console.log(JSON.stringify(event))\n}\n"
        },
        "FunctionName": "function5",
        "Handler": "index.handler",
        "Role": {
          "Fn::GetAtt": [
            "FunctionRole",
            "Arn"
          ]
        },
        "Runtime": "nodejs12.x"
      },
      "Type": "AWS::Lambda::Function"
    },
    "Function5Alias": {
      "Properties": {
        "FunctionName": {
          "Ref": "Function5"
        },
        "FunctionVersion": "$LATEST",
        "Name": "v1"
      },
      "Type": "AWS::Lambda::Alias"
    },
    "Function6": {
      "Properties": {
        "Code": {
          "ZipFile": "exports.handler = (event, context) => {\n  console.log(JSON.stringify(event))\n}\n"
        },
        "FunctionName": {
          "Fn::Sub": "function-${AWS::Region}"
        },
        "Handler": "index.handler",
        "Role": {
          "Fn::GetAtt": [
            "FunctionRole",
            "Arn"
          ]
        },
        "Runtime": "nodejs12.x"
      },
      "Type": "AWS::Lambda::Function"
    },
    "Function6Alias": {
      "Properties": {
        "FunctionName": {
          "Ref": "Function5"
        },
        "FunctionVersion": "$LATEST",
        "Name": "v1"
      },
      "Type": "AWS::Lambda::Alias"
    },
    "FunctionPermissionByArn": {
      "Properties": {
        "Action": "lambda:InvokeFunction",
        "FunctionName": {
          "Fn::GetAtt": [
            "Function",
            "Arn"
          ]
        },
        "Principal": "*"
      },
      "Type": "AWS::Lambda::Permission"
    },
    "FunctionPermissionByHardcodedName": {
      "Properties": {
        "Action": "lambda:InvokeFunction",
        "FunctionName": "function4",
        "Principal": "*"
      },
      "Type": "AWS::Lambda::Permission"
    },
    "FunctionPermissionByHardcodedNameAndAlias": {
      "Properties": {
        "Action": "lambda:InvokeFunction",
        "FunctionName": "function5:v1",
        "Principal": "*"
      },
      "Type": "AWS::Lambda::Permission"
    },
    "FunctionPermissionByNameAndAliasUsingFunctions": {
      "Properties": {
        "Action": "lambda:InvokeFunction",
        "FunctionName": {
          "Fn::Join": [
            ":",
            [
              {
                "Fn::Sub": "function-${AWS::Region}"
              },
              "v2"
            ]
          ]
        },
        "Principal": "*"
      },
      "Type": "AWS::Lambda::Permission"
    },
    "FunctionPermissionByPartialArn": {
      "Properties": {
        "Action": "lambda:InvokeFunction",
        "FunctionName": {
          "Fn::Sub": "${AWS::AccountId}:${Function3}"
        },
        "Principal": "*"
      },
      "Type": "AWS::Lambda::Permission"
    },
    "FunctionPermissionByRef": {
      "Properties": {
        "Action": "lambda:InvokeFunction",
        "FunctionName": {
          "Ref": "Function2"
        },
        "Principal": "*"
      },
      "Type": "AWS::Lambda::Permission"
    },
    "FunctionRole": {
      "Properties": {
        "AssumeRolePolicyDocument": {
          "Statement": [
            {
              "Action": "sts:AssumeRole",
              "Effect": "Allow",
              "Principal": {
                "Service": "lambda.amazonaws.com"
              }
            }
          ],
          "Version": "2012-10-17"
        },
        "ManagedPolicyArns": [
          "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
        ],
        "Path": "/"
      },
      "Type": "AWS::IAM::Role"
    }
  }
}

