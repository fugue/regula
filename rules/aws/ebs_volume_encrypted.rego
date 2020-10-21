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
package rules.ebs_volume_encrypted

__rego__metadoc__ := {
  "id": "FG_R00016",
  "title": "EBS volume encryption should be enabled",
  "description": "EBS volume encryption should be enabled. Enabling encryption on EBS volumes protects data at rest inside the volume, data in transit between the volume and the instance, snapshots created from the volume, and volumes created from those snapshots. EBS volumes are encrypted using KMS keys.",
  "custom": {
    "controls": {
      "NIST": [
        "NIST-800-53_SC-13"
      ]
    },
    "severity": "High"
  }
}

resource_type = "aws_ebs_volume"

default allow = false

allow {
  input.encrypted == true
}
