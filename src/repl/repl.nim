import ../lexer/lexer
import ../parser/parser
import ../evaluator/evaluator
import ../obj/obj
from strformat import fmt

const PROMPT = ">>"

proc ctrlc() {.noconv.} =
  quit(QuitSuccess)

proc start*(): void =
  let env = newEnv()
  echo "Exit: Ctrl + c"
  setControlCHook(ctrlc)
  while true:
    stdout.write PROMPT
    let line = stdin.readLine()
    let lex = newLexer(line)
    let parser = lex.newParser()
    let program = parser.parseProgram()
    if parser.getError != "" :
      echo fmt" -> {parser.getError}"
      continue

    let eval = evaluator.eval(program, env)
    if eval != nil: echo eval.inspect()

start()