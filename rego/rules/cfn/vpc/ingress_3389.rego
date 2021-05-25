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
package rules.cfn_vpc_ingress_3389

import data.fugue
import data.cfn.security_group_library

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_4.2"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_5.2"
      ]
    },
    "severity": "High"
  },
  "description": "VPC security group rules should not permit ingress from '0.0.0.0/0' to port 3389 (Remote Desktop Protocol). Removing unfettered connectivity to remote console services, such as Remote Desktop Protocol, reduces a server's exposure to risk.",
  "id": "FG_R00087",
  "title": "VPC security group rules should not permit ingress from '0.0.0.0/0' to port 3389 (Remote Desktop Protocol)"
}

input_type = "cloudformation"
resource_type = "MULTIPLE"

policy[p] {
  rule = security_group_library.ingress_rules[_]
  not security_group_library.rule_zero_cidr_includes_port(rule, 3389)
  p = fugue.allow_resource(rule.resource)
} {
  rule = security_group_library.ingress_rules[_]
  security_group_library.rule_zero_cidr_includes_port(rule, 3389)
  p = fugue.deny_resource(rule.resource)
}
