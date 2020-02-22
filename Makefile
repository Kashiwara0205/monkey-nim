compile: 
	nim compile --run token/token.nim
	nim compile --run token/minitest.nim
	
test:
	nim compile --run token/minitest.nim

test_token:
	nim compile --run token/minitest.nim