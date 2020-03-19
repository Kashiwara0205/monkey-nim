import evaluator
import ../test_utils/test_utils as test

# execute lexer test

# outline: whether correct get integer expression val
# expected_value: get caliculated val
block integer_expression_test:
  let input = "5"
  let obj = test.get_eval(input)