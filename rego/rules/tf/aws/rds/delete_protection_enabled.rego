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
package rules.aws_rds_delete_protection_enabled

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "RDS instance 'Deletion Protection' should be enabled. Enabling deletion protection ensures that any user or anonymous user can't accidentally or intentionally delete your database.",
  "id": "FG_R00280",
  "title": "RDS instance 'Deletion Protection' should be enabled"
}

resource_type = "aws_db_instance"

default allow = false

allow {
  input.deletion_protection == true
}

