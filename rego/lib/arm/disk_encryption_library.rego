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

# This helper rego code works for Azure "no ingress" rules.
# It is built on top of the terraform code that does the same,
# through a simple conversion (`rule_to_tf`).
package fugue.arm.disk_encryption_library

import data.fugue

disks := fugue.resources("Microsoft.Compute/disks")

virtual_machines := fugue.resources("Microsoft.Compute/virtualMachines")

data_disk_ids := {id |
	disk := virtual_machines[_].properties.storageProfile.dataDisks[_]
	id := disk.managedDisk.id
}

os_disk_ids := {id |
	id := virtual_machines[_].properties.storageProfile.osDisk.managedDisk.id
}

unattached_disk_ids := {id |
	_ := disks[id]
	not data_disk_ids[id]
	not os_disk_ids[id]
}

disk_encrypted(disk) {
	disk.properties.encryptionSettingsCollection.enabled == true
}

disk_encrypted(disk) {
	des_id := disk.properties.encryption.diskEncryptionSetId
	is_string(des_id)
	des_id != ""
}
