///|
struct ClosureInterpreter {
  extern_fns : Map[String, (@list.List[@syntax.Expr]) -> @syntax.Expr]
  // embedded函数存储 - 全局函数
  embedded_fns : Map[String, (@list.List[@syntax.Expr]) -> @syntax.Expr]
  // embedded方法存储 - 按类型组织的embedded方法定义
  embedded_methods : Map[
    String,
    Map[String, (@list.List[@syntax.Expr]) -> @syntax.Expr],
  ]
  // 函数别名存储 - 存储函数名到其实际实现的映射
  fn_aliases : Map[String, String]
  // 性能优化：区分可变和不可变变量
  immutable_values : Array[Map[String, @syntax.Expr]]
  mutable_values : Array[Map[String, @syntax.Expr]]
  // 用户定义的函数
  user_functions : Array[Map[String, @syntax.Func]]
  // 类型定义
  type_definitions : Map[String, @syntax.TypeDecl]
  // 结构体方法定义 - 按类型名组织方法
  struct_methods : Map[String, Map[String, @syntax.Func]]
}

///|
pub fn ClosureInterpreter::new() -> ClosureInterpreter {
  {
    extern_fns: Map::new(),
    embedded_fns: Map::new(),
    embedded_methods: Map::new(),
    fn_aliases: Map::new(),
    immutable_values: [{}],
    mutable_values: [{}],
    user_functions: [{}],
    type_definitions: Map::new(),
    struct_methods: Map::new(),
  }
}

///|
pub fn ClosureInterpreter::add_extern_fn(
  self : ClosureInterpreter,
  name : String,
  f : (@list.List[@syntax.Expr]) -> @syntax.Expr,
) -> Unit {
  self.extern_fns.set(name, f)
}

///|
pub fn ClosureInterpreter::add_embedded_fn(
  self : ClosureInterpreter,
  name : String,
  f : (@list.List[@syntax.Expr]) -> @syntax.Expr,
) -> Unit {
  self.embedded_fns.set(name, f)
}

///|
pub fn ClosureInterpreter::add_embedded_method(
  self : ClosureInterpreter,
  type_name : String,
  method_name : String,
  f : (@list.List[@syntax.Expr]) -> @syntax.Expr,
) -> Unit {
  if not(self.embedded_methods.contains(type_name)) {
    self.embedded_methods.set(type_name, Map::new())
  }
  self.embedded_methods.get(type_name).unwrap().set(method_name, f)
}

///| 获取当前函数作用域
fn ClosureInterpreter::current_user_function_scope(
  self : ClosureInterpreter,
) -> Map[String, @syntax.Func] {
  // user_functions 数组永远非空（初始化为 [{}]），直接访问最后一个元素
  self.user_functions[self.user_functions.length() - 1]
}

///| 获取当前不可变变量作用域
fn ClosureInterpreter::current_immutable_scope(
  self : ClosureInterpreter,
) -> Map[String, @syntax.Expr] {
  // immutable_values 数组永远非空（初始化为 [{}]），直接访问最后一个元素
  self.immutable_values[self.immutable_values.length() - 1]
}

///|
fn ClosureInterpreter::find(
  self : ClosureInterpreter,
  name : String,
) -> @syntax.Expr {
  find_variable(self.immutable_values, self.mutable_values, name)
}

///|
fn ClosureInterpreter::top_visit(
  self : ClosureInterpreter,
  node : @syntax.Impl,
) -> Unit {
  match node {
    // TopView(_) => ...
    // TopImpl(_) => ...
    // TopBatchTraitAlias(_) => ...
    // TopBatchTypeAlias(_) => ...
    // TopTrait(_) => ...
    // TopFuncAlias(_) =>

    // 处理顶层常量定义（如 const Zero = 0）
    TopLetDef(binder~, expr~, ..) => {
      let name = binder.name
      let evaluated_expr = self.visit(expr)
      self.set_immutable_variable(name, evaluated_expr)
    }
    TopTypeDef(def) =>
      match def {
        { tycon, .. } => self.type_definitions.set(tycon, def)
      }

    // 处理顶层函数定义，包括结构体方法和embedded函数
    TopFuncDef(fun_decl~, decl_body~, loc~) => {
      // 从fun_decl中提取函数名
      let func_name = fun_decl.name.name
      let type_name = match fun_decl.type_name {
        Some({ name: Ident(name=type_name), .. }) => Some(type_name)
        Some({ name: Dot(..), .. }) => None // 处理点号形式的类型名
        None => None
      }
      // 从decl_body中提取函数体
      match decl_body {
        DeclBody(local_types=_, expr~) => {
          let func = @syntax.Func::Lambda(
            parameters=fun_decl.decl_params.unwrap_or(@list.new()),
            params_loc=loc,
            body=expr,
            return_type=fun_decl.return_type,
            error_type=fun_decl.error_type,
            kind=Arrow,
            has_error=fun_decl.has_error,
            is_async=fun_decl.is_async,
            loc~,
          )
          if type_name is Some(type_name) {
            self.define_struct_method(type_name, func_name, func)
          } else {
            self.define_function(func_name, func)
          }
        }
        // 处理embedded函数声明
        DeclStubs(stubs) =>
          match stubs {
            Embedded(code=@syntax.EmbeddedCode::CodeString(code_str), ..) => {
              let func = self.embedded_fns.get(code_str)
              if (type_name, func) is (Some(type_name), Some(func)) {
                self.add_embedded_method(type_name, func_name, func)
              }
            }
            _ => ()
          }
      }
    }
    _ => ()
  }
  // TopTest(_) => ...
  // TopExpr(_) => ...
  // TopImplRelation(_) => ...
}

///|
fn ClosureInterpreter::visit(
  self : ClosureInterpreter,
  node : @syntax.Expr,
) -> @syntax.Expr {
  // @basic.show_loc.val = true
  let loc = node.loc()
  let unit = () => @syntax.Expr::Unit(loc~, faked=true)
  match node {
    // 处理常量
    Constant(c~, ..) => Constant(c~, loc~)

    // 处理中缀表达式（如 1+1）
    Infix(op~, lhs~, rhs~, ..) =>
      // 检查操作符
      match op.name {
        Ident(name~) =>
          match (self.visit(lhs), self.visit(rhs)) {
            (Constant(c=l, ..), Constant(c=r, ..)) =>
              Constant(c=constant_infix(name, l, r), loc~)
            _ => unit()
          }
        _ => unit()
      }
    // Handle unary expressions (like !false)
    Unary(op~, expr~, ..) =>
      match op.name {
        Ident(name~) =>
          match (name, self.visit(expr)) {
            // Handle logical not operator
            ("!", Constant(c=Bool(value), ..)) => Constant(c=Bool(!value), loc~)
            // Handle numeric negation
            ("-", Constant(c=constant, ..)) =>
              match constant {
                Int(value) =>
                  Constant(
                    c=Int(
                      (-(@strconv.parse_int(value) catch { _ => 0 })).to_string(),
                    ),
                    loc~,
                  )
                Double(value) =>
                  Constant(
                    c=Double(
                      (-(@strconv.parse_double(value) catch { _ => 0.0 })).to_string(),
                    ),
                    loc~,
                  )
                _ => unit()
              }
            _ => unit()
          }
        _ => unit()
      }

    // 处理不可变变量（性能优化：存储到专门的不可变变量数组）
    Let(pattern~, expr~, ..) => {
      let evaluated_expr = self.visit(expr)
      // 使用模式匹配来绑定变量（不创建新作用域）
      ignore(self.pattern_matches(evaluated_expr, pattern))
      unit()
    }
    // 处理可变变量声明（存储到专门的可变变量数组）
    LetMut(binder={ name, .. }, expr~, ..) => {
      let evaluated_expr = self.visit(expr)
      self.set_mutable_variable(name, evaluated_expr)
      unit()
    }
    // 处理函数定义
    LetFn(name={ name, .. }, func~, body~, loc~) => {
      self.define_function(name, func)
      // 如果body是Unit表达式，说明没有后续表达式，返回函数签名
      match body {
        Unit(..) => Function(func~, loc~)
        _ => self.visit(body)
      }
    }
    // 处理赋值操作（性能优化：只在可变变量中查找和更新）
    Assign(var_~, expr~, augmented_by~, ..) =>
      match var_.name {
        @syntax.LongIdent::Ident(name~) => {
          let new_value = match augmented_by {
            Some(op) => {
              // 增强赋值操作（如 +=, -=, *=, /= 等）
              let current_value = self.find(name)
              match op.name {
                Ident(name~) => {
                  let rhs_value = self.visit(expr)
                  match (current_value, rhs_value) {
                    (Constant(c=l, ..), Constant(c=r, ..)) =>
                      @syntax.Expr::Constant(c=constant_infix(name, l, r), loc={
                        start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
                        end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
                      })
                    _ => self.visit(expr)
                  }
                }
                _ => self.visit(expr)
              }
            }
            None =>
              // 普通赋值操作
              self.visit(expr)
          }
          update_mutable_variable(self.mutable_values, name, new_value)
          |> ignore
          unit()
        }
        _ => unit()
      }
    // Handle variable identifiers
    Ident(id={ name, .. }, ..) =>
      match name {
        @syntax.LongIdent::Ident(name~) => self.find(name)
        _ => unit()
      }
    // 处理函数调用
    Apply(func~, args~, ..) =>
      match func {
        Ident(id={ name: Ident(name~), .. }, ..) =>
          self.execute_function_by_name(name, args)
        _ => unit()
      }
    // Handle if expressions
    If(cond~, ifso~, ifnot~, ..) =>
      match self.visit(cond) {
        Constant(c=@syntax.Constant::Bool(value), ..) =>
          if value {
            self.visit(ifso)
          } else if ifnot is Some(ifnot) {
            self.visit(ifnot)
          } else {
            unit()
          }
        _ => unit()
      }
    // Handle while loops
    While(loop_cond~, loop_body~, ..) => {
      let mut result = unit()

      // 循环执行
      while true {
        // 检查循环条件
        let condition_result = self.visit(loop_cond)
        let should_continue = match condition_result {
          Constant(c=@syntax.Constant::Bool(value), ..) => value
          _ => false // 如果条件不是布尔值，停止循环
        }
        if not(should_continue) {
          break
        }

        // 执行循环体
        result = self.visit(loop_body)
      }
      result
    }

    // Handle for loops
    For(binders~, condition~, continue_block~, body~, ..) => {
      // 创建新的作用域
      self.push_scope()

      // 初始化循环变量
      for binder_init in binders {
        match binder_init {
          (binder, init_expr) => {
            let init_value = self.visit(init_expr)
            self.set_mutable_variable(binder.name, init_value)
          }
        }
      }

      // 执行循环
      let mut result = unit()

      // 循环执行
      while true {
        // 检查条件
        let should_continue = match condition {
          Some(cond) => {
            let condition_result = self.visit(cond)
            match condition_result {
              Constant(c=@syntax.Constant::Bool(value), ..) => value
              _ => false
            }
          }
          None => true // 如果没有条件，执行一次
        }
        if not(should_continue) {
          break
        }

        // 执行循环体
        result = self.visit(body)

        // 执行continue块（更新循环变量）
        for continue_update in continue_block {
          match continue_update {
            (binder, update_expr) => {
              let new_value = self.visit(update_expr)
              update_mutable_variable(
                self.mutable_values,
                binder.name,
                new_value,
              )
              |> ignore
            }
          }
        }
      }

      // 恢复作用域
      self.pop_scope()
      result
    }

    // Handle Function expressions (Lambda functions)
    Function(func~, ..) =>
      // 直接返回Function表达式，它将作为一个值存储
      Function(func~, loc~)
    // Handle group expressions (parentheses)
    Group(expr~, ..) => self.visit(expr)

    // Handle sequence expressions (multiple statements)
    Sequence(exprs~, last_expr~, ..) => {
      // 执行所有前面的表达式（副作用）
      for expr in exprs {
        self.visit(expr) |> ignore
      }
      // 返回最后一个表达式的值
      self.visit(last_expr)
    }

    // Handle record creation
    Record(type_name~, fields~, trailing~, ..) => {
      let inferred_type_name = match type_name {
        Some(tn) => Some(tn)
        None => None
      }
      Record(type_name=inferred_type_name, fields~, trailing~, loc~)
    }

    // Handle field access
    Field(record~, accessor~, ..) => {
      let evaluated_record = self.visit(record)
      match (evaluated_record, accessor) {
        (Record(fields~, ..), @syntax.Accessor::Label(label)) => {
          // 在记录的字段中查找匹配的标签
          for field in fields {
            // 根据JSON结构，FieldDef有label和expr字段
            if field.label.name == label.name {
              return self.visit(field.expr)
            }
          }
          unit() // 如果没有找到字段，返回unit
        }
        (Tuple(exprs~, ..), @syntax.Accessor::Index(tuple_index~, ..)) => {
          // 处理 tuple 的索引访问
          let exprs_array = exprs.to_array()
          if tuple_index >= 0 && tuple_index < exprs_array.length() {
            self.visit(exprs_array[tuple_index])
          } else {
            unit() // 索引越界返回 unit
          }
        }
        _ => unit() // 如果不是记录或访问器不匹配，返回unit
      }
    }
    // Handle method calls (DotApply)
    DotApply(self=self_expr, method_name~, args~, ..) =>
      // 查找结构体方法
      self.execute_method_call(self_expr, method_name.name, args)

    // Handle match expressions
    Match(expr~, cases~, ..) => {
      let evaluated_expr = self.visit(expr)
      self.execute_match(evaluated_expr, cases)
    }
    // Handle Tuple expressions
    Tuple(exprs~, ..) => {
      let evaluated_exprs = exprs.map(fn(expr) { self.visit(expr) })
      Tuple(exprs=evaluated_exprs, loc~)
    }
    // Handle Array expressions
    Array(exprs~, ..) => {
      let evaluated_exprs = exprs.map(fn(expr) { self.visit(expr) })
      Array(exprs=evaluated_exprs, loc~)
    }
    // Handle Record expressions
    // Record(fields~, type_name~, trailing~, ..) => {
    //   let evaluated_fields = fields.map(fn(field) {
    //     @syntax.FieldDef::{
    //       label: field.label,
    //       expr: self.visit(field.expr),
    //       is_pun: field.is_pun,
    //       loc: field.loc,
    //     }
    //   })
    //   Record(type_name~, fields=evaluated_fields, trailing~, loc~)
    // }

    // Handle record field mutation (record.field = value)
    Mutate(record~, accessor~, field~, augmented_by~, ..) => {
      // 对于记录字段修改，我们需要找到变量名并更新整个记录
      match record {
        Ident(id={ name, .. }, ..) => {
          match name {
            @syntax.LongIdent::Ident(name~) => {
              // 获取当前记录值
              let current_record = self.find(name)
              let new_field_value = match augmented_by {
                Some(op) => {
                  // 增强赋值操作（如 +=, -=, *=, /= 等）
                  let current_field_value = match (current_record, accessor) {
                    (@syntax.Expr::Record(fields~, ..), @syntax.Accessor::Label(label)) => {
                      // 在记录的字段中查找当前值
                      let mut current_value = unit()
                      for field_def in fields {
                        if field_def.label.name == label.name {
                          current_value = field_def.expr
                          break
                        }
                      }
                      current_value
                    }
                    _ => unit()
                  }
                  match op.name {
                    Ident(name~) => {
                      let rhs_value = self.visit(field)
                      match (current_field_value, rhs_value) {
                        (Constant(c=l, ..), Constant(c=r, ..)) =>
                          @syntax.Expr::Constant(c=constant_infix(name, l, r), loc~)
                        _ => self.visit(field)
                      }
                    }
                    _ => self.visit(field)
                  }
                }
                None => self.visit(field)
              }
              
              // 更新记录中的字段值
              match (current_record, accessor) {
                (@syntax.Expr::Record(type_name~, fields~, trailing~, ..), @syntax.Accessor::Label(label)) => {
                  let updated_fields = fields.map(fn(field_def) {
                    if field_def.label.name == label.name {
                      @syntax.FieldDef::{
                        label: field_def.label,
                        expr: new_field_value,
                        is_pun: field_def.is_pun,
                        loc: field_def.loc,
                      }
                    } else {
                      field_def
                    }
                  })
                  let updated_record = @syntax.Expr::Record(type_name~, fields=updated_fields, trailing~, loc~)
                  
                  // 更新变量存储的记录（可能在可变变量或不可变变量中）
                  if update_mutable_variable(self.mutable_values, name, updated_record) {
                    unit()
                  } else {
                    // 如果在可变变量中没找到，尝试更新不可变变量
                    // 注意：这里我们允许修改不可变变量中的可变字段
                    self.set_immutable_variable(name, updated_record)
                    unit()
                  }
                }
                _ => unit()
              }
            }
            _ => unit()
          }
        }
        _ => unit()
      }
    }
    _ => unit()
  }
}

///| 尝试执行embedded方法调用

///| 按名称执行函数调用
fn ClosureInterpreter::execute_function_by_name(
  self : ClosureInterpreter,
  name : String,
  args : @list.List[@syntax.Argument],
) -> @syntax.Expr {
  let name = self.fn_aliases.get(name).unwrap_or(name)
  // 按优先级查找函数：用户函数 -> Lambda变量 -> 外部函数 -> embedded函数
  match self.find_user_function(name) {
    Some(function) =>
      // 检查是否是embedded函数的标记函数
      match function {
        Lambda(body=Ident(id~, ..), ..) =>
          // 提取embedded函数名
          match id.name {
            Ident(name=embedded_name) => {
              // 这是embedded函数标记，调用对应的embedded函数
              let evaluated_args = args.map(arg => self.visit(arg.value))
              match self.embedded_fns.get(embedded_name) {
                Some(embedded_func) => embedded_func(evaluated_args)
                None => unit()
              }
            }
            _ => self.execute_function_call(function, args)
          }
        _ => self.execute_function_call(function, args)
      }
    None => {
      let var_value = self.find(name)
      match var_value {
        Function(func=lambda_func, ..) =>
          self.execute_function_call(lambda_func, args)
        _ => {
          let evaluated_args = args.map(arg => self.visit(arg.value))
          match self.extern_fns.get(name) {
            Some(extern_func) => extern_func(evaluated_args)
            None =>
              // 尝试查找全局embedded函数
              match self.embedded_fns.get(name) {
                Some(embedded_func) => embedded_func(evaluated_args)
                None => unit()
              }
          }
        }
      }
    }
  }
}

///| 执行结构体方法调用
fn ClosureInterpreter::execute_method_call(
  self : ClosureInterpreter,
  self_expr : @syntax.Expr,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> @syntax.Expr {
  let self_type = self.find_type(self_expr)
  match self.struct_methods.get(self_type) {
    Some(methods) => {
      let self_value = self.visit(self_expr)
      match methods.get(method_name) {
        Some(func) => {
          // 普通函数，正常调用
          let all_args = @list.construct(
            @syntax.Argument::{ value: self_value, kind: Positional },
            args,
          )
          self.execute_function_call(func, all_args)
        }
        None => unit()
      }
    }
    None =>
      match self.embedded_methods.get(self_type) {
        Some(type_methods) =>
          match type_methods.get(method_name) {
            Some(embedded_method) => {
              // 准备参数：self_value + 其他参数的求值结果
              let evaluated_args = @list.construct(
                self.visit(self_expr),
                args.map(fn(arg) { self.visit(arg.value) }),
              )
              embedded_method(evaluated_args)
            }
            None => unit()
          }
        None => unit()
      }
  }
}

///| 从表达式中提取类型名称
fn ClosureInterpreter::find_type(
  self : ClosureInterpreter,
  expr : @syntax.Expr,
) -> String {
  match expr {
    // 如果是Constant表达式，根据常量类型推断
    Constant(c~, ..) =>
      match c {
        String(_) => "String"
        Int(_) => "Int"
        Double(_) => "Double"
        Char(_) => "Char"
        Bool(_) => "Bool"
        Bytes(_) => "Bytes"
        _ => "Unknown"
      }
    // 如果是Record表达式且有显式类型名
    Record(type_name=Some(type_name), ..) =>
      // 根据top_visit中的模式，TypeName有name字段
      match type_name {
        { name: Ident(name=type_name), .. } => type_name
        _ => "Unknown"
      }
    // 如果是Record表达式但没有显式类型名，尝试从已定义的类型中推断
    Record(type_name=None, fields~, ..) => {
      // 收集当前记录的字段名
      let current_fields = []
      for field in fields {
        current_fields.push(field.label.name)
      }

      // 遍历已定义的类型，寻找字段匹配的类型
      let mut result = "Unknown"
      self.type_definitions
      .iter()
      .each(fn(entry) {
        let (type_name, type_def) = entry
        match type_def.components {
          Record(struct_fields) =>
            // 检查字段是否匹配
            if struct_fields.length() == current_fields.length() {
              let mut all_match = true
              for struct_field in struct_fields {
                let mut found = false
                for current_field in current_fields {
                  if struct_field.name.label == current_field {
                    found = true
                    break
                  }
                }
                if not(found) {
                  all_match = false
                  break
                }
              }
              if all_match {
                result = type_name
              }
            }
          _ => ()
        }
      })
      result
    }
    // 如果是Ident表达式，查找变量的值
    Ident(id={ name, .. }, ..) =>
      match name {
        Ident(name~) => {
          let var_value = self.find(name)
          self.find_type(var_value)
        }
        _ => "Unknown"
      }
    // 如果是Array表达式，返回Array类型
    Array(..) => "Array"
    // 如果是Tuple表达式，返回Tuple类型
    Tuple(..) => "Tuple"
    // 如果不是已知表达式类型，返回默认类型
    _ => "Unknown"
  }
}
