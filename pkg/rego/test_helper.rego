package regula

import data.fugue.resource_view.resource_view_input

mock_input(iac_configs) = ret {
  iac_config = iac_configs[_]
  ret = resource_view_input with input as iac_config.content
}
