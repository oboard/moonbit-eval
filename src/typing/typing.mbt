///| 类型检查：类型标注、类型推导、类型检查。
/// moonbit是一门静态类型编程语言。
/// 类型检查方法主要分为两大类：语法解析时检查、语法解析后检查
fn new_tvar() -> @types.Type {
  //  Var(t=None)
  Var({ val: None })
}

///|
priv suberror TyErr String

// 类型变量的归一化

///|
fn unify(t1 : @types.Type, t2 : @types.Type) -> Unit raise TyErr {
  let t1 = t1.repr()
  let t2 = t2.repr()
  if physical_equal(t1, t2) {
    return
  }
  match (t1, t2) {
    (Int, Int) | (Bool, Bool) | (Unit, Unit) | (Double, Double) => ()
    (Var({ val: None } as tvar), ty) | (ty, Var({ val: None } as tvar)) =>
      // check_occur(tvar.val, ty) // 自引用检查:  None(None and array(None))
      tvar.val = Some(ty)
    // .. // handle the function, tuple, and array @types.Type  
    _ => raise TyErr("类型变量的归一化错误")
  }
}

// fn check_occur(t1 : @types.Type?, _t2 : @types.Type) -> Unit!TyErr {
//   raise TyErr("类型变量的自引用错误")
// }

// 类型推导的上下文
// 全局的表记录外部函数的类型

///|
pub let extenv : Map[String, @types.Type] = {}

// 局部的表记录函数内部的变量和局部函数的类型，（嵌套作用域采用不可变数据结构，避免变量和局部函数的参数因命名相同而发生干涉。）
// type LocalCtx @immut/hashmap.T[String,@types.Type]

///|
typealias @immut/hashmap.T[String, @types.Type] as LocalCtx // 为某类型起别名

// 类型推导

///|
fn infer(ctx : LocalCtx, e : @types.Syntax) -> @types.Type raise TyErr {
  match e {
    // 简单的类型推导
    Int(_) => Int
    Bool(_) => Bool
    Var(x) =>
      match ctx.get(x) {
        Some(t) => t
        None =>
          match extenv.get(x) {
            Some(t) => t
            None => {
              let t = new_tvar()
              extenv[x] = t
              t
            }
          }
      }
    // 递归函数的类型推导
    LetRec({ name: (f, t), args: params, body }, rest) => {
      let env_with_f = ctx.add(f, t)
      let params_ty = params.map(x => match x {
        (_, t) => t
      })
      let mut env_with_params = env_with_f
      for p in params {
        env_with_params = env_with_params.add(p.0, p.1)
      }
      let body_ty = infer(env_with_params, body)
      unify(t, Fun(params_ty, body_ty))
      infer(env_with_f, rest)
    }
    // 函数调用的类型推导
    App(f, args) => {
      let ret_ty = new_tvar()
      let f_ty = infer(ctx, f)
      let args_ty = []
      for arg in args {
        args_ty.push(infer(ctx, arg))
      }
      unify(f_ty, Fun(args_ty, ret_ty))
      ret_ty
    }
    Lambda(param, body) => {
      let param_ty = new_tvar()
      let ctx2 = ctx.add(param, param_ty)
      let body_ty = infer(ctx2, body)
      Fun([param_ty], body_ty)
    }
    // 处理其他语法的匹配
    // _ => unimplemented() // 这里可以添加更多的处理逻辑
    _ => raise TyErr("类型推导错误")
  }
}

// 清理类型变量

///|
fn deref_type(t : @types.Type) -> @types.Type {
  match t {
    Fun(params, result) =>
      Fun(params.map(t => deref_type(t)), deref_type(result))
    Tuple(types) => Tuple(types.map(t => deref_type(t)))
    Array(t) => Array(deref_type(t))
    Var({ val: Some(t) } as tvar) => {
      let t = deref_type(t)
      tvar.val = Some(t)
      t
    }
    Var({ val: None } as tvar) => {
      tvar.val = Some(Unit)
      Unit
    }
    t => t
  }
}

///|
fn deref_term(_syntax : @types.Syntax) -> @types.Syntax {
  // 实现细节
  @types.Syntax::Unit
}

///|
pub fn typing(e : @types.Syntax) -> @types.Syntax raise {
  unify(Unit, infer(@immut/hashmap.new(), e))
  for ext_f, ext_t in extenv {
    extenv[ext_f] = deref_type(ext_t)
  }
  deref_term(e)
}
