import ../ast/ast
import ../obj/obj
from strformat import fmt

var
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
proc evalIntegerInfixExpression(operator: string, left: Object, right: Object): Object

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
    if isError(right):
      return right
    return evalPrefixExpression(prefix.operator, right)
  of eInfixExpression:
    return Object()
  of eIfExpression:
    return Object()
  of eIdentifier:
    return Object()
  of eFunctionLiteral:
    return Object()
  of eCallExpression:
    return Object()
  of eStringLiteral:
    return Object()
  of eArrayLiteral:
    return Object()
  of eIndexExpression:
    return Object()
  of eHashLiteral:
    return Object()

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