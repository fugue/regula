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
