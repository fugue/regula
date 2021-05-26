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
package tests.rules.cfn.lambda.inputs.valid_function_not_public_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "Valid private function configuration",
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

