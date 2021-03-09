#!/usr/bin/env bash
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
set -o nounset -o errexit -o pipefail

# Quick test that checks file naming.

for rule_file in {rules,examples}/*/*.rego; do
  1>&2 echo "Checking $rule_file..."

  test_file="tests/$(dirname "$rule_file")/$(basename "$rule_file" .rego)_test.rego"
  if [[ ! -f "$test_file" ]]; then
    1>&2 echo "Missing $test_file"
    exit 1
  fi

  infra_file="tests/$(dirname "$rule_file")/inputs/$(basename "$rule_file" .rego)_infra.tf"
  if [[ ! -f "$infra_file" ]]; then
    1>&2 echo "Missing $infra_file"
    exit 1
  fi
done

1>&2 echo "All ok!"
