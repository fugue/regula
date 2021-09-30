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
package tests.rules.k8s.default_namespace_use.inputs.invalid_example_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "k8s_resource_view_version": "0.0.1",
  "resources": {
    "Job.default.invalid2": {
      "apiVersion": "batch/v1",
      "kind": "Job",
      "metadata": {
        "name": "invalid2",
        "namespace": "default"
      },
      "spec": {
        "backoffLimit": 4,
        "template": {
          "spec": {
            "automountServiceAccountToken": false,
            "containers": [
              {
                "command": [
                  "perl",
                  "-Mbignum=bpi",
                  "-wle",
                  "print bpi(2000)"
                ],
                "image": "perl",
                "name": "pi"
              }
            ],
            "restartPolicy": "Never"
          }
        }
      }
    },
    "Pod.default.invalid1": {
      "apiVersion": "v1",
      "kind": "Pod",
      "metadata": {
        "labels": {
          "app": "myapp"
        },
        "name": "invalid1",
        "namespace": "default"
      },
      "spec": {
        "automountServiceAccountToken": false,
        "containers": [
          {
            "command": [
              "sh",
              "-c",
              "echo The app is running! && sleep 3600"
            ],
            "image": "busybox:1.28",
            "name": "myapp-container"
          }
        ],
        "initContainers": [
          {
            "command": [
              "sh",
              "-c",
              "until nslookup myservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for myservice; sleep 2; done"
            ],
            "image": "busybox:1.28",
            "name": "init-myservice"
          },
          {
            "command": [
              "sh",
              "-c",
              "until nslookup mydb.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for mydb; sleep 2; done"
            ],
            "image": "busybox:1.28",
            "name": "init-mydb"
          }
        ]
      }
    },
    "ServiceAccount.default.invalid3": {
      "apiVersion": "v1",
      "kind": "ServiceAccount",
      "metadata": {
        "name": "invalid3",
        "namespace": "default"
      }
    }
  }
}

