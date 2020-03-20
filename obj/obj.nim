import ../ast/ast
import tables
import ../utils/utils
from strformat import fmt
import fnv

type 
  ObjectType* = enum
    oInteger
    oBoolean
    oNull
    oReturnValue
    oError
    oFunction
    oString
    oBuiltin
    oArray
    oHash

type
  Object* = ref object of RootObj
    case o_type*: ObjectType
    of oInteger:
      integer_obj*: IntegerObj
    of oBoolean: 
      boolean_obj*: BooleanObj
    of oNull:
      null_obj*: NullObj
    of oReturnValue:
      return_value_obj*: ReturnValueObj
    of oError:
      error_obj*: ErrorObj
    of oFunction:
      function_obj*: FunctionObj
    of oString:
      string_obj*: StringObj
    of oBuiltin:
      builtin_obj*: BuiltinObj
    of oArray:
      array_obj*: ArrayObj
    of oHash:
      hash_obj*: HashObj

  IntegerObj* = ref object of Object
    value*: int64

  BooleanObj* = ref object of Object
    value*: bool

  NullObj* = ref object of Object

  ReturnValueObj* = ref object of Object
    value*: Object

  ErrorObj* = ref object of Object
    message*: string

  FunctionObj* = ref object of Object
    parameters*: ref seq[Identifier]
    body*: BlockStatement
    env*: Enviroment

  StringObj* = ref object of Object
    value*: string

  BuiltinFunction* = proc(args: ref seq[Object]): Object
  BuiltinObj* = ref object of Object
    fn*: BuiltinFunction

  ArrayObj* = ref object of Object
    elements*: ref seq[Object]

  HashKey* = ref object of Object
    obj_type*: ObjectType
    value*: uint64
  HashPair* = ref object of Object
    key*: Object
    value*: Object
  HashObj* = ref object of Object
    pairs: Table[HashKey, HashPair]
  Hashable* = ref object of Object

  Enviroment* = ref object of RootObj
    store*: Table[string, Object]
    outer*: Enviroment

# forward declaration
proc getType*(obj: Object):ObjectType
proc inspect*(obj: Object):string

proc getType*(obj: IntegerObj):ObjectType
proc inspect*(obj: IntegerObj): string
proc hashKey*(obj: IntegerObj): HashKey

proc getType*(obj: BooleanObj):ObjectType
proc inspect*(obj: BooleanObj): string
proc hashKey*(obj: BooleanObj): HashKey

proc getType*(obj: NullObj):ObjectType
proc inspect*(obj: NullObj): string

proc getType*(obj: ReturnValueObj):ObjectType
proc inspect*(obj: ReturnValueObj): string 

proc getType*(obj: ErrorObj):ObjectType
proc inspect*(obj: ErrorObj): string 

proc getType*(obj: FunctionObj):ObjectType
proc inspect*(obj: FunctionObj):string

proc getType*(obj: StringObj):ObjectType
proc inspect*(obj: StringObj): string
proc hashKey*(obj: StringObj): HashKey

proc getType*(obj: BuiltinObj):ObjectType
proc inspect*(obj: BuiltinObj): string

proc getType*(obj: ArrayObj):ObjectType
proc inspect*(obj: ArrayObj): string

proc getType*(obj: HashObj):ObjectType
proc inspect*(obj: HashObj): string

proc newEnv*(): Enviroment 
proc newEncloseEnv*(outer: Enviroment): Enviroment
proc getEnv*(env: Enviroment, name: string): (Object, bool)
proc setEnv*(env: Enviroment, name: string, val: Object): void

#----------------------------------------
# Object proc
#----------------------------------------
proc getType*(obj: Object):ObjectType =
  echo "ININ"
  echo obj.o_type
  case obj.o_type
  of oInteger:
    return obj.integer_obj.getType()
  of oBoolean: 
    return obj.boolean_obj.getType()
  of oNull:
    return obj.null_obj.getType()
  of oReturnValue:
    return obj.return_value_obj.getType()
  of oError:
    return obj.error_obj.getType()
  of oFunction:
    return obj.function_obj.getType()
  of oString:
    return obj.string_obj.getType()
  of oBuiltin:
    return obj.builtin_obj.getType()
  of oArray:
    return obj.array_obj.getType()
  of oHash:
    return obj.hash_obj.getType()

proc inspect*(obj: Object):string =
  case obj.o_type
  of oInteger:
    return obj.integer_obj.inspect()
  of oBoolean: 
    return obj.boolean_obj.inspect()
  of oNull:
    return obj.null_obj.inspect()
  of oReturnValue:
    return obj.return_value_obj.inspect()
  of oError:
    return obj.error_obj.inspect()
  of oFunction:
    return obj.function_obj.inspect()
  of oString:
    return obj.string_obj.inspect()
  of oBuiltin:
    return obj.builtin_obj.inspect()
  of oArray:
    return obj.array_obj.inspect()
  of oHash:
    return obj.hash_obj.inspect()

#----------------------------------------
# IntegerObj proc
#----------------------------------------
proc getType*(obj: IntegerObj):ObjectType =
  return oInteger

proc inspect*(obj: IntegerObj): string =
  return fmt"{$obj.value}"

proc hashKey*(obj: IntegerObj): HashKey =
  return HashKey(obj_type: obj.o_type, value: uint64(obj.value))

#----------------------------------------
# BooleanObj proc
#----------------------------------------
proc getType*(obj: BooleanObj):ObjectType =
  return oBoolean

proc inspect*(obj: BooleanObj): string =
  return fmt"{$obj.value}"

proc hashKey*(obj: BooleanObj): HashKey =
  var value: uint64 = if obj.value: 0 else: 1

  return HashKey(obj_type: obj.o_type, value: value)

#----------------------------------------
# NullObj proc
#----------------------------------------
proc getType*(obj: NullObj):ObjectType =
  return oNull

proc inspect*(obj: NullObj): string =
  return "null"

#----------------------------------------
# ReturnValueObj proc
#----------------------------------------
proc getType*(obj: ReturnValueObj):ObjectType =
  return oReturnValue

proc inspect*(obj: ReturnValueObj): string =
  return obj.value.inspect()

#----------------------------------------
# ErrorObj proc
#----------------------------------------
proc getType*(obj: ErrorObj):ObjectType =
  return oError

proc inspect*(obj: ErrorObj): string =
  return fmt"Error: {$obj.message}"

#----------------------------------------
# FunctionObj proc
#----------------------------------------
proc getType*(obj: FunctionObj):ObjectType =
  return oFunction

proc inspect*(obj: FunctionObj):string =
  var params: seq[string]

  for param in obj.parameters[]:
    params.add(param.getValue())

  var str = "fn"
  str &= "("
  str &= utils.cnvSeqStrToStr(params)
  str &= ") {\n"
  str &= obj.body.getValue()
  str &= "\n}"

  return str

#----------------------------------------
# StringObj proc
#----------------------------------------
proc getType*(obj: StringObj):ObjectType =
  return oString

proc inspect*(obj: StringObj): string =
  return obj.value

proc hashKey*(obj: StringObj): HashKey =
  var value: uint64 = fnv1a64(obj.value)

  return HashKey(obj_type: obj.o_type, value: value)

#----------------------------------------
# BuiltinObj proc
#----------------------------------------
proc getType*(obj: BuiltinObj):ObjectType =
  return oBuiltin

proc inspect*(obj: BuiltinObj): string = 
  return "builtin function"

#----------------------------------------
# ArrayObj proc
#----------------------------------------
proc getType*(obj: ArrayObj):ObjectType =
  return oArray

proc inspect*(obj: ArrayObj): string = 
  var elements: seq[string]
  for element in obj.elements[]:
    elements.add(element.inspect())

  var str = "["
  str &= utils.cnvSeqStrToStr(elements)
  str &= "]"

  return str

#----------------------------------------
# HashObj proc
#----------------------------------------
proc getType*(obj: HashObj):ObjectType =
  return oHash

proc inspect*(obj: HashObj): string =
  var pairs: seq[string]

  for _, pair in obj.pairs:
    pairs.add(fmt"{$pair.key.inspect()}: {$pair.value.inspect()}")

  var str = "{"
  str &= utils.cnvSeqStrToStr(pairs)
  str &= "}"

  return str

#----------------------------------------
# Enviroment proc
#----------------------------------------
proc newEnv*(): Enviroment = 
  let store = initTable[string, Object]()
  return Enviroment(store: store)

proc newEncloseEnv*(outer: Enviroment): Enviroment =
  let new_env = newEnv()
  new_env.outer = outer
  return new_env

proc getEnv*(env: Enviroment, name: string): (Object, bool) =
  let existance = env.store.hasKey(name)
  if not existance and env.outer != nil:
    # return from outer scope
    return env.outer.getEnv(name)
  elif not existance and env.outer == nil:
    # return null when not exists variable
    return (NullObj(), existance)
  else:
    # return from inner scope
    return (env.store[name], existance)

proc setEnv*(env: Enviroment, name: string, val: Object): void = 
  env.store[name] = val