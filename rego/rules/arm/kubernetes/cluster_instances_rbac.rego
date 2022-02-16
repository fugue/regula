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

package rules.arm_kubernetes_cluster_instances_rbac

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_8.5"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_8.5"
      ]
    },
    "severity": "Medium"
  },
  "description": "Azure Kubernetes Services has the capability to integrate Azure Active Directory users and groups into Kubernetes RBAC controls within the AKS Kubernetes API Server. This should be utilized to enable granular access to Kubernetes resources within the AKS clusters supporting RBAC controls not just of the overarching AKS instance but also the individual resources managed within Kubernetes.",
  "id": "FG_R00329",
  "title": "Azure Kubernetes Service instances should have RBAC enabled"
}

input_type := "arm"

resource_type := "Microsoft.ContainerService/managedClusters"

default allow = false

allow {
	input.properties.enableRBAC == true
}
