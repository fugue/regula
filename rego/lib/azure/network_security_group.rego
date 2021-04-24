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

# This helper rego code works for Azure "no ingress" rules
package fugue.azure.network_security_group

rule_allows_anywhere_to_port(rule, bad_port) {
  rule.access == "Allow"
  rule.direction == "Inbound"
  rule_includes_destination_port(rule, bad_port)
  rule_has_anywhere_source(rule)
}

group_allows_anywhere_to_port(group, bad_port) {
  rules_block = group.security_rule[_]
  rule_allows_anywhere_to_port(rules_block, bad_port)
}

rule_includes_destination_port(rule, bad_port) {
  port_range_includes_port(rule.destination_port_range, bad_port)
} {
  port_range_includes_port(rule.destination_port_ranges[_], bad_port)
}

port_range_includes_port(port_range, bad_port) {
  port_range == "*"
} {
  port_range == format_int(bad_port, 10)
} {
  is_string(port_range)
  contains(port_range, "-")
  split(port_range, "-", [lo, hi])
  bad_port >= to_number(lo)
  bad_port <= to_number(hi)
}

rule_has_anywhere_source(rule) {
  is_anywhere_source(rule.source_address_prefix)
} {
  is_anywhere_source(rule.source_address_prefixes[_])
}

is_anywhere_source(source_prefix) {
  is_string(source_prefix)
  anywhere_sources[lower(source_prefix)]
}

# See <https://docs.microsoft.com/en-us/azure/virtual-network/security-overview#security-rules>
anywhere_sources =  {"*", "0.0.0.0", "0.0.0.0/0", "::/0", "internet", "any"}
