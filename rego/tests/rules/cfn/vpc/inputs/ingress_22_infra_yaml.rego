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
package tests.rules.cfn.vpc.inputs.ingress_22_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "Resources": {
    "InvalidSecurityGroup01": {
      "Properties": {
        "GroupDescription": "Description",
        "SecurityGroupIngress": [
          {
            "CidrIp": "0.0.0.0/0",
            "FromPort": 22,
            "IpProtocol": -1,
            "ToPort": 22
          }
        ],
        "VpcId": {
          "Ref": "Vpc01"
        }
      },
      "Type": "AWS::EC2::SecurityGroup"
    },
    "InvalidSecurityGroup02": {
      "Properties": {
        "GroupDescription": "Description",
        "SecurityGroupIngress": [
          {
            "CidrIp": "0.0.0.0/0",
            "FromPort": -1,
            "IpProtocol": -1
          }
        ],
        "VpcId": {
          "Ref": "Vpc01"
        }
      },
      "Type": "AWS::EC2::SecurityGroup"
    },
    "InvalidSecurityGroup03": {
      "Properties": {
        "GroupDescription": "Description",
        "SecurityGroupIngress": [
          {
            "CidrIpv6": "::/0",
            "FromPort": 20,
            "IpProtocol": -1,
            "ToPort": 24
          }
        ],
        "VpcId": {
          "Ref": "Vpc01"
        }
      },
      "Type": "AWS::EC2::SecurityGroup"
    },
    "InvalidSecurityGroup04": {
      "Properties": {
        "GroupDescription": "Description",
        "VpcId": {
          "Ref": "Vpc01"
        }
      },
      "Type": "AWS::EC2::SecurityGroup"
    },
    "InvalidSecurityGroup04Ingress01": {
      "Properties": {
        "CidrIp": "0.0.0.0/0",
        "FromPort": 22,
        "GroupId": {
          "Ref": "ValidSecurityGroup04"
        },
        "IpProtocol": -1,
        "ToPort": 22
      },
      "Type": "AWS::EC2::SecurityGroupIngress"
    },
    "ValidSecurityGroup01": {
      "Properties": {
        "GroupDescription": "Description",
        "VpcId": {
          "Ref": "Vpc01"
        }
      },
      "Type": "AWS::EC2::SecurityGroup"
    },
    "ValidSecurityGroup02": {
      "Properties": {
        "GroupDescription": "Description",
        "SecurityGroupIngress": [
          {
            "CidrIp": "0.0.0.0/0",
            "FromPort": 80,
            "IpProtocol": -1,
            "ToPort": 80
          }
        ],
        "VpcId": {
          "Ref": "Vpc01"
        }
      },
      "Type": "AWS::EC2::SecurityGroup"
    },
    "ValidSecurityGroup03": {
      "Properties": {
        "GroupDescription": "Description",
        "SecurityGroupIngress": [
          {
            "CidrIpv6": "::/0",
            "FromPort": 80,
            "IpProtocol": -1,
            "ToPort": 80
          }
        ],
        "VpcId": {
          "Ref": "Vpc01"
        }
      },
      "Type": "AWS::EC2::SecurityGroup"
    },
    "ValidSecurityGroup04": {
      "Properties": {
        "GroupDescription": "Description",
        "VpcId": {
          "Ref": "Vpc01"
        }
      },
      "Type": "AWS::EC2::SecurityGroup"
    },
    "ValidSecurityGroup04Ingress01": {
      "Properties": {
        "CidrIp": "192.168.1.7/32",
        "FromPort": 22,
        "GroupId": {
          "Ref": "ValidSecurityGroup04"
        },
        "IpProtocol": -1,
        "ToPort": 22
      },
      "Type": "AWS::EC2::SecurityGroupIngress"
    },
    "Vpc01": {
      "Properties": {
        "CidrBlock": "10.0.0.0/16"
      },
      "Type": "AWS::EC2::VPC"
    }
  }
}

