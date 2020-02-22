import lexer

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

# execute lexer test

# outline: get expected byte from newLexer function
# expected_value: expected boolean
proc run_newLexer_test(): void =
  echo "Run newLexer test"
  var lex = newLexer("testtest", 0, 0, 0)
  # check newLexer contents
  eq_value("check input contents", "testtest", lex.get("input"))

proc run_test(): void =
  run_newLexer_test()



run_test()