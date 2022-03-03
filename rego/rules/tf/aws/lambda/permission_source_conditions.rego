# Copyright 2020-2022 Fugue, Inc.
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
package rules.tf_aws_lambda_permission_source_conditions

import data.fugue
import data.aws.lambda.permissions_library as lib

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "Lambda permissions with a service principal should contain a source ARN condition to restrict access to a single resource. Lambda permissions for S3 and SES should also contain a source account condition, because S3 and SES ARNs do not contain an AWS account ID.",
  "id": "FG_R00499",
  "title": "Lambda permissions with a service principal should apply to only one resource and AWS account"
}

resource_type := "MULTIPLE"

requires_source_account := {
  "s3.amazonaws.com",
  "ses.amazonaws.com"
}

is_service_principal(p) {
  endswith(p, ".amazonaws.com")
}

has_source_arn_and_account(permission) {
  permission.source_arn = _
  permission.source_account = _
}

invalid_permission(permission) = ret {
  requires_source_account[permission.principal]
  not has_source_arn_and_account(permission)
  ret = sprintf("Lambda permission '%s' should have both a source ARN condition and a source account condition.", [permission.id])
}

invalid_permission(permission) = ret {
  is_service_principal(permission.principal)
  not permission.source_arn
  ret = sprintf("Lambda permission '%s' should have a source ARN condition.", [permission.id])
}

invalid_perms_by_key := {k: invalid_ps |
  ps = lib.perm_by_key[k]
  invalid_ps = [p | p = invalid_permission(ps[_])]
}

policy[j] {
  func = lib.funcs_by_key[k][_]
  not invalid_perms_by_key[k]
  j = fugue.allow_resource(func)
}

policy[j] {
  func = lib.funcs_by_key[k][_]
  count(invalid_perms_by_key[k]) == 0
  j = fugue.allow_resource(func)
}

policy[j] {
  func = lib.funcs_by_key[k][_]
  count(invalid_perms_by_key[k]) > 0
  msg = concat(" ", invalid_perms_by_key[k])
  j = fugue.deny_resource_with_message(func, msg)
}
