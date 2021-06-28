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
package rules.aws_cloudtrail_encryption

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_2.7"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.7"
      ]
    },
    "severity": "High"
  },
  "description": "CloudTrail log files should be encrypted using KMS CMKs. By default, the log files delivered by CloudTrail to your bucket are encrypted with Amazon S3-managed encryption keys (SSE-S3). To get control over key rotation and obtain auditing visibility into key usage, use SSE-KMS to encrypt your log files.",
  "id": "FG_R00035",
  "title": "CloudTrail log files should be encrypted using KMS CMKs"
}

# Is a cloudtrail encrypted using a KMS CMK?
valid_kms_arn_prefix = {
  "arn:aws:kms:",
  "arn:aws-us-gov:kms:"
}

is_encrypted(ct) {
  ct.kms_key_id != null
  valid_kms_arn_prefix[k]
  startswith(ct.kms_key_id, k)
} {
  fugue.input_type != "tf_runtime"
  ct.kms_key_id != null
  fugue.resources("aws_kms_key")[ct.kms_key_id]
}

cloudtrails = fugue.resources("aws_cloudtrail")

resource_type = "MULTIPLE"

policy[j] {
  ct = cloudtrails[_]
  is_encrypted(ct)
  j = fugue.allow_resource(ct)
} {
  ct = cloudtrails[_]
  not is_encrypted(ct)
  j = fugue.deny_resource(ct)
}

