import ../../src/obj/obj
import ../test_helper/test_helper as test

# outline: whether correct buildin function val
# expected_value: expected number
block buildin_function_test:
  var input = "len(\"\")"
  var obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("0", obj.inspect)

  input = "len(\"abcd\")"
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("4", obj.inspect)

  input = """
    let arr = [1, 2, 3];
    len(arr)
  """
  obj = test.get_eval(input)
  test.eq_value(oInteger, obj.o_type)
  test.eq_value("3", obj.inspect)