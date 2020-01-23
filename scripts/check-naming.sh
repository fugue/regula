#!/bin/bash
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
