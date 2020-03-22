all:
	nim compile src/token/token.nim
	nim compile src/lexer/lexer.nim
	nim compile src/ast/ast.nim
	nim compile src/parser/parser.nim
	nim compile src/obj/obj.nim
	nim compile src/evaluator/evaluator.nim
	nim compile src/repl/repl.nim
	nim compile test/test_helper/test_helper.nim
	nim compile --run test/token_test/token_test.nim
	nim compile --run test/lexer_test/lexer_test.nim
	nim compile --run test/parser_test/parser_test.nim
	nim compile --run test/evaluator_test/evaluator_test.nim
	nim compile --run test/buildin_test/buildin_test.nim

install:
	curl https://nim-lang.org/choosenim/init.sh -sSf | sh

init:
	nim compile src/token/token.nim
	nim compile src/lexer/lexer.nim
	nim compile src/ast/ast.nim
	nim compile src/parser/parser.nim
	nim compile src/obj/obj.nim
	nim compile src/evaluator/evaluator.nim
	nim compile src/repl/repl.nim
	nim compile test/test_helper/test_helper.nim
	nim compile --run test/token_test/token_test.nim
	nim compile --run test/lexer_test/lexer_test.nim
	nim compile --run test/parser_test/parser_test.nim
	nim compile --run test/evaluator_test/evaluator_test.nim
	nim compile --run test/buildin_test/buildin_test.nim

monkey_test:
	nim compile --run test/token_test/token_test.nim
	nim compile --run test/lexer_test/lexer_test.nim
	nim compile --run test/parser_test/parser_test.nim
	nim compile --run test/evaluator_test/evaluator_test.nim
	nim compile --run test/buildin_test/buildin_test.nim

lexer_test:
	nim compile --run test/lexer_test/lexer_test.nim

token_test:
	nim compile --run test/token_test/token_test.nim

parser_test:
	nim compile src/parser/parser.nim
	nim compile --run test/parser_test/parser_test.nim

eval_test:
	nim compile src/ast/ast.nim
	nim compile src/parser/parser.nim
	nim compile --run test/evaluator_test/evaluator_test.nim

buildin_test:
	nim compile --run test/buildin_test/buildin_test.nim

monkey:
	src/repl/repl