import lexer
import ../test_utils/test_utils as test

# execute lexer test

# outline: get expected byte from newLexer function
# expected_value: expected boolean
proc run_newLexer_test(): void =
  echo "Run newLexer test"
  var lex = newLexer("testtest", 0, 0, 0)
  # check newLexer contents
  test.eq_value("check input contents", "testtest", lex.input)
  test.eq_value("check position contents", 0, lex.position)
  test.eq_value("check readPosition contents", 0, lex.readPosition)
  test.eq_value("check ch contents", 0.byte, lex.ch)

proc run_test(): void =
  run_newLexer_test()

run_test()