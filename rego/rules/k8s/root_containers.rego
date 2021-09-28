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

package rules.k8s_root_containers

import data.fugue
import data.k8s

# This rule confirms whether the combination of runAsUser and runAsNonRoot
# settings are correctly used at the Pod and/or container level in a template.
# Passes if (runAsUser > 0 || runAsNonRoot) for each container, where the top
# level securityContext is applied if container overrides are not present.

__rego__metadoc__ := {
	"custom": {
		"controls": {"CIS-Kubernetes_v1.6.1": ["CIS-Kubernetes_v1.6.1_5.2.6"]},
		"severity": "Medium",
	},
	"description": "Containers should explicitly be configured to use a non-root user. Running as a non-root user helps ensure that an attacker does not gain root privileges to the host system in the event of a container breakout.",
	"id": "FG_R00512",
	"title": "Containers should explicitly be configured to use a non-root user",
}

input_type = "k8s"

resource_type = "MULTIPLE"

# Determines the value of "runAsNonRoot" that is in effect for a container.
# Defaults to false if the value is not explicitly set.
run_as_non_root(spec, container) = ret {
	# The case where runAsNonRoot is set on the container securityContext
	containerCtx := object.get(container, "securityContext", {})
	containerVal := object.get(containerCtx, "runAsNonRoot", null)
	containerVal != null
	ret := containerVal
} else = ret {
	# The case where runAsNonRoot is set only on the pod securityContext
	podCtx := object.get(spec, "securityContext", {})
	podVal := object.get(podCtx, "runAsNonRoot", null)
	podVal != null
	ret := podVal
} else = ret {
	# runAsNonRoot is not specified, so it assumes a default value of false
	ret := false
}

# Determines the value of "runAsUser" that is in effect for a container.
# Defaults to "unknown" if the value is not explicitly set.
run_as_user(spec, container) = ret {
	# The case where runAsUser is set on the container securityContext
	containerCtx := object.get(container, "securityContext", {})
	containerVal := object.get(containerCtx, "runAsUser", null)
	containerVal != null
	ret := containerVal
} else = ret {
	# The case where runAsUser is set only on the pod securityContext
	podCtx := object.get(spec, "securityContext", {})
	podVal := object.get(podCtx, "runAsUser", null)
	podVal != null
	ret := podVal
} else = ret {
	# runAsUser is not specified, so it assumes a default value of "unknown"
	ret := "unknown"
}

# User ID 0 is root
dangerous_users = {0, "unknown"}

# Whether a specific container can run as root
can_run_as_root(template, container) {
	# runAsNonRoot prevents running as root if it is set to true
	run_as_non_root(template.spec, container) != true

	# user ID 0 and an unknown user are both considered dangerous
	dangerous_users[run_as_user(template.spec, container)]
}

# Whether ANY container can run as root
any_invalid_containers(template) {
	can_run_as_root(template, template.spec.containers[_])
}

policy[j] {
	obj := k8s.resources_with_pod_templates[_]
	count(obj.pod_template.spec.containers) > 0
	not any_invalid_containers(obj.pod_template)
	j := fugue.allow_resource(obj.resource)
}

policy[j] {
	obj := k8s.resources_with_pod_templates[_]
	count(obj.pod_template.spec.containers) > 0
	any_invalid_containers(obj.pod_template)
	j := fugue.deny_resource(obj.resource)
}
