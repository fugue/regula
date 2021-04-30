package regula

import data.fugue.resource_view.resource_view_input

mock_input(path) = ret {
  iac_configs := regula.load(path)
  iac_config = iac_configs[_]
  iac_config.filepath == path
  ret = resource_view_input with input as iac_config.content
}
