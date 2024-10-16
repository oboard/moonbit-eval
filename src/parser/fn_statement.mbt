fn fn_main_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(
    fn {
      Fn => {
        parser_context.is_main = false
        let curent_token_number = parser_context.token_length - tokens.length()
        // println("FN curent_token_number: \{curent_token_number}")
        let { column_start, .. } : @lex.TokenPosition = @lex.token_postion_array[curent_token_number]
        // println("FN column_start: \{column_start}")
        if parser_context.is_top_level {
          if column_start == 1 {
            true
          } else {
            @util.die("顶级未左对齐")
          }
        } else {
          true
        }
      }
      _ => false
    },
  )
  .and(
    ptoken(
      fn {
        Main => {
          // println("main function")
          parser_context.is_main = true
          true
        }
        _ => false
      },
    ).map(fn { _ => "main" }),
  )
  .and(block) // 解析函数体
  .and(semicolon)
  .map(
    fn {
      (((_, fun_name), body), _) => {
        let fundef : @types.Fundef = {
          name: (fun_name, @types.Type::Unit),
          args: [],
          body,
        }
        @types.Syntax::LetRec(fundef, @types.Syntax::Unit)
      }
      // (_,body)=>{
      //   let params=[]
      //   let fundef :@types.Fundef={name:("main",@types.Type::Unit), args:params, body:body}
      //   @types.Syntax::LetRec(fundef, @types.Syntax::Unit)
      // }
    },
  )
  .parse(tokens)
}

fn fn_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(
    fn {
      Fn => {
        parser_context.is_main = false
        let curent_token_number = parser_context.token_length - tokens.length()
        // println("FN curent_token_number: \{curent_token_number}")
        let { column_start, .. } : @lex.TokenPosition = @lex.token_postion_array[curent_token_number]
        // println("FN column_start: \{column_start}")
        if parser_context.is_top_level {
          if column_start == 1 {
            true
          } else {
            // println("顶级未左对齐")
            false
          }
        } else {
          true
        }
      }
      _ =>
        // println("not fn")
        false
    },
  )
  .and(
    ptoken(
      fn {
        Fun_name(_) =>
          // println("fun_name: \{parser_context}")
          true
        _ => false
      },
    ).map(
      fn {
        Fun_name(fun_name) => fun_name // 中间解析,可以简化最终解析
        _ => @util.die("missing_fun_name")
      },
    ),
  )
  .and(lparen)
  .and(
    // 解析参数列表，可以是空或一个或多个参数 todo：一个可选参数（可选类型）、many（一个必选逗号+一个参数（可选类型））、一个可选逗号。
    ptoken(
      fn {
        Identifier(_) => true
        _ => false
      },
    )
    .map(
      fn {
        Identifier(arg_name) => arg_name
        _ => "missing_arg_name"
      },
    )
    .and(colon_skip.and(parse_type_skip))
    // .and(ptoken_skip2(colon,parse_type))
    // 获得参数名和参数类型
    .map(fn { (arg_name, (_, arg_type)) => (arg_name, arg_type) }) // 参数类型,中间解析,可以简化最终解析
    .and(comma_skip)
    // .map(fn { (param, _) => param })
    .many()
    .and(rparen),
  )
  .and(
    // 可以缺省一次，必须一起跳过，此处存在bug，可以构造ptoken_skip2,内支持两个断言函数
    ptoken_skip(
      fn {
        Arrow => true
        _ => false
      },
    )
    .and(
      colon_skip.and(parse_type_skip), // todo typecheck
    )
    .map(
      fn {
        // 获得返回类型
        (_, (_, return_type)) => return_type
      },
    ),
  )
  .and(block) // 解析函数体
  .and(semicolon)
  .map(
    fn {
      // ((((_,fun_name), ((_,array_params),_)),ty), body)
      ((((((_, fun_name), _), (array_params, _)), return_type), body), _) => {
        let params = []
        for param in array_params {
          params.push(param.0)
        }
        // body[0]
        let fundef : @types.Fundef = {
          name: (fun_name, return_type),
          args: params,
          body,
        }
        @types.Syntax::LetRec(fundef, @types.Syntax::Unit)
      }
    },
  )
  .parse(tokens)
}

fn call_fn_stmt(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  // 调用函数暂且支持单参数或无参数
  ptoken(
    fn {
      Fun_name(_) => true
      _ => false
    },
  )
  .map(
    fn {
      Fun_name(fun_name) => @types.Syntax::Var(fun_name) // 中间解析,可以简化最终解析; Letrec
      _ => @util.die("missing_fun_name")
    },
  )
  .and(lparen)
  .and(
    // var.many()
    statement().many(),
    // .and(comma).many()
  )
  .and(rparen)
  .map(
    fn {
      (((fun_name, _), array_params), _) =>
        // println("test")
        @types.Syntax::App(fun_name, array_params)
    },
  )
  .parse(tokens)
}
