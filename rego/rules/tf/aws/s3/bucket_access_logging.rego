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
package rules.tf_aws_s3_bucket_access_logging


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_6.2"
      ]
    },
    "severity": "Medium"
  },
  "description": "S3 bucket access logging should be enabled. Enabling server access logging provides detailed records for the requests that are made to a S3 bucket. This information is useful for security and compliance auditing purposes.",
  "id": "FG_R00274",
  "title": "S3 bucket access logging should be enabled"
}

resource_type = "aws_s3_bucket"

default allow = false

allow {
  _ = input.logging[_]
}

