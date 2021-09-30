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
package tests.rules.k8s.root_containers.inputs.invalid_example_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "k8s_resource_view_version": "0.0.1",
  "resources": {
    "Pod.default.invalid1": {
      "apiVersion": "v1",
      "kind": "Pod",
      "metadata": {
        "name": "invalid1"
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
    },
    "Pod.default.invalid2": {
      "apiVersion": "v1",
      "kind": "Pod",
      "metadata": {
        "name": "invalid2"
      },
      "spec": {
        "containers": [
          {
            "image": "k8s.gcr.io/pause",
            "name": "pause1",
            "securityContext": {
              "runAsNonRoot": true,
              "runAsUser": 1001
            }
          },
          {
            "image": "k8s.gcr.io/pause",
            "name": "pause2"
          }
        ]
      }
    },
    "Pod.default.invalid3": {
      "apiVersion": "v1",
      "kind": "Pod",
      "metadata": {
        "name": "invalid3"
      },
      "spec": {
        "containers": [
          {
            "image": "k8s.gcr.io/pause",
            "name": "pause1",
            "securityContext": {
              "runAsUser": 0
            }
          },
          {
            "image": "k8s.gcr.io/pause",
            "name": "pause2",
            "securityContext": {
              "runAsUser": 1001
            }
          }
        ]
      }
    },
    "Pod.default.invalid4": {
      "apiVersion": "v1",
      "kind": "Pod",
      "metadata": {
        "name": "invalid4"
      },
      "spec": {
        "containers": [
          {
            "image": "k8s.gcr.io/pause",
            "name": "pause1"
          }
        ],
        "securityContext": {
          "runAsUser": 0
        }
      }
    },
    "Pod.default.invalid5": {
      "apiVersion": "v1",
      "kind": "Pod",
      "metadata": {
        "name": "invalid5"
      },
      "spec": {
        "containers": [
          {
            "image": "k8s.gcr.io/pause",
            "name": "pause1",
            "securityContext": {
              "runAsNonRoot": false
            }
          },
          {
            "image": "k8s.gcr.io/pause",
            "name": "pause2",
            "securityContext": {
              "runAsUser": 0
            }
          }
        ],
        "securityContext": {
          "runAsNonRoot": false
        }
      }
    }
  }
}

