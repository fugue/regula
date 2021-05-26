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
package tests.rules.cfn.vpc.inputs.nacl_ingress_3389_infra_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "InvalidVpc01": {
      "Properties": {
        "CidrBlock": "10.0.0.0/16"
      },
      "Type": "AWS::EC2::VPC"
    },
    "InvalidVpc01Nacl": {
      "Properties": {
        "VpcId": {
          "Ref": "InvalidVpc01"
        }
      },
      "Type": "AWS::EC2::NetworkAcl"
    },
    "InvalidVpc01NaclEntry01": {
      "Properties": {
        "CidrBlock": "0.0.0.0/0",
        "NetworkAclId": {
          "Ref": "InvalidVpc01Nacl"
        },
        "Protocol": -1,
        "RuleAction": "allow",
        "RuleNumber": 10
      },
      "Type": "AWS::EC2::NetworkAclEntry"
    },
    "InvalidVpc02": {
      "Properties": {
        "CidrBlock": "10.0.0.0/16"
      },
      "Type": "AWS::EC2::VPC"
    },
    "InvalidVpc02Nacl": {
      "Properties": {
        "VpcId": {
          "Ref": "InvalidVpc02"
        }
      },
      "Type": "AWS::EC2::NetworkAcl"
    },
    "InvalidVpc02NaclEntry01": {
      "Properties": {
        "CidrBlock": "0.0.0.0/0",
        "NetworkAclId": {
          "Ref": "InvalidVpc02Nacl"
        },
        "PortRange": {
          "From": 3389,
          "To": 3389
        },
        "Protocol": 1,
        "RuleAction": "allow",
        "RuleNumber": 10
      },
      "Type": "AWS::EC2::NetworkAclEntry"
    },
    "InvalidVpc03": {
      "Properties": {
        "CidrBlock": "10.0.0.0/16"
      },
      "Type": "AWS::EC2::VPC"
    },
    "InvalidVpc03Nacl": {
      "Properties": {
        "VpcId": {
          "Ref": "InvalidVpc03"
        }
      },
      "Type": "AWS::EC2::NetworkAcl"
    },
    "InvalidVpc03NaclEntry01": {
      "Properties": {
        "Ipv6CidrBlock": "::/0",
        "NetworkAclId": {
          "Ref": "InvalidVpc03Nacl"
        },
        "PortRange": {
          "From": 3389,
          "To": 3389
        },
        "Protocol": 6,
        "RuleAction": "allow",
        "RuleNumber": 10
      },
      "Type": "AWS::EC2::NetworkAclEntry"
    },
    "InvalidVpc03NaclEntry02": {
      "Properties": {
        "Ipv6CidrBlock": "::/0",
        "NetworkAclId": {
          "Ref": "InvalidVpc03Nacl"
        },
        "PortRange": {
          "From": 0,
          "To": 10000
        },
        "Protocol": 6,
        "RuleAction": "deny",
        "RuleNumber": 20
      },
      "Type": "AWS::EC2::NetworkAclEntry"
    },
    "ValidVpc01": {
      "Properties": {
        "CidrBlock": "10.0.0.0/16"
      },
      "Type": "AWS::EC2::VPC"
    },
    "ValidVpc01Nacl": {
      "Properties": {
        "VpcId": {
          "Ref": "ValidVpc01"
        }
      },
      "Type": "AWS::EC2::NetworkAcl"
    },
    "ValidVpc01NaclEntry01": {
      "Properties": {
        "CidrBlock": "0.0.0.0/0",
        "NetworkAclId": {
          "Ref": "ValidVpc01Nacl"
        },
        "Protocol": 6,
        "RuleAction": "allow",
        "RuleNumber": 10
      },
      "Type": "AWS::EC2::NetworkAclEntry"
    },
    "ValidVpc02": {
      "Properties": {
        "CidrBlock": "10.0.0.0/16"
      },
      "Type": "AWS::EC2::VPC"
    },
    "ValidVpc02Nacl": {
      "Properties": {
        "VpcId": {
          "Ref": "ValidVpc02"
        }
      },
      "Type": "AWS::EC2::NetworkAcl"
    },
    "ValidVpc02NaclEntry01": {
      "Properties": {
        "CidrBlock": "0.0.0.0/0",
        "NetworkAclId": {
          "Ref": "ValidVpc02Nacl"
        },
        "PortRange": {
          "From": 3389,
          "To": 3389
        },
        "Protocol": 6,
        "RuleAction": "deny",
        "RuleNumber": 10
      },
      "Type": "AWS::EC2::NetworkAclEntry"
    },
    "ValidVpc02NaclEntry02": {
      "Properties": {
        "CidrBlock": "0.0.0.0/0",
        "NetworkAclId": {
          "Ref": "ValidVpc02Nacl"
        },
        "PortRange": {
          "From": 0,
          "To": 10000
        },
        "Protocol": 6,
        "RuleAction": "allow",
        "RuleNumber": 20
      },
      "Type": "AWS::EC2::NetworkAclEntry"
    },
    "ValidVpc03": {
      "Properties": {
        "CidrBlock": "10.0.0.0/16"
      },
      "Type": "AWS::EC2::VPC"
    },
    "ValidVpc03Nacl": {
      "Properties": {
        "VpcId": {
          "Ref": "ValidVpc03"
        }
      },
      "Type": "AWS::EC2::NetworkAcl"
    },
    "ValidVpc03NaclEntry01": {
      "Properties": {
        "CidrBlock": "0.0.0.0/0",
        "Egress": true,
        "NetworkAclId": {
          "Ref": "ValidVpc03Nacl"
        },
        "Protocol": -1,
        "RuleAction": "allow",
        "RuleNumber": 10
      },
      "Type": "AWS::EC2::NetworkAclEntry"
    }
  }
}

