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

package rules.k8s_cluster_admin_role_use

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"id": "FG_R00479",
	"title": "The 'cluster-admin' role should not be used",
	"description": "The 'cluster-admin' role should not be used. The 'cluster-admin' role comes with super-user level access which can be used to manipulate all resources in the cluster. Avoid using this role unless it's absolutely necessary.",
	"custom": {
		"controls": {
			"CIS-Kubernetes_v1.6.1": [
				"CIS-Kubernetes_v1.6.1_5.1.1"
			]
		},
		"severity": "High"
	}
}

input_type = "k8s"

resource_type = "MULTIPLE"

is_invalid(resource) {
	resource.roleRef.name == "cluster-admin"
}

policy[j] {
	resource := k8s.role_bindings[_]
	not is_invalid(resource)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := k8s.role_bindings[_]
	is_invalid(resource)
	j = fugue.deny_resource(resource)
}
