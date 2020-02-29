import ../token/token
import ../utils/utils

# Interface
type 
  Node = ref object of RootObj
proc getTokenLiteral*(node: Node): string =
  return ""
proc getValue*(node: Node): string =
  return ""

# Interface
type Statement = ref object of Node
  node: Node

# Interface
type Expression = ref object of Node
  node: Node

# Interface
type Literal = ref object of Node
  node: Node

type Identifier = ref object
  tok: token.Token
  variable_name: string

proc getTokenLiteral*(identifier: Identifier): string =
  return identifier.tok.literal

proc getValue*(identifier: Identifier): string =
  return identifier.variable_name

type Boolean =  ref object
  tok: token.Token
  value: bool

proc getTokenLiteral*(boolean: Boolean): string =
  return boolean.tok.literal

proc getValue*(boolean: Boolean): string =
  return boolean.tok.literal

type
  Program = ref object
    statements :seq[Statement]

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

# This type used by following program 
# [let a = 5;]
type
  LetStatement = ref object of Statement
    tok: token.Token
    name: Identifier
    expression: Expression

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

# This type used by following program 
# [return value;]
type ReturnStatement = ref object of Statement
  tok: token.Token
  expression: Expression

proc getTokenLiteral*(statement: ReturnStatement): string =
  return statement.tok.literal

proc getValue*(statement: ReturnStatement): string =
  var str = statement.getTokenLiteral() & " "

  if statement.expression != nil:
    str &= statement.expression.getValue()
  
  str &= ";"
  return str

# This type used by following program 
# [value;]
type ExpressionStatement = ref object of Statement
  tok: token.Token
  expression: Expression

proc getTokenLiteral*(statement: ExpressionStatement): string =
  return statement.tok.literal

proc getValue*(statement: ExpressionStatement): string =
  if statement.expression != nil:
    return statement.expression.getValue()

  return ""

# This type used by following program 
# [5;]
type IntegerLiteral = ref object of Literal
  tok: token.Token
  number: int64

proc getTokenLiteral*(literal: IntegerLiteral): string =
  return literal.tok.literal

proc getValue*(literal: IntegerLiteral): string =
  return literal.tok.literal

# This type used by following program 
# [!] [ - ]
type PrefixExpression = ref object of Expression
  tok: token.Token
  operator: string
  right: Expression

proc getTokenLiteral*(expression: PrefixExpression): string =
  return expression.tok.literal

proc getValue*(expression: PrefixExpression): string = 
  var str = ""
  str &= "("
  str &= expression.operator
  str &= expression.right.getValue
  str &= ")"

  return str

# This type used by following program 
# [1 + 1] [1 < 1]
type InfixExpression = ref object of Expression
  tok: token.Token
  left: Expression
  operator: string
  right: Expression

proc getTokenLiteral*(expression: InfixExpression): string =
  return expression.tok.literal

proc getValue*(expression: InfixExpression): string = 
  var str = ""
  str &= "("
  str &= expression.left.getValue
  str &= expression.operator
  str &= expression.right.getValue
  str &= ")"

  return str

# This type used by following program 
# [{ }]
type BlockStatement = ref object of Statement
  tok: token.Token
  statements :seq[Statement]

proc getTokenLiteral*(statment: BlockStatement): string =
  return statment.tok.literal

proc getValue*(statment: BlockStatement): string = 
  var str = ""
  for elem in statment.statements:
    str &= elem.getValue()

  return str

# This type used by following program 
# [ 
#  if(xxx){
#    xxx
#  }
# ]
type IfExpression = ref object of Expression
  tok: token.Token
  condition: Expression
  consequence: BlockStatement
  alternative: BlockStatement

proc getTokenLiteral*(expression: IfExpression): string =
  return expression.tok.literal

proc getValue*(expression: IfExpression): string = 
  var str = "if"
  str &= expression.condition.getValue()
  str &= " "
  str &= expression.consequence.getValue()

  if expression.alternative != nil:
    str &= "else "
    str &= expression.alternative.getValue()
  
  return str

# This type used by following program 
# [ 
#  fn(xxx){
#    xxx
#  }
# ]
type FunctionLiteral = ref object of Literal
  tok: token.Token
  parameters: seq[Identifier]
  body: BlockStatement

proc getTokenLiteral*(literal: FunctionLiteral): string =
  return literal.tok.literal

proc getValue*(literal: FunctionLiteral): string = 
  var params: seq[string]
  for param in literal.parameters:
    params.add(param.getValue())

  var str = literal.getTokenLiteral()

  str &= "("
  str &= utils.cnvSeqStrToStr(params)
  str &= ")"
  str &= literal.body.getValue()

  return str

# This type used by following program 
# call function
# [ fn() ]
type CallExpression = ref object of Expression
  tok: token.Token
  function: Expression
  arguments: seq[Expression]

proc getTokenLiteral*(expression: CallExpression): string =
  return expression.tok.literal

proc getValue*(expression: CallExpression): string = 
  var args: seq[string]
  for arg in expression.arguments:
    args.add(arg.getValue())

  var str = expression.function.getValue()
  str &= "("
  str &= utils.cnvSeqStrToStr(args)
  str &= ")"

  return str

# This type used by following program 
# [ "abcde" ]
type StringLiteral = ref object of Literal
  tok: token.Token
  value: string

proc getTokenLiteral*(literal: StringLiteral): string =
  return literal.tok.literal

proc getValue*(literal: StringLiteral): string = 
  return literal.tok.literal

# This type used by following program 
# [ array[] ]
type ArrayLiteral = ref object of Literal
  tok: token.Token
  elements: seq[Expression]

proc getTokenLiteral*(literal: ArrayLiteral): string =
  return literal.tok.literal

proc getValue*(literal: ArrayLiteral): string = 
  var elements: seq[string]
  for el in literal.elements:
    elements.add(el.getValue())

  var str = "["
  str &= utils.cnvSeqStrToStr(elements)
  str &= "]"

  return str

# This type used by following program 
# [ [index] ]
type IndexExpression = ref object of Expression 
  tok: token.Token
  left: Expression
  index: Expression

proc getTokenLiteral*(expression: IndexExpression): string = 
  return expression.tok.literal

proc getValue*(expression: IndexExpression): string = 
  var str = "("
  str &= expression.left.getValue()
  str &= "["
  str &= expression.index.getValue()
  str &= "]"

  return str