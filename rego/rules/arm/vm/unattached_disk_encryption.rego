# Copyright 2021 Fugue, Inc.
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

package rules.arm_vm_unattached_disk_encryption

import data.fugue
import data.fugue.arm.disk_encryption_library as lib

__rego__metadoc__ := {
	"id": "FG_R00197",
	"title": "Virtual Machines unattached disks should be encrypted",
	"description": "Encrypting the IaaS VM's disks ensures that its entire content is fully unrecoverable without a key and thus protects the volume from unwarranted reads.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.1.0": [
				"CIS-Azure_v1.1.0_7.3"
			]
		},
		"severity": "High"
	}
}

input_type = "arm"

resource_type = "MULTIPLE"

disks[id] = disk {
  disk := lib.disks[id]
  lib.unattached_disk_ids[id]
}

policy[p] {
	disk = disks[_]
	not lib.disk_encrypted(disk)
	p = fugue.deny_resource(disk)
}

policy[p] {
	disk = disks[_]
	lib.disk_encrypted(disk)
	p = fugue.allow_resource(disk)
}
