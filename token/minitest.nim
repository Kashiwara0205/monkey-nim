import token
import ../test_utils/test_utils as test

# execute token test

# outline: get expected boolean from LookupIdent function
# expected_value: expected boolean
proc run_test(): void =
  echo "Run LookupIdent minitest"
  # check value
  var result = token.LookupIdent("value")
  test.eq_value("check value", "IDENT", result)

  # check hoge
  result = token.LookupIdent("hoge")
  test.eq_value("check hoge", "IDENT", result)

  # check fn
  result = token.LookupIdent("fn")
  test.eq_value("check fn", "FUNCTION", result)

  # check let
  result = token.LookupIdent("let")
  test.eq_value("check let", "LET", result)

  # check else
  result = token.LookupIdent("else")
  test.eq_value("check else", "else", result)

  # check return
  result = token.LookupIdent("return")
  test.eq_value("check return", "return", result)

run_test()