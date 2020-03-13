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
  ret = deny_resource_with_message(resource, "")
}

deny_resource_with_message(resource, message) = ret {
  ret = {
    "valid": false,
    "id": resource.id,
    "message": message,
    "type": resource._type
  }
}

missing_resource(resource_type) = ret {
  ret = missing_resource_with_message(resource_type, "")
}

missing_resource_with_message(resource_type, message) = ret {
  ret = {
    "valid": false,
    "id": "",
    "message": message,
    "type": resource_type
  }
}
