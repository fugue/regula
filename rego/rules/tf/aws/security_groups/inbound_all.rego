# Copyright 2020-2022 Fugue, Inc.
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
    "severity": "High"
  },
  "description": "VPC security group inbound rules should not permit ingress from a public address to all ports and protocols. Security groups provide stateful filtering of ingress/egress network traffic to AWS resources. AWS recommends that no security groups explicitly allow inbound ports.",
  "id": "FG_R00044",
  "title": "VPC security group inbound rules should not permit ingress from a public address to all ports and protocols"
}

resource_type := "MULTIPLE"

security_groups := fugue.resources("aws_security_group")

ingress_security_group_rules[rule_id] = rule {
    fugue.input_resource_types["aws_security_group_rule"]
    rules = fugue.resources("aws_security_group_rule")
    rule = rules[rule_id]
    lower(rule.type) == "ingress"
}

has_public_cidr(b) {
    cidr.public_cidr(b.cidr_blocks[_])
} {
    cidr.public_cidr(b.ipv6_cidr_blocks[_])
}

deny_security_group_rule(rule) {
    not library.rule_self_only(rule)
    has_public_cidr(rule)
    library.rule_all_ports(rule)
}

deny_security_group(security_group) {
    rule = security_group.ingress[_]
    deny_security_group_rule(rule)
}

policy[p] {
    security_group := security_groups[_]
    deny_security_group(security_group)
    p := fugue.deny_resource(security_group)
} {
    security_group := security_groups[_]
    not deny_security_group(security_group)
    p := fugue.allow_resource(security_group)
}

policy[p] {
    security_group_rule := ingress_security_group_rules[_]
    deny_security_group_rule(security_group_rule)
    p := fugue.deny_resource(security_group_rule)
} {
    security_group_rule := ingress_security_group_rules[_]
    not deny_security_group_rule(security_group_rule)
    p := fugue.allow_resource(security_group_rule)
}
