# Copyright 2020 Fugue, Inc.
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
package rules.kms_rotate

__rego__metadoc__ := {
  "id": "FG_R00036",
  "title": "KMS CMK rotation should be enabled",
  "description": "KMS CMK rotation should be enabled. It is recommended that users enable rotation for the customer created AWS Customer Master Key (CMK). Rotating encryption keys helps reduce the potential impact of a compromised key as users cannot use the old key to access the data.",
  "custom": {
    "controls": {
      "CIS": [
        "CIS_2-8"
      ]
    },
    "severity": "Medium"
  }
}

resource_type = "aws_kms_key"

deny[msg] {
  not input.enable_key_rotation
  msg = "KMS key rotation should be enabled"
}
