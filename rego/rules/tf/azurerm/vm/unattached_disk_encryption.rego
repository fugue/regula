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
package rules.tf_azurerm_vm_unattached_disk_encryption

import data.azurerm.vm.disk_encryption_library as lib
import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_7.3"
      ]
    },
    "severity": "High"
  },
  "description": "Virtual Machines unattached disks should be encrypted. Encrypting the IaaS VM's disks ensures that its entire content is fully unrecoverable without a key and thus protects the volume from unwarranted reads.",
  "id": "FG_R00197",
  "title": "Virtual Machines unattached disks should be encrypted"
}

resource_type = "MULTIPLE"

policy[j] {
  md = lib.managed_disks[_]
  not lib.attached_disks[lower(md.id)]
  lib.encrypted_managed_disks[md.id]
  j = fugue.allow_resource(md)
} {
  md = lib.managed_disks[_]
  not lib.attached_disks[lower(md.id)]
  not lib.encrypted_managed_disks[md.id]
  j = fugue.deny_resource(md)
}

