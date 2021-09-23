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

package rules.k8s_access_to_create_pods

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.1.4"]},
		"severity": "Medium",
	},
	"description": "Minimize access to create pods. Privilege escalation is possible when these permissions are available, since the created pods could be assigned privileged service accounts or have access to sensitive data. Avoid granting pod creation privileges by default.",
	"id": "FG_R00504",
	"title": "Minimize access to create pods",
}

input_type = "k8s"

resource_type = "MULTIPLE"

is_invalid_rule(rule) {
	rule.resources[_] == "pods"
	rule.verbs[_] == "create"
}

is_invalid(role) {
	is_invalid_rule(role.rules[_])
}

policy[j] {
	role := k8s.roles[_]
	not is_invalid(role)
	j = fugue.allow_resource(role)
}

policy[j] {
	role := k8s.roles[_]
	is_invalid(role)
	j = fugue.deny_resource(role)
}
