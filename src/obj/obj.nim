import
  ../ast/ast,
  tables,
  ../utils/utils,
  hashes

from strformat import fmt

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

  HashPair* = ref object of Object
    key*: Object
    value*: Object
  HashObj* = ref object of Object
    pairs*: Table[Hash, HashPair]

  Enviroment* = ref object of RootObj
    store*: Table[string, Object]
    outer*: Enviroment

# forward declaration
proc inspect*(obj: Object):string
proc isHashAble*(obj: Object):bool

proc inspect*(obj: IntegerObj): string
proc hashKey*(obj: IntegerObj): Hash

proc inspect*(obj: BooleanObj): string
proc hashKey*(obj: BooleanObj): Hash

proc inspect*(obj: NullObj): string

proc inspect*(obj: ReturnValueObj): string

proc inspect*(obj: ErrorObj): string

proc inspect*(obj: FunctionObj):string

proc inspect*(obj: StringObj): string
proc hashKey*(obj: StringObj): Hash

proc inspect*(obj: BuiltinObj): string

proc inspect*(obj: ArrayObj): string

proc inspect*(obj: HashObj): string

proc newEnv*(): Enviroment
proc newEncloseEnv*(outer: Enviroment): Enviroment
proc getEnv*(env: Enviroment, name: string): (Object, bool)
proc setEnv*(env: Enviroment, name: string, val: Object): void

#----------------------------------------
# Object proc
#----------------------------------------
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

proc isHashAble*(obj: Object):bool =
  case obj.o_type
  of oInteger:
    return true
  of oBoolean:
    return true
  of oString:
    return true
  else:
    return false

proc hashKey*(obj: Object): Hash =
  case obj.o_type
  of oInteger:
    return obj.integer_obj.hashKey()
  of oBoolean:
    return obj.boolean_obj.hashKey()
  of oString:
    return obj.string_obj.hashKey()
  else:
    discard

#----------------------------------------
# IntegerObj proc
#----------------------------------------
proc inspect*(obj: IntegerObj): string = return fmt"{$obj.value}"

proc hashKey*(obj: IntegerObj): Hash = return obj.value.hash

#----------------------------------------
# BooleanObj proc
#----------------------------------------
proc inspect*(obj: BooleanObj): string = return fmt"{$obj.value}"

proc hashKey*(obj: BooleanObj): Hash = return obj.value.hash

#----------------------------------------
# NullObj proc
#----------------------------------------
proc inspect*(obj: NullObj): string = return "null"

#----------------------------------------
# ReturnValueObj proc
#----------------------------------------
proc inspect*(obj: ReturnValueObj): string = return obj.value.inspect()

#----------------------------------------
# ErrorObj proc
#----------------------------------------
proc inspect*(obj: ErrorObj): string = return fmt"Error: {$obj.message}"

#----------------------------------------
# FunctionObj proc
#----------------------------------------
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
proc inspect*(obj: StringObj): string = return obj.value

proc hashKey*(obj: StringObj): Hash = return obj.value.hash

#----------------------------------------
# BuiltinObj proc
#----------------------------------------
proc inspect*(obj: BuiltinObj): string = return "builtin function"

#----------------------------------------
# ArrayObj proc
#----------------------------------------
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

proc setEnv*(env: Enviroment, name: string, val: Object): void = env.store[name] = val