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
package rules.ec2_t2_only

resource_type = "aws_instance"

# Explicitly allow only blessed instance types.
# Disallowing only t2.nano would blindly allow new instance types.
valid_instance_types = {
  "t2.micro",
  "t2.small",
  "t2.medium",
  "t2.large",
  "t2.xlarge",
  "t2.2xlarge"
}

default allow = false

allow {
  valid_instance_types[input.instance_type]
}
