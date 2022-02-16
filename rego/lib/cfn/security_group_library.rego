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
package cfn.security_group_library

import data.fugue

ingress_rules[ret] {
  sg = fugue.resources("AWS::EC2::SecurityGroup")[_]
  rule = sg.SecurityGroupIngress[_]
  ret = {"rule": rule, "resource": sg}
} {
  sgi = fugue.resources("AWS::EC2::SecurityGroupIngress")[_]
  ret = {"rule": sgi, "resource": sgi}
}

rule_zero_cidr(rule) {
  rule.rule.CidrIp == "0.0.0.0/0"
} {
  rule.rule.CidrIpv6 == "::/0"
}

rule_includes_port(rule, port) {
  rule.rule.FromPort < 0
} {
  rule.rule.ToPort < 0
} {
  rule.rule.FromPort <= port
  rule.rule.ToPort >= port
}

rule_zero_cidr_includes_port(rule, port) {
  rule_zero_cidr(rule)
  rule_includes_port(rule, port)
}
