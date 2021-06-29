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
package rules.tf_aws_cloudwatch_alarm_actions

import data.fugue.utils


__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "CloudWatch alarms should have at least one alarm action, one INSUFFICIENT_DATA action, or one OK action enabled. AWS can invoke an action when a metric alarm changes state. For example, you can configure CloudWatch to send an SNS notification when an EC2 instance's CPU usage exceeds a certain threshold, alerting you to potentially anomalous activity.",
  "id": "FG_R00240",
  "title": "CloudWatch alarms should have at least one alarm action, one INSUFFICIENT_DATA action, or one OK action enabled"
}

resource_type = "aws_cloudwatch_metric_alarm"

default allow = false

allow {
  input.insufficient_data_actions != null
  count(utils.as_array(input.insufficient_data_actions)) > 0
} {
  input.alarm_actions != null
  count(utils.as_array(input.alarm_actions)) > 0
} {
  input.ok_actions != null
  count(utils.as_array(input.ok_actions)) > 0
}

