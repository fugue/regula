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

package rules.k8s_host_network_namespace

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.2.4"]},
		"severity": "Medium",
	},
	"description": "Minimize the admission of containers wishing to share the host network namespace. A container that runs with hostNetwork set has the ability to interact with host services listening on localhost and potentially monitor traffic belonging to other pods. This opts-out of the network isolation provided by Linux network namespace mechanism.",
	"id": "FG_R00510",
	"title": "Minimize the admission of containers wishing to share the host network namespace",
}

input_type = "k8s"

resource_type = "MULTIPLE"

resources = k8s.resources_with_pod_templates

host_network_set(template) {
	template.spec.hostNetwork == true
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	not host_network_set(template)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	host_network_set(template)
	j = fugue.deny_resource(resource)
}
