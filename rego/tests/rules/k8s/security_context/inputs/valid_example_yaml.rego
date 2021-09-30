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
package tests.rules.k8s.security_context.inputs.valid_example_yaml

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "k8s_resource_view_version": "0.0.1",
  "resources": {
    "DaemonSet.default.valid3": {
      "apiVersion": "apps/v1",
      "kind": "DaemonSet",
      "metadata": {
        "labels": {
          "app": "widget",
          "chart": "widget-2.2.0",
          "heritage": "Helm",
          "release": "RELEASE-NAME"
        },
        "name": "valid3",
        "namespace": "default"
      },
      "spec": {
        "selector": {
          "matchLabels": {
            "app": "widget",
            "release": "RELEASE-NAME"
          }
        },
        "template": {
          "metadata": {
            "annotations": {
              "checksum/config": "81985e6edb592568080ee85db59b747664f91d75f2b452589c5a5659928f1076",
              "prometheus.io/port": "http-metrics",
              "prometheus.io/scrape": "true"
            },
            "labels": {
              "app": "widget",
              "release": "RELEASE-NAME"
            }
          },
          "spec": {
            "containers": [
              {
                "args": [
                  "-config.file=/etc/widget/widget.yaml",
                  "-client.url=http://RELEASE-NAME-loki:3100/loki/api/v1/push"
                ],
                "env": [
                  {
                    "name": "HOSTNAME",
                    "valueFrom": {
                      "fieldRef": {
                        "fieldPath": "spec.nodeName"
                      }
                    }
                  }
                ],
                "image": "grafana/widget:2.1.0",
                "imagePullPolicy": "IfNotPresent",
                "name": "widget",
                "ports": [
                  {
                    "containerPort": 3101,
                    "name": "http-metrics"
                  }
                ],
                "readinessProbe": {
                  "failureThreshold": 5,
                  "httpGet": {
                    "path": "/ready",
                    "port": "http-metrics"
                  },
                  "initialDelaySeconds": 10,
                  "periodSeconds": 10,
                  "successThreshold": 1,
                  "timeoutSeconds": 1
                },
                "securityContext": {
                  "readOnlyRootFilesystem": true,
                  "runAsGroup": 0,
                  "runAsUser": 0
                },
                "volumeMounts": [
                  {
                    "mountPath": "/etc/widget",
                    "name": "config"
                  },
                  {
                    "mountPath": "/run/widget",
                    "name": "run"
                  },
                  {
                    "mountPath": "/var/lib/docker/containers",
                    "name": "docker",
                    "readOnly": true
                  },
                  {
                    "mountPath": "/var/log/pods",
                    "name": "pods",
                    "readOnly": true
                  }
                ]
              }
            ],
            "serviceAccountName": "RELEASE-NAME-widget",
            "tolerations": [
              {
                "effect": "NoSchedule",
                "key": "node-role.kubernetes.io/master",
                "operator": "Exists"
              }
            ],
            "volumes": [
              {
                "configMap": {
                  "name": "RELEASE-NAME-widget"
                },
                "name": "config"
              },
              {
                "hostPath": {
                  "path": "/run/widget"
                },
                "name": "run"
              },
              {
                "hostPath": {
                  "path": "/var/lib/docker/containers"
                },
                "name": "docker"
              },
              {
                "hostPath": {
                  "path": "/var/log/pods"
                },
                "name": "pods"
              }
            ]
          }
        }
      }
    },
    "Pod.default.valid1": {
      "apiVersion": "v1",
      "kind": "Pod",
      "metadata": {
        "name": "valid1"
      },
      "spec": {
        "containers": [
          {
            "env": [
              {
                "name": "FOO",
                "value": "FOO"
              },
              {
                "name": "BAR",
                "value": "BAR"
              }
            ],
            "image": "redis",
            "name": "mycontainer"
          }
        ],
        "restartPolicy": "Never",
        "securityContext": {
          "readOnlyRootFilesystem": true,
          "runAsGroup": 0,
          "runAsUser": 0
        }
      }
    },
    "Pod.default.valid2": {
      "apiVersion": "v1",
      "kind": "Pod",
      "metadata": {
        "name": "valid2"
      },
      "spec": {
        "containers": [
          {
            "image": "redis",
            "name": "mycontainer",
            "securityContext": {
              "readOnlyRootFilesystem": true,
              "runAsGroup": 0,
              "runAsUser": 0
            }
          }
        ]
      }
    }
  }
}

