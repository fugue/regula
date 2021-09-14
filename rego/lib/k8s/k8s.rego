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

package k8s

import data.fugue

# Incremental definition of resources_with_containers is found below.
# Resource types that may include container definitions include:
#  * ReplicaSet
#  * Job
#  * Pod
#  * DaemonSet
#  * StatefulSet
#  * Deployment

resources_with_containers[id] = ret {
	resources = fugue.resources("ReplicaSet")
	some id
	count(containers(resources[id])) > 0
	ret = resources[id]
}

resources_with_containers[id] = ret {
	resources = fugue.resources("Job")
	some id
	count(containers(resources[id])) > 0
	ret = resources[id]
}

resources_with_containers[id] = ret {
	resources = fugue.resources("Pod")
	some id
	count(containers(resources[id])) > 0
	ret = resources[id]
}

resources_with_containers[id] = ret {
	resources = fugue.resources("DaemonSet")
	some id
	count(containers(resources[id])) > 0
	ret = resources[id]
}

resources_with_containers[id] = ret {
	resources = fugue.resources("StatefulSet")
	some id
	count(containers(resources[id])) > 0
	ret = resources[id]
}

resources_with_containers[id] = ret {
	resources = fugue.resources("Deployment")
	some id
	count(containers(resources[id])) > 0
	ret = resources[id]
}

# Lists of container definitions can be found in different locations. This
# function returns one set of all containers defined for the given resource.
containers(resource) = ret {
	c1 := {c | c = resource.spec.containers[_]}
	c2 := {c | c = resource.spec.template.spec.containers[_]}
	c3 := {c | c = resource.spec.initContainers[_]}
	c4 := {c | c = resource.spec.template.spec.initContainers[_]}
	c5 := {c | c = resource.spec.jobTemplate.spec.template.spec.containers[_]}
	ret = (((c1 | c2) | c3) | c4) | c5
}

# Returns a set of capabilities added in the given container definition
added_capabilities(container) = ret {
	ret = { cap | cap := container.securityContext.capabilities.add[_] }
} else = ret {
	ret = set()
}

# Returns a set of capabilities dropped in the given container definition
dropped_capabilities(container) = ret {
    ret = { cap | cap := container.securityContext.capabilities.drop[_] }
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

# Easy access to any default service accounts
default_service_accounts[id] = ret {
	account := fugue.resources("ServiceAccount")[id]
	account.metadata.name == "default"
	ret = account
}

# Access the pod template in different locations depending on the resource type
pod_template(resource) = ret {
	resource.kind == "Pod"
	ret = resource
} else = ret {
	resource.kind == "CronJob"
	ret = resource.spec.jobTemplate.spec.template
} else = ret {
	others := {
		"Deployment",
		"DaemonSet",
		"StatefulSet",
		"ReplicaSet",
		"ReplicationController",
		"Job",
	}

	others[resource.kind]
	ret = resource.spec.template
}

# Incremental definition of a set of all resources that may contain pod templates
resources_with_pod_templates[resource] {
	resource := fugue.resources("Deployment")[_]
}

resources_with_pod_templates[resource] {
	resource := fugue.resources("DaemonSet")[_]
}

resources_with_pod_templates[resource] {
	resource := fugue.resources("StatefulSet")[_]
}

resources_with_pod_templates[resource] {
	resource := fugue.resources("ReplicaSet")[_]
}

resources_with_pod_templates[resource] {
	resource := fugue.resources("ReplicationController")[_]
}

resources_with_pod_templates[resource] {
	resource := fugue.resources("Job")[_]
}

resources_with_pod_templates[resource] {
	resource := fugue.resources("CronJob")[_]
}

resources_with_pod_templates[resource] {
	resource := fugue.resources("Pod")[_]
}
