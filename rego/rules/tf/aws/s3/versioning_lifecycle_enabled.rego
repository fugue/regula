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
package rules.aws_s3_versioning_lifecycle_enabled



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_10.1",
        "CIS-Controls_v7.1_13.2"
      ]
    },
    "severity": "Medium"
  },
  "description": "S3 bucket versioning and lifecycle policies should be enabled. S3 bucket versioning and lifecycle policies are used to protect data availability and integrity. By enabling object versioning, data is protected from overwrites and deletions. Lifecycle policies ensure sensitive data is deleted when appropriate.",
  "id": "FG_R00101",
  "title": "S3 bucket versioning and lifecycle policies should be enabled"
}

resource_type = "aws_s3_bucket"

has_versioning_enabled {
  input.versioning[_].enabled
}

has_lifecycle_policy {
  count(input.lifecycle_rule) >= 1
}

default allow = false

allow {
  has_versioning_enabled
  has_lifecycle_policy
}

