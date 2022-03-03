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
package google.logging.audit_config_library

import data.fugue

audit_config_type := "google_project_iam_audit_config"
missing_default_config_message := "No default audit log config was found."

default_audit_config[id] = ret {
  audit_configs = fugue.resources("google_project_iam_audit_config")
  audit_config = audit_configs[id]
  audit_config.service == "allServices"
  ret = audit_config
}
