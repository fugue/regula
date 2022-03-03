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
package tests.rules.tf.aws.s3.inputs.bucket_sse_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "aws_kms_key.key": {
      "_filepath": "tests/rules/tf/aws/s3/inputs/bucket_sse_infra.tf",
      "_provider": "aws",
      "_type": "aws_kms_key",
      "id": "aws_kms_key.key"
    },
    "aws_s3_bucket.aes_encrypted": {
      "_filepath": "tests/rules/tf/aws/s3/inputs/bucket_sse_infra.tf",
      "_provider": "aws",
      "_type": "aws_s3_bucket",
      "force_destroy": true,
      "id": "aws_s3_bucket.aes_encrypted",
      "server_side_encryption_configuration": [
        {
          "rule": [
            {
              "apply_server_side_encryption_by_default": [
                {
                  "sse_algorithm": "AES256"
                }
              ]
            }
          ]
        }
      ]
    },
    "aws_s3_bucket.kms_encrypted": {
      "_filepath": "tests/rules/tf/aws/s3/inputs/bucket_sse_infra.tf",
      "_provider": "aws",
      "_type": "aws_s3_bucket",
      "force_destroy": true,
      "id": "aws_s3_bucket.kms_encrypted",
      "server_side_encryption_configuration": [
        {
          "rule": [
            {
              "apply_server_side_encryption_by_default": [
                {
                  "kms_master_key_id": "aws_kms_key.key",
                  "sse_algorithm": "aws:kms"
                }
              ]
            }
          ]
        }
      ]
    },
    "aws_s3_bucket.unencrypted": {
      "_filepath": "tests/rules/tf/aws/s3/inputs/bucket_sse_infra.tf",
      "_provider": "aws",
      "_type": "aws_s3_bucket",
      "force_destroy": true,
      "id": "aws_s3_bucket.unencrypted"
    }
  }
}

