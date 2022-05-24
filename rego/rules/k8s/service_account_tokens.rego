# Copyright 2020-2022 Fugue, Inc.
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

package rules.k8s_service_account_tokens

import data.fugue
import data.k8s

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "Service account 'automountServiceAccountToken' should be set to 'false'. Avoid automounting service account tokens. Service account tokens are used to authenticate requests from in-cluster processes to the Kubernetes API server. Many workloads do not need to communicate with the API server and hence should have automountServiceAccountToken set to false.",
  "id": "FG_R00484",
  "title": "Service account 'automountServiceAccountToken' should be set to 'false'"
}

input_type := "k8s"

resource_type := "MULTIPLE"

is_valid(spec) {
	spec.automountServiceAccountToken == false
}

policy[j] {
	obj := k8s.resources_with_pod_templates[_]
	count(obj.pod_template.spec.containers) > 0
	is_valid(obj.pod_template.spec)
	j = fugue.allow_resource(obj.resource)
}

policy[j] {
	obj := k8s.resources_with_pod_templates[_]
	count(obj.pod_template.spec.containers) > 0
	not is_valid(obj.pod_template.spec)
	j = fugue.deny_resource(obj.resource)
}

policy[j] {
	resource := fugue.resources("ServiceAccount")[_]
	is_valid(resource)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := fugue.resources("ServiceAccount")[_]
	not is_valid(resource)
	j = fugue.deny_resource(resource)
}
