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
package rules.tf_aws_sqs_granular_access

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Critical"
  },
  "description": "SQS access policies should not have global \"*.*\" access. SQS policies should not permit all users to access SQS queues. To promote the security principle of least privilege, an SQS policy should allow only necessary principals to access the queue.",
  "id": "FG_R00049",
  "title": "SQS access policies should not have global \"*.*\" access"
}

# Every sqs in input.
sqs = fugue.resources("aws_sqs_queue")

resource_type = "MULTIPLE"

policy[j] {
  q = sqs[id]
  not allow_all(q.policy)
  j = fugue.allow_resource(q)
} {
  q = sqs[id]
  allow_all(q.policy)
  j = fugue.deny_resource(q)
}

statement_has_condition(statement) {
  _ = statement.Condition
}

allow_all(pol) {
  doc = json.unmarshal(pol)
  statements = as_array(doc.Statement)
  statement = statements[_]
  statement.Effect == "Allow"
  statement.Principal == "*"
  not statement_has_condition(statement)
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}

