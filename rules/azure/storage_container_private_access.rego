# Copyright 2020 Fugue, Inc.
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
package rules.storage_container_private_access

__rego__metadoc__ := {
  "id": "FG_R00207",
  "title": "Blob Storage containers should have public access disabled",
  "description": "Anonymous, public read access to a container and its blobs can be enabled in Azure Blob storage. It grants read-only access to these resources without sharing the account key, and without requiring a shared access signature. It is recommended not to provide anonymous access to blob containers until, and unless, it is strongly desired. A shared access signature token should be used for providing controlled and timed access to blob containers.",
  "custom": {
    "controls": {
      "CISAZURE": [
        "CISAZURE_3.6"
      ]
    }
  }
}

resource_type = "azurerm_storage_container"

default allow = false

allow {
  input.container_access_type == "private"
}
