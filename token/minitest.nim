import token

# prepare error handling
var
  e: ref OSError
new(e)
e.msg = "Faild test"

proc eq_value(testname: string, expected: any, val: any): void =
  echo testname, " ->"
  if(expected == val):
    echo "OK"
  else:
    raise e

# execute token test

# outline: get expected boolean from LookupIdent function
# expected_value: expected boolean
proc run_test(): void =
  echo "Run LookupIdent minitest"
  # check value
  var result = token.LookupIdent("value")
  eq_value("check value", "IDENT", result)

  # check hoge
  result = token.LookupIdent("hoge")
  eq_value("check hoge", "IDENT", result)

  # check fn
  result = token.LookupIdent("fn")
  eq_value("check fn", "FUNCTION", result)

  # check let
  result = token.LookupIdent("let")
  eq_value("check let", "LET", result)

  # check else
  result = token.LookupIdent("else")
  eq_value("check else", "else", result)

  # check return
  result = token.LookupIdent("return")
  eq_value("check return", "return", result)


run_test()