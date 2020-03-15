import ../token/token
import ../ast/ast
import ../lexer/lexer
import ../parser/parser

# prepare error handling
var
  e: ref OSError
new(e)

proc get_program*(input: string): ast.Program =
  let lex = lexer.newLexer(input)
  let p = lex.newParser()
  return p.parseProgram().program

proc output_testname*(testname: string): void =
  echo "+-+-+-+-+-+-+-+-+-+"
  echo testname
  echo "+-+-+-+-+-+-+-+-+-+"

proc output_failure_result(expected: any, val: any): void =
  echo "[:ERROR]"
  echo "+-+-+-+-+-+-+-+-+-+"
  echo "expected => ", expected
  echo "value =>", val
  echo "+-+-+-+-+-+-+-+-+-+"

proc eq_value_with_testname*(testname: string, expected: any, val: any): void =
  output_testname(testname)
  if(expected == val):
    echo "=> PASS"
    echo ""
  else:
    e.msg = "Failure"
    output_failure_result(expected, val)
    raise e
    
proc eq_value*(expected: any, val: any): void =
  if(expected == val):
    echo "=> PASS"
    echo ""
  else:
    e.msg = "Failure"
    output_failure_result(expected, val)
    raise e

proc eq_token*(tok: Token, t_type: string, literal: string): void =
  eq_value(t_type, tok.t_type)
  eq_value(literal, tok.literal)