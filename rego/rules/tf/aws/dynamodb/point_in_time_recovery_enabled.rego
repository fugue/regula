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
package rules.tf_aws_dynamodb_point_in_time_recovery_enabled

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "DynamoDB tables Point in Time Recovery should be enabled. Point in Time Recovery should be enabled on DynamoDB tables. If an organization allows AWS to automatically back up DDB data, AWS takes on the risk of handling it and the organization can limit its own backup storage.",
  "id": "FG_R00106",
  "title": "DynamoDB tables Point in Time Recovery should be enabled"
}

has_point_in_time_recovery_enabled(ddb) {
  ddb.point_in_time_recovery[_].enabled == true
}

tables = fugue.resources("aws_dynamodb_table")

resource_type = "MULTIPLE"

policy[j] {
  ddb = tables[_]
  has_point_in_time_recovery_enabled(ddb)
  j = fugue.allow_resource(ddb)
} {
  ddb = tables[_]
  not has_point_in_time_recovery_enabled(ddb)
  j = fugue.deny_resource(ddb)
}

