import ../token/token

type
  Lexer* = ref object
    input: string       # input all source.
    position: int       # current position
    readPosition: int   # next read position
    ch: byte            # current looking chara
  
# define new
proc newLexer*(input: string, position: int, readPosition: int, ch: byte): Lexer =
  return Lexer(input: input, position: position, readPosition: readPosition, ch: ch)

# define setter
proc input*(lex: Lexer): string {.inline.} =
  return lex.input

proc position*(lex: Lexer): int {.inline.} =
  return lex.position

proc readPosition*(lex: Lexer): int {.inline.} =
  return lex.readPosition

proc ch*(lex: Lexer): byte {.inline.} =
  return lex.ch

proc readChar*(lex: Lexer): void {.inline.} =
  if lex.readPosition >= lex.input.len():
    lex.ch = 0
  else:
    lex.ch = lex.input[lex.readPosition].byte
  
  lex.position = lex.readPosition
  lex.readPosition += 1

proc peekChar*(lex: Lexer): byte {.inline.} =
  if lex.readPosition >= lex.input.len():
    return 0
  else:
    return lex.input[lex.readPosition].byte