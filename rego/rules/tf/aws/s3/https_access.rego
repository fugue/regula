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
package rules.tf_aws_s3_https_access

import data.fugue
import data.aws.s3.s3_library as lib
import data.aws.iam.policy_document_library as doclib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_2.1.2"
      ]
    },
    "severity": "Medium"
  },
  "description": "S3 bucket policies should only allow requests that use HTTPS. To protect data in transit, an S3 bucket policy should deny all HTTP requests to its objects and allow only HTTPS requests. HTTPS uses Transport Layer Security (TLS) to encrypt data, which preserves integrity and prevents tampering.",
  "id": "FG_R00100",
  "title": "S3 bucket policies should only allow requests that use HTTPS"
}

# This checks if this statement denies HTTPS requests.  In order for a statement
# to match:
#
# - `Effect` needs to be set to `Deny`
# - `Condition` needs to be set to `aws:SecureTransport == false`
# - `Action` needs to set to `s3:GetObject` or `s3:*`, or `*`
specifies_secure_transport(statement) {
  secure_transport_values = as_array(statement.Condition.Bool["aws:SecureTransport"])
  secure_transport_values == ["false"]
  statement.Effect == "Deny"

  actions = as_array(statement.Action)
  related_actions = {"s3:GetObject", "s3:*", "*"}
  related_actions[actions[_]]
}

buckets = fugue.resources("aws_s3_bucket")

# A valid policy specifies a `specifies_secure_transport` statement for the
# "s3:GetObject" method.  See also:
# <https://aws.amazon.com/blogs/security/how-to-use-bucket-policies-and-apply-defense-in-depth-to-help-secure-your-amazon-s3-data/>
valid_buckets[bucket_id] = bucket {
  bucket = buckets[bucket_id]
  policies = lib.bucket_policies_for_bucket(bucket)
  pol = policies[_]
  doc = doclib.to_policy_document(pol)
  statements = as_array(doc.Statement)
  specifies_secure_transport(statements[_])
}

resource_type = "MULTIPLE"

policy[j] {
  b = valid_buckets[_]
  j = fugue.allow_resource(b)
} {
  b = buckets[id]
  not valid_buckets[id]
  j = fugue.deny_resource(b)
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}

