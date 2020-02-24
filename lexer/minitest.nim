import lexer
import ../test_utils/test_utils as test

# execute lexer test

# outline: whether correct run proc nextToken 
# expected_value: get expected string
proc run_nextToken_test(): void =
  echo "Run nextToken Test"

  # let five = 5;
  output_testname("let five = 5;")
  var input = "let five = 5;"
  var lex = newLexer(input)
  var tok = lex.nextToken()
  test.eq_token(tok, "LET", "let")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "five")
  tok = lex.nextToken()
  test.eq_token(tok, "=", "=")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "5")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # let ten = 10;
  output_testname("let ten = 10;")
  input = "let ten = 10;"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "LET", "let")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "ten")
  tok = lex.nextToken()
  test.eq_token(tok, "=", "=")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "10")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # let function
  output_testname("""
  let add = fn(x, y){
    x + y;
  };
  """)

  input = """
  let add = fn(x, y){
    x + y;
  };
  """
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "LET", "let")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "add")
  tok = lex.nextToken()
  test.eq_token(tok, "=", "=")
  tok = lex.nextToken()
  test.eq_token(tok, "FUNCTION", "fn")
  tok = lex.nextToken()
  test.eq_token(tok, "(", "(")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "x")
  tok = lex.nextToken()
  test.eq_token(tok, ",", ",")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "y")
  tok = lex.nextToken()
  test.eq_token(tok, ")", ")")
  tok = lex.nextToken()
  test.eq_token(tok, "{", "{")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "x")
  tok = lex.nextToken()
  test.eq_token(tok, "+", "+")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "y")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "}", "}")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # let result = add(five, ten);
  output_testname("let result = add(five, ten);")
  input = "let result = add(five, ten);"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "LET", "let")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "result")
  tok = lex.nextToken()
  test.eq_token(tok, "=", "=")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "add")
  tok = lex.nextToken()
  test.eq_token(tok, "(", "(")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "five")
  tok = lex.nextToken()
  test.eq_token(tok, ",", ",")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "ten")
  tok = lex.nextToken()
  test.eq_token(tok, ")", ")")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # !-/*5;  
  output_testname("!-/*5;")
  input = "!-/*5;"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "!", "!")
  tok = lex.nextToken()
  test.eq_token(tok, "-", "-")
  tok = lex.nextToken()
  test.eq_token(tok, "/", "/")
  tok = lex.nextToken()
  test.eq_token(tok, "*", "*")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "5")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # 5 < 10 > 5;  
  output_testname("5 < 10 > 5;")
  input = "5 < 10 > 5;"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "5")
  tok = lex.nextToken()
  test.eq_token(tok, "<", "<")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "10")
  tok = lex.nextToken()
  test.eq_token(tok, ">", ">")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "5")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # if statement
  output_testname("""
  if (5 < 10){
    return true;
  }else{
    return false;
  }
  """)

  input = """
  if (5 < 10){
    return true;
  }else{
    return false;
  }
  """
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "if", "if")
  tok = lex.nextToken()
  test.eq_token(tok, "(", "(")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "5")
  tok = lex.nextToken()
  test.eq_token(tok, "<", "<")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "10")
  tok = lex.nextToken()
  test.eq_token(tok, ")", ")")
  tok = lex.nextToken()
  test.eq_token(tok, "{", "{")
  tok = lex.nextToken()
  test.eq_token(tok, "return", "return")
  tok = lex.nextToken()
  test.eq_token(tok, "true", "true")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "}", "}")
  tok = lex.nextToken()
  test.eq_token(tok, "else", "else")
  tok = lex.nextToken()
  test.eq_token(tok, "{", "{")
  tok = lex.nextToken()
  test.eq_token(tok, "return", "return")
  tok = lex.nextToken()
  test.eq_token(tok, "false", "false")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "}", "}")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # 10 == 10;
  output_testname("10 == 10;")
  input = "10 == 10;"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "10")
  tok = lex.nextToken()
  test.eq_token(tok, "==", "==")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "10")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")
  output_testname("10 != 9;")

  # 10 != 9;
  input = "10 != 9;"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "10")
  tok = lex.nextToken()
  test.eq_token(tok, "!=", "!=")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "9")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # foobar
  output_testname("foobar")
  input = "foobar"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "foobar")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # foo bar
  output_testname("foo bar")
  input = "foo bar"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "foo")
  tok = lex.nextToken()
  test.eq_token(tok, "IDENT", "bar")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # [1, 2];
  output_testname("[1, 2];")
  input = "[1, 2];"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "[", "[")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "1")
  tok = lex.nextToken()
  test.eq_token(tok, ",", ",")
  tok = lex.nextToken()
  test.eq_token(tok, "INT", "2")
  tok = lex.nextToken()
  test.eq_token(tok, "]", "]")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

  # {"foo": "bar"};
  output_testname("{\"foo\": \"bar\"}")
  input = "{\"foo\": \"bar\"};"
  lex = newLexer(input)
  tok = lex.nextToken()
  test.eq_token(tok, "{", "{")
  tok = lex.nextToken()
  test.eq_token(tok, "STRING", "foo")
  tok = lex.nextToken()
  test.eq_token(tok, ":", ":")
  tok = lex.nextToken()
  test.eq_token(tok, "STRING", "bar")
  tok = lex.nextToken()
  test.eq_token(tok, "}", "}")
  tok = lex.nextToken()
  test.eq_token(tok, ";", ";")
  tok = lex.nextToken()
  test.eq_token(tok, "EOF", "")

# outline: whether correct run proc readString 
# expected_value: get expected string
proc run_readString_test(): void =
  echo "Run readString Test"
  let input = "\"hogehoge\""
  var lex = newLexer(input)
  # ["]hogehoge"
  test.eq_value(input, lex.input)
  test.eq_value(0, lex.position)
  test.eq_value(1, lex.readPosition)
  test.eq_value(34.byte, lex.ch)

  var ident = lex.readString()
  test.eq_value("hogehoge", ident)

  # "hogehoge"[]
  lex.readChar()
  test.eq_value(input, lex.input)
  test.eq_value(10, lex.position)
  test.eq_value(11, lex.readPosition)
  test.eq_value(0.byte, lex.ch)

# outline: whether correct run proc readIdentifiter 
# expected_value: get expected number string
proc run_readIdentifiter_test(): void =
  echo "Run readIdentifiter Test"
  let input = "hogehoge1"
  var lex = newLexer(input)
  # [h]ogehoge1
  test.eq_value(input, lex.input)
  test.eq_value(0, lex.position)
  test.eq_value(1, lex.readPosition)
  test.eq_value(104.byte, lex.ch)

  var ident = lex.readIdentifiter()
  test.eq_value("hogehoge", ident)

# outline: whether correct run proc readNumber 
# expected_value: get expected number string
proc run_readNumber_test(): void =
  echo "Run readNumber Test"
  let input = "a3456b1c"
  var lex = newLexer(input)
  # [a]3456b1c
  test.eq_value(input, lex.input)
  test.eq_value(0, lex.position)
  test.eq_value(1, lex.readPosition)
  test.eq_value(97.byte, lex.ch)

  lex.readChar()
  var number = lex.readNumber()
  test.eq_value("3456", number)

  test.eq_value(input, lex.input)
  test.eq_value(5, lex.position)
  test.eq_value(6, lex.readPosition)
  test.eq_value(98.byte, lex.ch)

  lex.readChar()
  number = lex.readNumber()
  test.eq_value("1", number)

  test.eq_value(input, lex.input)
  test.eq_value(7, lex.position)
  test.eq_value(8, lex.readPosition)
  test.eq_value(99.byte, lex.ch)

# outline: whether correct run proc skipWhitespace
# expected_value: get expected property which skip space
proc run_skipWhitespace_test(): void = 
  echo "Run skipWhitespace Test"
  let input = "a         b     c"
  var lex = newLexer(input)
  # [a]         b     c
  test.eq_value(input, lex.input)
  test.eq_value(0, lex.position)
  test.eq_value(1, lex.readPosition)
  test.eq_value(97.byte, lex.ch)

  lex.readChar()
  lex.skipWhitespace()

  # a         [b]     c
  test.eq_value(input, lex.input)
  test.eq_value(10, lex.position)
  test.eq_value(11, lex.readPosition)
  test.eq_value(98.byte, lex.ch)

  lex.readChar()
  lex.skipWhitespace()

  # a         b     [c]
  test.eq_value(input, lex.input)
  test.eq_value(16, lex.position)
  test.eq_value(17, lex.readPosition)
  test.eq_value(99.byte, lex.ch)

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
  run_skipWhitespace_test()
  run_readNumber_test()
  run_readIdentifiter_test()
  run_readString_test()
  run_nextToken_test()

run_test()