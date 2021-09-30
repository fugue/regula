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
package tests.rules.k8s.privileged_containers.inputs.valid_example_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "k8s_resource_view_version": "0.0.1",
  "resources": {
    "Pod.default.privileged": {
      "apiVersion": "v1",
      "kind": "Pod",
      "metadata": {
        "name": "privileged"
      },
      "spec": {
        "containers": [
          {
            "image": "k8s.gcr.io/pause",
            "name": "pause1"
          },
          {
            "image": "k8s.gcr.io/pause",
            "name": "pause2"
          }
        ]
      }
    }
  }
}

