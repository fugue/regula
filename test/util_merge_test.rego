package util.merge

test_merge {
  merge({}, {}) == {}
  merge({"l": 1}, {"r": 2}) == {"l": 1, "r": 2}
  merge({"l": 1}, {"l": 2}) == {"l": 2}
}
