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

package rules.k8s_security_context

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.7.3"]},
		"severity": "Low",
	},
	"description": "Apply a security context to Pods and Containers. A security context controls a variety of settings for access control, Linux capabilities, and privileges. The security context may be set at the Pod or the Container level. Reference the Kubernetes documentation for specific recommendations for each setting.",
	"id": "FG_R00523",
	"title": "Apply a security context to Pods and Containers",
}

input_type = "k8s"

resource_type = "MULTIPLE"

resources = k8s.resources_with_pod_templates

has_pod_security_context(template) {
	template.spec.securityContext[_]
}

has_container_security_contexts(template) {
	valid_containers := {c |
		c := template.spec.containers[_]
		c.securityContext[_]
	}

	count(valid_containers) == count(template.spec.containers)
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	count(template.spec.containers) > 0
	has_pod_security_context(template)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	count(template.spec.containers) > 0
    not has_pod_security_context(template)
	has_container_security_contexts(template)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	count(template.spec.containers) > 0
	not has_pod_security_context(template)
	not has_container_security_contexts(template)
	j = fugue.deny_resource(resource)
}
