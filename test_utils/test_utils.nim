# prepare error handling
var
  e: ref OSError
new(e)

proc output_testname*(testname: string): void =
  echo "+-+-+-+-+-+-+-+-+-+"
  echo testname
  echo "+-+-+-+-+-+-+-+-+-+"

proc eq_value_with_testname*(testname: string, expected: any, val: any): void =
  output_testname(testname)
  if(expected == val):
    echo "→ PASS"
    echo ""
  else:
    e.msg = "Failure"
    echo "expected"
    echo expected
    echo "val"
    echo val
    raise e
    
proc eq_value*(expected: any, val: any): void =
  if(expected == val):
    echo "→ PASS"
    echo ""
  else:
    e.msg = "Failure"
    echo "expected"
    echo expected
    echo "val"
    echo val
    raise e