import lexer
import ../test_utils/test_utils as test

# execute lexer test

# outline: get expected byte from newLexer function
# expected_value: expected boolean
proc run_newLexer_test(): void =
  echo "Run newLexer test"
  var lex = newLexer("testtest")
  # check Lexer type
  test.eq_value_with_testname("check input contents", "testtest", lex.input)
  test.eq_value_with_testname("check position contents", 0, lex.position)
  test.eq_value_with_testname("check readPosition contents", 1, lex.readPosition)
  test.eq_value_with_testname("check ch contents", 116.byte, lex.ch)

# outline: get expected byte type value from peekChar function
# expected_value: expected byte value
proc run_peekChar_test(): void =
  echo "Run peekChar test"
  output_testname("should return byte type value")
  # a [b]
  var lex = newLexer("ab")
  eq_value(98.byte, lex.peekChar())

  # b [a]
  lex = newLexer("ba")
  eq_value(97.byte, lex.peekChar())

# outline: get expected byte type value from readChar function
# expected_value: expected byte value
proc run_readChar_test(): void =
  echo "Run readChar test"
  output_testname("should get next byte type value")

  var lex = newLexer("abc")

  # [A] B C
  test.eq_value("abc", lex.input)
  test.eq_value(0, lex.position)
  test.eq_value(1, lex.readPosition)
  test.eq_value(97.byte, lex.ch)

  # A [B] C
  lex.readChar()
  test.eq_value("abc", lex.input)
  test.eq_value(1, lex.position)
  test.eq_value(2, lex.readPosition)
  test.eq_value(98.byte, lex.ch)

  # A B [C]
  lex.readChar()
  test.eq_value("abc", lex.input)
  test.eq_value(2, lex.position)
  test.eq_value(3, lex.readPosition)
  test.eq_value(99.byte, lex.ch)

  # A B C []
  lex.readChar()
  test.eq_value("abc", lex.input)
  test.eq_value(3, lex.position)
  test.eq_value(4, lex.readPosition)
  test.eq_value(0.byte, lex.ch)

proc run_test(): void =
  run_newLexer_test()
  run_peekChar_test()
  run_readChar_test()

run_test()