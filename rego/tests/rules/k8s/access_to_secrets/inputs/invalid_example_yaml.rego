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
package tests.rules.k8s.access_to_secrets.inputs.invalid_example_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "k8s_resource_view_version": "0.0.1",
  "resources": {
    "ClusterRole.default.pod-and-pod-logs-reader-global": {
      "apiVersion": "rbac.authorization.k8s.io/v1",
      "kind": "ClusterRole",
      "metadata": {
        "labels": {
          "rbac.example.com/aggregate-to-monitoring": "true"
        },
        "name": "pod-and-pod-logs-reader-global"
      },
      "rules": [
        {
          "apiGroups": [
            ""
          ],
          "resources": [
            "services",
            "endpoints",
            "secrets",
            "pods"
          ],
          "verbs": [
            "get",
            "list",
            "watch"
          ]
        }
      ]
    },
    "ClusterRoleBinding.default.invalid2": {
      "apiVersion": "rbac.authorization.k8s.io/v1",
      "kind": "ClusterRoleBinding",
      "metadata": {
        "name": "invalid2"
      },
      "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "ClusterRole",
        "name": "pod-and-pod-logs-reader-global"
      },
      "subjects": [
        {
          "apiGroup": "rbac.authorization.k8s.io",
          "kind": "Group",
          "name": "manager"
        }
      ]
    },
    "ClusterRoleBinding.default.missing_ref": {
      "apiVersion": "rbac.authorization.k8s.io/v1",
      "kind": "ClusterRoleBinding",
      "metadata": {
        "name": "missing_ref"
      },
      "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "Role",
        "name": "missing"
      },
      "subjects": []
    },
    "Role.default.pod-and-pod-logs-reader": {
      "apiVersion": "rbac.authorization.k8s.io/v1",
      "kind": "Role",
      "metadata": {
        "name": "pod-and-pod-logs-reader",
        "namespace": "default"
      },
      "rules": [
        {
          "apiGroups": [
            ""
          ],
          "resources": [
            "pods",
            "pods/log",
            "secrets"
          ],
          "verbs": [
            "get",
            "list"
          ]
        }
      ]
    },
    "RoleBinding.default.invalid1": {
      "apiVersion": "rbac.authorization.k8s.io/v1",
      "kind": "RoleBinding",
      "metadata": {
        "name": "invalid1",
        "namespace": "default"
      },
      "roleRef": {
        "apiGroup": "rbac.authorization.k8s.io",
        "kind": "Role",
        "name": "pod-and-pod-logs-reader"
      },
      "subjects": [
        {
          "apiGroup": "rbac.authorization.k8s.io",
          "kind": "User",
          "name": "jane"
        }
      ]
    }
  }
}

