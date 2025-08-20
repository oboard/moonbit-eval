///|
let core_modules : Map[String, RuntimeModule] = { "int": int_module }

///|
fn dummy_loc() -> @basic.Location {
  {
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
}

///|
let int_module : RuntimeModule = {
  meta: ModuleMeta::new("moonbitlang/core/int"),
  env: {
    fn_aliases: {},
    deps: {},
    struct_methods: {},
    type_definitions: {},
    type_environments: [],
    mutable_vars: {},
    values: {
      "max_value": Int(@int.max_value),
      "min_value": Int(@int.min_value),
      "abs": Closure(
        @syntax.Func::Lambda(
          parameters=@list.of([
            Positional(binder={ name: "self", loc: dummy_loc() }, ty=None),
          ]),
          params_loc=dummy_loc(),
          body=@syntax.Expr::If(
            cond=@syntax.Expr::Infix(
              op=@syntax.Var::{
                name: @syntax.LongIdent::Ident(name="<"),
                loc: dummy_loc(),
              },
              lhs=@syntax.Expr::Ident(
                id=@syntax.Var::{
                  name: @syntax.LongIdent::Ident(name="self"),
                  loc: dummy_loc(),
                },
                loc=dummy_loc(),
              ),
              rhs=@syntax.Expr::Constant(
                c=@syntax.Constant::Int("0"),
                loc=dummy_loc(),
              ),
              loc=dummy_loc(),
            ),
            ifso=@syntax.Expr::Unary(
              op=@syntax.Var::{
                name: @syntax.LongIdent::Ident(name="-"),
                loc: dummy_loc(),
              },
              expr=@syntax.Expr::Ident(
                id=@syntax.Var::{
                  name: @syntax.LongIdent::Ident(name="self"),
                  loc: dummy_loc(),
                },
                loc=dummy_loc(),
              ),
              loc=dummy_loc(),
            ),
            ifnot=Some(
              @syntax.Expr::Ident(
                id=@syntax.Var::{
                  name: @syntax.LongIdent::Ident(name="self"),
                  loc: dummy_loc(),
                },
                loc=dummy_loc(),
              ),
            ),
            loc=dummy_loc(),
          ),
          return_type=None,
          error_type=NoErrorType,
          kind=Arrow,
          has_error=None,
          is_async=false,
          loc=dummy_loc(),
        ),
        RuntimeEnvironment::new(),
      ),
    },
    parent: None,
  },
}
