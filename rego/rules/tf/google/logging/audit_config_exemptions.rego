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
package rules.tf_google_logging_audit_config_exemptions

import data.fugue
import data.google.logging.audit_config_library as lib

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_2.1"
      ]
    },
    "severity": "Medium"
  },
  "description": "IAM default audit log config should not exempt any users. A project's default audit log config should not exempt any users, to ensure that user admin write operations and data access operations are appropriately logged.",
  "id": "FG_R00391",
  "title": "IAM default audit log config should not exempt any users"
}

resource_type := "MULTIPLE"

valid_audit_config_exemptions(audit_config) {
  # Check if all exempted_members are empty
  exempted_members = [exempted_member |
    exempted_member := audit_config.audit_log_config[_].exempted_members
    exempted_member != []
  ]
  exempted_members == []
}

policy[j] {
  audit_config = lib.default_audit_config[_]
  valid_audit_config_exemptions(audit_config)
  j = fugue.allow_resource(audit_config)
}

policy[j] {
  audit_config = lib.default_audit_config[_]
  not valid_audit_config_exemptions(audit_config)
  j = fugue.deny_resource(audit_config)
}

policy[j] {
  fugue.input_type == "tf_runtime"
  count(lib.default_audit_config) == 0
  j = fugue.missing_resource_with_message(lib.audit_config_type, lib.missing_default_config_message)
}
