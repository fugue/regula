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
package fugue.resource_view

import data.tests.lib.inputs.resource_view_05_tf_v0_13_infra_json as v0_13
import data.tests.lib.inputs.resource_view_05_tf_v0_14_infra_json as v0_14
import data.tests.lib.inputs.resource_view_05_tf_v0_15_infra_json as v0_15
import data.tests.lib.inputs.resource_view_05_tf_v1_0_infra_json as v1_0

test_resource_view_05 {
  v0_13.mock_resources == {
    "aws_cloudwatch_log_group.fargate-logs": {
      "_provider": "aws",
      "_type": "aws_cloudwatch_log_group",
      "id": "aws_cloudwatch_log_group.fargate-logs",
      "kms_key_id": "aws_kms_key.cloudwatch",
      "name": "/ecs/fargate-task-definition",
      "name_prefix": null,
      "retention_in_days": 0,
      "tags": null
    },
    "aws_kms_key.cloudwatch": {
      "_provider": "aws",
      "_type": "aws_kms_key",
      "bypass_policy_lockout_safety_check": false,
      "customer_master_key_spec": "SYMMETRIC_DEFAULT",
      "deletion_window_in_days": 10,
      "description": "cloudwatch kms key",
      "enable_key_rotation": true,
      "id": "aws_kms_key.cloudwatch",
      "is_enabled": true,
      "key_usage": "ENCRYPT_DECRYPT",
      "tags": null
    }
  }
  v0_13.mock_resources == v0_14.mock_resources
  v0_14.mock_resources == v0_15.mock_resources
  v0_15.mock_resources == v1_0.mock_resources
}
