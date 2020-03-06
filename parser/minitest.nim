import ../ast/ast
import ../test_utils/test_utils as test

# outline: whther be able to parse let
# expected_value: expected let statement
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

# outline: whther be able to parse return
# expected_value: expected return statement
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

# outline: whther be able to parse identifier
# expected_value: expected identifier
block identifier_test:
  var program = test.get_program("x;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("IDENT", ast.ExpressionStatement(statement).tok.t_type)
  var identifier = Identifier(ast.ExpressionStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

# outline: whther be able to parse integer_literal
# expected_value: expected integer_literal
block integer_literal_test:
  var program = test.get_program("5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("INT", ast.ExpressionStatement(statement).tok.t_type)
  var integer_literal = IntegerLiteral(ast.ExpressionStatement(statement).expression)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

# outline: whther be able to parse prefix_expression
# expected_value: expected prefix_expression
block prefix_expression_test:
  var program = test.get_program("!5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var prefix_expression = PrefixExpression(ast.ExpressionStatement(statement).expression)
  test.eq_value("!", prefix_expression.tok.t_type)
  test.eq_value("!", prefix_expression.operator)
  var integer_literal = IntegerLiteral(prefix_expression.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("-15;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  prefix_expression = PrefixExpression(ast.ExpressionStatement(statement).expression)
  test.eq_value("-", prefix_expression.tok.t_type)
  test.eq_value("-", prefix_expression.operator)
  integer_literal = IntegerLiteral(prefix_expression.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(15, integer_literal.number)

  program = test.get_program("!true")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  prefix_expression = PrefixExpression(ast.ExpressionStatement(statement).expression)
  test.eq_value("!", prefix_expression.tok.t_type)
  test.eq_value("!", prefix_expression.operator)
  var boolean = Boolean(prefix_expression.right)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)

  program = test.get_program("!false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  prefix_expression = PrefixExpression(ast.ExpressionStatement(statement).expression)
  test.eq_value("!", prefix_expression.tok.t_type)
  test.eq_value("!", prefix_expression.operator)
  boolean = Boolean(prefix_expression.right)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)

# outline: whther be able to parse infix_expression
# expected_value: expected infix_expression
block infix_expression_test:
  var program = test.get_program("5 + 5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var expression = ast.ExpressionStatement(statement)
  var infix = ast.InfixExpression(expression.expression)
  test.eq_value("+", infix.tok.t_type)
  test.eq_value("+", infix.operator)
  var integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 - 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("-", infix.tok.t_type)
  test.eq_value("-", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 * 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("*", infix.tok.t_type)
  test.eq_value("*", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 / 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("/", infix.tok.t_type)
  test.eq_value("/", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 > 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value(">", infix.tok.t_type)
  test.eq_value(">", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 < 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("<", infix.tok.t_type)
  test.eq_value("<", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 == 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("==", infix.tok.t_type)
  test.eq_value("==", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("5 != 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("!=", infix.tok.t_type)
  test.eq_value("!=", infix.operator)
  integer_literal = IntegerLiteral(infix.right)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)
  integer_literal = IntegerLiteral(infix.left)
  test.eq_value("INT", integer_literal.tok.t_type)
  test.eq_value(5, integer_literal.number)

  program = test.get_program("true == true")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("==", infix.tok.t_type)
  test.eq_value("==", infix.operator)
  var boolean = Boolean(infix.right)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)
  boolean = Boolean(infix.left)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)

  program = test.get_program("true != false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("!=", infix.tok.t_type)
  test.eq_value("!=", infix.operator)
  boolean = Boolean(infix.right)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)
  boolean = Boolean(infix.left)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)

  program = test.get_program("false == false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  infix = ast.InfixExpression(expression.expression)
  test.eq_value("==", infix.tok.t_type)
  test.eq_value("==", infix.operator)
  boolean = Boolean(infix.right)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)
  boolean = Boolean(infix.left)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)

# outline: whther be able to parse boolean
# expected_value: expected boolean
block boolean_test:
  var program = test.get_program("true;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var expression = ast.ExpressionStatement(statement)
  var boolean = ast.Boolean(expression.expression)
  test.eq_value("true", boolean.tok.t_type)
  test.eq_value(true, boolean.value)

  program = test.get_program("false;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  boolean = ast.Boolean(expression.expression)
  test.eq_value("false", boolean.tok.t_type)
  test.eq_value(false, boolean.value)

# outline: whther be able to parse if expression
# expected_value: expected if expression
block if_expression_test:
  var program = test.get_program("""
  if(x < y){
    x
  }
  """)

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  var expression = ast.ExpressionStatement(statement)
  var if_expression = ast.IfExpression(expression.expression)

  # if
  test.eq_value("if", if_expression.tok.t_type)

  # (x < y)
  var infix = ast.InfixExpression(if_expression.condition)
  test.eq_value("<", infix.tok.t_type)
  test.eq_value("<", infix.operator)
  var ident = Identifier(infix.right)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("y", ident.variable_name)
  ident = Identifier(infix.left)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("x", ident.variable_name)

  # { x }
  var block_statement = if_expression.consequence
  test.eq_value(1, block_statement.statements.len)
  statement = block_statement.statements[0]
  test.eq_value("IDENT", ast.ExpressionStatement(statement).tok.t_type)
  var identifier = Identifier(ast.ExpressionStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

  # alternative
  block_statement = if_expression.alternative
  test.eq_value(true, block_statement == nil)

  program = test.get_program("""
  if(x < y){
    x
  }else{
    y
  }
  """)

  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  expression = ast.ExpressionStatement(statement)
  if_expression = ast.IfExpression(expression.expression)

  # if
  test.eq_value("if", if_expression.tok.t_type)

  # (x < y)
  infix = ast.InfixExpression(if_expression.condition)
  test.eq_value("<", infix.tok.t_type)
  test.eq_value("<", infix.operator)
  ident = Identifier(infix.right)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("y", ident.variable_name)
  ident = Identifier(infix.left)
  test.eq_value("IDENT", ident.tok.t_type)
  test.eq_value("x", ident.variable_name)

  # { x }
  block_statement = if_expression.consequence
  test.eq_value(1, block_statement.statements.len)
  statement = block_statement.statements[0]
  test.eq_value("IDENT", ast.ExpressionStatement(statement).tok.t_type)
  identifier = Identifier(ast.ExpressionStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("x", identifier.variable_name)

  # { y }
  block_statement = if_expression.alternative
  test.eq_value(1, block_statement.statements.len)
  statement = block_statement.statements[0]
  test.eq_value("IDENT", ast.ExpressionStatement(statement).tok.t_type)
  identifier = Identifier(ast.ExpressionStatement(statement).expression)
  test.eq_value("IDENT", identifier.tok.t_type)
  test.eq_value("y", identifier.variable_name)