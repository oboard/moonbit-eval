///|
fn fn_main_statement(
  tokens : ArrayView[@lex.Token],
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(x => match x {
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
          @util.die_with_error(@util.ErrorType::MissingAlignment)
        }
      } else {
        true
      }
    }
    _ => false
  })
  .andBind(
    ptoken(x => match x {
      Main => {
        // println("main function")
        parser_context.is_main = true
        true
      }
      _ => false
    }).map(_ => "main"),
  )
  .andBind(block) // 解析函数体
  .andBind(semicolon)
  .map(x => match x {
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
  })
  .parse(tokens)
}

///|
fn fn_statement(
  tokens : ArrayView[@lex.Token],
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(x => match x {
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
  })
  .andBind(
    ptoken(x => match x {
      Fun_name(_) =>
        // println("fun_name: \{parser_context}")
        true
      _ => false
    }).map(x => match x {
      Fun_name(fun_name) => fun_name // 中间解析,可以简化最终解析
      _ => @util.function_name_error()
    }),
  )
  .andBind(lparen)
  .andBind(
    // 解析参数列表，可以是空或一个或多个参数 todo：一个可选参数（可选类型）、many（一个必选逗号+一个参数（可选类型））、一个可选逗号。
    ptoken(x => match x {
      Identifier(_) => true
      _ => false
    })
    .map(x => match x {
      Identifier(arg_name) => arg_name
      _ => "missing_arg_name"
    })
    .andBind(colon_skip.andBind(parse_type_skip))
    // .andBind(ptoken_skip2(colon,parse_type))
    // 获得参数名和参数类型
    .map(x => match x {
      (arg_name, (_, arg_type)) => (arg_name, arg_type)
    }) // 参数类型,中间解析,可以简化最终解析
    .andBind(comma_skip)
    // .map(fn { (param, _) => param })
    .many()
    .andBind(rparen),
  )
  .andBind(
    // 可以缺省一次，必须一起跳过，此处存在bug，可以构造ptoken_skip2,内支持两个断言函数
    ptoken_skip(x => match x {
      Arrow => true
      _ => false
    })
    .andBind(
      colon_skip.andBind(parse_type_skip), // todo typecheck
    )
    .map(x => match x {
      // 获得返回类型
      (_, (_, return_type)) => return_type
    }),
  )
  .andBind(block) // 解析函数体
  // .andBind(semicolon)
  .map(x => match x {
    // ((((_,fun_name), ((_,array_params),_)),ty), body)
    (((((_, fun_name), _), (array_params, _)), return_type), body) => {
      let params = array_params.map(fn(param) { param.0 })
      // body[0]
      let fundef : @types.Fundef = {
        name: (fun_name, return_type),
        args: params,
        body,
      }
      @types.Syntax::LetRec(fundef, @types.Syntax::Unit)
    }
  })
  .parse(tokens)
}

///|
fn call_fn_stmt(
  tokens : ArrayView[@lex.Token],
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  // 调用函数暂且支持单参数或无参数
  ptoken(x => match x {
    Fun_name(_) => true
    _ => false
  })
  .map(x => match x {
    Fun_name(fun_name) => @types.Syntax::Var(fun_name) // 中间解析,可以简化最终解析; Letrec
    _ => @util.function_name_error()
  })
  .andBind(lparen)
  .andBind(
    // Parse function arguments as expressions separated by commas
    Parser(expression)
    .andBind(comma_skip)
    .many()
    .map(fn(args) { args.map(fn(arg) { arg.0 }) })
    .or(Parser(expression).map(fn(arg) { [arg] }))
    .or(Parser(fn(_) { Some(([], tokens)) })), // Handle empty parameter list
  )
  .andBind(rparen)
  .map(x => match x {
    (((fun_name, _), array_params), _) =>
      @types.Syntax::App(fun_name, array_params)
  })
  .parse(tokens)
}
