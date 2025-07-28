// 暂未使用

///|
pub fn to_json(self : Type) -> Json {
  match self {
    Unit => "Unit"
    Bool => "Bool"
    Int => "Int"
    Double => "Double"
    Fun(params, result) =>
      ["Fun", params.map(Type::to_json).to_json(), result.to_json()]
    Tuple(types) => ["Tuple", types.map(Type::to_json).to_json()]
    Array(t) => ["Array", t.to_json()]
    Var({ val: None }) => ["Var", "None"]
    Var({ val: Some(t) }) => ["Var", ["Some", t.to_json()]]
    Ptr => "Ptr"
    _ => "Invalid"
  }
}

///|
pub fn Type::from_json(self : Json) -> Type raise Error {
  fn from(values : ArrayView[Json]) -> Array[Type] raise Error {
    let array = []
    for i = 0; i < values.length(); i = i + 1 {
      array.push(values[i] |> Type::from_json())
    }
    array
  }

  match self {
    "Unit" => Unit
    "Bool" => Bool
    "Int" => Int
    "Double" => Double
    ["Fun", [.. params], result] =>
      Fun(from(params), result |> Type::from_json())
    ["Tuple", [.. types]] => Tuple(from(types))
    ["Array", t] => Array(t |> Type::from_json())
    ["Var", "None"] => Var({ val: None })
    ["Var", ["Some", t]] => Var({ val: Some(t |> Type::from_json()) })
    "Ptr" => Ptr
    _ => fail("invalid json: should contain a valid type")
  }
}

///|
test {
  // Type序列化和反序列化
  inspect(try? Type::from_json(Type::Unit.to_json()), content="Ok(Unit)")
  inspect(try? Type::from_json(Type::Bool.to_json()), content="Ok(Bool)")
  inspect(try? Type::from_json(Type::Int.to_json()), content="Ok(Int)")
  inspect(try? Type::from_json(Type::Double.to_json()), content="Ok(Double)")
  inspect(
    try? Type::from_json(
      Type::Fun([Type::Int, Type::Double], Type::Unit).to_json(),
    ),
    content="Ok(Fun([Int, Double], Unit))",
  )
  inspect(
    try? Type::from_json(Type::Tuple([Type::Int, Type::Double]).to_json()),
    content="Ok(Tuple([Int, Double]))",
  )
  inspect(
    try? Type::from_json(Type::Array(Type::Int).to_json()),
    content="Ok(Array(Int))",
  )
  inspect(
    try? Type::from_json(Type::Var({ val: None }).to_json()),
    content="Ok(Var({val: None}))",
  )
  inspect(
    try? Type::from_json(Type::Var({ val: Some(Type::Int) }).to_json()),
    content="Ok(Var({val: Some(Int)}))",
  )
}

///|
pub fn to_fn_dict(self : Fundef) -> Json {
  {
    "name": [self.name.0.to_json(), self.name.1.to_json()],
    "args": [
      ..self.args.map(x => match x {
        (name, ty) => ([name.to_json(), ty.to_json()] : Json)
      }),
    ],
    "body": self.body.to_dict(),
  }
}

///|
pub fn Fundef::from_json(json : Json) -> Fundef raise Error {
  fn from_json(json : ArrayView[Json]) -> Array[(String, Type)] raise Error {
    let array = []
    for i = 0; i < json.length(); i = i + 1 {
      match json {
        [name, ty] => {
          let name = match name.as_string() {
            Some(name) => name
            None =>
              fail(
                "invalid json: function parameters should contain a string as name",
              )
          }
          let ty = ty |> Type::from_json()
          array.push((name, ty))
        }
        _ =>
          fail(
            "invalid json: function parameters should contain an array of name and type",
          )
      }
    }
    array
  }

  match json {
    { "name": [name, ty], "args": [.. args], "body": body, .. } => {
      let name = match name.as_string() {
        Some(name) => name
        None => fail("invalid field name: should contain a string and a type")
      }
      let ty = ty |> Type::from_json()
      let args = from_json(args)
      let body = body |> Syntax::from_json()
      Fundef::{ name: (name, ty), args, body }
    }
    _ =>
      fail(
        "invalid json: should contain name, args, and body where name is an array of two elements",
      )
  }
}

///|
pub fn to_dict(self : Syntax) -> Json {
  // 序列化：可以将AST序列化为json，以供存储或传输。
  match self {
    Unit => "Unit"
    Bool(b) => ["Bool", if b { true } else { false }]
    Int(i) => ["Int", i.to_double().to_json()]
    String(i) => ["String", i.to_json()]
    Double(f) => ["Double", f.to_json()]
    Not(e) => ["Not", e.to_dict()]
    Neg(e) => ["Neg", e.to_dict()]
    Prim(e1, e2, op) => {
      let op = op.to_string()
      [op.to_json(), e1.to_dict(), e2.to_dict()]
    }
    If(e1, e2, e3) => ["If", e1.to_dict(), e2.to_dict(), e3.to_dict()]
    Let((x, t), e1, e2, mutable~) =>
      [
        "Let",
        [x.to_json(), t.to_json()],
        e1.to_dict(),
        e2.to_dict(),
        mutable.to_json(),
      ]
    Var(id) => ["Var", id.to_json()]
    LetRec(funcdef, e) => ["LetRec", funcdef.to_fn_dict(), e.to_dict()]
    App(e, es) => ["App", e.to_dict(), es.map(Syntax::to_dict).to_json()]
    Tuple(es) => ["Tuple", es.map(Syntax::to_dict).to_json()]
    LetTuple(def, value, body) =>
      [
        "LetTuple",
        [
          ..def.map(x => match x {
            (x, t) => ([x.to_json(), t.to_json()] : Json)
          }),
        ],
        value.to_dict(),
        body.to_dict(),
      ]
    Array(es) => ["Array", es.map(Syntax::to_dict).to_json()]
    Get(arr, idx) => ["Get", arr.to_dict(), idx.to_dict()]
    Put(arr, idx, value) =>
      ["Put", arr.to_dict(), idx.to_dict(), value.to_dict()]
    _ => "Invalid"
  }
}

///|
pub fn Syntax::from_json(json : Json) -> Syntax raise {
  // 反序列化，可以将json反序列化为AST，以供进一步的处理。
  match json {
    "Unit" => Syntax::Unit
    ["Bool", true] => Bool(true)
    ["Bool", false] => Bool(false)
    ["Int", i] =>
      match i.as_number() {
        Some(i) =>
          if i.to_int().to_double() != i {
            fail("invalid json: an int should be an integer")
          } else {
            Int(i.to_int())
          }
        None => fail("invalid json: should contain a number as int")
      }
    ["Double", f] =>
      match f.as_number() {
        Some(f) => Double(f)
        None => fail("invalid json: should contain a number as Double")
      }
    ["Not", e] => Not(e |> Syntax::from_json())
    ["Neg", e] => Neg(e |> Syntax::from_json())
    ["Add", e1, e2] =>
      Prim(e1 |> Syntax::from_json(), e2 |> Syntax::from_json(), Add)
    ["Sub", e1, e2] =>
      Prim(e1 |> Syntax::from_json(), e2 |> Syntax::from_json(), Sub)
    ["Mul", e1, e2] =>
      Prim(e1 |> Syntax::from_json(), e2 |> Syntax::from_json(), Mul)
    ["Div", e1, e2] =>
      Prim(e1 |> Syntax::from_json(), e2 |> Syntax::from_json(), Div)
    ["If", e1, e2, e3] =>
      If(
        e1 |> Syntax::from_json(),
        e2 |> Syntax::from_json(),
        e3 |> Syntax::from_json(),
      )
    ["Let", [x, t], e1, e2, mutable] =>
      Let(
        (
          match x.as_string() {
            Some(x) => x
            None => fail("invalid json: let should contain a string as name")
          },
          t |> Type::from_json(),
        ),
        e1 |> Syntax::from_json(),
        e2 |> Syntax::from_json(),
        mutable=mutable is Json::True,
      )
    ["Var", id] =>
      match id.as_string() {
        Some(id) => Var(id)
        None => fail("invalid json: should contain a string as id")
      }
    ["LetRec", funcdef, e] =>
      LetRec(funcdef |> Fundef::from_json(), e |> Syntax::from_json())
    ["App", e, [.. es]] => {
      fn from_json(values : ArrayView[Json]) -> Array[Syntax] raise {
        let array = []
        for i = 0; i < values.length(); i = i + 1 {
          array.push(values[i] |> Syntax::from_json())
        }
        array
      }

      App(e |> Syntax::from_json(), from_json(es))
    }
    ["Tuple", [.. es]] => {
      fn from_json(values : ArrayView[Json]) -> Array[Syntax] raise {
        let array = []
        for i = 0; i < values.length(); i = i + 1 {
          array.push(values[i] |> Syntax::from_json())
        }
        array
      }

      Tuple(from_json(es))
    }
    ["LetTuple", [.. def], value, body] => {
      fn from_json(values : ArrayView[Json]) -> Array[(String, Type)] raise {
        let array = []
        for i = 0; i < values.length(); i = i + 1 {
          match values[i] {
            [x, t] => {
              let x = match x.as_string() {
                Some(x) => x
                None =>
                  fail(
                    "invalid json: let tuple should contain a string as name",
                  )
              }
              let t = t |> Type::from_json()
              array.push((x, t))
            }
            _ =>
              fail(
                "invalid json: let tuple should contain an array of name and type",
              )
          }
        }
        array
      }

      LetTuple(
        from_json(def),
        value |> Syntax::from_json(),
        body |> Syntax::from_json(),
      )
    }
    ["Array", [.. es]] => {
      fn from_json(values : ArrayView[Json]) -> Array[Syntax] raise {
        let array = []
        for i = 0; i < values.length(); i = i + 1 {
          array.push(values[i] |> Syntax::from_json())
        }
        array
      }

      Array(from_json(es))
    }
    ["Get", arr, idx] =>
      Get(arr |> Syntax::from_json(), idx |> Syntax::from_json())
    ["Put", arr, idx, value] =>
      Put(
        arr |> Syntax::from_json(),
        idx |> Syntax::from_json(),
        value |> Syntax::from_json(),
      )
    _ => fail("invalid json: should contain an operator")
  }
}

///|
test {
  // 语法序列化和反序列化
  inspect(
    Syntax::App(Syntax::Var("f"), []).to_dict().stringify(),
    content=(
      #|["App",["Var","f"],[]]
    ),
  )
  inspect(
    Syntax::App(Syntax::Var("f"), [Syntax::Int(1)]).to_dict().stringify(),
    content=(
      #|["App",["Var","f"],[["Int",1]]]
    ),
  )
  inspect(
    Syntax::Array([Syntax::Int(1), Syntax::Int(2)]).to_dict().stringify(),
    content=(
      #|["Array",[["Int",1],["Int",2]]]
    ),
  )
  inspect(
    Syntax::Bool(true).to_dict().stringify(),
    content=(
      #|["Bool",true]
    ),
  )
  inspect(
    Syntax::Double(1.0).to_dict().stringify(),
    content=(
      #|["Double",1]
    ),
  )
  inspect(
    Syntax::Get(Syntax::Int(1), Syntax::Int(2)).to_dict().stringify(),
    content=(
      #|["Get",["Int",1],["Int",2]]
    ),
  )
  inspect(
    Syntax::If(Syntax::Bool(true), Syntax::Int(1), Syntax::Int(2))
    .to_dict()
    .stringify(),
    content=(
      #|["If",["Bool",true],["Int",1],["Int",2]]
    ),
  )
}

///|
test {
  inspect(Syntax::from_json("Unit"), content="Unit")
  inspect(Syntax::from_json(["Bool", true]), content="Bool(true)")
  inspect(Syntax::from_json(["Bool", false]), content="Bool(false)")
  inspect(Syntax::from_json(["Int", 1]), content="Int(1)")
  inspect(Syntax::from_json(["Double", 1.0]), content="Double(1)")
  inspect(Syntax::from_json(["Not", ["Bool", true]]), content="Not(Bool(true))")
  inspect(Syntax::from_json(["Neg", ["Int", 1]]), content="Neg(Int(1))")
  inspect(
    Syntax::from_json(["Add", ["Int", 1], ["Int", 2]]),
    content="Prim(Int(1), Int(2), Add)",
  )
  inspect(
    Syntax::from_json(["Sub", ["Int", 1], ["Int", 2]]),
    content="Prim(Int(1), Int(2), Sub)",
  )
  inspect(
    Syntax::from_json(["Mul", ["Int", 1], ["Int", 2]]),
    content="Prim(Int(1), Int(2), Mul)",
  )
  inspect(
    Syntax::from_json(["Div", ["Int", 1], ["Int", 2]]),
    content="Prim(Int(1), Int(2), Div)",
  )
  inspect(
    Syntax::from_json(["Eq", ["Int", 1], ["Int", 2]]),
    content="Eq(Int(1), Int(2))",
  )
  inspect(
    Syntax::from_json(["LE", ["Int", 1], ["Int", 2]]),
    content="LE(Int(1), Int(2))",
  )
  inspect(
    Syntax::from_json(["If", ["Bool", true], ["Int", 1], ["Int", 2]]),
    content="If(Bool(true), Int(1), Int(2))",
  )
  inspect(
    Syntax::from_json(["Let", ["x", "Int"], ["Int", 1], ["Int", 2]]),
    content=(
      #|Let(("x", Int), Int(1), Int(2))
    ),
  )
  inspect(
    Syntax::from_json(["Var", "x"]),
    content=(
      #|Var("x")
    ),
  )
}
