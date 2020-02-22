
import tables

type TokenType = string

type
  Token = object
    Type: TokenType
    Literal: string

const
  ILLEGAL = "ILLEGAL"
  EOF = "EOF"
  IDENT = "IDENT"
  INT = "INT"
  ASSIGN = "="
  PLUS = "PLUS"
  MINUS = "MINUS"
  BANG = "!"
  ASTERISK = "*"
  SLASH = "/"
  EQ = "=="
  NOT_EQ = "!="
  LT = "<"
  GT = ">"
  COMMA = ","
  SEMICOLON = ";"
  LPAREN = "("
  RPAREN = ")"
  LBRACE = "{"
  RBRACE = "}"
  LBRACKET = "]"
  RBRACKET = "["
  FUNCTION = "FUNCTION"
  LET = "LET"
  TRUE = "true"
  FALSE = "false"
  IF = "if"
  ELSE = "else"
  RETURN = "return"
  STRING = "STRING"
  COLON = ":"

var keywords = {
  "fn": FUNCTION,
  "let": LET,
  "true": TRUE,
  "false": FALSE,
  "if": IF,
  "else": ELSE,
  "return": RETURN
}.newTable

proc LookupIdent*(ident: string): TokenType =
  if keywords.hasKey(ident):
    return keywords[ident]
  else:
    return IDENT