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

# Lists of container definitions can be found in 4 different locations. This
# function returns one set of all containers defined for the given resource.
containers(resource) = ret {
	c1 := {c | c = resource.spec.containers[_]}
	c2 := {c | c = resource.spec.template.spec.containers[_]}
	c3 := {c | c = resource.spec.initContainers[_]}
	c4 := {c | c = resource.spec.template.spec.initContainers[_]}
	ret = ((c1 | c2) | c3) | c4
}

# Returns a list of capabilities added to the given container definition
added_capabilities(container) = ret {
	ret = container.securityContext.capabilities.add
} else = ret {
	ret = {}
}
