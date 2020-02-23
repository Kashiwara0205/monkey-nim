proc is_space*(val: char): bool =
  return val == ' ' or val == '\t' or val == '\n' or val == '\r'

proc is_digit*(ch: byte): bool =
  return '0'.byte <= ch and ch <= '9'.byte