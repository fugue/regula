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
  $TERRAFORM init "$tfdir"
  $TERRAFORM plan -refresh=false -out="$tfdir/plan.tfplan" "$tfdir"
  $TERRAFORM show -json "$tfdir/plan.tfplan" >"$tfdir/plan.json"

  local package="rules.inputs.$(basename "$2" .rego)"
  echo '# This package was automatically generated from:' >"$2"
  echo '#' >>"$2"
  echo "#     $1" >>"$2"
  echo '#' >>"$2"
  echo '# using `generate_test_inputs.sh` and should not be modified' >>"$2"
  echo '# directly.' >>"$2"
  echo "package $package" >>"$2"
  echo "json = $(jq '.' <"$tfdir/plan.json")" >>"$2"

  1>&2 echo "Generated $2"
}

for tf_file in tests/rules/inputs/*.tf; do
  rego_file="$(dirname "$tf_file")/$(basename "$tf_file" .tf).rego"
  1>&2 echo "$tf_file -> $rego_file"
  generate_test_input "$tf_file" "$rego_file"
done
