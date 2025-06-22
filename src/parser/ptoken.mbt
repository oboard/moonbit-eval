// 返回一个词法单元解析器函数

///|
fn ptoken(predicate : (@lex.Token) -> Bool) -> Parser[@lex.Token] {
  // 必须要有
  // 直接返回一个函数作为Parser[@lex.Token]
  x => match x { // 省略参数
    [hd, .. tl] =>
      if hd == @lex.Token::Skip {
        if predicate(tl[0]) {
          Some((tl[0], tl[1:]))
        } else {
          None
        }
      } else if predicate(hd) {
        Some((hd, tl))
      } else {
        None
      }
    [] => None
  }
}

///|
fn ptoken_skip(predicate : (@lex.Token) -> Bool) -> Parser[@lex.Token] {
  // 可有可无
  // 直接返回一个函数作为Parser[@lex.Token];跳过失败，并不消耗token
  x => match x { // 省略参数
    [hd, .. tl] as all =>
      if predicate(hd) {
        Some((hd, tl))
      } else {
        // println("ptoken_skip \{all}")
        // None
        Some((@lex.Token::Skip, all))
      }
    [] => None
  }
}

// fn ptoken_skip2(predicate_first : (@lex.Token) -> Bool, predicate_second: (@lex.Token) -> Bool) -> Parser[@lex.Token] {
//   // 可有可无
//   // 直接返回一个函数作为Parser[@lex.Token];跳过失败，并不消耗token
//   fn {  // 省略参数
//     [first,second, .. as tl] as all=> {
//       if predicate_first(first) && predicate_second(second) {
//         Some((first, tl)) 
//       } else {
//         // println("ptoken_skip \{all}")
//         // None
//         Some((@lex.Token::Skip,all))
//       }
//     }
//     _ => None
//   }
// }

// fn ptoken_not(predicate : (@lex.Token) -> Bool) -> Parser[@lex.Token] {
//   // 必须要无
//   // 直接返回一个函数作为Parser[@lex.Token];
//   // println("进入了ptoken not")
//   fn {  // 省略参数
//     [hd, .. as tl] as all=> {
//       if predicate(hd) {
//         // println("test test00")
//         None
//       } else {
//         // println("ptoken_skip \{all}")
//         // None
//         // println("test test11")
//         Some((@lex.Token::Skip,all))
//         // Some((@lex.Token::Arrow,tl))
//       }
//     }
//     [] => {
//       // println("test test")
//       None
//     }
//   }
// }
