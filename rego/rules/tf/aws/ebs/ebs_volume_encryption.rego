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
package rules.tf_aws_ebs_ebs_volume_encryption

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_2.2.1"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_2.2.1"
      ]
    },
    "severity": "High"
  },
  "description": "EBS volume encryption should be enabled. Enabling encryption on EBS volumes protects data at rest inside the volume, data in transit between the volume and the instance, snapshots created from the volume, and volumes created from those snapshots. By default, EBS volumes are encrypted with AWS managed KMS keys. Alternatively, you can specify a symmetric customer managed key as the default KMS key for EBS encryption via the AWS console and CLI.",
  "id": "FG_R00016",
  "title": "EBS volume encryption should be enabled"
}

volumes = fugue.resources("aws_ebs_volume")

resource_type := "MULTIPLE"

policy[j] {
  v = volumes[_]
  v.encrypted
  j = fugue.allow({"resource": v})
} {
  v = volumes[_]
  not v.encrypted
  j = fugue.deny(
    {"resource": v, "attribute": ["encrypted"]}
  )
}
