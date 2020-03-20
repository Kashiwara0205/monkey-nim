import ../ast/ast
import ../obj/obj

var
  NULL = Object( o_type: oNull, null_obj: NullObj())
  TRUE = Object( o_type: oBoolean, boolean_obj: BooleanObj(value: true))
  FALSE = Object( o_type: oBoolean, boolean_obj: BooleanObj(value: false))

# forward declaration
proc newError(): ErrorObj
proc isError(obj: Object): bool
proc evalProgram(program: Program, env: Enviroment): Object
proc eval*(node: Node, env: Enviroment): Object
proc evalExpression(expression: Expression, env: Enviroment): Object
proc evalStatement(statement: Statement, env: Enviroment): Object
proc evalBangOperatorExpression(right: Object): Object
proc evalMinusPrefixOperatorExpression(right: Object): Object
proc evalPrefixExpression(operator: string, right: Object): Object
proc evalInfixExpression(operator: string, left: Object, right: Object): Object
proc evalIntegerInfixExpression(operator: string, left: Object, right: Object): Object
proc evalStringInfixExpression(operator: string, left: Object, right: Object): Object
proc evalIfExpression(expression: IfExpression, env: Enviroment): Object
proc evalIdentifier(node: Identifier, env: Enviroment): Object
proc evalExpressions(expressions: ref seq[Expression], env: Enviroment): ref seq[Object]
proc evalIndexExpression(left: Object, index: Object): Object
proc evalArrayIndexExpression(arr: Object, index: Object): Object
proc evalBlockStatement(block_statement: BlockStatement, env: Enviroment): Object
proc convNativeBoolToBoolObj(input: bool): BooleanObj
proc isTruthy(obj: Object): bool
proc extendFunctionEnv(fn: FunctionObj, args: ref seq[Object]): Enviroment
proc applyFunction(fn: Object, args: ref seq[Object]): Object
proc unwrapReturnValue(obj: Object): Object

proc newError(): ErrorObj =
  return ErrorObj()

proc isError(obj: Object): bool =
  return if obj != nil: obj.o_type == oError else: false

proc eval*(node: Node, env: Enviroment): Object =
  case node.n_type
  of nProgram:
    let obj = evalProgram(node.program, env)
    return obj
  of nExpression:
    return evalExpression(node.expression, env)
  of nStatement:
    let obj = evalStatement(node.statement, env)
    return obj

proc evalProgram(program: Program, env: Enviroment): Object =
  var obj: Object
  for statement in program.statements:
    obj = eval(statement, env)
    case obj.o_type
    of oReturnValue:
      return obj.return_value_obj.value
    of oError:
      return obj
    else:
      discard

  return obj

proc evalExpression(expression: Expression, env: Enviroment): Object =
  case expression.e_type:
  of eIntegerLiteral:
    let integer_obj = IntegerObj(value: expression.integerLit.number)
    return Object(o_type: oInteger, integer_obj: integer_obj)
  of eBoolean:
    let boolean_obj = convNativeBoolToBoolObj(expression.boolean.value)
    return Object(o_type: oBoolean, boolean_obj: boolean_obj)
  of ePrefixExpression:
    let prefix = expression.prefixExp
    let right = evalExpression(prefix.right, env)

    if isError(right): return right
    return evalPrefixExpression(prefix.operator, right)
  of eInfixExpression:
    let infix = expression.infixExp

    let left = evalExpression(infix.left, env)
    if isError(left): return left

    let right = evalExpression(infix.right, env)
    if isError(right): return right

    return evalInfixExpression(infix.operator, left, right)
  of eIfExpression:
    let if_expression = expression.ifExp

    return evalIfExpression(if_expression, env)
  of eIdentifier:
    let identifier = expression.identifier

    return evalIdentifier(identifier, env)
  of eFunctionLiteral:
    let function = expression.functionLit
    let params = function.parameters
    let body = function.body
    let function_obj = FunctionObj(parameters: params, env: env, body: body)

    return Object(o_type: oFunction, function_obj: function_obj)
  of eCallExpression:
    let call = expression.callExp
    let function = evalExpression(call.function, env)
    if isError(function): return function

    let ref_args = evalExpressions(call.arguments, env)
    let args = ref_args[]
    if args.len == 1 and isError(args[0]): return args[0]

    return applyFunction(function, ref_args)
  of eStringLiteral:
    let string_obj = StringObj(value: expression.stringLit.value)

    return Object(o_type: oString, string_obj: string_obj)
  of eArrayLiteral:
    let arrayliteral = expression.arrayLit
    let elements = evalExpressions(arrayliteral.elements, env)

    if elements[].len == 1 and isError(elements[][0]): return elements[0]

    return Object(o_type: oArray, array_obj: ArrayObj(elements: elements))
  of eIndexExpression:
    let index_expression = expression.indexExp
    let left = evalExpression(index_expression.left, env)
    if isError(left): return left

    let index = evalExpression(index_expression.index, env)
    if isError(index): return index

    return evalIndexExpression(left, index)
  of eHashLiteral:
    # later implement
    return Object()

proc evalExpressions(expressions: ref seq[Expression], env: Enviroment): ref seq[Object] =
  var objects: ref seq[Object]
  objects.new
  objects[] = @[]

  for expression in expressions[]:
    let evaluted = evalExpression(expression, env)

    if isError(evaluted):
      var error: ref seq[Object]
      error.new
      error[] = @[]
      error[].add(evaluted)
      return error

    objects[].add(evaluted)

  return objects

proc applyFunction(fn: Object, args: ref seq[Object]): Object =
  case fn.o_type
  of oFunction:
    let function = FunctionObj(fn)
    let extendEnv = extendFunctionEnv(function, args)
    let evaluted = evalStatement(function.body, extendEnv)
    return unwrapReturnValue(evaluted)
  of oBuiltin:
    let builtin = BuiltinObj(fn)
    return builtin.fn(args)
  else:
    return newError()

proc extendFunctionEnv(fn: FunctionObj, args: ref seq[Object]): Enviroment =
  var env = newEncloseEnv(fn.env)

  var count: int = 0
  for param in fn.parameters[]:
    env.setEnv(param.variable_name, args[count])
    count = count + 1

  return env

proc evalStatement(statement: Statement, env: Enviroment): Object =
  case statement.s_type:
  of sLetStatement:
    let let_statement = LetStatement(statement)
    let val = evalExpression(let_statement.expression, env)

    if isError(val): return val
    env.setEnv(let_statement.name.variable_name, val)

    return val
  of sExpressionStatement:
    let obj = evalExpression(statement.expressionStmt.expression, env)
    return obj
  of sBlockStatement:
    # following property is BlockStatement type 
    # but use this process, so need cast converion Statement to BlockStatement
    # IfExpression: consequence, alternative
    # FunctionLiteral: body
    return evalBlockStatement(BlockStatement(statement), env)
  of sReturnStatement:
    let return_val = evalExpression(statement.returnStmt.expression, env)

    if isError(return_val): return return_val
    return Object(o_type: oReturnValue, return_value_obj: ReturnValueObj(value: return_val))

proc convNativeBoolToBoolObj(input: bool): BooleanObj =
  return if input : TRUE.boolean_obj else : FALSE.boolean_obj

proc evalPrefixExpression(operator: string, right: Object): Object =
  case operator
  of "!":
    return evalBangOperatorExpression(right)
  of "-":
    return evalMinusPrefixOperatorExpression(right)
  else:
    return newError()

proc is_left_and_right_integer(left: Object, right: Object): bool=
  return left.o_type == right.o_type and right.o_type == oInteger

proc is_left_and_right_string(left: Object, right: Object): bool=
  return left.o_type == right.o_type and right.o_type == oString

proc evalInfixExpression(operator: string, left: Object, right: Object): Object =
  if is_left_and_right_integer(left, right): return evalIntegerInfixExpression(operator, left, right)
  if is_left_and_right_string(left, right): return evalStringInfixExpression(operator, left, right)

  if operator == "==": 
    let left_val = left.boolean_obj.value
    let right_val = right.boolean_obj.value
    let boolean_obj = convNativeBoolToBoolObj(left_val == right_val)

    return Object(o_type: oBoolean, boolean_obj: boolean_obj)

  if operator == "!=":
    let left_val = left.boolean_obj.value
    let right_val = right.boolean_obj.value
    let boolean_obj = convNativeBoolToBoolObj(left_val != right_val)

    return  Object(o_type: oBoolean, boolean_obj: boolean_obj)

  if left.o_type != right.o_type: return newError()

  return newError()

proc evalBangOperatorExpression(right: Object): Object =
  case right.o_type
  of oBoolean:
    case right.boolean_obj.value
      of true: return FALSE
      of false: return TRUE
  of oNull:
    return TRUE
  else:
    return FALSE

proc evalMinusPrefixOperatorExpression(right: Object): Object =
  if right.o_type != oInteger:
    return newError()
  let value = right.integer_obj.value
  let integer_obj = IntegerObj(value: -value)
  return Object(o_type: oInteger, integer_obj: integer_obj)

proc evalIntegerInfixExpression(operator: string, left: Object, right: Object): Object =
  let leftVal = left.integer_obj.value
  let rightVal = right.integer_obj.value

  case operator
  of "+":
    let integer_obj = IntegerObj(value: leftVal + rightVal)
    return Object(o_type: oInteger, integer_obj: integer_obj)
  of "-":
    let integer_obj = IntegerObj(value: leftVal - rightVal)
    return Object(o_type: oInteger, integer_obj: integer_obj)
  of "*":
    let integer_obj = IntegerObj(value: leftVal * rightVal)
    return Object(o_type: oInteger, integer_obj: integer_obj)
  of "/":
    let integer_obj = IntegerObj(value: (int(leftVal) / int(rightVal)).toInt)
    return Object(o_type: oInteger, integer_obj: integer_obj)
  of "<":
    let boolean_obj = convNativeBoolToBoolObj(leftVal < rightVal)
    return Object(o_type: oBoolean, boolean_obj: boolean_obj)
  of ">":
    let boolean_obj = convNativeBoolToBoolObj(leftVal > rightVal)
    return Object(o_type: oBoolean, boolean_obj: boolean_obj)
  of "==":
    let boolean_obj = convNativeBoolToBoolObj(leftVal == rightVal)
    return Object(o_type: oBoolean, boolean_obj: boolean_obj)
  of "!=":
    let boolean_obj = convNativeBoolToBoolObj(leftVal != rightVal)
    return Object(o_type: oBoolean, boolean_obj: boolean_obj)
  else:
    return newError()

proc evalStringInfixExpression(operator: string, left: Object, right: Object): Object =
  if operator != "+" : return newError()

  let combine = StringObj(left).value & StringObj(right).value
  return StringObj(value: combine)

proc isTruthy(obj: Object): bool =
  case obj.o_type
  of oNull:
    return false
  of oBoolean:
    return obj.boolean_obj.value
  else:
    return true

proc evalIfExpression(expression: IfExpression, env: Enviroment): Object =
  let condition = evalExpression(expression.condition, env)
  if isError(condition): return condition

  if isTruthy(condition):
    let consequence = expression.consequence
    return evalStatement(consequence, env)
  elif expression.alternative != nil:
    let alternative = expression.alternative
    return evalStatement(alternative, env)
  else:
    return NULL

proc evalIdentifier(node: Identifier, env: Enviroment): Object =
  let res = env.getEnv(node.variable_name)
  let obj = res[0]
  let existance = res[1]

  if existance: return obj

  return newError()

proc unwrapReturnValue(obj: Object): Object =
  if obj.o_type == oReturnValue:
    return ReturnValueObj(obj).value

  return obj

proc evalIndexExpression(left: Object, index: Object): Object =
  if left.o_type == oArray and index.o_type == oInteger:
    return evalArrayIndexExpression(left, index)

  return newError()

proc evalArrayIndexExpression(arr: Object, index: Object): Object =
  let array_object = ArrayObj(arr)
  let idx = IntegerObj(index).value
  let max = array_object.elements[].len
  if idx < 0 or idx > max: return NULL

  return array_object.elements[idx]

proc exists_return_obj(obj: Object): bool =
  return obj != nil and obj.o_type == oReturnValue or obj.o_type == oError

proc evalBlockStatement(block_statement: BlockStatement, env: Enviroment): Object =
  var obj: Object

  for statement in block_statement.statements:
    obj = evalStatement(statement, env)

    if exists_return_obj(obj): return obj

  return obj