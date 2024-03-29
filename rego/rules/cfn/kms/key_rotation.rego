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
package rules.cfn_kms_key_rotation

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_2.8"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.8"
      ]
    },
    "severity": "Medium"
  },
  "description": "KMS CMK rotation should be enabled. It is recommended that users enable rotation for the customer created AWS Customer Master Key (CMK). Rotating encryption keys helps reduce the potential impact of a compromised key as users cannot use the old key to access the data.",
  "id": "FG_R00036",
  "title": "KMS CMK rotation should be enabled"
}

input_type := "cfn"
resource_type := "AWS::KMS::Key"

default allow = false

allow {
  input.EnableKeyRotation == true
}
