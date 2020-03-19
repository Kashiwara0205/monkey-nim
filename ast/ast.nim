import ../token/token
import ../utils/utils
import tables
import hashes

type
  NodeType* = enum
    nExpression
    nStatement
    nProgram
type
  ExpressionType* = enum
    eIdentifier
    eBoolean
    eIntegerLiteral
    ePrefixExpression
    eInfixExpression
    eStringLiteral
    eIfExpression
    eFunctionLiteral
    eCallExpression
    eArrayLiteral
    eIndexExpression
    eHashLiteral

type
  StatementType* = enum
    sLetStatement
    sReturnStatement
    sExpressionStatement
    sBlockStatement

type
  Node* = ref object of RootObj
    case n_type*: NodeType
    of nProgram:
      program*: Program
    of nExpression:
      expression*: Expression
    of nStatement:
      statement*: Statement

  Program* = ref object of RootObj
    statements* :seq[Node]

  Expression* = ref object of RootObj
    case e_type*: ExpressionType
    of eIdentifier:
      identifier*: Identifier
    of eBoolean:
      boolean*: Boolean
    of eIntegerLiteral:
      integerLit*: IntegerLiteral
    of ePrefixExpression:
      prefixExp*: PrefixExpression
    of eInfixExpression:
      infixExp*: InfixExpression
    of eStringLiteral:
      stringLit*: StringLiteral
    of eIfExpression:
      ifExp*: IfExpression
    of eFunctionLiteral:
      functionLit*: FunctionLiteral
    of eCallExpression:
      callExp*: CallExpression
    of eArrayLiteral:
      arrayLit*: ArrayLiteral
    of eIndexExpression:
      indexExp*: IndexExpression
    of eHashLiteral:
      hashLit*: HashLiteral

  # This type controll variable
  Identifier* = ref object of Expression
    tok*: token.Token
    variable_name*: string

  # This type controll boolean
  Boolean* =  ref object of Expression
    tok*: token.Token
    value*: bool

  # This type used by following program
  # [5;]
  IntegerLiteral* = ref object of Expression
    tok*: token.Token
    number*: int64

  # This type used by following program
  # [!] [ - ]
  PrefixExpression* = ref object of Expression
    tok*: token.Token
    operator*: string
    right*: Expression

  # This type used by following program
  # [1 + 1] [1 < 1]
  InfixExpression* = ref object of Expression
    tok*: token.Token
    left*: Expression
    operator*: string
    right*: Expression

  # This type used by following program
  # [ "abcde" ]
  StringLiteral* = ref object of Expression
    tok*: token.Token
    value*: string

  # This type used by following program
  # [
  #  if(xxx){
  #    xxx
  #  }
  # ]
  IfExpression* = ref object of Expression
    tok*: token.Token
    condition*: Expression
    consequence*: BlockStatement
    alternative*: BlockStatement

  # This type used by following program
  # [
  #  fn(xxx){
  #    xxx
  #  }
  # ]
  FunctionLiteral* = ref object of Expression
    tok*: token.Token
    parameters*: ref seq[Identifier]
    body*: BlockStatement

  # This type used by following program
  # call function
  # [ fn() ]
  CallExpression* = ref object of Expression
    tok*: token.Token
    function*: Expression
    arguments*: ref seq[Expression]

  # This type used by following program
  # [ array[] ]
  ArrayLiteral* = ref object of Expression
    tok*: token.Token
    elements*: ref seq[Expression]

  # This type used by following program
  # [ [index] ]
  IndexExpression* = ref object of Expression
    tok*: token.Token
    left*: Expression
    index*: Expression

  # This type used by following program
  # [ {"key": value} ]
  HashLiteral* = ref object of Expression
    tok*: token.Token
    pairs*: Table[ast.Expression, ast.Expression]

  Statement* = ref object of RootObj
    case s_type*: StatementType
    of sLetStatement:
    letStmt* : LetStatement
    of sReturnStatement:
    returnStmt* : ReturnStatement
    of sExpressionStatement:
    expressionStmt* : ExpressionStatement
    of sBlockStatement:
    blockStmt* : BlockStatement

  # This type used by following program
  # [let a = 5;]
  LetStatement* = ref object of Statement
    tok*: token.Token
    name*: Identifier
    expression*: Expression

  # This type used by following program
  # [{ }]
  BlockStatement* = ref object of Statement
    tok*: token.Token
    statements* :seq[Statement]

  # This type used by following program
  # [value;]
  ExpressionStatement* = ref object of Statement
    tok*: token.Token
    expression*: Expression

  # This type used by following program
  # [return value;]
  ReturnStatement* = ref object of Statement
    tok*: token.Token
    expression*: Expression

# forward declaration
proc getTokenLiteral*(node: Node): string
proc getValue*(node: Node) :string

proc getToeknLiteral*(p: Program): string
proc getValue*(p: Program): string

proc getTokenLiteral*(expression: Expression): string
proc getValue*(expression: Expression) :string

proc getTokenLiteral*(statement: Statement): string
proc getValue*(statement: Statement): string

proc getTokenLiteral*(identifier: Identifier): string
proc getValue*(identifier: Identifier): string

proc getTokenLiteral*(boolean: Boolean): string
proc getValue*(boolean: Boolean): string

proc getTokenLiteral*(literal: IntegerLiteral): string
proc getValue*(literal: IntegerLiteral): string

proc getTokenLiteral*(expression: PrefixExpression): string
proc getValue*(expression: PrefixExpression): string

proc getTokenLiteral*(expression: InfixExpression): string
proc getValue*(expression: InfixExpression): string

proc getTokenLiteral*(literal: StringLiteral): string
proc getValue*(literal: StringLiteral): string

proc getTokenLiteral*(expression: IfExpression): string
proc getValue*(expression: IfExpression): string

proc getTokenLiteral*(literal: FunctionLiteral): string
proc getValue*(literal: FunctionLiteral): string

proc getTokenLiteral*(expression: CallExpression): string
proc getValue*(expression: CallExpression): string

proc getTokenLiteral*(literal: ArrayLiteral): string
proc getValue*(literal: ArrayLiteral): string

proc getTokenLiteral*(expression: IndexExpression): string
proc getValue*(expression: IndexExpression): string

proc getTokenLiteral*(literal: HashLiteral): string
proc getValue*(literal: HashLiteral): string

proc getTokenLiteral*(statement: LetStatement): string
proc getValue*(statement: LetStatement): string

proc getTokenLiteral*(statement: ReturnStatement): string
proc getValue*(statement: ReturnStatement): string

proc getTokenLiteral*(statement: ExpressionStatement): string
proc getValue*(statement: ExpressionStatement): string

proc getTokenLiteral*(statement: BlockStatement): string
proc getValue*(statement: BlockStatement): string

#----------------------------------------
# Node proc
#----------------------------------------
proc getTokenLiteral*(node: Node):string =
  case node.n_type:
  of nExpression:
    return node.expression.getTokenLiteral()
  of nStatement:
    return node.statement.getTokenLiteral()
  of nProgram:
    return node.program.getToeknLiteral()

proc getValue*(node: Node):string =
  case node.n_type:
  of nExpression:
    return node.expression.getValue()
  of nStatement:
    return node.statement.getValue()
  of nProgram:
    return node.program.getValue()

#----------------------------------------
# Program proc
#----------------------------------------
proc getToeknLiteral*(p: Program): string =
  if p.statements.len() > 0:
    return p.statements[0].getTokenLiteral()
  else:
    return ""

proc getValue*(p: Program): string =
  var str = ""
  for elem in p.statements:
    str &= elem.getValue()

  return str

#----------------------------------------
# Expression proc
#----------------------------------------
proc getTokenLiteral*(expression: Expression):string =
  case expression.e_type
  of eIdentifier:
    return expression.identifier.getTokenLiteral
  of eBoolean:
    return expression.boolean.getTokenLiteral
  of eIntegerLiteral:
    return expression.integerLit.getTokenLiteral
  of ePrefixExpression:
    return expression.prefixExp.getTokenLiteral
  of eInfixExpression:
    return expression.infixExp.getTokenLiteral
  of eStringLiteral:
    return expression.stringLit.getTokenLiteral
  of eIfExpression:
    return expression.ifExp.getTokenLiteral
  of eFunctionLiteral:
    return expression.functionLit.getTokenLiteral
  of eCallExpression:
    return expression.callExp.getTokenLiteral
  of eArrayLiteral:
    return expression.arrayLit.getTokenLiteral
  of eIndexExpression:
    return expression.indexExp.getTokenLiteral
  of eHashLiteral:
    return expression.hashLit.getTokenLiteral

proc getValue*(expression: Expression):string =
  case expression.e_type
  of eIdentifier:
    return expression.identifier.getValue
  of eBoolean:
    return expression.boolean.getValue
  of eIntegerLiteral:
    return expression.integerLit.getValue
  of ePrefixExpression:
    return expression.prefixExp.getValue
  of eInfixExpression:
    return expression.infixExp.getValue
  of eStringLiteral:
    return expression.stringLit.getValue
  of eIfExpression:
    return expression.ifExp.getValue
  of eFunctionLiteral:
    return expression.functionLit.getValue
  of eCallExpression:
    return expression.callExp.getValue
  of eArrayLiteral:
    return expression.arrayLit.getValue
  of eIndexExpression:
    return expression.indexExp.getValue
  of eHashLiteral:
    return expression.hashLit.getValue

proc hash*(literal: Expression): Hash =
  var h: Hash = 0
  h = h !& hash(literal.getValue)
  result = !$h

#----------------------------------------
# Statement proc
#----------------------------------------
proc getTokenLiteral*(statement: Statement): string =
  case statement.s_type
  of sLetStatement:
    return statement.letStmt.getTokenLiteral
  of sReturnStatement:
    return statement.returnStmt.getTokenLiteral
  of sExpressionStatement:
    return statement.expressionStmt.getTokenLiteral
  of sBlockStatement:
    return statement.blockStmt.getTokenLiteral

proc getValue*(statement: Statement): string =
  case statement.s_type
  of sLetStatement:
    return statement.letStmt.getValue
  of sReturnStatement:
    return statement.returnStmt.getValue
  of sExpressionStatement:
    return statement.expressionStmt.getValue
  of sBlockStatement:
    return statement.blockStmt.getValue

#----------------------------------------
# Identifier proc
#----------------------------------------
proc getTokenLiteral*(identifier: Identifier): string =
  return identifier.tok.literal

proc getValue*(identifier: Identifier): string =
  return identifier.variable_name

#----------------------------------------
# Boolean proc
#----------------------------------------
proc getTokenLiteral*(boolean: Boolean): string =
  return boolean.tok.literal

proc getValue*(boolean: Boolean): string =

  return boolean.tok.literal

#----------------------------------------
# IntegerLiteral proc
#----------------------------------------
proc getTokenLiteral*(literal: IntegerLiteral): string =
  return literal.tok.literal

proc getValue*(literal: IntegerLiteral): string =
  return literal.tok.literal

#----------------------------------------
# PrefixExpression proc
#----------------------------------------
proc getTokenLiteral*(expression: PrefixExpression): string =
  return expression.tok.literal

proc getValue*(expression: PrefixExpression): string =
  var str = ""
  str &= "("
  str &= expression.operator
  str &= expression.right.getValue()
  str &= ")"

  return str

#----------------------------------------
# InfixExpression proc
#----------------------------------------
proc getTokenLiteral*(expression: InfixExpression): string =
  return expression.tok.literal

proc getValue*(expression: InfixExpression): string =
  var str = ""
  str &= "("
  str &= expression.left.getValue()
  str &= expression.operator
  str &= expression.right.getValue()
  str &= ")"

  return str

#----------------------------------------
# StringLiteral proc
#----------------------------------------
proc getTokenLiteral*(literal: StringLiteral): string =
  return literal.tok.literal

proc getValue*(literal: StringLiteral): string =
  return literal.tok.literal

#----------------------------------------
# IfExpression proc
#----------------------------------------
proc getTokenLiteral*(expression: IfExpression): string =
  return expression.tok.literal

proc getValue*(expression: IfExpression): string =
  var str = "if"
  str &= expression.condition.getValue()
  str &= " "
  str &= expression.consequence.getValue()

  if expression.alternative != nil:
    str &= " else "
    str &= expression.alternative.getValue()

  return str

#----------------------------------------
# FunctionLiteral proc
#----------------------------------------
proc getTokenLiteral*(literal: FunctionLiteral): string =
  return literal.tok.literal

proc getValue*(literal: FunctionLiteral): string =
  var params: seq[string]
  for param in literal.parameters[]:
    params.add(param.getValue())

  var str = literal.getTokenLiteral()

  str &= "("
  str &= utils.cnvSeqStrToStr(params)
  str &= ")"
  str &= literal.body.getValue()

  return str

#----------------------------------------
# CallExpression proc
#----------------------------------------
proc getTokenLiteral*(expression: CallExpression): string =
  return expression.tok.literal

proc getValue*(expression: CallExpression): string =
  var args: seq[string]
  for arg in expression.arguments[]:
    args.add(arg.getValue())

  var str = expression.function.getValue()
  str &= "("
  str &= utils.cnvSeqStrToStr(args)
  str &= ")"

  return str

#----------------------------------------
# ArrayLiteral proc
#----------------------------------------
proc getTokenLiteral*(literal: ArrayLiteral): string =
  return literal.tok.literal

proc getValue*(literal: ArrayLiteral): string =
  var elements: seq[string]
  for el in literal.elements[]:
    elements.add(el.getValue())

  var str = "["
  str &= utils.cnvSeqStrToStr(elements)
  str &= "]"

  return str

#----------------------------------------
# IndexExpression proc
#----------------------------------------
proc getTokenLiteral*(expression: IndexExpression): string =
  return expression.tok.literal

proc getValue*(expression: IndexExpression): string =
  var str = expression.left.getValue()
  str &= "["
  str &= expression.index.getValue()
  str &= "]"

  return str

#----------------------------------------
# HashLiteral proc
#----------------------------------------
proc getTokenLiteral*(literal: HashLiteral): string =
  return literal.tok.literal

proc getValue*(literal: HashLiteral): string =
  var pairs: seq[string]

  for key, val in literal.pairs:
    let pair = key.getValue() & ":" & val.getValue()
    pairs.add(pair)

  var pairs_str = "{" & utils.cnvSeqStrToStr(pairs) & "}"

  return pairs_str

#----------------------------------------
# LetStatement proc
#----------------------------------------
proc getTokenLiteral*(statement: LetStatement): string =
  return statement.tok.literal

proc getValue*(statement: LetStatement): string =
  # get [let] from statement.getTokenLiteral()
  var str = statement.getTokenLiteral() & " "
  # get [variable name] from statement.name.getValue()
  str &= statement.name.getValue()
  str &= "="

  # get [number] from statement.value.getValue()
  if statement.expression != nil:
    str &= statement.expression.getValue()

  str &= ";"
  return str

#----------------------------------------
# ReturnStatement proc
#----------------------------------------
proc getTokenLiteral*(statement: ReturnStatement): string =
  return statement.tok.literal

proc getValue*(statement: ReturnStatement): string =
  var str = statement.getTokenLiteral() & " "

  if statement.expression != nil:
    str &= statement.expression.getValue()

  str &= ";"
  return str

#----------------------------------------
# ExpressionStatement proc
#----------------------------------------
proc getTokenLiteral*(statement: ExpressionStatement): string =
  return statement.tok.literal

proc getValue*(statement: ExpressionStatement): string =
  if statement.expression != nil:
    return statement.expression.getValue()

  return ""

#----------------------------------------
# Blockstatement proc
#----------------------------------------
proc getTokenLiteral*(statement: BlockStatement): string =
  return statement.tok.literal

proc getValue*(statement: BlockStatement): string =
  var str = ""
  for elem in statement.statements:
    str &= elem.getValue()

  return str