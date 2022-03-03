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

package rules.arm_vm_data_disk_encryption

import data.fugue
import data.arm.disk_encryption_library as lib

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_7.2"
      ]
    },
    "severity": "High"
  },
  "description": "Encrypting the IaaS VM's Data disks ensures that its entire content is fully unrecoverable without a key and thus protects the volume from unwarranted reads.",
  "id": "FG_R00196",
  "title": "Virtual Machines data disks (non-boot volumes) should be encrypted"
}

input_type := "arm"

resource_type := "MULTIPLE"

disks[id] = disk {
	disk := lib.disks[id]
	lib.data_disk_ids[id]
}

policy[p] {
	disk := disks[_]
	not lib.disk_encrypted(disk)
	p := fugue.deny_resource(disk)
}

policy[p] {
	disk := disks[_]
	lib.disk_encrypted(disk)
	p := fugue.allow_resource(disk)
}


# Data disks inlined in virtual machine definitions do not have encryption
# settings, so mark these as invalid.

managed_disk(disk) {
	_ := disk.managedDisk.id
}

has_unmanaged_disk(virtual_machine) {
	disk := virtual_machine.properties.storageProfile.dataDisks[_]
	not managed_disk(disk)
}

policy[p] {
	virtual_machine := lib.virtual_machines[_]
	has_unmanaged_disk(virtual_machine)
	p := fugue.deny_resource(virtual_machine)
}
