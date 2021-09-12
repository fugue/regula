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

package rules.k8s_privileged_containers

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.2.1"]},
		"severity": "High",
	},
	"description": "Minimize the admission of privileged containers. Running containers with full privileges should only be done in exceptional situations in which accessing resources and kernel capabilities of the host system is required. An attacker may be able to use a vulnerability in a privileged pod to directly attack the host.",
	"id": "FG_R00507",
	"title": "Minimize the admission of privileged containers",
}

input_type = "k8s"

resource_type = "MULTIPLE"

resources = k8s.resources_with_pod_templates

any_invalid_containers(spec) {
	spec.containers[_].securityContext.privileged == true
}

policy[j] {
	resource := resources[_]
	spec := k8s.pod_template(resource)
	count(spec.containers) > 0
	not any_invalid_containers(spec)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := resources[_]
	spec := k8s.pod_template(resource)
	count(spec.containers) > 0
	any_invalid_containers(spec)
	j = fugue.deny_resource(resource)
}
