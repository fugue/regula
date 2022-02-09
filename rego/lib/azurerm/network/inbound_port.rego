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
package azurerm.network.inbound_port

import data.fugue


# Check that trafic from "anywhere" to a specific inbound port is not allowed in
# `azurerm_network_security_group`s and `azurerm_network_security_rule`s.  For a
# usage example, see `inbound_port_3389.rego`.

# Is the port in this range?  The range can be specified as "*", "N-M", or "M".
in_port_range(port, range) {
  range == "*"
} {
  format_int(port, 10) == range
} {
  re_match("^[0-9]+-[0-9]+$", range)
  split(range, "-", [lo, hi])
  port >= to_number(lo)
  port <= to_number(hi)
}

# Check if a CIDR/network address space is the entire intergalacticnet.
is_intergalacticnet(network) {
  prefixes = {"*", "0.0.0.0", "<nw>/0", "/0", "internet", "any"}
  prefixes[network]
}

# Source address prefixes and destination port ranges can be specified under
# multiple keys...
get_source_address_prefixes(attributes) = ret {
  ret = array.concat(
    [x | x = attributes.source_address_prefix],
    [x | x = attributes.source_address_prefixes[_]]
  )
}

get_destination_port_ranges(attributes) = ret {
  ret = array.concat(
    [x | x = attributes.destination_port_range],
    [x | x = attributes.destination_port_ranges[_]]
  )
}

bad_inbound_rule(port, rule_attributes) {
  # No need to check if protocol is Tcp really.
  rule_attributes.access == "Allow"
  rule_attributes.direction == "Inbound"

  # Check the source address.
  source_address_prefixes = get_source_address_prefixes(rule_attributes)
  is_intergalacticnet(source_address_prefixes[_])

  # Check the destination port.
  destination_port_ranges = get_destination_port_ranges(rule_attributes)
  in_port_range(port, destination_port_ranges[_])
}

resources[id] = resource {
  security_rule := fugue.resources("azurerm_network_security_rule")[id]
  resource := {
    "resource": security_rule,
    "rules": [security_rule]
  }
}

resources[id] = resource {
  security_group := fugue.resources("azurerm_network_security_group")[id]
  resource := {
    "resource": security_group,
    "rules": [security_rule |
      security_rule := security_group.security_rule[_]
      _ := security_rule.access
    ]
  }
}

bad_inbound_resource(port, resource) {
  rule := resource.rules[_]
  bad_inbound_rule(port, rule)
}

inbound_port_policy(port) = ret {
  ret := {j |
    r := resources[_]
    bad_inbound_resource(port, r)
    j := fugue.deny_resource(r.resource)
  } | {j |
    r := resources[_]
    not bad_inbound_resource(port, r)
    j := fugue.allow_resource(r.resource)
  }
}
