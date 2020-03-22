
import tables
from strformat import fmt

type TokenType* = string

type
  Token* = ref object
    t_type*: TokenType
    literal*: string

# forward declaration
proc newToken*(tokenType: TokenType, ch: byte): Token
proc newMultiliteralToken*(tokenType: TokenType, str: string): Token

proc newToken*(tokenType: TokenType, ch: byte): Token =
  # convert byte to char and char to string
  let str = fmt"{$ch.byte.char}"
  return Token(t_type: tokenType, literal: str)

proc newMultiliteralToken*(tokenType: TokenType, str: string): Token =
  return Token(t_type: tokenType, literal: str)

const
  ILLEGAL* = "ILLEGAL"
  EOF* = "EOF"
  IDENT* = "IDENT"
  INT* = "INT"
  ASSIGN* = "="
  PLUS* = "+"
  MINUS* = "-"
  BANG* = "!"
  ASTERISK* = "*"
  SLASH* = "/"
  EQ* = "=="
  NOT_EQ* = "!="
  LT* = "<"
  GT* = ">"
  COMMA* = ","
  SEMICOLON* = ";"
  LPAREN* = "("
  RPAREN* = ")"
  LBRACE* = "{"
  RBRACE* = "}"
  LBRACKET* = "["
  RBRACKET* = "]"
  FUNCTION* = "FUNCTION"
  LET* = "LET"
  TRUE* = "true"
  FALSE* = "false"
  IF* = "if"
  ELSE* = "else"
  RETURN* = "return"
  STRING* = "STRING"
  COLON* = ":"

var keywords = {
  "fn": FUNCTION,
  "let": LET,
  "true": TRUE,
  "false": FALSE,
  "if": IF,
  "else": ELSE,
  "return": RETURN
}.newTable

proc lookupIdent*(ident: string): TokenType =
  return if keywords.hasKey(ident): keywords[ident] else: IDENT