///|
/// 运行时类型信息 - 包含包名、类型名和环境

///|
pub(all) enum RuntimeType {
  Any
  Arrow(
    args~ : @list.List[RuntimeType],
    res~ : RuntimeType,
    err~ : RuntimeErrorType,
    is_async~ : Bool
  )
  Tuple(@list.List[RuntimeType])
  Name(pkg~ : RuntimePackage, name~ : String, tys~ : @list.List[RuntimeType])
  Option(RuntimeType)
  Object(pkg~ : RuntimePackage, name~ : String)
  Internal
} derive(ToJson)

///|
pub impl Eq for RuntimeErrorType with equal(
  self : RuntimeErrorType,
  other : RuntimeErrorType,
) -> Bool {
  match (self, other) {
    (ErrorType(ty1), ErrorType(ty2)) => ty1 == ty2
    (DefaultErrorType, DefaultErrorType) => true
    (NoErrorType, NoErrorType) => true
    (Noraise, Noraise) => true
    (MaybeError(ty1), MaybeError(ty2)) => ty1 == ty2
    _ => false
  }
}

///|
pub impl Eq for RuntimeType with equal(self : RuntimeType, other : RuntimeType) -> Bool {
  match (self, other) {
    (Any, Any) => true
    (
      Arrow(args=args1, res=res1, err=err1, is_async=async1),
      Arrow(args=args2, res=res2, err=err2, is_async=async2),
    ) => args1 == args2 && res1 == res2 && err1 == err2 && async1 == async2
    (Tuple(tys1), Tuple(tys2)) => tys1 == tys2
    (Name(pkg=pkg1, name=name1, tys=tys1), Name(pkg=pkg2, name=name2, tys=tys2)) =>
      pkg1.name == pkg2.name && name1 == name2 && tys1 == tys2
    (Option(ty1), Option(ty2)) => ty1 == ty2
    (Object(pkg=pkg1, name=name1), Object(pkg=pkg2, name=name2)) =>
      pkg1.name == pkg2.name && name1 == name2
    _ => false
  }
}

///|
pub(all) enum RuntimeErrorType {
  ErrorType(RuntimeType)
  DefaultErrorType
  NoErrorType
  Noraise
  MaybeError(RuntimeType)
} derive(ToJson)

///|
pub impl Show for RuntimeErrorType with output(
  self : RuntimeErrorType,
  logger : &Logger,
) -> Unit {
  match self {
    ErrorType(ty) => {
      logger.write_string("raise ")
      ty.output(logger)
    }
    DefaultErrorType => ()
    NoErrorType => ()
    Noraise => logger.write_string("noraise")
    MaybeError(ty) => {
      logger.write_string("raise ")
      ty.output(logger)
      logger.write_char('?')
    }
  }
}

///|
pub impl Show for RuntimeType with output(self : RuntimeType, logger : &Logger) -> Unit {
  match self {
    Any => logger.write_string("Any")
    Arrow(args~, res~, err~, is_async~) => {
      if is_async {
        logger.write_string("async ")
      }
      logger.write_char('(')
      let mut first = true
      for arg in args {
        if !first {
          logger.write_string(", ")
        } else {
          first = false
        }
        arg.output(logger)
      }
      logger.write_char(')')
      logger.write_string(" -> ")
      res.output(logger)
      err.output(logger)
    }
    Tuple(tys) => {
      logger.write_char('(')
      let mut first = true
      for ty in tys {
        if !first {
          logger.write_string(", ")
        } else {
          first = false
        }
        ty.output(logger)
      }
      logger.write_char(')')
    }
    Name(pkg~, name~, tys~) => {
      if pkg.name != "main" && !pkg.name.has_prefix("moonbitlang/core") {
        logger.write_char('@')
        logger.write_string(pkg.name)
        logger.write_char('.')
      }
      logger.write_string(name)
      if !tys.is_empty() {
        logger.write_char('[')
        let mut first = true
        for ty in tys {
          if !first {
            logger.write_string(", ")
          } else {
            first = false
          }
          ty.output(logger)
        }
        logger.write_char(']')
      }
    }
    Option(ty) => {
      ty.output(logger)
      logger.write_char('?')
    }
    Object(pkg~, name~) => {
      if pkg.name != "main" {
        logger.write_char('@')
        logger.write_string(pkg.name)
        logger.write_char('.')
      }
      logger.write_string(name)
    }
    Internal => logger.write_string("<internal>")
  }
}

///|
pub impl Show for RuntimeType with to_string(self : RuntimeType) -> String {
  let buf = @buffer.new()
  self.output(buf)
  buf.to_string()
}

///|
pub fn ClosureInterpreter::parse_error_type(
  self : ClosureInterpreter,
  ty : @syntax.ErrorType,
) -> RuntimeErrorType {
  match ty {
    ErrorType(ty~) => ErrorType(self.parse_type(ty))
    DefaultErrorType(_) => DefaultErrorType
    NoErrorType => NoErrorType
    Noraise(_) => Noraise
    MaybeError(ty~) => MaybeError(self.parse_type(ty))
  }
}

///|
pub fn ClosureInterpreter::parse_type(
  self : ClosureInterpreter,
  ty : @syntax.Type,
) -> RuntimeType {
  match ty {
    Any(_) => Any
    Arrow(args~, res~, err~, is_async~, ..) =>
      Arrow(
        args=args.map(arg => self.parse_type(arg)),
        res=self.parse_type(res),
        err=self.parse_error_type(err),
        is_async~,
      )
    Tuple(tys~, ..) => Tuple(tys.map(ty => self.parse_type(ty)))
    Name(constr_id={ id, .. }, tys~, ..) => {
      let (pkg, name) = match id {
        Ident(name~) => (self.current_pkg, name)
        Dot(pkg~, id~) => (self.find_pkg(pkg), id)
      }
      Name(pkg~, name~, tys=tys.map(ty => self.parse_type(ty)))
    }
    Object({ id, .. }) => {
      let (pkg, name) = match id {
        Ident(name~) => (self.current_pkg, name)
        Dot(pkg~, id~) => (self.find_pkg(pkg), id)
      }
      Object(pkg~, name~)
    }
    Option(ty~, ..) => Option(self.parse_type(ty))
  }
}

///|
fn ClosureInterpreter::parse_function_type(
  self : ClosureInterpreter,
  func : @syntax.Func,
) -> RuntimeType {
  match func {
    Lambda(parameters~, error_type~, is_async~, body~, return_type~, ..) => {
      let param_types = parameters.map(param => match param {
        DiscardPositional(ty~, ..) =>
          self.parse_type(ty.unwrap_or(Any(loc=dummy_loc())))
        Positional(ty~, ..) =>
          self.parse_type(ty.unwrap_or(Any(loc=dummy_loc())))
        Labelled(ty~, ..) => self.parse_type(ty.unwrap_or(Any(loc=dummy_loc())))
        Optional(ty~, ..) => self.parse_type(ty.unwrap_or(Any(loc=dummy_loc())))
        QuestionOptional(ty~, ..) =>
          self.parse_type(ty.unwrap_or(Any(loc=dummy_loc())))
      })
      let return_type = match return_type {
        Some(return_type) => self.parse_type(return_type)
        None => self.infer_return_type_from_expr(body)
      }
      Arrow(
        args=param_types,
        res=return_type,
        err=self.parse_error_type(error_type),
        is_async~,
      )
    }
    _ => Any
  }
}

///|
pub fn RuntimeType::bool() -> RuntimeType {
  Object(pkg=moonbitlang_core_bool_module, name="Bool")
}

///|
pub fn RuntimeType::int() -> RuntimeType {
  Object(pkg=moonbitlang_core_int_module, name="Int")
}

///|
pub fn RuntimeType::uint() -> RuntimeType {
  Object(pkg=moonbitlang_core_uint_module, name="UInt")
}

///|
pub fn RuntimeType::int64() -> RuntimeType {
  Object(pkg=moonbitlang_core_int64_module, name="Int64")
}

///|
pub fn RuntimeType::uint16() -> RuntimeType {
  Object(pkg=moonbitlang_core_uint16_module, name="UInt16")
}

///|
pub fn RuntimeType::uint64() -> RuntimeType {
  Object(pkg=moonbitlang_core_uint64_module, name="UInt64")
}

///|
pub fn RuntimeType::float() -> RuntimeType {
  Object(pkg=moonbitlang_core_float_module, name="Float")
}

///|
pub fn RuntimeType::double() -> RuntimeType {
  Object(pkg=moonbitlang_core_double_module, name="Double")
}

///|
pub fn RuntimeType::bigint() -> RuntimeType {
  Object(pkg=moonbitlang_core_bigint_module, name="BigInt")
}

///|
pub fn RuntimeType::char() -> RuntimeType {
  Object(pkg=moonbitlang_core_char_module, name="Char")
}

///|
pub fn RuntimeType::byte() -> RuntimeType {
  Object(pkg=moonbitlang_core_byte_module, name="Byte")
}

///|
pub fn RuntimeType::string() -> RuntimeType {
  Object(pkg=moonbitlang_core_string_module, name="String")
}

///|
pub fn RuntimeType::bytes() -> RuntimeType {
  Object(pkg=moonbitlang_core_bytes_module, name="Bytes")
}

///|
pub fn RuntimeType::tuple() -> RuntimeType {
  Object(pkg=moonbitlang_core_tuple_module, name="Tuple")
}

///|
pub fn RuntimeType::array() -> RuntimeType {
  Object(pkg=moonbitlang_core_array_module, name="Array")
}

///|
pub fn RuntimeType::array_view() -> RuntimeType {
  Object(pkg=moonbitlang_core_array_module, name="ArrayView")
}

///|
pub fn RuntimeType::fixed_array() -> RuntimeType {
  Object(pkg=moonbitlang_core_builtin_module, name="FixedArray")
}

///|
pub fn RuntimeType::uninitialized_array() -> RuntimeType {
  Object(pkg=moonbitlang_core_builtin_module, name="UninitializedArray")
}

///|
pub fn RuntimeType::map() -> RuntimeType {
  Object(pkg=moonbitlang_core_builtin_module, name="Map")
}

///|
pub fn RuntimeType::json() -> RuntimeType {
  Object(pkg=moonbitlang_core_builtin_module, name="Json")
}

///|
pub fn RuntimeType::option() -> RuntimeType {
  Object(pkg=moonbitlang_core_option_module, name="Option")
}

///|
pub fn RuntimeType::string_builder() -> RuntimeType {
  Object(pkg=moonbitlang_core_builtin_module, name="StringBuilder")
}

///|
pub fn RuntimeType::result() -> RuntimeType {
  Object(pkg=moonbitlang_core_result_module, name="Result")
}

///|
pub fn RuntimeType::iter() -> RuntimeType {
  Object(pkg=moonbitlang_core_builtin_module, name="Iter")
}

///|
pub fn RuntimeType::list() -> RuntimeType {
  Object(pkg=moonbitlang_core_list_module, name="List")
}

///|
pub fn RuntimeType::any() -> RuntimeType {
  Any
}

///|
/// 带类型信息的值包装器
pub struct WithType[T] {
  val : T
  ty : RuntimeType
} derive(ToJson)
