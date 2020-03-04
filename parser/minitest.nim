import ../ast/ast
import ../test_utils/test_utils as test

block let_test:
  var program = test.get_program("let x = 5;")

  test.eq_value(1, program.statements.len)
  var statment = program.statements[0]
  test.eq_value("LET", ast.LetStatement(statment).tok.t_type)
  test.eq_value("IDENT", ast.LetStatement(statment).name.tok.t_type)
  test.eq_value("x", ast.LetStatement(statment).name.variable_name)
  var expression = IntegerLiteral(ast.LetStatement(statment).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(5, expression.number)

  program = test.get_program("""
    let a = 1;
    let b = 5;
  """)

  test.eq_value(2, program.statements.len)
  statment = program.statements[0]
  test.eq_value("LET", ast.LetStatement(statment).tok.t_type)
  test.eq_value("IDENT", ast.LetStatement(statment).name.tok.t_type)
  test.eq_value("a", ast.LetStatement(statment).name.variable_name)
  expression = IntegerLiteral(ast.LetStatement(statment).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(1, expression.number)

  statment = program.statements[1]
  test.eq_value("LET", ast.LetStatement(statment).tok.t_type)
  test.eq_value("IDENT", ast.LetStatement(statment).name.tok.t_type)
  test.eq_value("b", ast.LetStatement(statment).name.variable_name)
  expression = IntegerLiteral(ast.LetStatement(statment).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(5, expression.number)
