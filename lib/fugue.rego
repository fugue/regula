package fugue

resource_types = {rt |
  r = input.resources[_]
  rt = r._type
}

resources_by_type = {rt: rs |
  resource_types[rt]
  rs = {ri: r |
    r = input.resources[ri]
    r._type == rt
  }
}

plan = ret {
  ret = input._plan
}

resources(rt) = ret {
  ret = resources_by_type[rt]
}

allow_resource(resource) = ret {
  ret = {
    "valid": true,
    "id": resource.id,
    "message": "",
    "type": resource._type
  }
}

deny_resource(resource) = ret {
  ret = {
    "valid": false,
    "id": resource.id,
    "message": "invalid",
    "type": resource._type
  }
}

missing_resource(resource_type) = ret {
  ret = {
    "valid": false,
    "id": "",
    "message": "invalid",
    "type": resource_type
  }
}
