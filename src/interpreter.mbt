///|
struct ClosureInterpreter {
  extern_fns : Map[String, (@list.List[@syntax.Expr]) -> @syntax.Expr]
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
  // {"type":"Impl::TopTypeDef","0":{"type":"TypeDecl","tycon":"S","tycon_loc":null,"params":[],"components":{"type":"TypeDesc::Record","0":[{"type":"FieldDecl","name":{"type":"FieldName","label":"a","loc":null},"ty":{"type":"Type::Name","constr_id":{"type":"ConstrId","id":{"type":"LongIdent::Ident","0":"Int"},"loc":null},"tys":[],"loc":null},"mut":false,"vis":{"type":"Visibility::Default"},"loc":null,"attrs":[],"doc":""}]},"attrs":[],"doc":"","type_vis":{"type":"Visibility::Default"},"deriving":[],"loc":null}}
  match node {
    // TopView(_) => ...
    // TopImpl(_) => ...
    // TopBatchTraitAlias(_) => ...
    // TopBatchTypeAlias(_) => ...
    // TopTrait(_) => ...
    // TopFuncAlias(_) => ...
    // TopFuncDef(_) => ...

    // 处理顶层常量定义（如 const Zero = 0）
    TopLetDef(binder~, expr~, ..) => {
      let name = binder.name
      let evaluated_expr = self.visit(expr)
      set_immutable_variable(self.immutable_values, 0, name, evaluated_expr)
    }

    // tycon : String
    // tycon_loc : Location
    // params : @list.List[TypeDeclBinder]
    // components : TypeDesc
    // attrs : @list.List[Attribute]
    // mut doc : DocString
    // type_vis : Visibility
    // deriving : @list.List[DerivingDirective]
    // loc : Location
    TopTypeDef(def) =>
      match def {
        { tycon, .. } => self.type_definitions.set(tycon, def)
      }

    // 处理顶层函数定义，包括结构体方法
    TopFuncDef(fun_decl~, decl_body~, loc~) => {
      // 从fun_decl中提取函数名
      let func_name = fun_decl.name.name

      // 从decl_body中提取函数体
      match decl_body {
        @syntax.DeclBody::DeclBody(local_types=_, expr~) => {
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
          if fun_decl.type_name is Some({ name: Ident(name=type_name), .. }) {
            define_struct_method(
              self.struct_methods,
              type_name,
              func_name,
              func,
            )
            ()
          } else {
            define_function(
              self.user_functions.last().unwrap(),
              func_name,
              func,
            )
          }
        }
        _ => ()
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
  let level = 0
  // @basic.show_loc.val = true
  // let loc = @basic.Location::{
  //   start: { fname: "", lnum: 10, bol: 0, cnum: 0 },
  //   end: { fname: "", lnum: 10, bol: 0, cnum: 0 },
  // }
  let loc = node.loc()
  let unit = () => @syntax.Expr::Unit(loc~, faked=true)
  match node {
    // 处理常量
    @syntax.Expr::Constant(c~, ..) => @syntax.Expr::Constant(c~, loc~)

    // 处理中缀表达式（如 1+1）
    @syntax.Expr::Infix(op~, lhs~, rhs~, ..) =>
      // 检查操作符
      match op.name {
        @syntax.LongIdent::Ident(name~) =>
          match (self.visit(lhs), self.visit(rhs)) {
            (@syntax.Expr::Constant(c=l, ..), @syntax.Expr::Constant(c=r, ..)) =>
              @syntax.Expr::Constant(c=constant_infix(name, l, r), loc~)
            _ => unit()
          }
        _ => unit()
      }
    // Handle unary expressions (like !false)
    @syntax.Expr::Unary(op~, expr~, ..) =>
      match op.name {
        @syntax.LongIdent::Ident(name~) =>
          match (name, self.visit(expr)) {
            // Handle logical not operator
            ("!", @syntax.Expr::Constant(c=@syntax.Constant::Bool(value), ..)) =>
              @syntax.Expr::Constant(c=@syntax.Constant::Bool(!value), loc~)
            // Handle numeric negation
            ("-", @syntax.Expr::Constant(c=constant, ..)) =>
              match constant {
                @syntax.Constant::Int(value) =>
                  @syntax.Expr::Constant(
                    c=@syntax.Constant::Int(
                      (-(@strconv.parse_int(value) catch { _ => 0 })).to_string(),
                    ),
                    loc~,
                  )
                @syntax.Constant::Double(value) =>
                  @syntax.Expr::Constant(
                    c=@syntax.Constant::Double(
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
    @syntax.Expr::Let(pattern=@syntax.Pattern::Var({ name, .. }), expr~, ..) => {
      let evaluated_expr = self.visit(expr)
      set_immutable_variable(self.immutable_values, level, name, evaluated_expr)
      unit()
    }
    // 处理可变变量声明（存储到专门的可变变量数组）
    @syntax.Expr::LetMut(binder={ name, .. }, expr~, ..) => {
      let evaluated_expr = self.visit(expr)
      set_mutable_variable(self.mutable_values, level, name, evaluated_expr)
      unit()
    }
    // 处理函数定义
    @syntax.Expr::LetFn(name={ name, .. }, func~, body~, loc~) => {
      define_function(self.user_functions.last().unwrap(), name, func)
      // 如果body是Unit表达式，说明没有后续表达式，返回函数签名
      match body {
        @syntax.Expr::Unit(..) => @syntax.Expr::Function(func~, loc~)
        _ => self.visit(body)
      }
    }
    // 处理赋值操作（性能优化：只在可变变量中查找和更新）
    @syntax.Expr::Assign(var_~, expr~, augmented_by~, ..) =>
      match var_.name {
        @syntax.LongIdent::Ident(name~) => {
          let new_value = match augmented_by {
            Some(op) => {
              // 增强赋值操作（如 +=, -=, *=, /= 等）
              let current_value = self.find(name)
              match op.name {
                @syntax.LongIdent::Ident(name~) => {
                  let rhs_value = self.visit(expr)
                  match (current_value, rhs_value) {
                    (
                      @syntax.Expr::Constant(c=l, ..),
                      @syntax.Expr::Constant(c=r, ..),
                    ) =>
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
    @syntax.Expr::Ident(id={ name, .. }, ..) =>
      match name {
        @syntax.LongIdent::Ident(name~) => self.find(name)
        _ => unit()
      }
    // 处理函数调用
    @syntax.Expr::Apply(func~, args~, ..) =>
      match func {
        @syntax.Expr::Ident(id={ name, .. }, ..) =>
          match name {
            @syntax.LongIdent::Ident(name~) =>
              // 首先尝试查找用户定义的函数
              match self.find_user_function(name) {
                Some(function) => self.execute_function_call(function, args)
                None => {
                  // 如果没有找到用户定义的函数，尝试查找变量（可能是Lambda函数）
                  let var_value = self.find(name)
                  match var_value {
                    @syntax.Expr::Function(func=lambda_func, ..) =>
                      self.execute_function_call(lambda_func, args)
                    _ =>
                      // 最后尝试查找外部函数
                      match self.extern_fns.get(name) {
                        Some(extern_func) =>
                          // 将参数转换为 @syntax.Parameters
                          args.map(arg => self.visit(arg.value)) |> extern_func
                        None => unit()
                      }
                  }
                }
              }
            _ => unit()
          }
        _ => unit()
      }
    // Handle if expressions
    @syntax.Expr::If(cond~, ifso~, ifnot~, ..) =>
      match self.visit(cond) {
        @syntax.Expr::Constant(c=@syntax.Constant::Bool(value), ..) =>
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
    @syntax.Expr::While(loop_cond~, loop_body~, ..) => {
      let mut result = unit()

      // 循环执行
      while true {
        // 检查循环条件
        let condition_result = self.visit(loop_cond)
        let should_continue = match condition_result {
          @syntax.Expr::Constant(c=@syntax.Constant::Bool(value), ..) => value
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
    @syntax.Expr::For(binders~, condition~, continue_block~, body~, ..) => {
      // 创建新的作用域
      self.push_scope()

      // 初始化循环变量
      for binder_init in binders {
        match binder_init {
          (binder, init_expr) => {
            let init_value = self.visit(init_expr)
            set_mutable_variable(
              self.mutable_values,
              self.mutable_values.length() - 1,
              binder.name,
              init_value,
            )
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
              @syntax.Expr::Constant(c=@syntax.Constant::Bool(value), ..) =>
                value
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
    @syntax.Expr::Function(func~, ..) =>
      // 直接返回Function表达式，它将作为一个值存储
      @syntax.Expr::Function(func~, loc~)
    // Handle group expressions (parentheses)
    @syntax.Expr::Group(expr~, ..) => self.visit(expr)

    // Handle sequence expressions (multiple statements)
    @syntax.Expr::Sequence(exprs~, last_expr~, ..) => {
      // 执行所有前面的表达式（副作用）
      for expr in exprs {
        self.visit(expr) |> ignore
      }
      // 返回最后一个表达式的值
      self.visit(last_expr)
    }

    // Handle record creation
    @syntax.Expr::Record(type_name~, fields~, trailing~, ..) => {
      let inferred_type_name = match type_name {
        Some(tn) => Some(tn)
        None => None
      }
      @syntax.Expr::Record(
        type_name=inferred_type_name,
        fields~,
        trailing~,
        loc~,
      )
    }

    // Handle field access
    @syntax.Expr::Field(record~, accessor~, ..) => {
      let evaluated_record = self.visit(record)
      match (evaluated_record, accessor) {
        (@syntax.Expr::Record(fields~, ..), @syntax.Accessor::Label(label)) => {
          // 在记录的字段中查找匹配的标签
          for field in fields {
            // 根据JSON结构，FieldDef有label和expr字段
            if field.label.name == label.name {
              return self.visit(field.expr)
            }
          }
          unit() // 如果没有找到字段，返回unit
        }
        _ => unit() // 如果不是记录或访问器不匹配，返回unit
      }
    }

    // Handle method calls (DotApply)
    @syntax.Expr::DotApply(self=self_expr, method_name~, args~, ..) => {
      let self_type : String = self.find_type_from_record(self_expr)
      let method_name = method_name.name
      match self.struct_methods.get(self_type) {
        Some(methods) =>
          match methods.get(method_name) {
            Some(func) => self.execute_method_call(func, self_expr, args)
            None => unit()
          }
        None => unit()
      }
    }

    // Handle match expressions
    @syntax.Expr::Match(expr~, cases~, ..) => {
      let evaluated_expr = self.visit(expr)
      self.execute_match(evaluated_expr, cases)
    }
    // Handle Tuple expressions
    @syntax.Expr::Tuple(exprs~, ..) => {
      let evaluated_exprs = exprs.map(fn(expr) { self.visit(expr) })
      @syntax.Expr::Tuple(exprs=evaluated_exprs, loc~)
    }
    // Handle Array expressions
    @syntax.Expr::Array(exprs~, ..) => {
      let evaluated_exprs = exprs.map(fn(expr) { self.visit(expr) })
      @syntax.Expr::Array(exprs=evaluated_exprs, loc~)
    }
    // Handle Record expressions
    // @syntax.Expr::Record(fields~, type_name~, trailing~, ..) => {
    //   let evaluated_fields = fields.map(fn(field) {
    //     @syntax.FieldDef::{
    //       label: field.label,
    //       expr: self.visit(field.expr),
    //       is_pun: field.is_pun,
    //       loc: field.loc,
    //     }
    //   })
    //   @syntax.Expr::Record(type_name~, fields=evaluated_fields, trailing~, loc~)
    // }
    _ => unit()
  }
}

///| 执行结构体方法调用
fn ClosureInterpreter::execute_method_call(
  self : ClosureInterpreter,
  function : @syntax.Func,
  self_expr : @syntax.Expr,
  args : @list.List[@syntax.Argument],
) -> @syntax.Expr {
  match function {
    @syntax.Func::Lambda(parameters~, body~, ..) => {
      // 创建新的作用域
      self.push_scope()

      // 绑定self参数（第一个参数）
      match parameters {
        @list.More(first_param, tail=rest_params) => {
          let self_value = self.visit(self_expr)
          match first_param {
            @syntax.Parameter::Positional(binder={ name, .. }, ..) =>
              self.immutable_values.last().unwrap().set(name, self_value)
            _ => ()
          }
          // 绑定其余参数
          self.bind_function_parameters(rest_params, args)
        }
        @list.Empty => ()
      }

      // 执行函数体
      let result = self.visit(body)

      // 恢复作用域
      self.pop_scope()
      result
    }
    _ => unit()
  }
}

///| 从记录表达式中提取类型名称
fn ClosureInterpreter::find_type_from_record(
  self : ClosureInterpreter,
  expr : @syntax.Expr,
) -> String {
  match expr {
    // 如果是Record表达式且有显式类型名
    @syntax.Expr::Record(type_name=Some(type_name), ..) =>
      // 根据top_visit中的模式，TypeName有name字段
      match type_name {
        { name: Ident(name=type_name), .. } => type_name
        _ => "Unknown"
      }
    // 如果是Record表达式但没有显式类型名，尝试从已定义的类型中推断
    @syntax.Expr::Record(type_name=None, fields~, ..) => {
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
          @syntax.TypeDesc::Record(struct_fields) =>
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
    @syntax.Expr::Ident(id={ name, .. }, ..) =>
      match name {
        @syntax.LongIdent::Ident(name~) => {
          let var_value = self.find(name)
          self.find_type_from_record(var_value)
        }
        _ => "Unknown"
      }
    // 如果不是Record或Ident表达式，返回默认类型
    _ => "Unknown"
  }
}
