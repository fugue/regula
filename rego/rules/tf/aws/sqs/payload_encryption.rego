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
package rules.tf_aws_sqs_payload_encryption

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "severity": "High"
  },
  "description": "SQS queue server-side encryption should be enabled with KMS keys. When using SQS queues to send and receive sensitive data, message payloads should be encrypted using server-side encryption with keys managed in KMS (SSE-KMS). Using SQS owned keys (SSE-SQS) is also an option, but lacks the benefits of using KMS, including viewing key policies, auditing usage, and rotating cryptographic material.",
  "id": "FG_R00070",
  "title": "SQS queue server-side encryption should be enabled with KMS keys"
}

queues = fugue.resources("aws_sqs_queue")

has_key(q) {
  q.kms_master_key_id != null
  _ = q.kms_master_key_id
}

resource_type := "MULTIPLE"

policy[j] {
  q = queues[_]
  has_key(q)
  j = fugue.allow_resource(q)
} {
  q = queues[_]
  not has_key(q)
  j = fugue.deny_resource(q)
}
