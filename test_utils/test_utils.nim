# prepare error handling
var
  e: ref OSError
new(e)

proc output_testname(testname: string): void =
  echo "+-+-+-+-+-+-+-+-+-+"
  echo testname
  echo "+-+-+-+-+-+-+-+-+-+"

proc eq_value*(testname: string, expected: any, val: any): void =
  output_testname(testname)
  if(expected == val):
    echo "→ PASS"
    echo ""
  else:
    e.msg = "Failure"
    raise e