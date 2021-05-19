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
shopt -s nullglob
shopt -s globstar

# Quick test that checks file naming.
exit_code=0

for rule_file in {rules,examples}/**/*.rego; do
  1>&2 echo "Checking $rule_file..."
  rule_dirname=$(dirname "$rule_file")
  rule_basename=$(basename "$rule_file" .rego)

  test_file="tests/${rule_dirname}/${rule_basename}_test.rego"
  if [[ ! -f "$test_file" ]]; then
    1>&2 echo "Missing $test_file"
    exit_code=1
  fi

  infra_files=(tests/${rule_dirname}/inputs/*${rule_basename}*_infra.*)
  if [[ ${#infra_files[@]} -lt 1 ]]; then
    1>&2 echo "Missing infra files for ${rule_file}"
    exit_code=1
  fi
done

if [[ ${exit_code} == 0 ]]; then
  1>&2 echo "All ok!"
else
  1>&2 echo "Failed to find expected tests and test inputs for all rules."
fi

exit ${exit_code}
