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
package rules.cfn_s3_https_access

import data.fugue
import data.fugue.cfn.s3

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

input_type := "cfn"
resource_type := "MULTIPLE"

buckets := fugue.resources("AWS::S3::Bucket")
bucket_policies := fugue.resources("AWS::S3::BucketPolicy")

policies_for_bucket(bucket) = ret {
  ret := [p | 
    p := bucket_policies[_]
    s3.matches_bucket_name_or_id(bucket, p.Bucket)
  ]
}

specifies_secure_transport(statement) {
  secure_transport_values := as_array(statement.Condition.Bool["aws:SecureTransport"])
  secure_transport_values[_] == false
  statement.Effect == "Deny"

  actions := as_array(statement.Action)
  related_actions := {"s3:GetObject", "s3:*", "*"}
  related_actions[actions[_]]
}

valid_buckets[bucket_id] = bucket {
  bucket := buckets[bucket_id]
  policies := policies_for_bucket(bucket)
  pol := policies[_]
  statements := as_array(pol.PolicyDocument.Statement)
  specifies_secure_transport(statements[_])
}

policy[j] {
  b := valid_buckets[_]
  j := fugue.allow_resource(b)
} {
  b := buckets[id]
  not valid_buckets[id]
  j := fugue.deny_resource(b)
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}
