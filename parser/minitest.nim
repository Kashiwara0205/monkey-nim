import ../ast/ast
import ../test_utils/test_utils as test

block let_test:
  var program = test.get_program("let x = 5;")

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("LET", ast.LetStatement(statement).tok.t_type)
  test.eq_value("IDENT", ast.LetStatement(statement).name.tok.t_type)
  test.eq_value("x", ast.LetStatement(statement).name.variable_name)
  var expression = IntegerLiteral(ast.LetStatement(statement).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(5, expression.number)

  program = test.get_program("""
    let a = 1;
    let b = 5;
  """)

  test.eq_value(2, program.statements.len)
  statement = program.statements[0]
  test.eq_value("LET", ast.LetStatement(statement).tok.t_type)
  test.eq_value("IDENT", ast.LetStatement(statement).name.tok.t_type)
  test.eq_value("a", ast.LetStatement(statement).name.variable_name)
  expression = IntegerLiteral(ast.LetStatement(statement).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(1, expression.number)

  statement = program.statements[1]
  test.eq_value("LET", ast.LetStatement(statement).tok.t_type)
  test.eq_value("IDENT", ast.LetStatement(statement).name.tok.t_type)
  test.eq_value("b", ast.LetStatement(statement).name.variable_name)
  expression = IntegerLiteral(ast.LetStatement(statement).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(5, expression.number)

block return_test:
  var program = test.get_program("return 5;")

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("return", ast.ReturnStatement(statement).tok.t_type)
  var expression = IntegerLiteral(ast.ReturnStatement(statement).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(5, expression.number)

  program = test.get_program("""
    return 10;
    return 15;
  """)

  test.eq_value(2, program.statements.len)
  statement = program.statements[0]
  test.eq_value("return", ast.ReturnStatement(statement).tok.t_type)
  expression = IntegerLiteral(ast.ReturnStatement(statement).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(10, expression.number)

  statement = program.statements[1]
  test.eq_value("return", ast.ReturnStatement(statement).tok.t_type)
  expression = IntegerLiteral(ast.ReturnStatement(statement).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(15, expression.number)

  program = test.get_program("""
    let x = 5;
    return x;
  """)

  test.eq_value(2, program.statements.len)
  statement = program.statements[0]
  test.eq_value("LET", ast.LetStatement(statement).tok.t_type)
  test.eq_value("IDENT", ast.LetStatement(statement).name.tok.t_type)
  test.eq_value("x", ast.LetStatement(statement).name.variable_name)
  expression = IntegerLiteral(ast.LetStatement(statement).expression)
  test.eq_value("INT", expression.tok.t_type)
  test.eq_value(5, expression.number)

  statement = program.statements[1]
  test.eq_value("return", ast.ReturnStatement(statement).tok.t_type)
  var identifier = Identifier(ast.ReturnStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

block identifier_test:
  var program = test.get_program("x;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("IDENT", ast.ExpressionStatement(statement).tok.t_type)
  var identifier = Identifier(ast.ExpressionStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

block integer_literal_test:
  var program = test.get_program("5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("INT", ast.ExpressionStatement(statement).tok.t_type)
  var integer_literal = IntegerLiteral(ast.ExpressionStatement(statement).expression)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)