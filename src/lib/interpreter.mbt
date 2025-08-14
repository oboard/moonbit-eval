///|
struct ClosureInterpreter {
  extern_fns : Map[String, @syntax.Func]
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
  f : @syntax.Func,
) -> Unit {
  self.extern_fns.set(name, f)
}

// 常量运算功能已移动到 constants.mbt

// 变量管理功能已移动到 variables.mbt

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
  @basic.show_loc.val = true
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
    @syntax.Expr::LetFn(name={ name, .. }, func~, loc~, ..) => {
      define_function(self.user_functions, name, func)
      Function(func~, loc~)
    }
    // 处理赋值操作（性能优化：只在可变变量中查找和更新）
    @syntax.Expr::Assign(var_~, expr~, ..) =>
      match var_.name {
        @syntax.LongIdent::Ident(name~) => {
          let new_value = self.visit(expr)
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
              match find_user_function(self.user_functions, name) {
                Some(function) =>
                  execute_function_call(
                    function,
                    args,
                    self.immutable_values,
                    self.mutable_values,
                    fn(expr) { self.visit(expr) },
                  )
                None => unit()
              }
            _ => unit()
          }
        _ => unit()
      }
    _ => unit()
  }
}
