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
package rules.tf_google_logging_audit_config_logtype

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
  "description": "IAM default audit log config should include 'DATA_READ' and 'DATA_WRITE' log types. A best practice is to enable 'DATA_READ' and 'DATA_WRITE' data access log types as part of the default IAM audit log config, so that read and write operations on user-provided data are tracked across all relevant services. Please note that the 'ADMIN_WRITE' log type and BigQuery data access logs are enabled by default.",
  "id": "FG_R00389",
  "title": "IAM default audit log config should include 'DATA_READ' and 'DATA_WRITE' log types"
}

resource_type = "MULTIPLE"
required_log_types = {"DATA_READ", "DATA_WRITE"}

has_required_log_types(audit_config) {
  log_types := {c | c = audit_config.audit_log_config[_].log_type}
  count(required_log_types - log_types) == 0
}

policy[j] {
  audit_config = lib.default_audit_config[_]
  has_required_log_types(audit_config)
  j = fugue.allow_resource(audit_config)
}

policy[j] {
  audit_config = lib.default_audit_config[_]
  not has_required_log_types(audit_config)
  j = fugue.deny_resource(audit_config)
}

policy[j] {
  fugue.input_type == "tf_runtime"
  count(lib.default_audit_config) == 0
  j = fugue.missing_resource_with_message(lib.audit_config_type, lib.missing_default_config_message)
}

