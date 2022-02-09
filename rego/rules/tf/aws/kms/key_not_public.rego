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
package rules.tf_aws_kms_key_not_public

import data.fugue

# KMS master keys should not be publicly accessible
# 
# aws_kms_key

__rego__metadoc__ := {
  "custom": {
    "severity": "Critical"
  },
  "description": "KMS master keys should not be publicly accessible. KMS keys are used for encrypting and decrypting data which may be sensitive. Publicly accessible KMS keys may allow anyone to perform decryption operations which may reveal data.",
  "id": "FG_R00252",
  "title": "KMS master keys should not be publicly accessible"
}

resource_type := "aws_kms_key"

default deny = false

all_principals(statement) {
    principals = as_array(statement.Principal)
    principal = principals[_]
    principal.AWS == "*"
}

missing_caller_condition(statement) {
    not statement.Condition
} {
    statement.Condition == ""
} {
    conditions = as_array(statement.Condition)
    condition = conditions[_]
    not condition.StringEquals["kms:CallerAccount"]
} {
    conditions = as_array(statement.Condition)
    condition = conditions[_]
    condition.StringEquals["kms:CallerAccount"] == ""
}

deny {
    json.unmarshal(input.policy, doc)
    statements = as_array(doc.Statement)
    statement = statements[_]

    all_principals(statement)
    missing_caller_condition(statement)
}

as_array(x) = [x] {not is_array(x)} else = x {true}
