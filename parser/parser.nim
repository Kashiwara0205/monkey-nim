import ../token/token
import ../lexer/lexer
import ../utils/utils
import strutils
import ../ast/ast
import tables
import hashes

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
  errors: seq[string]
  prefixParseFns: Table[token.TokenType, proc(parser: Parser): ast.Expression]
  infixParseFns: Table[token.TokenType, proc(parser: Parser, left: ast.Expression): ast.Expression]

# forward declaration
proc getErrors*(parser: Parser): seq[string]
proc peekError*(parser: Parser, t_type: token.TokenType): void
proc noPrefixPraseError*(parser: Parser, t_type: token.TokenType): void
proc nextToken*(parser: Parser): void
proc curTokenIs*(parser: Parser, t_type: token.TokenType): bool
proc peekTokenIs*(parser: Parser, t_type: token.TokenType): bool
proc expectPeekTokenIs*(parser: Parser, t_type: token.TokenType): bool
proc peekPrecedence*(parser: Parser): Priority
proc curPrecedence*(parser: Parser): Priority
proc parseProgram*(parser: Parser): ast.Program
proc parseIdentifier*(parser: Parser): ast.Expression
proc parseIntegerLiteral*(parser: Parser): ast.Expression
proc parseExpression*(parser: Parser, precedence: Priority): ast.Expression
proc parssLetStatement*(parser: Parser): ast.Statement
proc parseReturnStatement*(parser: Parser): ast.Statement
proc parseExpressionStatement*(parser: Parser): ast.Statement
proc parseStatement*(parser: Parser): ast.Statement
proc parseBlockStatement*(parser: Parser): ast.Statement
proc parsePrefixExpression*(parser: Parser): ast.Expression
proc parseInfixExpression*(parser: Parser, left: ast.Expression): ast.Expression
proc parseBoolean*(parser: Parser): ast.Expression
proc parseGroupExpression*(parser: Parser): ast.Expression
proc parseIfExpression*(parser: Parser): ast.Expression
proc parseFunctionParameters*(parser: Parser): ref seq[ast.Identifier]
proc parseFunctionLiteral*(parser: Parser): ast.Expression
proc parseExpressionList*(parser: Parser, tok: token.TokenType): ref seq[ast.Expression]
proc parseCallExpression*(parser: Parser, function: ast.Expression): ast.Expression
proc parseCallArguments*(parser: Parser): ref seq[ast.Expression]
proc parseStringLiteral*(parser: Parser): ast.Expression
proc parseArrayLiteral*(parser: Parser): ast.Expression
proc parseIndexExpression*(parser: Parser, left: ast.Expression): ast.Expression
proc parseHashLiteral*(parser: Parser): ast.Expression

proc getErrors*(parser: Parser): seq[string] =
  return parser.errors

proc peekError*(parser: Parser, t_type: token.TokenType): void =
  parser.errors.add("peekError...")

proc noPrefixPraseError*(parser: Parser, t_type: token.TokenType): void =
  parser.errors.add("noPrefixPraseError...")

proc nextToken*(parser: Parser): void =
  parser.curToken = parser.peekToken
  parser.peekToken = parser.lex.nextToken()

proc curTokenIs*(parser: Parser, t_type: token.TokenType): bool =
  return parser.curToken.t_type == t_type

proc peekTokenIs*(parser: Parser, t_type: token.TokenType): bool =
  return parser.peekToken.t_type == t_type

proc expectPeekTokenIs*(parser: Parser, t_type: token.TokenType): bool =
  if parser.peekTokenIs(t_type):
    parser.nextToken()
    return true
  else:
    parser.peekError(t_type)
    return false

proc peekPrecedence*(parser: Parser): Priority =
  if precedences.hasKey(parser.peekToken.t_type):
    return precedences[parser.peekToken.t_type]
  else:
    return LOWSET

proc curPrecedence*(parser: Parser): Priority =
  if precedences.hasKey(parser.curToken.t_type):
    return precedences[parser.curToken.t_type]
  else:
    return LOWSET

proc newParser*(lex: lexer.Lexer): Parser =
  var parser = Parser(lex: lex, errors: @[])
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

proc parseProgram*(parser: Parser): ast.Program =
  var prgoram = ast.Program()

  prgoram.statements = @[]

  while parser.curToken.t_type != token.EOF:
    var statment = parser.parseStatement()

    if statment != nil:
      prgoram.statements.add(statment)

    parser.nextToken()

  return prgoram

proc parseIdentifier*(parser: Parser): ast.Expression =
  let identifier = ast.Identifier(tok: parser.curToken, variable_name: parser.curToken.literal)
  return ast.Expression(e_type: eIdentifier, identifier: identifier)

proc parseIntegerLiteral*(parser: Parser): ast.Expression =
  var literal = ast.IntegerLiteral(tok: parser.curToken)
  var value: int64

  if utils.isStrDigit(parser.curToken.literal):
    value = parseInt(parser.curToken.literal)
  else:
    parser.errors.add("not integer")
    return nil

  literal.number = value

  return ast.Expression(e_type: eIntegerLiteral, integerLit: literal)

proc parseExpression*(parser: Parser, precedence: Priority): ast.Expression =
  var prefix = parser.prefixParseFns[parser.curToken.t_type]
  if prefix == nil:
    parser.noPrefixPraseError(parser.curToken.t_type)
    return nil

  var leftExp = prefix(parser)

  while not parser.peekTokenIs(token.SEMICOLON) and precedence < parser.peekPrecedence():
    var infix = parser.infixParseFns[parser.peekToken.t_type]
    if infix == nil:
      return leftExp

    parser.nextToken()
    leftExp = infix(parser, leftExp)

  return leftExp

proc parssLetStatement*(parser: Parser): ast.Statement =
  var statement = ast.LetStatement(tok: parser.curToken)

  if not parser.expectPeekTokenIs(token.IDENT):
    return nil

  statement.name = ast.Identifier(tok: parser.curToken, variable_name: parser.curToken.literal)

  if not parser.expectPeekTokenIs(token.ASSIGN):
    return nil

  parser.nextToken()
  statement.expression = parser.parseExpression(LOWSET)

  if parser.peekTokenIs(token.SEMICOLON):
    parser.nextToken()

  return ast.Statement(s_type: sLetStatement, letStmt: statement)

proc parseReturnStatement*(parser: Parser): ast.Statement =
  var statement = ast.ReturnStatement(tok: parser.curToken)

  parser.nextToken()
  statement.expression = parser.parseExpression(LOWSET)
  while not parser.curTokenIs(token.SEMICOLON):
    parser.nextToken()

  return ast.Statement(s_type: sReturnStatement, returnStmt: statement)

proc parseExpressionStatement*(parser: Parser): ast.Statement =
  var statement = ast.ExpressionStatement(tok: parser.curToken)
  statement.expression = parser.parseExpression(LOWSET)
  if parser.peekTokenIs(token.SEMICOLON):
    parser.nextToken()

  return ast.Statement(s_type: sExpressionStatement, expressionStmt: statement)

proc parseStatement*(parser: Parser): ast.Statement =
  case parser.curToken.t_type:
  of token.LET:
    return parser.parssLetStatement()
  of token.RETURN:
    return parser.parseReturnStatement()
  else:
    return parser.parseExpressionStatement()

proc parseBlockStatement*(parser: Parser): ast.Statement =
  var block_statement = ast.BlockStatement(tok: parser.curToken)
  block_statement.statements = @[]

  parser.nextToken()

  while not parser.curTokenIs(token.RBRACE) and not parser.curTokenIs(token.EOF):
    var statement = parser.parseStatement()
    if statement != nil:
      block_statement.statements.add(statement)

    parser.nextToken()

  return ast.Statement(s_type: sBlockStatement, blockStmt: block_statement)

proc parsePrefixExpression*(parser: Parser): ast.Expression =
  var expression = ast.PrefixExpression(tok: parser.curToken, operator: parser.curToken.literal)
  parser.nextToken()
  expression.right = parser.parseExpression(PREFIX)

  return ast.Expression(e_type: ePrefixExpression, prefixExp: expression)

proc parseInfixExpression*(parser: Parser, left: ast.Expression): ast.Expression =
  var expression = ast.InfixExpression(tok: parser.curToken, operator: parser.curToken.literal, left: left)
  var precedence = parser.curPrecedence()

  parser.nextToken()
  expression.right = parser.parseExpression(precedence)

  return ast.Expression(e_type: eInfixExpression, infixExp: expression)

proc parseBoolean*(parser: Parser): ast.Expression =
  var boolean = ast.Boolean(tok: parser.curToken, value: parser.curTokenIs(token.TRUE))
  return ast.Expression(e_type: eBoolean, boolean: boolean)

proc parseGroupExpression*(parser: Parser): ast.Expression =
  parser.nextToken()
  let expression = parser.parseExpression(LOWSET)
  if not parser.expectPeekTokenIs(token.RPAREN):
    return nil

  return expression

proc parseIfExpression*(parser: Parser): ast.Expression =
  var expression = ast.IfExpression(tok: parser.curToken)

  if not parser.expectPeekTokenIs(token.LPAREN):
    return nil

  parser.nextToken()

  expression.condition = parser.parseExpression(LOWSET)

  if not parser.expectPeekTokenIs(token.RPAREN):
    return nil

  if not parser.expectPeekTokenIs(token.LBRACE):
    return nil

  expression.consequence = parser.parseBlockStatement().blockStmt

  if parser.peekTokenIs(token.ELSE):
    parser.nextToken()

    if not parser.expectPeekTokenIs(token.LBRACE):
      return nil

    expression.alternative = parser.parseBlockStatement().blockStmt

  return ast.Expression(e_type: eIfExpression, ifExp: expression)

proc parseFunctionParameters*(parser: Parser): ref seq[ast.Identifier] =
  var identifiers:ref seq[ast.Identifier]
  identifiers.new
  identifiers[] = @[]

  if parser.peekTokenIs(token.RPAREN):
    parser.nextToken()

    return identifiers

  parser.nextToken()

  var ident = ast.Identifier(tok: parser.curToken, variable_name: parser.curToken.literal)
  identifiers[].add(ident)

  while parser.peekTokenIs(token.COMMA):
    # skip comma
    # x [,] y
    parser.nextToken()
    # move to valiable
    # x , [y]
    parser.nextToken()

    var ident = ast.Identifier(tok: parser.curToken, variable_name: parser.curToken.literal)
    identifiers[].add(ident)

  if not parser.expectPeekTokenIs(token.RPAREN):
    return nil

  return identifiers

proc parseFunctionLiteral*(parser: Parser): ast.Expression =
  var literal = ast.FunctionLiteral(tok: parser.curToken)

  if not parser.expectPeekTokenIs(token.LPAREN):
    return nil

  literal.parameters = parser.parseFunctionParameters()

  if not parser.expectPeekTokenIs(token.LBRACE):
    return nil

  literal.body = parser.parseBlockStatement().blockStmt

  return ast.Expression(e_type: eFunctionLiteral, functionLit: literal)

proc parseExpressionList*(parser: Parser, tok: token.TokenType): ref seq[ast.Expression] =
  var list: ref seq[ast.Expression]
  list.new
  list[] = @[]

  if parser.peekTokenIs(tok):
    parser.nextToken()
    return list

  parser.nextToken()
  list[].add(parser.parseExpression(LOWSET))

  while parser.peekTokenIs(token.COMMA):
    parser.nextToken()
    parser.nextToken()
    list[].add(parser.parseExpression(LOWSET))

  if not parser.expectPeekTokenIs(tok):
    return nil

  return list

proc parseCallExpression*(parser: Parser, function: ast.Expression): ast.Expression =
  var expression = ast.CallExpression(tok: parser.curToken, function: function)
  expression.arguments = parser.parseCallArguments()

  return ast.Expression(e_type: eCallExpression, callExp: expression)

proc parseCallArguments*(parser: Parser): ref seq[ast.Expression] =
  var args: ref seq[ast.Expression]
  args.new
  args[] = @[]

  if parser.peekTokenIs(token.RPAREN):
    parser.nextToken()
    return args

  parser.nextToken()
  args[].add(parser.parseExpression(LOWSET))

  while parser.peekTokenIs(token.COMMA):
    parser.nextToken()
    parser.nextToken()
    args[].add(parser.parseExpression(LOWSET))

  if not parser.expectPeekTokenIs(token.RPAREN):
    return nil

  return args

proc parseStringLiteral*(parser: Parser): ast.Expression =
  let string_literal = ast.StringLiteral(tok: parser.curToken, value: parser.curToken.literal)
  return ast.Expression(e_type: eStringLiteral, stringLit: string_literal)

proc parseArrayLiteral*(parser: Parser): ast.Expression =
  var literal = ast.ArrayLiteral(tok: parser.curToken)
  literal.elements = parser.parseExpressionList(token.RBRACKET)

  return ast.Expression(e_type: eArrayLiteral, arrayLit: literal)

proc parseIndexExpression*(parser: Parser, left: ast.Expression): ast.Expression =
  var expression = ast.IndexExpression(tok: parser.curToken, left: left)

  parser.nextToken()
  expression.index = parser.parseExpression(LOWSET)

  if not parser.expectPeekTokenIs(token.RBRACKET):
    return nil

  return ast.Expression(e_type: eIndexExpression, indexExp: expression)

proc parseHashLiteral*(parser: Parser): ast.Expression =
  var hash = ast.HashLiteral(tok: parser.curToken)

  while not parser.peekTokenIs(token.RBRACE):
    parser.nextToken()
    let key = parser.parseExpression(LOWSET)

    if not parser.expectPeekTokenIs(token.COLON):
      return nil

    parser.nextToken()

    let value =  parser.parseExpression(LOWSET)
    hash.pairs[key] = value
    if not parser.peekTokenIs(token.RBRACE) and not parser.expectPeekTokenIs(token.COMMA):
      return nil

  if not parser.expectPeekTokenIs(token.RBRACE):
    return nil

  return ast.Expression(e_type: eHashLiteral, hashLit: hash)