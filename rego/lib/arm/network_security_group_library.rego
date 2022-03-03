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

# This helper rego code works for Azure "no ingress" rules.
# It is built on top of the terraform code that does the same,
# through a simple conversion (`rule_to_tf`).
package arm.network_security_group_library

import data.fugue
import data.azurerm.network.inbound_port as tf

rule_to_tf(arm_rule) = ret {
	# We only pass in the attributes we actually use.
	props = arm_rule.properties
	ret := {
		"access": props.access,
		"direction": props.direction,
		"destination_port_range": object.get(props, "destinationPortRange", null),
		"destination_port_ranges": object.get(props, "destinationPortRanges", []),
		"source_address_prefix": object.get(props, "sourceAddressPrefix", null),
		"source_address_prefixes": object.get(props, "sourceAddressPrefixes", null),
	}
}

rule_allows_anywhere_to_port(rule, bad_port) {
	tf.bad_inbound_rule(bad_port, rule_to_tf(rule))
}

group_allows_anywhere_to_port(group, bad_port) {
	rule = group.properties.securityRules[_]
	tf.bad_inbound_rule(bad_port, rule_to_tf(rule))
}

no_inbound_anywhere_to_port_policy(port) = ret {
	security_groups := fugue.resources("Microsoft.Network/networkSecurityGroups")
	security_groups_policy = {p |
		security_group := security_groups[_]
		group_allows_anywhere_to_port(security_group, port)
		p := fugue.deny_resource(security_group)
	} | {p |
		security_group := security_groups[_]
		not group_allows_anywhere_to_port(security_group, port)
		p := fugue.allow_resource(security_group)
	}

	security_rules := fugue.resources("Microsoft.Network/networkSecurityGroups/securityRules")
	security_rules_policy = {p |
		security_rule := security_rules[_]
		rule_allows_anywhere_to_port(security_rule, port)
		p := fugue.deny_resource(security_rule)
	} | {p |
		security_rule := security_rules[_]
		not rule_allows_anywhere_to_port(security_rule, port)
		p := fugue.allow_resource(security_rule)
	}

	ret := security_groups_policy | security_rules_policy
}
