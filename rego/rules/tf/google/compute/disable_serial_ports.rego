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
package rules.google_compute_disable_serial_ports

import data.fugue
import data.google.compute.compute_instance_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_9.4"
      ],
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_4.5"
      ]
    },
    "severity": "High"
  },
  "description": "Compute instances 'Enable connecting to serial ports' should not be enabled. A Compute Engine instance's serial port - also known as an interactive serial console - does not support IP-based access restrictions. If enabled, the interactive serial console can be used by clients to connect to the instance from any IP address. This enables anyone who has the correct SSH key, username, and other login information to connect to the instance.",
  "id": "FG_R00415",
  "title": "Compute instances 'Enable connecting to serial ports' should not be enabled"
}

resource_type = "MULTIPLE"

compute_instances = fugue.resources("google_compute_instance")

serial_port_enabled(instance) {
  lib.get_metadata_with_default(instance, "serial-port-enable", false)
}

policy[j] {
  instance = compute_instances[_]
  not serial_port_enabled(instance)
  j = fugue.allow_resource(instance)
} {
  instance = compute_instances[_]
  serial_port_enabled(instance)
  j = fugue.deny_resource(instance)
}

