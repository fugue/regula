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
#     tests/rules/cfn/lambda/inputs/invalid_public_function_sam_infra.cfn
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
#
# It provides three inputs for testing:
# - mock_input: The resource view input as passed to advanced rules
# - mock_resources: The resources present as a convenience for tests
# - mock_plan_input: The original plan input as generated by terraform
package tests.rules.cfn.lambda.inputs.invalid_public_function_sam_infra
import data.fugue.resource_view.resource_view_input
mock_input = ret {
  ret = resource_view_input with input as mock_plan_input
}
mock_resources = mock_input.resources
mock_plan_input = {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Transform": "AWS::Serverless-2016-10-31",
  "Description": "Invalid public function configuration",
  "Resources": {
    "Function": {
      "Type": "AWS::Serverless::Function",
      "Properties": {
        "InlineCode": "exports.handler = (event, context) => {\n  console.log(JSON.stringify(event))\n}\n",
        "Handler": "index.handler",
        "Runtime": "nodejs12.x"
      }
    },
    "FunctionPermission": {
      "Type": "AWS::Lambda::Permission",
      "Properties": {
        "FunctionName": {
          "Fn::GetAtt": [
            "Function",
            "Arn"
          ]
        },
        "Action": "lambda:InvokeFunction",
        "Principal": "*"
      }
    }
  }
}
