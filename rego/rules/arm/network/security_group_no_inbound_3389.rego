# Copyright 2021 Fugue, Inc.
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

package rules.arm_network_security_group_no_inbound_3389

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00190",
	"title": "Virtual Network security groups should not permit ingress from '0.0.0.0/0' to TCP/UDP port 3389 (RDP)",
	"description": "The potential security problem with using RDP over the Internet is that attackers can use various brute force techniques to gain access to Azure Virtual Machines. Once the attackers gain access, they can use a virtual machine as a launch point for compromising other machines on an Azure Virtual Network or even attack networked devices outside of Azure.",
	"custom": {
		"controls": {},
		"severity": "High",
	},
}

input_type = "arm"

resource_type = "MULTIPLE"

resources = fugue.resources("Microsoft.Network/networkSecurityGroups")

is_invalid(resource) {
	resource.TODO == "TODO" # FIXME
}

policy[p] {
	resource = resources[_]
	reason = is_invalid(resource)
	p = fugue.deny_resource(resource)
}

policy[p] {
	resource = resources[_]
	not is_invalid(resource)
	p = fugue.allow_resource(resource)
}
