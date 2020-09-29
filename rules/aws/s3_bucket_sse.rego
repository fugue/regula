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
package rules.s3_bucket_sse

resource_type = "aws_s3_bucket"
controls = {"NIST-800-53_SC-13"}

# Explicitly allow AES256 or aws:kms server side SSE algorithms.
valid_sse_algorithms = {
  "AES256",
  "aws:kms"
}

# Collect all sse algorithms configued under `server_side_encryption_configuration`.
used_sse_algorithms[algorithm] {
  algorithm = input.server_side_encryption_configuration[_].rule[_][_][_].sse_algorithm
}

default allow = false
allow {
  count(used_sse_algorithms) > 0
  count(used_sse_algorithms - valid_sse_algorithms) <= 0
}
