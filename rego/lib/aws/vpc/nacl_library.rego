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
package aws.vpc.nacl_library

import data.fugue

ingress_for_nacl[id] = nacl_rules {
  # aws_network_acl_rule is not currently supported. 
  # This check ensures the library will function.
  fugue.input_resource_types["aws_network_acl_rule"]
  
  rules = fugue.resources("aws_network_acl_rule")
  nacls = fugue.resources("aws_network_acl")
  nacl = nacls[_]

  id = nacl.id
  nacl_rules = array.concat(
    # Inline
    object.get(nacl, "ingress", []),
    # External
    [rule |
      rule = rules[_]
      not object.get(rule, "egress", false)
      rule.network_acl_id = nacl.id
    ]
  )
} {
  not fugue.input_resource_types["aws_network_acl_rule"]
  nacls = fugue.resources("aws_network_acl")
  nacl = nacls[_]
  id = nacl.id
  nacl_rules = nacl.ingress
}

# Returns true if the given cidr is all zeroes
zero_cidr(cidr) {cidr == "0.0.0.0/0"} {cidr == "::/0"}

# Returns the list of rules for a nacl for a given port open to the world
ingress_zero_cidr_by_port(nacl, port) = ret {
  ret = ingress_for_nacl[nacl.id]
  zero_cidr(ret[i].cidr_block)
  ret[i].from_port <= port
  ret[i].to_port >= port
} {
  ret = ingress_for_nacl[nacl.id]
  zero_cidr(ret[i].cidr_block)
  ret[i].from_port == 0
  ret[i].to_port == 0
}

# Returns the lowest ALLOW numbered rule for a nacl by port open to the world
lowest_allow_ingress_zero_cidr_by_port(nacl, port) = ret {
  rules = ingress_zero_cidr_by_port(nacl, port)
  rule = rules[_]
  arr_rule_nos = [ rule_no |
    rule_no = rule_number(rule)
    rule_action(rule) == "allow"
  ]
  # Workaround due to bug in min() where it returns null
  # Use this line after fregot is upgraded
  # ret = min(arr_rule_nos)
  sorted = sort(arr_rule_nos)
  ret = sorted[0]
}

# Returns the lowest DENY numbered rule for a nacl by port open to the world
lowest_deny_ingress_zero_cidr_by_port(nacl, port) = ret {
  rules = ingress_zero_cidr_by_port(nacl, port)
  rule = rules[_]
  arr_rule_nos = [ rule_no |
    rule_no = rule_number(rule)
    rule_action(rule) == "deny"
  ]
  # Workaround due to bug in min() where it returns null
  # Use this line after fregot is upgraded
  # ret = min(arr_rule_nos)
  sorted = sort(arr_rule_nos)
  ret = sorted[0]
}

rule_number(rule) = ret {
  not rule.rule_number
  ret = rule.rule_no
} {
  not rule.rule_no
  ret = rule.rule_number
}

rule_action(rule) = ret {
  not rule.action
  ret = rule.rule_action
} {
  not rule.rule_action
  ret = rule.action
}
