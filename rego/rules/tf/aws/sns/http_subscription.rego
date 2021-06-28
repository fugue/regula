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
package rules.tf_aws_sns_http_subscription

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_14.4"
      ]
    },
    "severity": "Medium"
  },
  "description": "SNS subscriptions should deny access via HTTP. SNS subscriptions should not use HTTP as the delivery protocol. To enforce encryption in transit, any subscription to an HTTP endpoint should use HTTPS instead.",
  "id": "FG_R00052",
  "title": "SNS subscriptions should deny access via HTTP"
}

topic_subscriptions = fugue.resources("aws_sns_topic_subscription")

invalid_topic_subscriptions[id] = topic_subscription {
  topic_subscription = topic_subscriptions[id]
  topic_subscription.protocol == "http"
}

resource_type = "MULTIPLE"

policy[j] {
  invalid_topic_subscriptions[id] = sub
  j = fugue.deny_resource(sub)
} {
  topic_subscriptions[id] = sub
  not invalid_topic_subscriptions[id]
  j = fugue.allow_resource(sub)
}

