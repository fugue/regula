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
package rules.cfn_cloudtrail_log_validation

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_2.2"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.2"
      ]
    },
    "severity": "Medium"
  },
  "description": "CloudTrail log file validation should be enabled. It is recommended that file validation be enabled on all CloudTrail logs because it provides additional integrity checking of the log data.",
  "id": "FG_R00027",
  "title": "CloudTrail log file validation should be enabled"
}

input_type := "cfn"
resource_type := "AWS::CloudTrail::Trail"

default allow = false

allow {
  input.EnableLogFileValidation == true
}
