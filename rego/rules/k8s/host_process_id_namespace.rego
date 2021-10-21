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

package rules.k8s_host_process_id_namespace

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"id": "FG_R00486",
	"title": "Pods should not run containers wishing to share the host process ID namespace",
	"description": "Pods should not run containers wishing to share the host process ID namespace. A container that runs with hostPID set has visibility into processes running on the host, which could expose information including environment variables to an attacker.",
	"custom": {
		"controls": {
			"CIS-Kubernetes_v1.6.1": [
				"CIS-Kubernetes_v1.6.1_5.2.2"
			]
		},
		"severity": "Medium"
	}
}

input_type = "k8s"

resource_type = "MULTIPLE"

host_pid_set(template) {
	template.spec.hostPID == true
}

policy[j] {
	obj := k8s.resources_with_pod_templates[_]
	not host_pid_set(obj.pod_template)
	j = fugue.allow_resource(obj.resource)
}

policy[j] {
	obj := k8s.resources_with_pod_templates[_]
	host_pid_set(obj.pod_template)
	j = fugue.deny_resource(obj.resource)
}
