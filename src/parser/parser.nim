import
  ../token/token,
  ../lexer/lexer,
  ../utils/utils,
  ../ast/ast,
  strutils,
  tables,
  hashes

from strformat import fmt

type Priority = enum
  LOWSET
  EQUALS
  LESSGREATER
  SUM
  PRODUCT
  PREFIX
  CALL
  INDEX

var precedences = {
  token.EQ: EQUALS,
  token.NOT_EQ: EQUALS,
  token.LT: LESSGREATER,
  token.GT: LESSGREATER,
  token.PLUS: SUM,
  token.MINUS: SUM,
  token.SLASH: PRODUCT,
  token.ASTERISK: PRODUCT,
  token.LPAREN: CALL,
  token.LBRACKET: INDEX
}.newTable

type Parser = ref object
  lex: lexer.Lexer
  curToken: token.Token
  peekToken: token.Token
  error: string
  prefixParseFns: Table[token.TokenType, proc(parser: Parser): Node]
  infixParseFns: Table[token.TokenType, proc(parser: Parser, left: Expression): Node]

# forward declaration
proc getError*(parser: Parser): string
proc peekError*(parser: Parser, t_type: token.TokenType): void
proc noPrefixPraseError*(parser: Parser, t_type: token.TokenType): void
proc nextToken*(parser: Parser): void
proc curTokenIs*(parser: Parser, t_type: token.TokenType): bool
proc peekTokenIs*(parser: Parser, t_type: token.TokenType): bool
proc expectPeekTokenIs*(parser: Parser, t_type: token.TokenType): bool
proc peekPrecedence*(parser: Parser): Priority
proc curPrecedence*(parser: Parser): Priority
proc parseProgram*(parser: Parser): Node
proc parseIdentifier*(parser: Parser): Node
proc parseIntegerLiteral*(parser: Parser): Node
proc parseExpression*(parser: Parser, precedence: Priority): Node
proc parssLetStatement*(parser: Parser): Node
proc parseReturnStatement*(parser: Parser): Node
proc parseExpressionStatement*(parser: Parser): Node
proc parseStatement*(parser: Parser): Node
proc parseBlockStatement*(parser: Parser): Node
proc parsePrefixExpression*(parser: Parser): Node

proc parseInfixExpression*(parser: Parser, left: Expression): Node
proc parseBoolean*(parser: Parser): Node
proc parseGroupExpression*(parser: Parser): Node
proc parseIfExpression*(parser: Parser): Node
proc parseFunctionParameters*(parser: Parser): ref seq[Identifier]
proc parseFunctionLiteral*(parser: Parser): Node
proc parseExpressionList*(parser: Parser, tok: token.TokenType): ref seq[Expression]
proc parseCallExpression*(parser: Parser, function: Expression): Node
proc parseCallArguments*(parser: Parser): ref seq[Expression]
proc parseStringLiteral*(parser: Parser): Node
proc parseArrayLiteral*(parser: Parser): Node
proc parseIndexExpression*(parser: Parser, left: Expression): Node
proc parseHashLiteral*(parser: Parser): Node

proc getError*(parser: Parser): string = return parser.error

proc peekError*(parser: Parser, t_type: token.TokenType): void =
  parser.error = fmt"expected next token no be {$t_type}, got {$parser.peekToken.t_type} instead"
  raise

proc noPrefixPraseError*(parser: Parser, t_type: token.TokenType): void =
  parser.error = fmt"no prefix parse fuction for {$t_type} found"
  raise

proc nextToken*(parser: Parser): void =
  parser.curToken = parser.peekToken
  parser.peekToken = parser.lex.nextToken()

proc curTokenIs*(parser: Parser, t_type: token.TokenType): bool = return parser.curToken.t_type == t_type

proc peekTokenIs*(parser: Parser, t_type: token.TokenType): bool = return parser.peekToken.t_type == t_type

proc expectPeekTokenIs*(parser: Parser, t_type: token.TokenType): bool =
  if parser.peekTokenIs(t_type):
    parser.nextToken()
    return true
  else:
    parser.peekError(t_type)
    return false

proc peekPrecedence*(parser: Parser): Priority =
  let existance = precedences.hasKey(parser.peekToken.t_type)
  return if existance: precedences[parser.peekToken.t_type] else: LOWSET

proc curPrecedence*(parser: Parser): Priority =
  let existance = precedences.hasKey(parser.curToken.t_type)
  return if existance: precedences[parser.curToken.t_type] else: LOWSET

proc newParser*(lex: lexer.Lexer): Parser =
  var parser = Parser(lex: lex, error: "")
  parser.prefixParseFns[token.IDENT] = parseIdentifier
  parser.prefixParseFns[token.INT] = parseIntegerLiteral
  parser.prefixParseFns[token.BANG] = parsePrefixExpression
  parser.prefixParseFns[token.MINUS] = parsePrefixExpression
  parser.prefixParseFns[token.TRUE] = parseBoolean
  parser.prefixParseFns[token.FALSE] = parseBoolean
  parser.prefixParseFns[token.LPAREN] = parseGroupExpression
  parser.prefixParseFns[token.IF] = parseIfExpression
  parser.prefixParseFns[token.FUNCTION] = parseFunctionLiteral
  parser.prefixParseFns[token.STRING] = parseStringLiteral
  parser.prefixParseFns[token.LBRACKET] = parseArrayLiteral
  parser.prefixParseFns[token.LBRACE] = parseHashLiteral

  parser.infixParseFns[token.PLUS] = parseInfixExpression
  parser.infixParseFns[token.MINUS] = parseInfixExpression
  parser.infixParseFns[token.SLASH] = parseInfixExpression
  parser.infixParseFns[token.ASTERISK] = parseInfixExpression
  parser.infixParseFns[token.EQ] = parseInfixExpression
  parser.infixParseFns[token.NOT_EQ] = parseInfixExpression
  parser.infixParseFns[token.LT] = parseInfixExpression
  parser.infixParseFns[token.GT] = parseInfixExpression
  parser.infixParseFns[token.LPAREN] = parseCallExpression
  parser.infixParseFns[token.LBRACKET] = parseIndexExpression

  parser.nextToken()
  parser.nextToken()

  return parser

proc parseProgram*(parser: Parser): Node =
  try:
    var prgoram = Program()
    prgoram.statements = @[]
    while parser.curToken.t_type != token.EOF:
      var statment = parser.parseStatement()

      if not statment.isNil: prgoram.statements.add(statment)

      parser.nextToken()

    return Node(n_type: nProgram, program: prgoram)
  except:
    return Node(n_type: nProgram, program: nil)

proc parseIdentifier*(parser: Parser): Node =
  let identifier = Identifier(tok: parser.curToken, variable_name: parser.curToken.literal)
  return Node(n_type: nExpression, expression: Expression(e_type: eIdentifier, identifier: identifier))

proc parseIntegerLiteral*(parser: Parser): Node =
  var
    literal = IntegerLiteral(tok: parser.curToken)
    value: int64

  if utils.isStrDigit(parser.curToken.literal):
    value = parseInt(parser.curToken.literal)
  else:
    parser.error = "not integer"
    return nil

  literal.number = value

  return Node(n_type: nExpression, expression: Expression(e_type: eIntegerLiteral, integerLit: literal))

proc parseExpression*(parser: Parser, precedence: Priority): Node =
  let existance = parser.prefixParseFns.hasKey(parser.curToken.t_type)

  if not existance:
    parser.noPrefixPraseError(parser.curToken.t_type)
    return nil

  let prefix = parser.prefixParseFns[parser.curToken.t_type]
  var leftExp = prefix(parser).expression

  while not parser.peekTokenIs(token.SEMICOLON) and precedence < parser.peekPrecedence():
    let infix = parser.infixParseFns[parser.peekToken.t_type]
    if infix.isNil:
      return  Node(n_type: nExpression, expression: leftExp)

    parser.nextToken()
    leftExp = infix(parser, leftExp).expression

  return Node(n_type: nExpression, expression: leftExp)

proc parssLetStatement*(parser: Parser): Node =
  var statement = LetStatement(tok: parser.curToken)

  if not parser.expectPeekTokenIs(token.IDENT): return nil

  statement.name = Identifier(tok: parser.curToken, variable_name: parser.curToken.literal)

  if not parser.expectPeekTokenIs(token.ASSIGN): return nil

  parser.nextToken()
  statement.expression = parser.parseExpression(LOWSET).expression

  if parser.peekTokenIs(token.SEMICOLON):
    parser.nextToken()

  return Node(n_type: nStatement, statement: Statement(s_type: sLetStatement, letStmt: statement) )

proc parseReturnStatement*(parser: Parser): Node =
  var statement = ReturnStatement(tok: parser.curToken)

  parser.nextToken()
  statement.expression = parser.parseExpression(LOWSET).expression
  while not parser.curTokenIs(token.SEMICOLON):
    if parser.curTokenIS(token.EOF):
      parser.error = "can't return"
      return nil

    parser.nextToken()

  return Node(n_type: nStatement, statement: Statement(s_type: sReturnStatement, returnStmt: statement) )

proc parseExpressionStatement*(parser: Parser): Node =
  var statement = ExpressionStatement(tok: parser.curToken)
  statement.expression = parser.parseExpression(LOWSET).expression
  if parser.peekTokenIs(token.SEMICOLON):
    parser.nextToken()

  return Node(n_type: nStatement, statement: Statement(s_type: sExpressionStatement, expressionStmt: statement) )

proc parseStatement*(parser: Parser): Node =
  case parser.curToken.t_type:
  of token.LET:
    return parser.parssLetStatement()
  of token.RETURN:
    return parser.parseReturnStatement()
  else:
    return parser.parseExpressionStatement()

proc parseBlockStatement*(parser: Parser): Node =
  var block_statement = BlockStatement(s_type: sBlockStatement, tok: parser.curToken)
  block_statement.statements = @[]

  parser.nextToken()

  while not parser.curTokenIs(token.RBRACE) and not parser.curTokenIs(token.EOF):
    var node = parser.parseStatement()
    if not node.isNil:
      block_statement.statements.add(node.statement)

    parser.nextToken()

  return Node(n_type: nStatement, statement: Statement(s_type: sBlockStatement, blockStmt: block_statement) )

proc parsePrefixExpression*(parser: Parser): Node =
  var expression = PrefixExpression(tok: parser.curToken, operator: parser.curToken.literal)
  parser.nextToken()
  expression.right = parser.parseExpression(PREFIX).expression

  return Node(n_type: nExpression, expression: Expression(e_type: ePrefixExpression, prefixExp: expression) )

proc parseInfixExpression*(parser: Parser, left: Expression): Node =
  var expression = InfixExpression(tok: parser.curToken, operator: parser.curToken.literal, left: left)
  let precedence = parser.curPrecedence()

  parser.nextToken()
  expression.right = parser.parseExpression(precedence).expression

  return Node(n_type: nExpression, expression: Expression(e_type: eInfixExpression, infixExp: expression) )

proc parseBoolean*(parser: Parser): Node =
  var boolean = Boolean(tok: parser.curToken, value: parser.curTokenIs(token.TRUE))
  return Node(n_type: nExpression, expression: Expression(e_type: eBoolean, boolean: boolean) )

proc parseGroupExpression*(parser: Parser): Node =
  parser.nextToken()
  let expression = parser.parseExpression(LOWSET)

  if not parser.expectPeekTokenIs(token.RPAREN):
    return nil

  return expression

proc parseIfExpression*(parser: Parser): Node =
  var expression = IfExpression(tok: parser.curToken)

  if not parser.expectPeekTokenIs(token.LPAREN):
    return nil

  parser.nextToken()

  expression.condition = parser.parseExpression(LOWSET).expression

  if not parser.expectPeekTokenIs(token.RPAREN):
    return nil

  if not parser.expectPeekTokenIs(token.LBRACE):
    return nil

  expression.consequence = parser.parseBlockStatement().statement.blockStmt

  if parser.peekTokenIs(token.ELSE):
    parser.nextToken()

    if not parser.expectPeekTokenIs(token.LBRACE):
      return nil

    expression.alternative = parser.parseBlockStatement().statement.blockStmt

  return Node(n_type: nExpression, expression: Expression(e_type: eIfExpression, ifExp: expression))

proc parseFunctionParameters*(parser: Parser): ref seq[Identifier] =
  var identifiers:ref seq[Identifier]
  identifiers.new

  if parser.peekTokenIs(token.RPAREN):
    parser.nextToken()

    return identifiers

  parser.nextToken()

  var ident = Identifier(tok: parser.curToken, variable_name: parser.curToken.literal)
  identifiers[].add(ident)

  while parser.peekTokenIs(token.COMMA):
    # skip comma
    # x [,] y
    parser.nextToken()
    # move to valiable
    # x , [y]
    parser.nextToken()

    var ident = Identifier(tok: parser.curToken, variable_name: parser.curToken.literal)
    identifiers[].add(ident)

  if not parser.expectPeekTokenIs(token.RPAREN): return nil

  return identifiers

proc parseFunctionLiteral*(parser: Parser): Node =
  var literal = FunctionLiteral(tok: parser.curToken)

  if not parser.expectPeekTokenIs(token.LPAREN): return nil
  literal.parameters = parser.parseFunctionParameters()

  if not parser.expectPeekTokenIs(token.LBRACE): return nil
  literal.body = parser.parseBlockStatement().statement.blockStmt

  return Node(n_type: nExpression, expression: Expression(e_type: eFunctionLiteral, functionLit: literal))

proc parseExpressionList*(parser: Parser, tok: token.TokenType): ref seq[Expression] =
  var list: ref seq[Expression]
  list.new

  if parser.peekTokenIs(tok):
    parser.nextToken()
    return list

  parser.nextToken()
  list[].add(parser.parseExpression(LOWSET).expression)

  while parser.peekTokenIs(token.COMMA):
    parser.nextToken()
    parser.nextToken()
    list[].add(parser.parseExpression(LOWSET).expression)

  if not parser.expectPeekTokenIs(tok): return nil

  return list

proc parseCallExpression*(parser: Parser, function: Expression): Node =
  var expression = CallExpression(tok: parser.curToken, function: function)
  expression.arguments = parser.parseCallArguments()

  return Node(n_type: nExpression, expression: Expression(e_type: eCallExpression, callExp: expression) )

proc parseCallArguments*(parser: Parser): ref seq[Expression] =
  var args: ref seq[Expression]
  args.new
  args[] = @[]

  if parser.peekTokenIs(token.RPAREN):
    parser.nextToken()
    return args

  parser.nextToken()
  args[].add(parser.parseExpression(LOWSET).expression)

  while parser.peekTokenIs(token.COMMA):
    parser.nextToken()
    parser.nextToken()
    args[].add(parser.parseExpression(LOWSET).expression)

  if not parser.expectPeekTokenIs(token.RPAREN): return nil

  return args

proc parseStringLiteral*(parser: Parser): Node =
  let string_literal = StringLiteral(tok: parser.curToken, value: parser.curToken.literal)
  return Node(n_type: nExpression, expression: Expression(e_type: eStringLiteral, stringLit: string_literal) )

proc parseArrayLiteral*(parser: Parser): Node =
  var literal = ArrayLiteral(tok: parser.curToken)
  literal.elements = parser.parseExpressionList(token.RBRACKET)

  return Node(n_type: nExpression, expression: Expression(e_type: eArrayLiteral, arrayLit: literal) )

proc parseIndexExpression*(parser: Parser, left: Expression): Node =
  var expression = IndexExpression(tok: parser.curToken, left: left)

  parser.nextToken()
  expression.index = parser.parseExpression(LOWSET).expression

  if not parser.expectPeekTokenIs(token.RBRACKET): return nil

  return  Node(n_type: nExpression, expression: Expression(e_type: eIndexExpression, indexExp: expression) )

proc parseHashLiteral*(parser: Parser): Node =
  var hash = HashLiteral(tok: parser.curToken)

  while not parser.peekTokenIs(token.RBRACE):
    parser.nextToken()
    let key = parser.parseExpression(LOWSET).expression

    if not parser.expectPeekTokenIs(token.COLON): return nil

    parser.nextToken()

    let value =  parser.parseExpression(LOWSET).expression
    hash.pairs[key] = value
    if not parser.peekTokenIs(token.RBRACE) and not parser.expectPeekTokenIs(token.COMMA): return nil

  if not parser.expectPeekTokenIs(token.RBRACE): return nil

  return Node(n_type: nExpression, expression: Expression(e_type: eHashLiteral, hashLit: hash) )