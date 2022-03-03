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
package azurerm.vm.disk_encryption_library

import data.fugue

managed_disks = fugue.resources("azurerm_managed_disk")

# Find managed disks, and create a set of the CMK encrypted ones.

disk_is_encrypted_via_cmk(managed_disk) = ret {
  ret = managed_disk.disk_encryption_set_id != ""
}

encrypted_managed_disks_via_cmk = {managed_disk_id |
  managed_disk = managed_disks[_]
  managed_disk_id = managed_disk.id
  disk_is_encrypted_via_cmk(managed_disk)
}

# Find managed disks, and create a set of the encrypted ones.

disk_is_encrypted(managed_disk) = ret {
  managed_disk.encryption_settings[_].enabled
  ret = true
} else = ret {
  managed_disk.disk_encryption_set_id != null
  ret = true
} else = ret {
  ret = false
}

encrypted_managed_disks = {managed_disk_id |
  managed_disk = managed_disks[_]
  managed_disk_id = managed_disk.id
  disk_is_encrypted(managed_disk)
}

# Figure out which managed disks are attached to virtual machines.

virtual_machines = fugue.resources("azurerm_virtual_machine")

data_disk_attachments = fugue.resources("azurerm_virtual_machine_data_disk_attachment")

attached_data_disks[managed_disk_id] {
  # Attached as data disk directly.
  virtual_machine = virtual_machines[_]
  managed_disk_id = lower(virtual_machine.storage_data_disk[_].managed_disk_id)
} {
  # Attached as data disk through a
  # `azurerm_virtual_machine_data_disk_attachment`.
  disk_attachment = data_disk_attachments[_]
  lower(disk_attachment.managed_disk_id) = managed_disk_id
}

attached_os_disks[managed_disk_id] {
  # Attached as os disk directly.
  virtual_machine = virtual_machines[_]
  managed_disk_id = lower(virtual_machine.storage_os_disk[_].managed_disk_id)
}

attached_disks[managed_disk_id] {
  attached_data_disks[managed_disk_id]
} {
  attached_os_disks[managed_disk_id]
}

unattached_disks[managed_disk_id] {
  managed_disk = managed_disks[_]
  managed_disk_id = lower(managed_disk.id)
  not attached_disks[managed_disk_id]
}

# Provide some lookup capability for friendly messages

vm_name_from_managed_disk_id(managed_disk_id) = ret {
  virtual_machine = virtual_machines[_]
  virtual_machine.storage_data_disk[_].managed_disk_id == managed_disk_id
  ret = virtual_machine.name
}

vm_name_from_managed_disk_id(managed_disk_id) = ret {
  virtual_machine = virtual_machines[_]
  virtual_machine.storage_os_disk[_].managed_disk_id == managed_disk_id
  ret = virtual_machine.name
}
