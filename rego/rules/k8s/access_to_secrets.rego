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

package rules.k8s_access_to_secrets

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"id": "FG_R00480",
	"title": "Roles and cluster roles should not grant 'get', 'list', or 'watch' permissions for secrets",
	"description": "Roles and cluster roles should not grant 'get', 'list', or 'watch' permissions for secrets. RBAC resources in Kubernetes are used to grant access to get, list, and watch secrets on the Kubernetes API. Restrict use of these permissions to the smallest set of users and service accounts as possible.",
	"custom": {
		"controls": {
			"CIS-Kubernetes_v1.6.1": [
				"CIS-Kubernetes_v1.6.1_5.1.2"
			]
		},
		"severity": "Medium"
	}
}

input_type = "k8s"

resource_type = "MULTIPLE"

match_verbs = {"get", "list", "watch"}

is_invalid_rule(rule) {
	rule.resources[_] == "secrets"
	match_verbs[rule.verbs[_]]
}

is_invalid_role(role) {
	is_invalid_rule(role.rules[_])
}

is_invalid_binding(binding) {
	role := k8s.role_from_binding(binding)
	is_invalid_role(role)
}

policy[j] {
	resource := k8s.role_bindings[_]
	not is_invalid_binding(resource)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := k8s.role_bindings[_]
	is_invalid_binding(resource)
	j = fugue.deny_resource(resource)
}
