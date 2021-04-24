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
package rules.useast1_only

import data.fugue

resource_type = "MULTIPLE"

# Obtain the region set in the provider (if possible) and check that it equals
# "us-east-1".

provider_region = ret {
  provider := fugue.plan.configuration.provider_config.aws
  ret := provider.expressions.region.constant_value
}

policy[p] {
  provider_region != "us-east-1"
  p = fugue.missing_resource("provider")
}
