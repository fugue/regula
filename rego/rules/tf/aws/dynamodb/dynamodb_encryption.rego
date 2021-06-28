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
package rules.aws_dynamodb_dynamodb_encryption

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_14.8"
      ]
    },
    "severity": "Medium"
  },
  "description": "DynamoDB tables should be encrypted with AWS or customer managed KMS CMKs. Although DynamoDB tables are encrypted at rest by default with AWS owned CMKs, using AWS managed CMKs or customer managed CMKs provides additional functionality via AWS KMS, such as viewing key policies, auditing usage, and rotating cryptographic material.",
  "id": "FG_R00069",
  "title": "DynamoDB tables should be encrypted with AWS or customer managed KMS CMKs"
}

tables = fugue.resources("aws_dynamodb_table")

server_side_encryption_enabled(obj) {
  obj.server_side_encryption[_].enabled
}

resource_type = "MULTIPLE"

policy[j] {
  tables[_] = obj
  server_side_encryption_enabled(obj)
  j = fugue.allow_resource(obj)
} {
  tables[_] = obj
  not server_side_encryption_enabled(obj)
  j = fugue.deny_resource(obj)
}

