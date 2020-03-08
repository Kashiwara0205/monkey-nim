import token
import ../test_utils/test_utils as test

# execute token test

# outline: get expected value from newToken function
# expected_value: expected value
block newToken_test:
  echo "should get expected token struct"
  var token = newToken("IDENT", 97.byte)
  test.eq_value("IDENT", token.t_type)
  test.eq_value("a", token.literal)

# outline: get expected boolean from lookupIdent function
# expected_value: expected boolean
block lookupIdent_test:
  echo "Run lookupIdent minitest"
  # check value
  var result = token.lookupIdent("value")
  test.eq_value_with_testname("check value", "IDENT", result)

  # check hoge
  result = token.lookupIdent("hoge")
  test.eq_value_with_testname("check hoge", "IDENT", result)

  # check fn
  result = token.lookupIdent("fn")
  test.eq_value_with_testname("check fn", "FUNCTION", result)

  # check let
  result = token.lookupIdent("let")
  test.eq_value_with_testname("check let", "LET", result)

  # check else
  result = token.lookupIdent("else")
  test.eq_value_with_testname("check else", "else", result)

  # check return
  result = token.lookupIdent("return")
  test.eq_value_with_testname("check return", "return", result)