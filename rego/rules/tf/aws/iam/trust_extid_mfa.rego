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
package rules.aws_iam_trust_extid_mfa

import data.fugue

# IAM roles used for trust relationships should have MFA or external IDs
# 
# aws_iam_role


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_16.3",
        "CIS-Controls_v7.1_4.5"
      ]
    },
    "severity": "High"
  },
  "description": "IAM roles used for trust relationships should have MFA or external IDs. IAM roles that establish trust with other AWS accounts should use additional security measures such as MFA or external IDs. This can protect your account if the trusted account is compromised and can also prevent the \"confused deputy problem.\"",
  "id": "FG_R00255",
  "title": "IAM roles used for trust relationships should have MFA or external IDs"
}

resource_type = "aws_iam_role"

default deny = false

# Find account number from an ARN or IAM principal
account_from_iam_arn_or_principal(arn) = account {
    parts = split(arn, ":")
    account = parts[4]
    account != ""
}

# Only work on AWS principals
# Valid examples:
#  Service principal: {"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}
#  Not IAM role owner: {"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::810369035479:root"},"Action":"sts:AssumeRole","Condition":{"StringEquals":{"sts:ExternalID":"foobarbazqux"}}}]}
#  IAM role owner: {"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::895556027146:root"},"Action":"sts:AssumeRole","Condition":{"StringEquals":{"sts:ExternalID":"foobarbazqux"}}}]}
#  IAM role owner: {"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::895556027146:root"},"Action":"sts:AssumeRole"}]}
external_principal(role, statement) {
    # Case for regula - arn will be undefined, so treat every AWS principal
    # as an external account
    not role.arn
    principals = as_array(statement.Principal)
    principal = principals[_]
    principal_awss = as_array(principal.AWS)
    count(principal_awss) >= 1
} {
    principals = as_array(statement.Principal)
    principal = principals[_]
    principal_awss = as_array(principal.AWS)
    principal_aws = principal_awss[_]
    this_account = account_from_iam_arn_or_principal(role.arn)
    that_account = account_from_iam_arn_or_principal(principal_aws)
    this_account != that_account
}

valid_condition(statement) {
    statement.Condition.Bool[j] == "true"
    lower(j) == "aws:multifactorauthpresent"
} {
    statement.Condition.StringEquals[j] != ""
    lower(j) == "sts:externalid"
}

deny {
    json.unmarshal(input.assume_role_policy, doc)
    statements = as_array(doc.Statement)
    statement = statements[_]

    not valid_condition(statement)
    external_principal(input, statement)
}

as_array(x) = [x] {not is_array(x)} else = x {true}

