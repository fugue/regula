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

package rules.k8s_host_ipc_namespace

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.2.3"]},
		"severity": "Medium",
	},
	"description": "Minimize the admission of containers wishing to share the host IPC namespace. A container that runs with hostIPC set has the ability to interact with processes running on the host via shared memory and other interprocess communication (IPC) mechanisms.",
	"id": "FG_R00509",
	"title": "Minimize the admission of containers wishing to share the host IPC namespace",
}

input_type = "k8s"

resource_type = "MULTIPLE"

resources = k8s.resources_with_pod_templates

host_ipc_set(template) {
	template.spec.hostIPC == true
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	not host_ipc_set(template)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	host_ipc_set(template)
	j = fugue.deny_resource(resource)
}