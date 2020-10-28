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
package util.update

doc = {
  "name": {
    "first": "Tom",
    "last": "Nook",
  },
  "address": [
    "Sunset ave 1",
    "Tropical Island"
  ]
}

test_update_1 {
  update(doc, [
    [["name", "first"], "Tim"]
  ]) == {
    "name": {
      "first": "Tim",
      "last": "Nook",
    },
    "address": [
      "Sunset ave 1",
      "Tropical Island"
    ]
  }
}

test_update_2 {
  update(doc, [
    [["name"], "Tim Nook"]
  ]) == {
    "name": "Tim Nook",
    "address": [
      "Sunset ave 1",
      "Tropical Island"
    ]
  }
}

test_update_3 {
  update(doc, [
    [["address", 0], "Sunrise ave 1"]
  ]) == {
    "name": {
      "first": "Tom",
      "last": "Nook",
    },
    "address": [
      "Sunrise ave 1",
      "Tropical Island"
    ]
  }
}

test_update_4 {
  update(doc, [
    [["name", "first"], "Tim"],
    [["address", 1], "Subtropical Island"],
  ]) == {
    "name": {
      "first": "Tim",
      "last": "Nook",
    },
    "address": [
      "Sunset ave 1",
      "Subtropical Island"
    ]
  }
}
