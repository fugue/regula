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

package rules.k8s_privileged_containers

import data.k8s
import data.tests.rules.k8s.privileged_containers.inputs

test_valid {
	pol := policy with input as inputs.valid_example_yaml.mock_input
	resources := {p.id: p.valid | p := pol[_]}
	resources["Pod.privileged"] == true
}

test_invalid {
	pol := policy with input as inputs.invalid_example_yaml.mock_input
	resources := {p.id: p.valid | p := pol[_]}
	resources["Pod.privileged"] == false
}
