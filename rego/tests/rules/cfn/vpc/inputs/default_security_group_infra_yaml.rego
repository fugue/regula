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
package tests.rules.cfn.vpc.inputs.default_security_group_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "Resources": {
    "Vpc01": {
      "Properties": {
        "CidrBlock": "10.0.0.0/16"
      },
      "Type": "AWS::EC2::VPC"
    },
    "Vpc01InvalidIngress": {
      "Properties": {
        "CidrIp": "0.0.0.0/0",
        "FromPort": 22,
        "GroupId": {
          "Fn::GetAtt": [
            "Vpc01",
            "DefaultSecurityGroup"
          ]
        },
        "IpProtocol": "tcp",
        "ToPort": 22
      },
      "Type": "AWS::EC2::SecurityGroupIngress"
    },
    "Vpc01SecurityGroup": {
      "Properties": {
        "GroupDescription": "Description",
        "VpcId": {
          "Ref": "Vpc01"
        }
      },
      "Type": "AWS::EC2::SecurityGroup"
    },
    "Vpc01ValidIngress": {
      "Properties": {
        "CidrIp": "0.0.0.0/0",
        "FromPort": 22,
        "GroupId": {
          "Ref": "Vpc01SecurityGroup"
        },
        "IpProtocol": "tcp",
        "ToPort": 22
      },
      "Type": "AWS::EC2::SecurityGroupIngress"
    }
  }
}

