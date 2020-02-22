import token
import ../test_utils/test_utils as test

# execute token test

# outline: get expected boolean from LookupIdent function
# expected_value: expected boolean
proc run_test(): void =
  echo "Run LookupIdent minitest"
  # check value
  var result = token.LookupIdent("value")
  test.eq_value_with_testname("check value", "IDENT", result)

  # check hoge
  result = token.LookupIdent("hoge")
  test.eq_value_with_testname("check hoge", "IDENT", result)

  # check fn
  result = token.LookupIdent("fn")
  test.eq_value_with_testname("check fn", "FUNCTION", result)

  # check let
  result = token.LookupIdent("let")
  test.eq_value_with_testname("check let", "LET", result)

  # check else
  result = token.LookupIdent("else")
  test.eq_value_with_testname("check else", "else", result)

  # check return
  result = token.LookupIdent("return")
  test.eq_value_with_testname("check return", "return", result)

run_test()