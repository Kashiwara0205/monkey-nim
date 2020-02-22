import lexer
import ../test_utils/test_utils as test

# execute lexer test

# outline: get expected byte from newLexer function
# expected_value: expected boolean
proc run_newLexer_test(): void =
  echo "Run newLexer test"
  var lex = newLexer("testtest", 0, 0, 0)
  # check Lexer type
  test.eq_value_with_testname("check input contents", "testtest", lex.input)
  test.eq_value_with_testname("check position contents", 0, lex.position)
  test.eq_value_with_testname("check readPosition contents", 0, lex.readPosition)
  test.eq_value_with_testname("check ch contents", 0.byte, lex.ch)

# outline: get expected byte type value from peekChar function
# expected_value: expected byte value
proc run_peekChar_test(): void =
  echo "Run peekChar test"
  output_testname("should return byte type value")
  # [a]
  var lex = newLexer("a", 0, 0, 0)

  # [a] b c
  eq_value(97.byte, lex.peekChar())
  lex = newLexer("abc", 0, 0, 0)
  eq_value(97.byte, lex.peekChar())

  # a [b] c
  lex = newLexer("abc", 0, 1, 0)
  eq_value(98.byte, lex.peekChar())

  # a b [c]
  lex = newLexer("abc", 0, 2, 0)
  eq_value(99.byte, lex.peekChar())

  # a b c [ ]
  output_testname("should return 0")
  lex = newLexer("abc", 0, 3, 0)
  eq_value(0.byte, lex.peekChar())


proc run_test(): void =
  run_newLexer_test()
  run_peekChar_test()

run_test()