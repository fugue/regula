# Copyright 2020 Fugue, Inc.
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

# Update a nested object or array with a number of patches.  For some examples,
# see `tests/lib/util_update_test.rego`.
package util.update

import data.util.merge

update(obj, patches) = ret {
  # No patches needed.
  count(patches) == 0
  ret := obj
} else = ret {
  # Patch replacing the whole object.
  patch := patches[_]
  count(patch[0]) == 0
  ret = patch[1]
} else = ret {
  is_array(obj)
  ret := [v |
    obj_v := obj[obj_i]
    rec_patches := update_nested_patches(obj_i, patches)
    v := update_1(obj_v, rec_patches)
  ]
} else = ret {
  is_object(obj)
  ret := merge.merge({obj_k: v |
    obj_v := obj[obj_k]
    rec_patches := update_nested_patches(obj_k, patches)
    v := update_1(obj_v, rec_patches)
  }, {path[0]: patch[1] |
    patch := patches[_]
    path := patch[0]
    count(path) == 1
    not merge.exists(obj, path[0])
  })
} else = ret {
  ret := obj
}

update_1(obj, patches) = ret {
  # No patches needed.
  count(patches) == 0
  ret := obj
} else = ret {
  # Patch replacing the whole object.
  patch := patches[_]
  count(patch[0]) == 0
  ret := patch[1]
} else = ret {
  is_array(obj)
  ret := [v |
    obj_v := obj[obj_i]
    rec_patches := update_nested_patches(obj_i, patches)
    v := update_2(obj_v, rec_patches)
  ]
} else = ret {
  is_object(obj)
  ret := merge.merge({obj_k: v |
    obj_v := obj[obj_k]
    rec_patches := update_nested_patches(obj_k, patches)
    v := update_2(obj_v, rec_patches)
  }, {path[0]: patch[1] |
    patch := patches[_]
    path := patch[0]
    count(path) == 1
    not merge.exists(obj, path[0])
  })
} else = ret {
  ret := obj
}

update_2(obj, patches) = ret {
  # No patches needed.
  count(patches) == 0
  ret := obj
} else = ret {
  # Patch replacing the whole object.
  patch := patches[_]
  count(patch[0]) == 0
  ret := patch[1]
} else = ret {
  is_array(obj)
  ret := [v |
    obj_v := obj[obj_i]
    rec_patches := update_nested_patches(obj_i, patches)
    v := update_3(obj_v, rec_patches)
  ]
} else = ret {
  is_object(obj)
  ret := merge.merge({obj_k: v |
    obj_v := obj[obj_k]
    rec_patches := update_nested_patches(obj_k, patches)
    v := update_3(obj_v, rec_patches)
  }, {path[0]: patch[1] |
    patch := patches[_]
    path := patch[0]
    count(path) == 1
    not merge.exists(obj, path[0])
  })
} else = ret {
  ret := obj
}

update_3(obj, patches) = ret {
  # No patches needed.
  count(patches) == 0
  ret := obj
} else = ret {
  # Patch replacing the whole object.
  patch := patches[_]
  count(patch[0]) == 0
  ret := patch[1]
} else = ret {
  is_array(obj)
  ret := [v |
    obj_v := obj[obj_i]
    rec_patches := update_nested_patches(obj_i, patches)
    v := update_4(obj_v, rec_patches)
  ]
} else = ret {
  is_object(obj)
  ret := merge.merge({obj_k: v |
    obj_v := obj[obj_k]
    rec_patches := update_nested_patches(obj_k, patches)
    v := update_4(obj_v, rec_patches)
  }, {path[0]: patch[1] |
    patch := patches[_]
    path := patch[0]
    count(path) == 1
    not merge.exists(obj, path[0])
  })
} else = ret {
  ret := obj
}

update_4(obj, patches) = ret {
  # No patches needed.
  count(patches) == 0
  ret := obj
} else = ret {
  # Patch replacing the whole object.
  patch := patches[_]
  count(patch[0]) == 0
  ret := patch[1]
} else = ret {
  is_array(obj)
  ret := [v |
    obj_v := obj[obj_i]
    rec_patches := update_nested_patches(obj_i, patches)
    v := update_5(obj_v, rec_patches)
  ]
} else = ret {
  is_object(obj)
  ret := merge.merge({obj_k: v |
    obj_v := obj[obj_k]
    rec_patches := update_nested_patches(obj_k, patches)
    v := update_5(obj_v, rec_patches)
  }, {path[0]: patch[1] |
    patch := patches[_]
    path := patch[0]
    count(path) == 1
    not merge.exists(obj, path[0])
  })
} else = ret {
  ret := obj
}

update_5(obj, patches) = ret {
  # No patches needed.
  count(patches) == 0
  ret := obj
} else = ret {
  # Patch replacing the whole object.
  patch := patches[_]
  count(patch[0]) == 0
  ret := patch[1]
} else = ret {
  is_array(obj)
  ret := [v |
    obj_v := obj[obj_i]
    rec_patches := update_nested_patches(obj_i, patches)
    v := update_6(obj_v, rec_patches)
  ]
} else = ret {
  is_object(obj)
  ret := merge.merge({obj_k: v |
    obj_v := obj[obj_k]
    rec_patches := update_nested_patches(obj_k, patches)
    v := update_6(obj_v, rec_patches)
  }, {path[0]: patch[1] |
    patch := patches[_]
    path := patch[0]
    count(path) == 1
    not merge.exists(obj, path[0])
  })
} else = ret {
  ret := obj
}

update_6(obj, patches) = ret {
  # No patches needed.
  count(patches) == 0
  ret := obj
} else = ret {
  # Patch replacing the whole object.
  patch := patches[_]
  count(patch[0]) == 0
  ret := patch[1]
} else = ret {
  is_array(obj)
  ret := [v |
    obj_v := obj[obj_i]
    rec_patches := update_nested_patches(obj_i, patches)
    v := update_end(obj_v, rec_patches)
  ]
} else = ret {
  is_object(obj)
  ret := merge.merge({obj_k: v |
    obj_v := obj[obj_k]
    rec_patches := update_nested_patches(obj_k, patches)
    v := update_end(obj_v, rec_patches)
  }, {path[0]: patch[1] |
    patch := patches[_]
    path := patch[0]
    count(path) == 1
    not merge.exists(obj, path[0])
  })
} else = ret {
  ret := obj
}

update_end(obj, patches) = obj {
  true
}

update_nested_patches(k, patches) = ret {
  ret = [[path_tail, patch[1]] |
    patch := patches[_]
    not patch[0][0] != k
    path_tail := array.slice(patch[0], 1, count(patch[0]))
  ]
}
