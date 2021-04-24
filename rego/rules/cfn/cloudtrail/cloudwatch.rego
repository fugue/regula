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
package rules.cfn_cloudtrail_cloudwatch

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_2.4"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.4"
      ]
    },
    "severity": "Medium"
  },
  "description": "CloudTrail trails should have CloudWatch log integration enabled. It is recommended that users configure CloudTrail to send log events to CloudWatch Logs. Users can then create CloudWatch Logs metric filters to search for specific terms such as a user or resource, or create CloudWatch alarms to trigger based on thresholds or anomalous activity.\r\n\r\nNote: CIS recognizes that there are alternative logging solutions instead of CloudWatch Logs. The intent of this recommendation is to capture, monitor, and appropriately alarm on an AWS account.",
  "id": "FG_R00029",
  "title": "CloudTrail trails should have CloudWatch log integration enabled"
}

input_type := "cloudformation"
resource_type := "AWS::CloudTrail::Trail"

default allow = false

allow {
  input.CloudWatchLogsLogGroupArn != null
  input.CloudWatchLogsRoleArn != null
}
