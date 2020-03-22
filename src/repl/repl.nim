import ../lexer/lexer
import ../parser/parser
import ../evaluator/evaluator
import ../obj/obj

const PROMPT = ">>"
const ERROR_MESSAGE = "error"

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
    if parser.getErrors.len != 0:
      echo ERROR_MESSAGE
      continue

    let program = parser.parseProgram()
    let eval = evaluator.eval(program, env)
    if eval != nil: echo eval.inspect()

start()