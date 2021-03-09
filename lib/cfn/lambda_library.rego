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
package fugue.cfn.lambda_library

matches_function_name_or_id(function, value) {
  value == function.id
} {
  value == function.FunctionName
}

function_name_matches_function(function, function_name) {
  matches_function_name_or_id(function, function_name)
} {
  is_string(function_name)
  parts := split(function_name, ":")
  matches_function_name_or_id(function, parts[_])
} {
  is_array(function_name)
  matches_function_name_or_id(function, function_name[_])
}
