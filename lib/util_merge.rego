# Copyright 2020 Fugue, Inc.
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
package util.merge

# Little bit of object merging boilerplate.
exists(obj, k) {
  _ = obj[k]
}

pick(k, obj1, obj2) = v {
  v := obj1[k]
}

pick(k, obj1, obj2) = v {
  not exists(obj1, k)
  v := obj2[k]
}

merge(a, b) = c {
  keys := {k | _ = a[k]} | {k | _ = b[k]}
  c := {k: v | k := keys[_]; v := pick(k, b, a)}
}
