import ../../src/obj/obj
import ../test_helper/test_helper as test

# execute evaluator test
# outline: whether correct get integer expression val
# expected_value: caliculated number
block integer_expression_test:
  var input = "5"
  var obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("5", obj.inspect)

  input = "10"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "-5"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("-5", obj.inspect)

  input = "-10"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("-10", obj.inspect)

  input = "1 + 1"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("2", obj.inspect)

  input = "5 + 5 + 5 + 5 - 10"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "2 * 2 * 2 * 2"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("16", obj.inspect)

  input = "- 50 + 100 - 50"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("0", obj.inspect)

  input = "5 * 2 + 10"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("20", obj.inspect)

  input = "5 + 2 * 10"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("25", obj.inspect)

  input = "20 + 2 * -10"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("0", obj.inspect)

  input = "50 / 2 * 2 + 10"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("60", obj.inspect)

  input = "2 * (5 + 10)"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("30", obj.inspect)

  input = "3 * (3 * 3) + 10"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("37", obj.inspect)

  input = "(5 + 10 * 2 + 15 / 3) * 2 + -10"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("50", obj.inspect)

# outline: whether correct get boolean expression val
# expected_value: expected boolean
block boolean_expression_test:
  var input = "true"
  var obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "false"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "1 < 2"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "1 > 2"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "1 < 1"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "1 > 1"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "1 == 1"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "1 != 1"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "1 == 2"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "1 != 2"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "true == true"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "false == false"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "true == false"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "true != false"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "false != true"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "(1 < 2) == true"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "(1 < 2) == false"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "(1 > 2) == false"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "(1 > 2) == true"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

# outline: whether correct get bang operater val
# expected_value: expected boolean
block bang_operator_test:
  var input = "!true"
  var obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "!false"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "!5"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "!!true"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

  input = "!!false"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("false", obj.inspect)

  input = "!!5"
  obj = test.get_eval(input)
  test.eq_value(oBoolean, obj.o_type)
  test.eq_value("true", obj.inspect)

# outline: whether correct get if else expression val
# expected_value: expected number or nil
block if_expression_test:
  var input = "if (true) { 10 }"
  var obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "if (false) { 10 }"
  obj = test.get_eval(input)
  test.eq_value(oNull, obj.o_type)
  test.eq_value("null", obj.inspect)

  input = "if (1) { 10 }"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "if (1 < 2) { 10 }"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "if (1 > 2) { 10 }"
  obj = test.get_eval(input)
  test.eq_value(oNull, obj.o_type)
  test.eq_value("null", obj.inspect)

  input = "if (1 > 2) { 10 } else { 20 }"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("20", obj.inspect)

  input = "if (1 < 2) { 10 } else { 20 }"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

# outline: whether correct get return statement val
# expected_value: expected number
block return_statement_test:
  var input = "return 10;"
  var obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "return 10; 9;"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "return 2 * 5;"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "9; return 10;"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = """
  if(10 > 1){
    if(10 > 1){
      return 10;
    }
    return 1;
  }
  """
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

# outline: whether correct get let statement val
# expected_value: expected number
block let_statement_test:
  var input = "let a = 5; a;"
  var obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("5", obj.inspect)

  input = "let a = 5 * 5; a;"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("25", obj.inspect)

  input = "let a = 5 * 5; let b = a; b;"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("25", obj.inspect)

  input = "let a = 5 * 5; let b = a; let c = a + b; c;"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("50", obj.inspect)

# outline: whether correct get function val
# expected_value: expected number
block func_application_test:
  var input = "let identify = fn(x){x;} identify(5);"
  var obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("5", obj.inspect)

  input = "let identify = fn(x){ return x;} let a = identify(5); a;"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("5", obj.inspect)

  input = "let double = fn(x){ x * 2;} double(5);"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "let add = fn(x, y){ x + y;} add(5, 5);"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)

  input = "fn(x){ x; }(5)"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("5", obj.inspect)

# outline: whether correct get string val
# expected_value: expected number
block string_test:
  var input = "\"a\""
  var obj = test.get_eval(input)
  test.eq_value(oString, obj.o_type)
  test.eq_value("a", obj.inspect)

  input = "\"a\" + \"i\""
  obj = test.get_eval(input)
  test.eq_value(oString, obj.o_type)
  test.eq_value("ai", obj.inspect)

# outline: whether correct get array index expression val
# expected_value: expected number
block array_index_expression_test:
  var input = "[1, 2, 3][0]"
  var obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("1", obj.inspect)

  input = "[1, 2, 3][1]"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("2", obj.inspect)

  input = "[1, 2, 3][2]"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("3", obj.inspect)

  input = "[1, 2, 3][1 + 1]"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("3", obj.inspect)

  input = """
    let arr = [1, 2, 3];
    arr[0]
  """
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("1", obj.inspect)

  input = """
    let arr = [1, 2, 3];
    arr[1]
  """
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("2", obj.inspect)

  input = """
    let arr = [1, 2, 3];
    arr[2]
  """
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("3", obj.inspect)

  input = """
    let arr = [1, 2, 3];
    arr[0] + arr[1] + arr[2]
  """
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("6", obj.inspect)

  input = "[1, 2, 3][3]"
  obj = test.get_eval(input)
  test.eq_value(oNull, obj.o_type)
  test.eq_value("null", obj.inspect)

  input = "[1, 2, 3][-1]"
  obj = test.get_eval(input)
  test.eq_value(oNull, obj.o_type)
  test.eq_value("null", obj.inspect)

# outline: whether correct get error handling val
# expected_value: expected number
block error_handling_test:
  var input = "5 + true"
  var obj = test.get_eval(input)
  test.eq_value(oError, obj.o_type)
  test.eq_value("Error: type mismatch: oInteger + oBoolean", obj.inspect)

  input = "5 + true; 5;"
  obj = test.get_eval(input)
  test.eq_value(oError, obj.o_type)
  test.eq_value("Error: type mismatch: oInteger + oBoolean", obj.inspect)

  input = "-true"
  obj = test.get_eval(input)
  test.eq_value(oError, obj.o_type)
  test.eq_value("Error: unknown operator: -oBoolean", obj.inspect)

  input = "true + false"
  obj = test.get_eval(input)
  test.eq_value(oError, obj.o_type)
  test.eq_value("Error: unknown operator: oBoolean + oBoolean", obj.inspect)

  input = "5; true + false; 5"
  obj = test.get_eval(input)
  test.eq_value(oError, obj.o_type)
  test.eq_value("Error: unknown operator: oBoolean + oBoolean", obj.inspect)

  input = "if (10 > 1) { true + false; }"
  obj = test.get_eval(input)
  test.eq_value(oError, obj.o_type)
  test.eq_value("Error: unknown operator: oBoolean + oBoolean", obj.inspect)

  input = "foobar"
  obj = test.get_eval(input)
  test.eq_value(oError, obj.o_type)
  test.eq_value("Error: identifier not found: foobar", obj.inspect)

  input = "\"str\" - \"str\""
  obj = test.get_eval(input)
  test.eq_value(oError, obj.o_type)
  test.eq_value("Error: unknown operator: oString - oString", obj.inspect)

# outline: whether correct get hash literal test
# expected_value: expected number
block hash_literal_test:
  var input = "{1: 1}"
  var obj = test.get_eval(input)
  test.eq_value(oHash, obj.o_type)
  test.eq_value("{1: 1}", obj.inspect)

  input = "{\"1\": 1}"
  obj = test.get_eval(input)
  test.eq_value(oHash, obj.o_type)
  test.eq_value("{1: 1}", obj.inspect)

  input = "{true: 1}"
  obj = test.get_eval(input)
  test.eq_value(oHash, obj.o_type)
  test.eq_value("{true: 1}", obj.inspect)

# outline: whether correct get hash index expression test
# expected_value: expected number
block hash_index_expression_test:
  var input = "{\"foo\": 5}[\"foo\"]"
  var obj = test.get_eval(input)

  test.eq_value(oInteger, obj.o_type)
  test.eq_value("5", obj.inspect)

  input = "{1: 5}[1]"
  obj = test.get_eval(input)

  test.eq_value(oInteger, obj.o_type)
  test.eq_value("5", obj.inspect)

  input = "{true: 5}[true]"
  obj = test.get_eval(input)

  test.eq_value(oInteger, obj.o_type)
  test.eq_value("5", obj.inspect)

  input = "{1: 5, \"1\": 10}[1]"
  obj = test.get_eval(input)

  test.eq_value(oInteger, obj.o_type)
  test.eq_value("5", obj.inspect)

  input = "{1: 5, \"1\": 10}[\"1\"]"
  obj = test.get_eval(input)

  test.eq_value(oInteger, obj.o_type)
  test.eq_value("10", obj.inspect)