proc isSpace*(val: char): bool =
  return val == ' ' or val == '\t' or val == '\n' or val == '\r'

proc isDigit*(ch: byte): bool =
  return '0'.byte <= ch and ch <= '9'.byte

proc isLetter*(ch: byte): bool =
  return ('a'.byte <= ch and ch <= 'z'.byte) or
         ('A'.byte <= ch and ch <= 'Z'.byte) or
         ('_'.byte == ch)

proc isStrEnd*(ch: byte): bool =
  return ch == '"'.byte or ch == 0

proc cnvSeqStrToStr* (arr: seq[string]): string =
  var str = ""
  let size = arr.len
  for i, elem in arr.pairs:
    if (size - 1) > i:
      str &= elem & ", "
    else:
      str &= elem

  return str