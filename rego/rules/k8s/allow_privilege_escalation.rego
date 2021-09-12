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

package rules.k8s_allow_privilege_escalation

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.2.5"]},
		"severity": "Medium",
	},
	"description": "Minimize the admission of containers with allowPrivilegeEscalation. This setting controls whether a process can gain more privileges than its parent process. Set allowPrivilegeEscalation to false unless it is absolutely required.",
	"id": "FG_R00511",
	"title": "Minimize the admission of containers with allowPrivilegeEscalation.",
}

input_type = "k8s"

resource_type = "MULTIPLE"

resources = k8s.resources_with_pod_templates

any_invalid_containers(template) {
	template.spec.containers[_].securityContext.allowPrivilegeEscalation == true
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	count(template.spec.containers) > 0
	not any_invalid_containers(template)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	count(template.spec.containers) > 0
	any_invalid_containers(template)
	j = fugue.deny_resource(resource)
}
