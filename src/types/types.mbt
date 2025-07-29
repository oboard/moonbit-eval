// Syntax枚举用于构建表达式抽象语法树
// 多语句问题：Let、LetRec、LetTuple最后一个参数用来支持连续语句。虽然不存在mut变量，因此赋值之后无法修改，但是数组内容可以重复更改，这意味着必须有一个Seq
// 注意：返回的语法结构，本身就可以自行构建一个Array[Syntax]  ：)，但是Array[Syntax]和Syntax类型验证时又不同！头大！

///|
pub(all) enum Syntax {
  Unit
  Bool(Bool) // Bool(true),Bool(false)
  Int(Int) // Int(1)
  Double(Double) // Double(1.1)
  String(String) // "hello"
  TemplateString(Array[(String, Syntax?)]) // "hello \{expr}"
  Var(String) // _
  Tuple(Array[Syntax]) // Tuple(_, _, _)
  Not(Syntax) // not(_)
  Array(Array[Syntax]) // [_, _, ...]
  Neg(Syntax) // -_
  App(Syntax, Array[Syntax]) // _(_, _, _) or _()
  Get(Syntax, Syntax) // _[_]
  If(Syntax, Syntax, Syntax) // if _ { _ } else { _ }
  ForIn(Syntax, Syntax) // for _ in _ { _ }
  For(Syntax, Syntax, Syntax, Syntax) // for _; _; _ { _ }
  While(Syntax, Syntax) // while _ { _ }
  Lambda(String, Syntax) // x => x * 2
  Prim(Syntax, Syntax, Op) // _+ - * / _
  Assign(String, Syntax) // _ = _
  Let((String, Type), Syntax, Syntax, mutable~ : Bool) // let _: _ = _; _
  LetRec(Fundef, Syntax) // fn f() {} ; _
  LetTuple(Array[(String, Type)], Syntax, Syntax) // let (_ , _) : (_, _)= _; _
  Put(Syntax, Syntax, Syntax) // _[_] = _
  Seq(Array[Syntax]) // Seq(_,_,_):未来弃用：目前其等同于Tuple(Array[Syntax])，本质上是一个函数，输入为语法数组，输出为语法，且无法取出任意一条语法。
} derive(Show, Eq)

///|
pub(all) enum Op {
  Add
  Sub
  Mul
  Div
  EqEq
  LessEqual
  NotEqual
  LessThan
  GreaterThan
  GreaterEqual
  And
  Or
} derive(Show, Eq, ToJson)

///|
pub(all) struct Fundef {
  name : (String, Type)
  args : Array[(String, Type)]
  body : Syntax
} derive(Show, Eq)

///|
pub(all) enum Type {
  Unit
  Bool
  Int
  Double
  String
  Fun(Array[Type], Type) // (_, _, _) -> _
  Tuple(Array[Type]) // (_, _, _)
  Array(Type) // Array[_]
  Var(Ref[Type?])
  Ptr
} derive(Show)

///|
pub fn Type::is_ptr_like(self : Type) -> Bool {
  match self {
    Fun(_) | Tuple(_) | Array(_) | Ptr => true
    Var(t) =>
      match t.val {
        Some(t) => t.is_ptr_like()
        None => false
      }
    _ => false
  }
}

///|
pub fn Type::is_float_like(self : Type) -> Bool {
  match self {
    Double => true
    Var(t) =>
      match t.val {
        Some(t) => t.is_float_like()
        None => false
      }
    _ => false
  }
}

///|
pub fn Type::size_of(self : Type, size_of_ptr : Int) -> Int {
  match self {
    Unit => 0
    Bool => 4
    Int => 4
    Double => 8
    Tuple(_) | Fun(_, _) | Array(_) | Ptr => size_of_ptr
    Var(t) =>
      match t.val {
        Some(t) => t.size_of(size_of_ptr)
        None => @util.die_with_error(@util.ErrorType::TypeInstantiationError)
      }
    _ => @util.die_with_error(@util.ErrorType::InvalidType)
  }
}

///|
pub impl Eq for Type with op_equal(self : Type, other : Type) -> Bool {
  match (self, other) {
    (Unit, Unit) => true
    (Bool, Bool) => true
    (Int, Int) => true
    (Double, Double) => true
    (Fun(xs, x), Fun(ys, y)) => xs == ys && x == y
    (Tuple(xs), Tuple(ys)) => xs == ys
    (Array(x), Array(y)) => x == y
    (Ptr, Ptr) => true
    (Var(x), Var(y)) => x.val == y.val
    _ => false
  }
}

// 找到类型变量代表的实际类型：

///|
pub fn Type::repr(self : Type) -> Type {
  match self {
    Var({ val: Some(ty) } as tvar) => {
      let actual_ty = ty.repr()
      tvar.val = Some(actual_ty) // 压缩路径
      actual_ty
    }
    ty => ty
  }
}
