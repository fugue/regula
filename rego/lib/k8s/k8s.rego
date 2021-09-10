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

resources_with_containers[id] = ret {
	clusters = fugue.resources("ReplicaSet")
	ret = clusters[id]
}

resources_with_containers[id] = ret {
	clusters = fugue.resources("Job")
	ret = clusters[id]
}

resources_with_containers[id] = ret {
	clusters = fugue.resources("Pod")
	ret = clusters[id]
}

resources_with_containers[id] = ret {
	instances = fugue.resources("DaemonSet")
	ret = instances[id]
}

resources_with_containers[id] = ret {
	clusters = fugue.resources("StatefulSet")
	ret = clusters[id]
}

resources_with_containers[id] = ret {
	clusters = fugue.resources("Deployment")
	ret = clusters[id]
}

containers(resource) = ret {
    ret = resource.spec.containers
} else = ret {
    ret = resource.spec.template.spec.containers
}
