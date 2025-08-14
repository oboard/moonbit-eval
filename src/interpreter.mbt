///|
struct ClosureInterpreter {
  extern_fns : Map[String, (@list.List[@syntax.Expr]) -> @syntax.Expr]
  // 性能优化：区分可变和不可变变量
  immutable_values : Array[Map[String, @syntax.Expr]]
  mutable_values : Array[Map[String, @syntax.Expr]]
  // 用户定义的函数
  user_functions : Map[String, @syntax.Func]
}

///|
pub fn ClosureInterpreter::new() -> ClosureInterpreter {
  {
    extern_fns: Map::new(),
    immutable_values: [{}],
    mutable_values: [{}],
    user_functions: Map::new(),
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
      define_function(self.user_functions, name, func)
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
              match find_user_function(self.user_functions, name) {
                Some(function) =>
                  execute_function_call(
                    function,
                    args,
                    self.immutable_values,
                    self.mutable_values,
                    expr => self.visit(expr),
                  )
                None => {
                  // 如果没有找到用户定义的函数，尝试查找变量（可能是Lambda函数）
                  let var_value = self.find(name)
                  match var_value {
                    @syntax.Expr::Function(func=lambda_func, ..) =>
                      execute_function_call(
                        lambda_func,
                        args,
                        self.immutable_values,
                        self.mutable_values,
                        expr => self.visit(expr),
                      )
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
    // Handle for loops
    @syntax.Expr::For(binders~, condition~, continue_block~, body~, ..) => {
      // 创建新的作用域
      self.immutable_values.push(Map::new())
      self.mutable_values.push(Map::new())

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
      self.immutable_values.pop() |> ignore
      self.mutable_values.pop() |> ignore
      result
    }

    // Handle Function expressions (Lambda functions)
    @syntax.Expr::Function(func~, ..) =>
      // 直接返回Function表达式，它将作为一个值存储
      @syntax.Expr::Function(func~, loc~)
    // Handle group expressions (parentheses)
    @syntax.Expr::Group(expr~, ..) => self.visit(expr)
    // @syntax.Expr::Sequence(exprs~,last_expr~)
    _ => unit()
  }
}
