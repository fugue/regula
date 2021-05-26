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
package tests.rules.cfn.api_gateway.inputs.invalid_v2_custom_domain_name_sam_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Description": "Invalid V2 custom domain name configurations",
  "Resources": {
    "ServerlessAPI": {
      "Properties": {
        "Domain": {
          "CertificateArn": "arn:aws:acm:us-east-1:111122223333:certificate/9bb7fd90-00cf-4326-ae14-7dc62c92dfe5",
          "DomainName": "api.example.com",
          "SecurityPolicy": "TLS_1_0"
        }
      },
      "Type": "AWS::Serverless::HttpApi"
    },
    "ServerlessAPI2": {
      "Properties": {
        "Domain": {
          "CertificateArn": "arn:aws:acm:us-east-1:111122223333:certificate/cf9e8763-2af9-490f-84ea-c91c0f668755",
          "DomainName": "api-2.example.com"
        }
      },
      "Type": "AWS::Serverless::HttpApi"
    }
  },
  "Transform": "AWS::Serverless-2016-10-31"
}

