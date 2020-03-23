import
  ../token/token,
  ../utils/utils

const
  BYTE_ASSIGN = '='.byte
  BYTE_SEMICOLON = ';'.byte
  BYTE_LPAREN = '('.byte
  BYTE_RPAREN = ')'.byte
  BYTE_COMMA = ','.byte
  BYTE_PLUS = '+'.byte
  BYTE_MINUS = '-'.byte
  BYTE_BANG = '!'.byte
  BYTE_SLASH = '/'.byte
  BYTE_ASTERISK = '*'.byte
  BYTE_LT = '<'.byte
  BYTE_GT = '>'.byte
  BYTE_LBRACE = '{'.byte
  BYTE_RBRACE = '}'.byte
  BYTE_LBRACKET = '['.byte
  BYTE_RBRACKET = ']'.byte
  BYTE_DOUBLE_QUOTATION = '"'.byte
  BYTE_COLON = ':'.byte
  NONE = 0.byte

type
  Lexer* = ref object
    input*: string       # input all source.
    position*: int       # current position
    readPosition*: int   # next read position
    ch*: byte            # current looking chara

# forward declaration
proc readChar*(lex: Lexer): void {.inline.}
proc newLexer*(input: string): Lexer
proc skipWhitespace*(lex: Lexer): void
proc readIdentifiter*(lex: Lexer): string
proc readNumber*(lex: Lexer): string
proc readString*(lex: Lexer): string
proc nextToken*(lex: Lexer): token.Token
proc get_assign_or_eq_token(lex: Lexer): token.Token
proc get_bang_or_not_eq_token(lex: Lexer): token.Token

# define new
proc newLexer*(input: string): Lexer =
  let lex = Lexer(input: input, position: 0, readPosition: 0, ch: 0.byte)
  lex.readChar()
  return lex

proc readChar*(lex: Lexer): void {.inline.} =
  lex.ch =
    if lex.readPosition >= lex.input.len(): 0.byte else: lex.input[lex.readPosition].byte

  lex.position = lex.readPosition
  lex.readPosition += 1

proc readNumber*(lex: Lexer): string =
  let position = lex.position
  while utils.isDigit(lex.ch):
    lex.readChar

  return lex.input[position..( lex.position - 1)]

proc readIdentifiter*(lex: Lexer): string =
  let position = lex.position
  while utils.isLetter(lex.ch):
    lex.readChar

  # instead of a <= x <= b, use a .. b
  return lex.input[position..( lex.position - 1)]

proc readString*(lex: Lexer): string =
  # move to string from double quotation
  # ["]ab" → "[a]b"
  let position = lex.position + 1

  while true:
    lex.readChar()
    if utils.isStrEnd(lex.ch):
      break

  # instead of a <= x <= b, use a .. b
  return lex.input[position..( lex.position - 1)]

proc peekChar*(lex: Lexer): byte {.inline.} =
  if lex.readPosition >= lex.input.len():
    return 0
  else:
    return lex.input[lex.readPosition].byte

proc skipWhitespace*(lex: Lexer): void =
  while utils.isSpace(lex.ch.char):
    lex.readChar()

proc get_assign_or_eq_token(lex: Lexer): token.Token =
  if lex.peekChar() == BYTE_ASSIGN:
    # this case is equal '=='
    lex.readChar()
    return newMultiliteralToken(token.EQ, "==")
  else:
    # this case is assign '='
    return newToken(token.ASSIGN, lex.ch)

proc get_bang_or_not_eq_token(lex: Lexer): token.Token =
  if lex.peekChar() == BYTE_ASSIGN:
    # this case is not_equal '!='
    lex.readChar()
    return newMultiliteralToken(token.NOT_EQ, "!=")
  else:
    # this case is bang '!'
    return newToken(token.BANG, lex.ch)

proc nextToken*(lex: Lexer): token.Token =
  var tok: token.Token

  lex.skipWhitespace()

  case lex.ch:
  of BYTE_ASSIGN:
    tok = get_assign_or_eq_token(lex)
  of BYTE_SEMICOLON:
    tok = newToken(token.SEMICOLON, lex.ch)
  of BYTE_LPAREN:
    tok = newToken(token.LPAREN, lex.ch)
  of BYTE_RPAREN:
    tok = newToken(token.RPAREN, lex.ch)
  of BYTE_COMMA:
    tok = newToken(token.COMMA, lex.ch)
  of BYTE_PLUS:
    tok = newToken(token.PLUS, lex.ch)
  of BYTE_MINUS:
    tok = newToken(token.MINUS, lex.ch)
  of BYTE_BANG:
    tok = get_bang_or_not_eq_token(lex)
  of BYTE_SLASH:
    tok = newToken(token.SLASH, lex.ch)
  of BYTE_ASTERISK:
    tok = newToken(token.ASTERISK, lex.ch)
  of BYTE_LT:
    tok = newToken(token.LT, lex.ch)
  of BYTE_GT:
    tok = newToken(token.GT, lex.ch)
  of BYTE_LBRACE:
    tok = newToken(token.LBRACE, lex.ch)
  of BYTE_RBRACE:
    tok = newToken(token.RBRACE, lex.ch)
  of BYTE_LBRACKET:
    tok = newToken(token.LBRACKET, lex.ch)
  of BYTE_RBRACKET:
    tok = newToken(token.RBRACKET, lex.ch)
  of BYTE_DOUBLE_QUOTATION:
    tok = newMultiliteralToken(token.STRING, lex.readString())
  of BYTE_COLON:
    tok = newToken(token.COLON, lex.ch)
  of NONE:
    tok = newMultiliteralToken(token.EOF, "")
  else:
    if utils.isLetter(lex.ch):
      # this case of some string token
      # example, if, func, hoge...
      let ident = lex.readIdentifiter()
      return newMultiliteralToken(token.lookupIdent(ident), ident)
    elif isDigit(lex.ch):
      return newMultiliteralToken(token.INT, lex.readNumber)
    else:
      tok = newToken(token.ILLEGAL, lex.ch)

  lex.readChar()
  return tok