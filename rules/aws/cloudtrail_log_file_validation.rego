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
package rules.cloudtrail_log_file_validation

__rego__metadoc__ := {
  "id": "FG_R00027",
  "title": "CloudTrail log file validation should be enabled",
  "description": "CloudTrail log file validation should be enabled. It is recommended that file validation be enabled on all CloudTrail logs because it provides additional integrity checking of the log data.",
  "custom": {
    "controls": {
      "CIS": [
        "CIS_2-2"
      ],
      "NIST": [
        "NIST-800-53_AC-2g",
        "NIST-800-53_AC-6 (9)"
      ]
    },
    "severity": "Medium"
  }
}

resource_type = "aws_cloudtrail"

default allow = false

allow {
  input.enable_log_file_validation == true
}
