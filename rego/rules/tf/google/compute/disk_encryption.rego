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
package rules.google_compute_disk_encryption

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_4.7"
      ]
    },
    "severity": "Medium"
  },
  "description": "Compute instance disks should be encrypted with customer-supplied encryption keys (CSEKs). Google Cloud encrypts all data at rest by default with Google-generated keys. However, for business critical instances, users may want to use customer-supplied encryption keys (CSEKs) for an additional layer of protection as data encrypted with CSEKs cannot be accessed by Google.",
  "id": "FG_R00417",
  "title": "Compute instance disks should be encrypted with customer-supplied encryption keys (CSEKs)"
}

resource_type = "MULTIPLE"

compute_instances = fugue.resources("google_compute_instance")

base_message = "The following disks attached to this instance are not encrypted with a CSEK: %s"

encrypted(disk) {
  is_string(disk.disk_encryption_key_sha256)
  disk.disk_encryption_key_sha256 != ""
} {
  is_string(disk.disk_encryption_key_raw)
  disk.disk_encryption_key_raw != ""
}

extract_unencrypted_disks(compute_instance) = ret {
  boot = object.get(compute_instance, "boot_disk", [])
  attached = object.get(compute_instance, "attached_disk", [])
  scratch = object.get(compute_instance, "scratch_disk", [])
  ret = [d | 
    d = array.concat(boot, array.concat(attached, scratch))[_];
    not encrypted(d)
  ]
}

policy[j] {
  instance = compute_instances[_]
  unencrypted_disks = extract_unencrypted_disks(instance)
  count(unencrypted_disks) < 1
  j = fugue.allow_resource(instance)
} {
  instance = compute_instances[_]
  unencrypted_disks = extract_unencrypted_disks(instance)
  count(unencrypted_disks) > 0
  disk_names = [d.device_name | d = unencrypted_disks[_]]
  message = sprintf(base_message, [concat(", ", disk_names)])
  j = fugue.deny_resource_with_message(instance, message)
}

