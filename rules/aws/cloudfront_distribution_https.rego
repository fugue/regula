# Copyright 2020 Fugue, Inc.
# Copyright 2020 New Light Technologies Inc.
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
package rules.cloudfront_distribution_https

resource_type = "aws_cloudfront_distribution"

controls = {
  "NIST-800-53_AC-17 (2)",
  "NIST-800-53_SC-8",
}

# Explicitly allow only https or redirection to https.
valid_protocols = {
  "redirect-to-https",
  "https-only"
}

used_traffic_protocols[protocol] {
  protocol = input.default_cache_behavior[_].viewer_protocol_policy
}

default allow = false

allow {
  # Difference of used_traffic_protocols and valid_protocols must be empty.
  count(used_traffic_protocols - valid_protocols) == 0
}
