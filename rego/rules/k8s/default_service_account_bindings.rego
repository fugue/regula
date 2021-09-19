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

package rules.k8s_default_service_account_bindings

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.1.5"]},
		"severity": "Medium",
	},
	"description": "Roles and cluster roles should not be bound to the default service account. Dedicated service accounts should be created for each workload with appropriate rights assigned.",
	"id": "FG_R005XY",
	"title": "Roles and cluster roles should not be bound to the default service account",
}

input_type = "k8s"

resource_type = "MULTIPLE"

# This rule specifically checks for the following portion of 5.1.5:
# "For each namespace in the cluster, review the rights assigned to the default
# service account and ensure that it has no roles or cluster roles bound to it
# apart from the defaults."

is_invalid(resource) {
    # subjects:
    # - kind: ServiceAccount
    #   name: default
    #   namespace: kube-system
    some i
    resource.subjects[i].name == "default"
    resource.subjects[i].kind == "ServiceAccount"
}

policy[j] {
	resource := k8s.role_bindings[_]
	not is_invalid(resource)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := k8s.role_bindings[_]
	is_invalid(resource)
	j = fugue.deny_resource(resource)
}
