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

package rules.k8s_default_service_account_tokens

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.1.5"]},
		"severity": "Medium",
	},
	"description": "",
	"id": "FG_R00505",
	"title": "Opt out of automounting API credentials for the default service account",
}

input_type = "k8s"

resource_type = "MULTIPLE"

# This rule specifically checks for the following portion of 5.1.5. This may be
# applicable primarily at runtime. "Additionally ensure that the
# automountServiceAccountToken: false setting is in place for each default
# service account."
# https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account

is_valid(resource) {
    # Require this to be explicitly set to false, since it defaults to true
    resource.automountServiceAccountToken == false
}

policy[j] {
	resource := k8s.default_service_accounts[_]
	is_valid(resource)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := k8s.default_service_accounts[_]
	not is_valid(resource)
	j = fugue.deny_resource(resource)
}
