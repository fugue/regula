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
package rules.tf_aws_security_groups_inbound_all

import data.fugue
import data.aws.security_groups.library
import data.fugue.cidr


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_9.2",
        "CIS-Controls_v7.1_9.4"
      ]
    },
    "severity": "High"
  },
  "description": "VPC security group inbound rules should not permit ingress from a public address to all ports and protocols. Security groups provide stateful filtering of ingress/egress network traffic to AWS resources. AWS recommends that no security groups explicitly allow inbound ports.",
  "id": "FG_R00044",
  "title": "VPC security group inbound rules should not permit ingress from a public address to all ports and protocols"
}

resource_type = "aws_security_group"

default deny = false

has_public_cidr(b) {
  cidr.public_cidr(b.cidr_blocks[_])
} {
  cidr.public_cidr(b.ipv6_cidr_blocks[_])
}

deny {
  b = input.ingress[_]
  not library.rule_self_only(b)
  has_public_cidr(b)
  library.rule_all_ports(b)
}

