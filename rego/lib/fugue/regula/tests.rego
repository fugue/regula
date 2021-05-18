package fugue.regula.tests

import data.fugue.resource_view.resource_view_input

mock_input(iac_configs) = ret {
  is_array(iac_configs)
  count(iac_configs) > 0
  iac_config = iac_configs[0]
  ret = resource_view_input with input as iac_config.content
}
