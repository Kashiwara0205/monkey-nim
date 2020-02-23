proc is_space*(val: char): bool =
  return val == ' ' or val == '\t' or val == '\n' or val == '\r'

proc is_digit*(ch: byte): bool =
  return '0'.byte <= ch and ch <= '9'.byte

proc is_letter*(ch: byte): bool =
  return ('a'.byte <= ch and ch <= 'z'.byte) or
         ('A'.byte <= ch and ch <= 'Z'.byte) or
         ('_'.byte == ch)

proc is_str_end*(ch: byte): bool =
  return ch == '"'.byte or ch == 0