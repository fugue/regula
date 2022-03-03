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
package rules.tf_aws_cloudwatch_encrypted_logs

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "CloudWatch log groups should be encrypted with customer managed KMS keys. CloudWatch log groups are encrypted by default. However, utilizing customer managed KMS keys gives you more control over key rotation and provides auditing visibility into key usage.",
  "id": "FG_R00068",
  "title": "CloudWatch log groups should be encrypted with customer managed KMS keys"
}

resource_type := "aws_cloudwatch_log_group"

default allow = false

allow {
  is_string(input.kms_key_id)
  input.kms_key_id != ""
}
