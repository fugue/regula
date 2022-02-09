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
package rules.tf_google_sql_database_no_public_ip

import data.google.sql_database.sql_database_library as lib

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_6.6"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_6.6"
      ]
    },
    "severity": "Medium"
  },
  "description": "SQL database instances should not have public IPs. SQL database instances with public IP addresses are directly accessible by hosts on the Internet. To minimize its attack surface, a database server should be configured with private IP addresses. Private addresses provide better security because of intermediary firewall or NAT devices.",
  "id": "FG_R00435",
  "title": "SQL database instances should not have public IPs"
}

resource_type := "google_sql_database_instance"

default deny = false

deny {
  # Runtime
  input.ip_address[_].type == "PRIMARY"
} {
  # Design time
  input.settings[_].ip_configuration[_].ipv4_enabled == true
}
