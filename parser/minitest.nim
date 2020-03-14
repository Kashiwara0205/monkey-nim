import ../ast/ast
import ../test_utils/test_utils as test

# outline: whther be able to parse let
# expected_value: expected let statement
block let_test:
  var program = test.get_program("let x = 5;")

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("let", statement.getTokenLiteral)
  test.eq_value(ast.nLetStatement, statement.s_type)
  test.eq_value("let x=5;", statement.getValue)

  program = test.get_program("""
    let a = 1;
    let b = 5;
  """)

  test.eq_value(2, program.statements.len)
  statement = program.statements[0]
  test.eq_value("let", statement.getTokenLiteral)
  test.eq_value(ast.nLetStatement, statement.s_type)
  test.eq_value("let a=1;", statement.getValue)

  statement = program.statements[1]
  test.eq_value("let", statement.getTokenLiteral)
  test.eq_value(ast.nLetStatement, statement.s_type)
  test.eq_value("let b=5;", statement.getValue)

# outline: whther be able to parse return
# expected_value: expected return statement
block return_test:
  var program = test.get_program("return 5;")

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("return", statement.getTokenLiteral)
  test.eq_value(ast.nReturnStatement, statement.s_type)
  test.eq_value("return 5;", statement.getValue)

  program = test.get_program("""
    let x = 5;
    return x;
  """)

  test.eq_value(2, program.statements.len)
  statement = program.statements[0]
  test.eq_value("let", statement.getTokenLiteral)
  test.eq_value(ast.nLetStatement, statement.s_type)
  test.eq_value("let x=5;", statement.getValue)
  statement = program.statements[1]
  test.eq_value("return", statement.getTokenLiteral)
  test.eq_value(ast.nReturnStatement, statement.s_type)
  test.eq_value("return x;", statement.getValue)

# outline: whther be able to parse identifier
# expected_value: expected identifier
block identifier_test:
  var program = test.get_program("x;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("x", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("x", statement.getValue)


# outline: whther be able to parse integer_literal
# expected_value: expected integer_literal
block integer_literal_test:
  var program = test.get_program("5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("5", statement.getValue)

# outline: whther be able to parse string_literal
# expected_value: expected string_literal
block string_literal_test:
  var program = test.get_program("\"kashiwara\"")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("kashiwara", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("kashiwara", statement.getValue)
  
# outline: whther be able to parse boolean
# expected_value: expected boolean
block boolean_test:
  var program = test.get_program("true;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("true", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("true", statement.getValue)

  program = test.get_program("false;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("false", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("false", statement.getValue)

# outline: whther be able to parse prefix_expression
# expected_value: expected prefix_expression
block prefix_expression_test:
  var program = test.get_program("!5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("!", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(!5)", statement.getValue)

  program = test.get_program("-15;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("-", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(-15)", statement.getValue)

  program = test.get_program("!true")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("!", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(!true)", statement.getValue)

  program = test.get_program("!false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("!", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(!false)", statement.getValue)

# outline: whther be able to parse infix_expression
# expected_value: expected infix_expression
block infix_expression_test:
  var program = test.get_program("5 + 5;")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(5+5)", statement.getValue)

  program = test.get_program("5 - 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(5-5)", statement.getValue)

  program = test.get_program("5 * 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(5*5)", statement.getValue)

  program = test.get_program("5 / 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(5/5)", statement.getValue)

  program = test.get_program("5 > 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(5>5)", statement.getValue)

  program = test.get_program("5 < 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(5<5)", statement.getValue)
  
  program = test.get_program("5 == 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(5==5)", statement.getValue)

  program = test.get_program("5 != 5;")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(5!=5)", statement.getValue)

  program = test.get_program("true == true")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("true", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(true==true)", statement.getValue)

  program = test.get_program("true != false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("true", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(true!=false)", statement.getValue)

  program = test.get_program("false == false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("false", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(false==false)", statement.getValue)

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
  test.eq_value("if", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("if(x<y) x", statement.getValue)

  program = test.get_program("""
  if(x < y){
    x
  }else{
    y
  }
  """)

  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("if", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("if(x<y) x else y", statement.getValue)

# outline: whther be able to parse fn expression
# expected_value: expected fn expression
block function_expression_test:
  var program = test.get_program("""
  fn(x,  y){
    x + y;
  }
  """)

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("fn", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("fn(x, y)(x+y)", statement.getValue)

  program = test.get_program("""
  fn(){
  }
  """)

  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("fn", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("fn()", statement.getValue)


# outline: whther be able to parse call expression
# expected_value: expected call expression
block call_expression_test:
  var program = test.get_program("add(1, 2 * 3, x + y)")

  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("add", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("add(1, (2*3), (x+y))", statement.getValue)

# outline: whther be able to parse array literal test
# expected_value: expected array literal
block array_literal_test:
  # [1, 2 * 2, x + y]
  var program = test.get_program("[1, 2 * 2, x + y]")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("[", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("[1, (2*2), (x+y)]", statement.getValue)

  # [10 * 2]
  program = test.get_program("[10 * 2]")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("[", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("[(10*2)]", statement.getValue)
#
# outline: whther be able to parse index_expression test
# expected_value: expected index_expression
block index_expression_test:
  # arr[1]
  var program = test.get_program("arr[1]")
  var statement = program.statements[0]
  test.eq_value("arr", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("arr[1]", statement.getValue)

  # arr[x * y]
  program = test.get_program("arr[x * y]")
  statement = program.statements[0]
  test.eq_value("arr", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("arr[(x*y)]", statement.getValue)

# outline: whther be able to parse hash_literal test
# expected_value: expected hash_literal
block hash_literal_test:
  # {"a": 1}
  var program = test.get_program("{\"a\": 1}")
  var statement = program.statements[0]
  test.eq_value("{", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("{a:1}", statement.getValue)

  # {b:2, c:3, a:1}
  program = test.get_program("{\"a\": 1, \"b\": 2, \"c\": 3}")
  statement = program.statements[0]
  test.eq_value("{", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  # not warranty oeder about hash table
  test.eq_value("{b:2, c:3, a:1}", statement.getValue)

# outline: whther be able to parse operator precedence
# expected_value: expected operator precedence
block opreator_precedence_test:
  var program = test.get_program("-a * b")
  test.eq_value(1, program.statements.len)
  var statement = program.statements[0]
  test.eq_value("-", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((-a)*b)", statement.getValue)

  program = test.get_program("!-a")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("!", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(!(-a))", statement.getValue)

  program = test.get_program("!-a")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("!", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(!(-a))", statement.getValue)

  program = test.get_program("a + b + c")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("a", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((a+b)+c)", statement.getValue)

  program = test.get_program("a * b * c")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("a", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((a*b)*c)", statement.getValue)

  program = test.get_program("a * b / c")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("a", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((a*b)/c)", statement.getValue)

  program = test.get_program("a + b / c")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("a", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(a+(b/c))", statement.getValue)

  program = test.get_program("a + b * c + d / e - f")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("a", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(((a+(b*c))+(d/e))-f)", statement.getValue)

  program = test.get_program("3 + 4; -5 * 5")
  test.eq_value(2, program.statements.len)
  statement = program.statements[0]
  test.eq_value("3", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(3+4)", statement.getValue)
  statement = program.statements[1]
  test.eq_value("-", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((-5)*5)", statement.getValue)

  program = test.get_program("5 > 4 == 3 < 4")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((5>4)==(3<4))", statement.getValue)

  program = test.get_program("5 < 4 != 3 > 4")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("5", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((5<4)!=(3>4))", statement.getValue)

  program = test.get_program("3 + 4 * 5 == 3 * 1 + 4 * 5")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("3", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((3+(4*5))==((3*1)+(4*5)))", statement.getValue)

  program = test.get_program("true")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("true", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("true", statement.getValue)

  program = test.get_program("false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("false", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("false", statement.getValue)

  program = test.get_program("3 > 5 == false")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("3", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((3>5)==false)", statement.getValue)

  program = test.get_program("3 < 5 == true")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("3", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((3<5)==true)", statement.getValue)

  program = test.get_program("1 + (2 + 3) + 4")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("1", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((1+(2+3))+4)", statement.getValue)

  program = test.get_program("(5 + 5) * 2")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("(", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((5+5)*2)", statement.getValue)

  program = test.get_program("2 / (5 + 5)")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("2", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(2/(5+5))", statement.getValue)

  program = test.get_program("-(5 + 5)")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("-", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(-(5+5))", statement.getValue)

  program = test.get_program("!(true == true)")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("!", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("(!(true==true))", statement.getValue)

  program = test.get_program("a + add(b * c) + d")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("a", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((a+add((b*c)))+d)", statement.getValue)

  program = test.get_program("add(a, b, 1, 2 * 3, 4 + 5, add(6, 7 * 8))")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("add", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("add(a, b, 1, (2*3), (4+5), add(6, (7*8)))", statement.getValue)

  program = test.get_program("add(a + b + c * d / f + g)")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("add", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("add((((a+b)+((c*d)/f))+g))", statement.getValue)

  program = test.get_program("a * [1, 2, 3, 4][b * c]* d")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("a", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("((a*[1, 2, 3, 4][(b*c)])*d)", statement.getValue)

  program = test.get_program("add(a * b[2], b[1], 2 * [1, 2][1])")
  test.eq_value(1, program.statements.len)
  statement = program.statements[0]
  test.eq_value("add", statement.getTokenLiteral)
  test.eq_value(ast.nExpressionStatement, statement.s_type)
  test.eq_value("add((a*b[2]), b[1], (2*[1, 2][1]))", statement.getValue)