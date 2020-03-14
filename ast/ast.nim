import ../token/token
import ../utils/utils
import tables
import hashes

type Node* = ref object of RootObj

type 
  ExpressionType* = enum
    nIdentifier
    nBoolean
    nIntegerLiteral
    nPrefixExpression
    nInfixExpression
    nStringLiteral
    nIfExpression
    nFunctionLiteral
    nCallExpression
    nArrayLiteral
    nIndexExpression
    nHashLiteral

type
  StatementType* = enum
    nLetStatement
    nReturnStatement
    nExpressionStatement
    nBlockStatement

type 
  Expression* = ref object of Node
    case e_type*: ExpressionType
    of nIdentifier:
      identifier*: Identifier
    of nBoolean:
      boolean*: Boolean
    of nIntegerLiteral:
      integerLit*: IntegerLiteral
    of nPrefixExpression:
      prefixExp*: PrefixExpression
    of nInfixExpression:
      infixExp*: InfixExpression
    of nStringLiteral:
      stringLit*: StringLiteral
    of nIfExpression:
      ifExp*: IfExpression
    of nFunctionLiteral:
      functionLit*: FunctionLiteral
    of nCallExpression:
      callExp*: CallExpression
    of nArrayLiteral:
      arrayLit*: ArrayLiteral
    of nIndexExpression:
      indexExp*: IndexExpression
    of nHashLiteral:
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
    pairs*: Table[ast.StringLiteral, ast.Expression]

  Statement* = ref object of Node
    case s_type*: StatementType
    of nLetStatement: 
    letStmt* : LetStatement
    of nReturnStatement:
    returnStmt* : ReturnStatement
    of nExpressionStatement:
    expressionStmt* : ExpressionStatement
    of nBlockStatement:
    blockStmt* : BlockStatement

  # This type used by following program
  # [let a = 5;]
  LetStatement* = ref object
    tok*: token.Token
    name*: Identifier
    expression*: Expression

  # This type used by following program
  # [{ }]
  BlockStatement* = ref object
    tok*: token.Token
    statements* :seq[Statement]

  # This type used by following program
  # [value;]
  ExpressionStatement* = ref object
    tok*: token.Token
    expression*: Expression

  # This type used by following program
  # [return value;]
  ReturnStatement* = ref object
    tok*: token.Token
    expression*: Expression

# forward declaration
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
# Expression proc
#----------------------------------------
proc getTokenLiteral*(expression: Expression):string =
  case expression.e_type
  of nIdentifier:
    return expression.identifier.getTokenLiteral
  of nBoolean:
    return expression.boolean.getTokenLiteral
  of nIntegerLiteral:
    return expression.integerLit.getTokenLiteral
  of nPrefixExpression:
    return expression.prefixExp.getTokenLiteral
  of nInfixExpression:
    return expression.infixExp.getTokenLiteral
  of nStringLiteral:
    return expression.stringLit.getTokenLiteral
  of nIfExpression:
    return expression.ifExp.getTokenLiteral
  of nFunctionLiteral:
    return expression.functionLit.getTokenLiteral
  of nCallExpression:
    return expression.callExp.getTokenLiteral
  of nArrayLiteral:
    return expression.arrayLit.getTokenLiteral
  of nIndexExpression:
    return expression.indexExp.getTokenLiteral
  of nHashLiteral:
    return expression.hashLit.getTokenLiteral

proc getValue*(expression: Expression):string =
  case expression.e_type
  of nIdentifier:
    return expression.identifier.getValue
  of nBoolean:
    return expression.boolean.getValue
  of nIntegerLiteral:
    return expression.integerLit.getValue
  of nPrefixExpression:
    return expression.prefixExp.getValue
  of nInfixExpression:
    return expression.infixExp.getValue
  of nStringLiteral:
    return expression.stringLit.getValue
  of nIfExpression:
    return expression.ifExp.getValue
  of nFunctionLiteral:
    return expression.functionLit.getValue
  of nCallExpression:
    return expression.callExp.getValue
  of nArrayLiteral:
    return expression.arrayLit.getValue
  of nIndexExpression:
    return expression.indexExp.getValue
  of nHashLiteral:
    return expression.hashLit.getValue

#----------------------------------------
# Statement proc
#----------------------------------------
proc getTokenLiteral*(statement: Statement): string =
  case statement.s_type
  of nLetStatement: 
    return statement.letStmt.getTokenLiteral
  of nReturnStatement:
    return statement.returnStmt.getTokenLiteral
  of nExpressionStatement:
    return statement.expressionStmt.getTokenLiteral
  of nBlockStatement:
    return statement.blockStmt.getTokenLiteral

proc getValue*(statement: Statement): string =
  case statement.s_type
  of nLetStatement: 
    return statement.letStmt.getValue
  of nReturnStatement:
    return statement.returnStmt.getValue
  of nExpressionStatement:
    return statement.expressionStmt.getValue
  of nBlockStatement:
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
proc hash*(literal: StringLiteral): Hash =
  var h: Hash = 0
  h = h !& hash(literal.value)
  result = !$h

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
  var str = "("
  str &= expression.left.getValue()
  str &= "["
  str &= expression.index.getValue()
  str &= "]"
  str &= ")"

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

type
  Program* = ref object
    statements* :seq[Statement]

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