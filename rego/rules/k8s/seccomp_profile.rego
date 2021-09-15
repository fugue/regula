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

package rules.k8s_seccomp_profile

import data.fugue
import data.k8s

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.7.2"]},
		"severity": "Medium",
	},
	"description": "The seccomp profile should be set to runtime/default or docker/default in pod definitions. The Secure Computing Mode (seccomp) in Linux is used to restrict which syscalls are allowed, which generally increases workload security. The docker/default profile was deprecated in Kubernetes 1.11 and runtime/default should now be used.",
	"id": "FG_R00522",
	"title": "The seccomp profile should be set to runtime/default or docker/default in pod definitions",
}

input_type = "k8s"

resource_type = "MULTIPLE"

resources = k8s.resources_with_pod_templates

# https://kubernetes.io/docs/concepts/policy/pod-security-policy/#seccomp
# The Docker default seccomp profile is used. Deprecated as of Kubernetes 1.11.
# Use runtime/default instead.
approved_profiles = {
    "docker/default",
    "runtime/default",
}

seccomp_set(template) {
    annotations := template.metadata.annotations
	profile := annotations["seccomp.security.alpha.kubernetes.io/pod"]
    approved_profiles[profile]
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	seccomp_set(template)
	j = fugue.allow_resource(resource)
}

policy[j] {
	resource := resources[_]
	template := k8s.pod_template(resource)
	not seccomp_set(template)
	j = fugue.deny_resource(resource)
}
