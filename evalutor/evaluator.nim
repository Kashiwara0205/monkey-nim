import ../ast/ast
import ../obj/obj
from strformat import fmt

var
  NULL = Object( o_type: oNull, null_obj: NullObj())
  TRUE = Object( o_type: oBoolean, boolean_obj: BooleanObj(value: true))
  FALSE = Object( o_type: oBoolean, boolean_obj: BooleanObj(value: false))

# forward declaration
proc newError(): ErrorObj
proc isError(obj: Object): bool
proc evalProgram(program: Program, env: Enviroment): Object
proc eval(node: Node, env: Enviroment): Object
proc evalExpression(expression: Expression, env: Enviroment): Object
proc evalStatement(statement: Statement, env: Enviroment): Object
proc convNativeBoolToBoolObj(input: bool): BooleanObj
proc evalBangOperatorExpression(right: Object): Object
proc evalMinusPrefixOperatorExpression(right: Object): Object
proc evalPrefixExpression(operator: string, right: Object): Object
proc evalInfixExpression(operator: string, left: Object, right: Object): Object
proc evalIntegerInfixExpression(operator: string, left: Object, right: Object): Object
proc evalStringInfixExpression(operator: string, left: Object, right: Object): Object
proc evalIfExpression(expression: IfExpression, env: Enviroment): Object
proc isTruthy(obj: Object): bool
proc evalIdentifier(node: Identifier, env: Enviroment): Object
proc evalExpressions(expressions: ref seq[Expression], env: Enviroment): seq[Object]
proc extendFunctionEnv(fn: FunctionObj, args: ref seq[Object]): Enviroment

proc newError(): ErrorObj =
  return ErrorObj()

proc isError(obj: Object): bool =
  return if obj != nil: obj.o_type == oError else: false

proc eval(node: Node, env: Enviroment): Object =
  case node.n_type
  of nProgram:
    return evalProgram(node.program, env)
  of nExpression:
    return evalExpression(node.expression, env)
  of nStatement:
    return evalStatement(node.statement, env)

proc evalProgram(program: Program, env: Enviroment): Object =
  for statement in program.statements:
    let obj = eval(statement, env)
    case obj.o_type
    of oReturnValue:
      return ReturnValueObj(obj).value
    of oError:
      return obj
    else:
      discard

proc evalExpression(expression: Expression, env: Enviroment): Object =
  case expression.e_type:
  of eIntegerLiteral:
    let integer_obj =  IntegerObj(value: IntegerLiteral(expression).number)
    
    return Object(o_type: oInteger, integer_obj: integer_obj)
  of eBoolean:
    return convNativeBoolToBoolObj(Boolean(expression).value)
  of ePrefixExpression:
    let prefix = PrefixExpression(expression)

    let right = evalExpression(prefix.right, env)
    if isError(right): return right

    return evalPrefixExpression(prefix.operator, right)
  of eInfixExpression:
    let infix = InfixExpression(expression)

    let left = evalExpression(infix.left, env)
    if isError(left): return left

    let right = evalExpression(infix.right, env)
    if isError(right): return right

    return evalInfixExpression(infix.operator, left, right)
  of eIfExpression:
    let if_expression = IfExpression(expression)

    return evalIfExpression(if_expression, env)
  of eIdentifier:
    let identifier = Identifier(expression)

    return evalIdentifier(identifier, env)
  of eFunctionLiteral:
    let function = FunctionLiteral(expression)
    let params = function.parameters
    let body = function.body

    return FunctionObj(parameters: params, env: env, body: body)
  of eCallExpression:
    let call = CallExpression(expression)
    let function = evalExpression(call.function, env)
    if isError(function): return function

    let args = evalExpressions(call.arguments, env)
    if args.len == 1 and isError(args[0]): return args[0]

    return applyFunction(function, args)
  of eStringLiteral:
    return Object()
  of eArrayLiteral:
    return Object()
  of eIndexExpression:
    return Object()
  of eHashLiteral:
    return Object()

proc evalExpressions(expressions: ref seq[Expression], env: Enviroment): seq[Object] =
  var objects: seq[Object]

  for expression in expressions[]:
    let evaluted = evalExpression(expression, env)

    if isError(evaluted): 
      var error: seq[Object]
      error.add(evaluted)
      return error

    objects.add(evaluted)

  return objects

proc applyFunction(fn: Object, args: ref seq[Expression]): Object =
  case fn.o_type
  of oFunction:
    let extendEnv = extendFunctionEnv()
  of oBuiltin:

  else: 
    return newError()

proc extendFunctionEnv(fn: FunctionObj, args: ref seq[Object]): Enviroment =
  var env = newEncloseEnv(fn.env)

  var count: int = 0
  for param in fn.parameters[]:
    env = env.setEnv(param.variable_name, args[count])
    count = count + 1

  return env

proc evalStatement(statement: Statement, env: Enviroment): Object =
  case statement.s_type:
  of sLetStatement:
    return Object()
  of sExpressionStatement:
    return evalExpression(ExpressionStatement(statement).expression, env)
  of sBlockStatement:
    return Object()
  of sReturnStatement:
    return Object()

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
  if operator == "==": return convNativeBoolToBoolObj(left == right)
  if operator == "!=": return convNativeBoolToBoolObj(left != right)
  if left.o_type != right.o_type: return newError()

  return newError()

proc evalBangOperatorExpression(right: Object): Object =
  case right.o_type
  of oBoolean:
    case BooleanObj(right).value
      of true: return FALSE
      of false: return TRUE
  of oNull:
    return TRUE
  else:
    return FALSE

proc evalMinusPrefixOperatorExpression(right: Object): Object =
  if right.o_type != oInteger:
    return newError()

  let value = IntegerObj(right).value

  return IntegerObj(value: -value)

proc evalIntegerInfixExpression(operator: string, left: Object, right: Object): Object =
  let leftVal = IntegerObj(left).value
  let rightVal = IntegerObj(right).value

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
    return convNativeBoolToBoolObj(leftVal < rightVal)
  of ">":
    return convNativeBoolToBoolObj(leftVal > rightVal)
  of "==":
    return convNativeBoolToBoolObj(leftVal == rightVal)
  of "!=":
    return convNativeBoolToBoolObj(leftVal != rightVal)
  else:
    return newError()

proc evalStringInfixExpression(operator: string, left: Object, right: Object): Object =
  if operator != "+" : return newError()

  let combine = StringObj(left).value & StringObj(right).value
  return StringObj(value: combine)

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

proc isTruthy(obj: Object): bool =
  case obj.o_type
  of oNull:
    return false
  of oBoolean:
    return BooleanObj(obj).value
  else:
    return true

proc evalIdentifier(node: Identifier, env: Enviroment): Object =
  let res = env.get(node.variable_name)
  let obj = res[0]
  let existance = res[1]

  if existance: return obj

  return newError()

#[
proc evalExpression(expressions: seq[Expression], env: Enviroment): seq[Object] =
  var objects: seq[Object]
  for expression in expressions:


  return objects
]#