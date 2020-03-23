import
  ../lexer/lexer,
  ../parser/parser,
  ../evaluator/evaluator,
  ../obj/obj

from strformat import fmt

const
  PROMPT = ">>"
  EXIT_MESSAGE = "Exit: Ctrl + c"

proc ctrlc() {.noconv.} = quit(QuitSuccess)

proc start(): void =
  setControlCHook(ctrlc)

  let env = newEnv()
  echo EXIT_MESSAGE

  while true:
    stdout.write PROMPT
    let
      line = stdin.readLine()
      lex = newLexer(line)
      parser = lex.newParser()
      program = parser.parseProgram()

    if parser.getError != "" :
      echo fmt" -> {parser.getError}"
      continue

    let eval = evaluator.eval(program, env)

    if not eval.isNil: echo eval.inspect()

start()