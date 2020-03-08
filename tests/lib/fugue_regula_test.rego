package fugue.regula

# Simple resource used for testing.
testutil_resource = {
  "id": "testutil_resource",
  "_type": "aws_elb_volume"
}

test_judgement_from_allow_denies_01 {
  j = judgement_from_allow_denies(testutil_resource, [true], [])
  j.valid
}

test_judgement_from_allow_denies_02 {
  j = judgement_from_allow_denies(testutil_resource, [false], [])
  not j.valid
}

test_judgement_from_allow_denies_03 {
  j = judgement_from_allow_denies(testutil_resource, [], [false])
  j.valid
}

test_judgement_from_allow_denies_04 {
  j = judgement_from_allow_denies(testutil_resource, [], [true])
  not j.valid
}

test_judgement_from_allow_denies_05 {
  j = judgement_from_allow_denies(testutil_resource, [true], [false])
  j.valid
}

test_judgement_from_allow_denies_06 {
  j = judgement_from_allow_denies(testutil_resource, [true], [true])
  not j.valid
}

test_judgement_from_allow_denies_07 {
  j = judgement_from_allow_denies(testutil_resource, [false], [false])
  not j.valid
}

test_judgement_from_allow_denies_08 {
  j = judgement_from_allow_denies(testutil_resource, [false], [true])
  not j.valid
}

# Note that when this tests is run, `data.rules[_]` will contain all rules in
# the rules directory as well as the examples. This makes the output of the test
# report extremely volatile.
#
# We should try and fix this by using a with data.rules clause but
# unfortunately, that isn't supported in fregot yet:
#
# <https://github.com/fugue/fregot/issues/178>
#
# For now, we just check the "shape" of the report instead.
test_report {
  r = report
  is_object(r.rules)
  is_object(r.controls)
  is_number(r.summary.rules_failed)
  is_number(r.summary.rules_passed)
  is_number(r.summary.controls_failed)
  is_number(r.summary.controls_passed)
  is_string(r.message)
}
