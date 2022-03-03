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
package tests.rules.tf.aws.kms.inputs.key_rotation_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "aws_kms_key.blank-invalid": {
      "_filepath": "tests/rules/tf/aws/kms/inputs/key_rotation_infra.tf",
      "_provider": "aws",
      "_type": "aws_kms_key",
      "description": "KMS key 3",
      "id": "aws_kms_key.blank-invalid"
    },
    "aws_kms_key.invalid": {
      "_filepath": "tests/rules/tf/aws/kms/inputs/key_rotation_infra.tf",
      "_provider": "aws",
      "_type": "aws_kms_key",
      "description": "KMS key 2",
      "enable_key_rotation": false,
      "id": "aws_kms_key.invalid"
    },
    "aws_kms_key.valid": {
      "_filepath": "tests/rules/tf/aws/kms/inputs/key_rotation_infra.tf",
      "_provider": "aws",
      "_type": "aws_kms_key",
      "description": "KMS key 1",
      "enable_key_rotation": true,
      "id": "aws_kms_key.valid"
    }
  }
}

