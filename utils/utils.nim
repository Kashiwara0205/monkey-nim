proc is_space*(val: char): bool =
  return val == ' ' or val == '\t' or val == '\n' or val == '\r'