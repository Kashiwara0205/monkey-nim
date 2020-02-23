all:
	nim compile token/token.nim
	nim compile lexer/lexer.nim
	nim compile token/minitest.nim
	nim compile lexer/minitest.nim
	nim compile test_utils/test_utils.nim
	./token/minitest
	./lexer/minitest

compile: 
	nim compile --run token/token.nim
	nim compile --run lexer/lexer.nim

test:
	nim compile --run token/minitest.nim
	nim compile --run lexer/minitest.nim

lexer_test:
	nim compile --run lexer/minitest.nim

token_test:
	nim compile --run token/minitest.nim
