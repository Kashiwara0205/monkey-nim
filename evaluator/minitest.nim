import evaluator
import ../obj/obj
import ../test_utils/test_utils as test

# execute lexer test

# outline: whether correct get integer expression val
# expected_value: caliculated val
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