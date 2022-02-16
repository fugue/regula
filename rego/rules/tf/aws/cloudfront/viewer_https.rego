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
package rules.tf_aws_cloudfront_viewer_https

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "CloudFront viewer protocol policy should be set to https-only or redirect-to-https. CloudFront connections should be encrypted during transmission over networks that can be accessed by malicious individuals. A CloudFront distribution should only use HTTPS or Redirect HTTP to HTTPS for communication between viewers and CloudFront.",
  "id": "FG_R00011",
  "title": "CloudFront viewer protocol policy should be set to https-only or redirect-to-https"
}

resource_type := "aws_cloudfront_distribution"

# Explicitly allow only https or redirection to https.
valid_protocols := {
  "redirect-to-https",
  "https-only"
}

# Properties where cache behaviors live.
cache_behavior_keys := {
  "cache_behavior", "default_cache_behavior", "ordered_cache_behavior"
}

used_traffic_protocols[protocol] {
  protocol = input[cache_behavior_keys[_]][_].viewer_protocol_policy
}

default allow = false

allow {
  # Difference of used_traffic_protocols and valid_protocols must be empty.
  count(used_traffic_protocols - valid_protocols) == 0
}
