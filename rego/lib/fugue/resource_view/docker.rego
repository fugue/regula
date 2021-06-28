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
package fugue.resource_view.dockerfile

resource_view[id] = ret {
  id := "dockerfile"
  resource := input#.resources[id]
  ret := json.patch(resource, [
    {"op": "add", "path": ["id"], "value": "dockerfile"},
    {"op": "add", "path": ["_type"], "value": "dockerfile"},
    {"op": "add", "path": ["_provider"], "value": "dockerfile"},
  ])
}
