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
	"id": "FG_R00482",
	"title": "Roles and cluster roles should not grant 'create' permissions for pods",
	"description": "Roles and cluster roles should not grant 'create' permissions for pods. Minimize access to create pods for RBAC roles. Privilege escalation is possible when these permissions are available, since the created pods could be assigned privileged service accounts or have access to sensitive data. Avoid granting pod creation privileges by default.",
	"custom": {
		"controls": {
			"CIS-Kubernetes_v1.6.1": [
				"CIS-Kubernetes_v1.6.1_5.1.4"
			]
		},
		"severity": "Medium"
	}
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
