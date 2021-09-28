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

package rules.k8s_added_capabilities

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.2.8"]},
		"severity": "Medium",
	},
	"description": "Minimize the admission of containers with added capabilities. Adding capabilities beyond the default set increases the risk of container breakout attacks. In most cases, applications are able to operate normally with all Linux capabilities dropped, or with the default set of capabilities.",
	"id": "FG_R00514",
	"title": "Minimize the admission of containers with added capabilities",
}

input_type = "k8s"

resource_type = "MULTIPLE"

is_invalid(obj) {
	count(k8s.added_capabilities(obj.containers[_])) > 0
}

policy[j] {
	obj := k8s.resources_with_containers[_]
	not is_invalid(obj)
	j = fugue.allow_resource(obj.resource)
}

policy[j] {
	obj := k8s.resources_with_containers[_]
	is_invalid(obj)
	j = fugue.deny_resource(obj.resource)
}
