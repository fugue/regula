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
package rules.tf_aws_security_group_ingress_anywhere

import data.aws.security_groups.library as sglib

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "VPC security group rules should not permit ingress from '0.0.0.0/0' except to ports 80 and 443. VPC firewall rules should not permit unrestricted access from the internet, with the exception of port 80 (HTTP) and port 443 (HTTPS). Web applications or APIs generally need to be publicly accessible.",
  "id": "FG_R00377",
  "title": "VPC security group rules should not permit ingress from '0.0.0.0/0' except to ports 80 and 443"
}

resource_type := "aws_security_group"

whitelisted_ports = {80, 443}

whitelisted_ingress_rule(rule) {
  rule.from_port == rule.to_port
  whitelisted_ports[rule.from_port]
}

bad_ingress_rule(rule) {
  sglib.rule_zero_cidr(rule)
  not sglib.rule_self_only(rule)
  not whitelisted_ingress_rule(rule)
}

default deny = false

deny {
  rule = input.ingress[_]
  bad_ingress_rule(rule)
}
