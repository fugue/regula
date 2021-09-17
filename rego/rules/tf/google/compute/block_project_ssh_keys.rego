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
package rules.tf_google_compute_block_project_ssh_keys

import data.fugue
import data.google.compute.compute_instance_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_4.3"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_4.3"
      ]
    },
    "severity": "Medium"
  },
  "description": "Compute instance 'block-project-ssh-keys' should be enabled. Project-wide SSH keys for Compute Engine instances may be easier to manage than instance-specific SSH keys, but if compromised, present increase security risk to all instances within a given project. Given this, using instance-specific SSH keys is the more secure approach. Please note that if OS Login is enabled, SSH keys in instance metadata are ignored, so blocking project-wide SSH keys is not necessary.",
  "id": "FG_R00413",
  "title": "Compute instance 'block-project-ssh-keys' should be enabled"
}

resource_type = "MULTIPLE"

compute_instances = fugue.resources("google_compute_instance")

policy[j] {
  instance = compute_instances[_]
  # When enable-oslogin is true, it supersedes  block-project-ssh-keys
  lib.get_metadata_with_default(instance, "enable-oslogin", false)
  j = fugue.allow_resource(instance)
} {
  instance = compute_instances[_]
  lib.get_metadata_with_default(instance, "block-project-ssh-keys", false)
  j = fugue.allow_resource(instance)
} {
  instance = compute_instances[_]
  not lib.get_metadata_with_default(instance, "enable-oslogin", false)
  not lib.get_metadata_with_default(instance, "block-project-ssh-keys", false)
  j = fugue.deny_resource(instance)
}

