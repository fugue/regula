#!/bin/bash
set -o nounset -o errexit -o pipefail

# Allow overriding terraform version.
TERRAFORM="${TERRAFORM:-terraform}"

function generate_test_input {
  if [[ $# -ne 2 ]]; then
    1>&2 echo "Usage: $0 TF_FILE REGO_FILE"
    exit 1
  fi

  local tfdir="$(mktemp -d)"
  trap "rm -rf "$tfdir"" return
  cp "$1" "$tfdir"

  # For some reason running this from the current directory sometimes fails; we
  # create a subshell and `cd` to where we copied the terraform configuration.
  (cd "$tfdir" &&
      $TERRAFORM init &&
      $TERRAFORM plan -refresh=false -out="plan.tfplan" &&
      $TERRAFORM show -json "plan.tfplan" >"plan.json")

  local package="tests.rules.$(basename "$2" _infra.rego)"
  echo '# This package was automatically generated from:' >"$2"
  echo '#' >>"$2"
  echo "#     $1" >>"$2"
  echo '#' >>"$2"
  echo '# using `generate_test_inputs.sh` and should not be modified' >>"$2"
  echo '# directly.' >>"$2"
  echo "package $package" >>"$2"
  echo "mock_input = $(jq '.' <"$tfdir/plan.json")" >>"$2"

  1>&2 echo "Generated $2"
}

for tf_file in tests/{rules,examples}/inputs/*.tf; do
  rego_file="$(dirname "$tf_file")/$(basename "$tf_file" .tf).rego"
  if [[ ! -f "$rego_file" ]] || [[ "$tf_file" -nt "$rego_file" ]]; then
    1>&2 echo "$tf_file -> $rego_file"
    generate_test_input "$tf_file" "$rego_file"
  else
    1>&2 echo "$rego_file is up to date.  Remove it to force re-generating."
  fi
done
