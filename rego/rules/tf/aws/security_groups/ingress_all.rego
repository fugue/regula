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
package rules.tf_aws_security_groups_ingress_all

import data.aws.security_groups.library
import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "High"
  },
  "description": "VPC security group inbound rules should not permit ingress from '0.0.0.0/0' to all ports and protocols. Security groups provide stateful filtering of ingress/egress network traffic to AWS resources. AWS recommends that no security group allows unrestricted ingress access from 0.0.0.0/0 to all ports. Removing unfettered connectivity to remote console services reduces a server's exposure to risk.",
  "id": "FG_R00045",
  "title": "VPC security group inbound rules should not permit ingress from '0.0.0.0/0' to all ports and protocols"
}

security_groups = fugue.resources("aws_security_group")

invalid_security_group(sg) {
  ingress = sg.ingress[_]
  library.rule_all_ports(ingress)
  library.rule_zero_cidr(ingress)
}

resource_type = "MULTIPLE"

policy[j] {
  sg = security_groups[_]
  invalid_security_group(sg)
  j = fugue.deny_resource(sg)
} {
  sg = security_groups[_]
  not invalid_security_group(sg)
  j = fugue.allow_resource(sg)
}

