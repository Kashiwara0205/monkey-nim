import evaluator
import ../obj/obj
import ../test_utils/test_utils as test

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