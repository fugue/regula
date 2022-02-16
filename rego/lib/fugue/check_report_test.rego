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
package fugue.check_report

import data.fugue

# Check that the report conforms to the interface we expect.
check_report(r, id_regexes) {
  is_boolean(r.valid)
  is_string(r.message)
  check_report_resources(r, id_regexes)
}

check_report_resources(r, id_regexes) {
  # Skip this at design time since the resource IDs are not filled in.
  fugue.input_type != "tf_runtime"
} {
  count(r.resources) == 0
} {
  is_array(r.resources)
  rr = r.resources[_]
  not check_report_resource_invalid(rr, id_regexes)
} {
  is_set(r.resources)
  r.resources[rr]
  not check_report_resource_invalid(rr, id_regexes)
}

check_report_resource_invalid(rr, id_regexes) {
  not check_report_resource(rr, id_regexes)
}

# Check that a resource in the report conforms to the interface we expect.  Used
# by `check_report`.
check_report_resource(rr, id_regexes) {
  is_boolean(rr.valid)
  is_string(rr.message)
  is_string(rr.type)
  is_string(rr.id)
  id_regexes[id_regex]
  re_match(id_regex, rr.id)
}
