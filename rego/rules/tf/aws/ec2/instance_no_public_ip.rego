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
package rules.aws_ec2_instance_no_public_ip


__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "EC2 instances should not have a public IP association (IPv4). Publicly accessible EC2 instances are reachable over the internet even if you have protections such as NACLs or security groups. If these protections are accidentally removed your instances may be vulnerable to attack.",
  "id": "FG_R00271",
  "title": "EC2 instances should not have a public IP association (IPv4)"
}

resource_type = "aws_instance"

default deny = false

deny {
  is_string(input.public_ip)
  input.public_ip != ""
} {
  input.associate_public_ip_address == true
}

