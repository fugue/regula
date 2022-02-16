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

package rules.k8s_seccomp_profile

import data.fugue
import data.k8s

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "Pod seccomp profile should be set to 'docker/default'. The seccomp profile should be set to runtime/default or docker/default in pod definitions. The Secure Computing Mode (seccomp) in Linux is used to restrict which syscalls are allowed, which generally increases workload security. The docker/default profile was deprecated in Kubernetes 1.11 and runtime/default should now be used.",
  "id": "FG_R00495",
  "title": "Pod seccomp profile should be set to 'docker/default'"
}

input_type := "k8s"

resource_type := "MULTIPLE"

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
	obj := k8s.resources_with_pod_templates[_]
	seccomp_set(obj.pod_template)
	j := fugue.allow_resource(obj.resource)
}

policy[j] {
	obj := k8s.resources_with_pod_templates[_]
	not seccomp_set(obj.pod_template)
	j := fugue.deny_resource(obj.resource)
}
