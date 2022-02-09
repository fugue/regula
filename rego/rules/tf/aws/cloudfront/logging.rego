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
package rules.tf_aws_cloudfront_logging

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "CloudFront access logging should be enabled. CloudFront access logs record information about every user request that CloudFront receives. CloudFront distribution access logging should be enabled in order to track viewer requests for content, analyze statistics, and perform security audits.",
  "id": "FG_R00067",
  "title": "CloudFront access logging should be enabled"
}

cloudfronts = fugue.resources("aws_cloudfront_distribution")

has_logging(cf) {
  cf.logging_config[_].bucket != ""
}

resource_type := "MULTIPLE"

policy[j] {
  cf = cloudfronts[_]
  has_logging(cf)
  j = fugue.allow_resource(cf)
} {
  cf = cloudfronts[_]
  not has_logging(cf)
  j = fugue.deny_resource(cf)
}
