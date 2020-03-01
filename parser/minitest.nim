import ../lexer/lexer
import ../ast/ast
import parser
import ../test_utils/test_utils as test

# execute token test
proc run_hoge(): void =
  let input = "let x = 5;"
  let lex = lexer.newLexer(input)
  let p = lex.newParser()
 # let program = p.parsePro


proc run_test(): void =
  run_hoge()


run_test()