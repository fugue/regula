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
package rules.tf_aws_cloudtrail_management_events


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_6.2"
      ]
    },
    "severity": "Medium"
  },
  "description": "CloudTrail trails should be configured to log management events. Management events provide visibility into management operations that are performed on resources in your AWS account. Management events can also include non-API events that occur in your account. For example, when a user logs in to your account, CloudTrail logs the ConsoleLogin event. CloudTrail logging enables security analysis, resource change tracking, and compliance auditing.",
  "id": "FG_R00237",
  "title": "CloudTrail trails should be configured to log management events"
}

resource_type = "aws_cloudtrail"

default deny = false

deny {
  input.event_selector[_].include_management_events == false
}

