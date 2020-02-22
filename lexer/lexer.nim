import ../token/token

type
  Lexer* = object
    input: string       # input all source.
    position: int       # current position
    readPosition: int   # next read position
    ch: byte            # current looking chara

proc newLexer*(input: string, position: int, readPosition: int, ch: byte): Lexer =
  return Lexer(input: input, position: position, readPosition: readPosition, ch: ch)

proc get*(lex: Lexer, key: string): any =
  case key
  of "input": return lex.input

proc peekChar*(lex: Lexer): byte {.inline.} =
  if lex.readPosition >= lex.input.len():
    return 0
  else:
    return lex.input[lex.readPosition].byte