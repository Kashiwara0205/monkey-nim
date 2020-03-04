import ../lexer/lexer
import ../ast/ast
import parser
import ../test_utils/test_utils as test

block let_test:
  let input = "let x = 5;"
  let lex = lexer.newLexer(input)
  let p = lex.newParser()
  let program = p.parseProgram()
  test.eq_value(1, program.statements.len)

  var statment = program.statements[0]
  test.eq_value("LET", ast.LetStatement(statment).tok.t_type)
  test.eq_value("IDENT", ast.LetStatement(statment).name.tok.t_type)
  test.eq_value("x", ast.LetStatement(statment).name.variable_name)
  var expression = IntegerLiteral(ast.LetStatement(statment).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(5, expression.number)