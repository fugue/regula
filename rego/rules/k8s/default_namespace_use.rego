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

package rules.k8s_default_namespace_use

import data.fugue

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.7.4"]},
		"severity": "Low",
	},
	"description": "The default namespace should not be used. Kubernetes cluster resources should be segregated by namespace to support security controls and resource management.",
	"id": "FG_R00524",
	"title": "The default namespace should not be used",
}

input_type = "k8s"

resource_type = "MULTIPLE"

namespaced_kinds = {
	"ConfigMap",
	"CronJob",
	"DaemonSet",
	"Deployment",
	"Ingress",
	"Job",
	"Pod",
	"ReplicaSet",
	"ReplicationController",
	"Role",
	"RoleBinding",
	"Secret",
	"Service",
	"ServiceAccount",
	"StatefulSet",
}

resources[id] = ret {
	kind := namespaced_kinds[_]
	kind_resources := fugue.resources(kind)
	ret := kind_resources[id]
}

is_invalid(resource) {
	resource.kind != "ServiceAccount"
	resource.kind != "Service"
	resource.metadata.namespace == "default"
}

is_invalid(resource) {
	resource.kind == "ServiceAccount"
	resource.metadata.name != "default"
	resource.metadata.namespace == "default"
}

is_invalid(resource) {
	resource.kind == "Service"
	resource.metadata.name != "kubernetes"
	resource.metadata.namespace == "default"
}

policy[j] {
	resource := resources[_]
	not is_invalid(resource)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := resources[_]
	is_invalid(resource)
	j = fugue.deny_resource(resource)
}
