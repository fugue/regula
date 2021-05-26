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

# Allow overriding terraform version.
TERRAFORM="${TERRAFORM:-terraform}"

function validate_input {
  local infra_file="$1"
  local extension="${infra_file##*.}"

  if [[ "${extension}" != "tf" && ! -d "${infra_file}" ]]; then
    1>&2 echo "Unknown extension: $extension"
    exit 1
  fi
}

function get_plan_json_name {
  local infra_file="$1"
  local infra_dirname=$(dirname "${infra_file}")
  local infra_basename=$(basename "${infra_file}" .tf)
  echo "${infra_dirname}/${infra_basename}.json"
}

function generate_tf_plan {
  local infra_file="$1"
  local output_file=$(get_plan_json_name "${infra_file}")  
  local workdir="$(mktemp -d)"

  trap "rm -rf "$workdir"" return

  if [[ -d "${infra_file}" ]]; then
    cp -R "${infra_file}"/* "${workdir}"
  else
    cp "${infra_file}" "${workdir}"
  fi

  (cd "${workdir}" &&
    ${TERRAFORM} init &&
    ${TERRAFORM} plan -refresh=false -out="plan.tfplan" &&
    ${TERRAFORM} show -json "plan.tfplan" | jq > "plan.json")
  
  cp "${workdir}/plan.json" "${output_file}"
}

if [[ $# -eq 0 ]]; then
  for infra in $(find tests -type d -name '*_infra') $(find tests -type f -name '*_infra.tf'); do
    generate_tf_plan "${infra}"
  done
elif [[ "$1" == "-h" || $# -gt 1 ]]; then
  1>&2 echo "Usage:"
  1>&2 echo "  $0             # Regenerates all test outputs"
  1>&2 echo "  $0 INFRA_FILE  # Regenerates a specific test output"
  exit 1
else
  validate_input "$1"
  generate_tf_plan "$1"
fi
