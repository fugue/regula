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

package rules.k8s_capabilities_assigned

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"id": "FG_R00493",
	"title": "Pods should not run containers with default capabilities assigned",
	"description": "Pods should not run containers with default capabilities assigned. A default set of Linux capabilities are granted when a container runs and many services do not need these capabilities to function. The recommended strategy is to drop all capabilities and then add back only the required ones, according to the principal of least privilege.",
	"custom": {
		"controls": {
			"CIS-Kubernetes_v1.6.1": [
				"CIS-Kubernetes_v1.6.1_5.2.9"
			]
		},
		"severity": "Medium"
	}
}

input_type = "k8s"

resource_type = "MULTIPLE"

# At least one of these capabilities needs to be explicitly dropped to pass
capabilities = {
	"all",
	"ALL",
}

is_valid_container(container) {
	dropped := k8s.dropped_capabilities(container)
	count(dropped & capabilities) >= 1
}

# Confirm every container drops one of the above capabilities
is_invalid(obj) {
	container = obj.containers[_]
	not is_valid_container(container)
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
