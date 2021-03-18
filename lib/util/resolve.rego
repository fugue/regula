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
package util.resolve

resolve(references) = ret {
  vertices := {k | _ = references[k]} | {v | v = references[_]}
  dag := {k: {v | v = references[k]} | k = vertices[_]}
  ret := {k: resolve_final(dag, reachable, k) |
    _ := references[k]
    reachable := graph.reachable(dag, {k})
  }
}

resolve_final(dag, reachable, k) = final {
  final := reachable[_]
  count(dag[final]) == 0
} else = k {
  true
}
