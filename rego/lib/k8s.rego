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

package k8s

import data.fugue

# Resource types that may include container definitions include:
#  * ReplicaSet
#  * Job
#  * Pod
#  * DaemonSet
#  * StatefulSet
#  * Deployment
#
# This utility returns objects of the shape:
#
#     {
#       "resource": <original resource>,
#       "containers": [<non-empty list of containers>]
#     }
resources_with_containers[id] = ret {
	resource_types := {
		"ReplicaSet",
		"Job",
		"Pod",
		"DaemonSet",
		"StatefulSet",
		"Deployment",
	}

	resource := fugue.resources(resource_types[_])[id]
	containers := resource_containers(resource)
	_ = containers[_]
	ret = {"resource": resource, "containers": containers}
}

# Lists of container definitions can be found in different locations. This
# function returns one set of all containers defined for the given resource.
resource_containers(resource) = ret {
	c1 := {c | c = resource.spec.containers[_]}
	c2 := {c | c = resource.spec.template.spec.containers[_]}
	c3 := {c | c = resource.spec.initContainers[_]}
	c4 := {c | c = resource.spec.template.spec.initContainers[_]}
	c5 := {c | c = resource.spec.jobTemplate.spec.template.spec.containers[_]}
	ret = (((c1 | c2) | c3) | c4) | c5
}

# Returns a set of capabilities added in the given container definition
added_capabilities(container) = ret {
	ret = {cap | cap := container.securityContext.capabilities.add[_]}
} else = ret {
	ret = set()
}

# Returns a set of capabilities dropped in the given container definition
dropped_capabilities(container) = ret {
	ret = {cap | cap := container.securityContext.capabilities.drop[_]}
} else = ret {
	ret = set()
}

# Incremental definition of role_bindings to include both RoleBinding and
# ClusterRoleBinding resources
role_bindings[id] = ret {
	ret = fugue.resources("RoleBinding")[id]
}

role_bindings[id] = ret {
	ret = fugue.resources("ClusterRoleBinding")[id]
}

# Incremental definition of roles to include both Role and ClusterRole
roles[id] = ret {
	ret = fugue.resources("Role")[id]
}

roles[id] = ret {
	ret = fugue.resources("ClusterRole")[id]
}

# Finds the Role or ClusterRole for the given binding
role_from_binding(binding) = ret {
	role = fugue.resources(binding.roleRef.kind)[_]
	role.metadata.name == binding.roleRef.name
	ret = role
	# May need to add a namespace match condition in the future
}

# Easy access to any default service accounts
default_service_accounts[id] = ret {
	account := fugue.resources("ServiceAccount")[id]
	account.metadata.name == "default"
	ret = account
}

# Access the pod template in different locations depending on the resource type.
# Returns an object of the shape:
#
#     {
#       "resource": <original resource>,
#       "pod_template": <pod template>
#     }
resources_with_pod_templates[id] = ret {
	resource := fugue.resources("Pod")[id]
	ret := {"resource": resource, "pod_template": resource}
}

resources_with_pod_templates[id] = ret {
	resource := fugue.resources("CronJob")[id]
	ret := {
		"resource": resource,
		"pod_template": resource.spec.jobTemplate.spec.template,
	}
}

resources_with_pod_templates[id] = ret {
	others_types := {
		"Deployment",
		"DaemonSet",
		"StatefulSet",
		"ReplicaSet",
		"ReplicationController",
		"Job",
	}

	resource := fugue.resources(others_types[_])[id]
	ret := {
		"resource": resource,
		"pod_template": resource.spec.template,
	}
}
