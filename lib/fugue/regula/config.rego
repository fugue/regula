# Copyright 2021 Fugue, Inc.
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

# This package provides a stub for users to add their own configuration.  This
# way we ensure that the declared sets are incremental.
package fugue.regula.config

waivers[waiver] {
  false
  waiver := {
    "rule_id": "*",
    "rule_name": "*",
    "resource_id": "*",
    "filename": "*",
  }
}

rules[rule] {
  false
  rule := {
    "rule_id": "some_rule_id",
    "rule_name": "some_rule_name",
    "status": "disabled",
  }
}
