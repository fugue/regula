# Copyright 2020 Fugue, Inc.
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
package rules.security_group_ingress_anywhere_rdp

import data.fugue.regula.aws.security_group as sglib

__rego__metadoc__ := {
  "id": "FG_R00087",
  "title": "VPC security group rules should not permit ingress from '0.0.0.0/0' to port 3389 (Remote Desktop Protocol)",
  "description": "VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 3389 (Remote Desktop Protocol). VPC security groups should not permit unrestricted access from the internet to port 3389 (RDP). Removing unfettered connectivity to remote console services, such as Remote Desktop Protocol, reduces a server's exposure to risk.",
  "custom": {
    "controls": {
      "CIS": [
        "CIS_4-2"
      ],
      "NIST": [
        "NIST-800-53_AC-4",
        "NIST-800-53_AC-17 (3)"
      ]
    }
  }
}

resource_type = "aws_security_group"

default deny = false

deny {
  block = input.ingress[_]
  sglib.ingress_zero_cidr_to_port(block, 3389)
}
