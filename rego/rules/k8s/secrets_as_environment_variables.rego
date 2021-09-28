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

package rules.k8s_secrets_as_environment_variables

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.4.1"]},
		"severity": "Medium",
	},
	"description": "Prefer using secrets as files over secrets as environment variables. Providing access to secrets via volume mounts is preferred. Any secrets stored in environment variables could be exposed if the environment is logged or otherwise exposed by an application.",
	"id": "FG_R00518",
	"title": "Prefer using secrets as files over secrets as environment variables",
}

input_type = "k8s"

resource_type = "MULTIPLE"

has_secret_key_ref(template) {
	ref := template.spec.containers[_].env[_].valueFrom.secretKeyRef
	ref.name
	ref.key
}

policy[j] {
	obj := k8s.resources_with_pod_templates[_]
	count(obj.pod_template.spec.containers) > 0
	not has_secret_key_ref(obj.pod_template)
	j = fugue.allow_resource(obj.resource)
}

policy[j] {
	obj := k8s.resources_with_pod_templates[_]
	count(obj.pod_template.spec.containers) > 0
	has_secret_key_ref(obj.pod_template)
	j = fugue.deny_resource(obj.resource)
}
