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
package aws.rds.encryption_library

import data.fugue


# The set of customer-managed CMKs.  The idea here is that AWS-managed CMKs do
# not appear in the survey output.
customer_managed_key_arns = {arn |
  kms_keys = fugue.resources("aws_kms_key")
  arn = kms_keys[_].arn
}

# This is like `customer_managed_key_arns` but for design-time validations.
customer_managed_key_ids = {id |
  kms_keys = fugue.resources("aws_kms_key")
  id = kms_keys[_].id
}

valid_kms_arn_prefix = {
  "arn:aws:kms:",
  "arn:aws-us-gov:kms:"
}

# Retrieve the encryption key ARN.
kms_encryption_key_arn(instance_or_cluster) = arn {
  arn = instance_or_cluster.kms_key_id
  valid_kms_arn_prefix[k]
  startswith(arn, k)
}

# Check if an instance is encrypted.
is_encrypted(instance_or_cluster) {
  instance_or_cluster.storage_encrypted == true
}

# Check if an instance is encrypted using a customer-managed CMK.
is_encrypted_using_customer_managed_cmk(instance_or_cluster) {
  is_encrypted(instance_or_cluster)
  arn = kms_encryption_key_arn(instance_or_cluster)
  customer_managed_key_arns[arn]
} {
  is_encrypted(instance_or_cluster)
  customer_managed_key_ids[instance_or_cluster.kms_key_id]
}

# All DB instances.
instances_or_clusters[id] = ret {
  instances = fugue.resources("aws_db_instance")
  ret = instances[id]
} {
  clusters = fugue.resources("aws_rds_cluster")
  ret = clusters[id]
}

