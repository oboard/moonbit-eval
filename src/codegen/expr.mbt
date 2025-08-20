// ///|
// // fn dummy_loc() -> @basic.Location {
// //   {
// //     start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
// //     end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
// //   }
// // }

// ///|
// fn expr_codegen(expr : @syntax.Expr) -> String {
//   fn position_codegen(pos : @basic.Position) -> String {
//     let fname = pos.fname
//     let lnum = pos.lnum
//     let bol = pos.bol
//     let cnum = pos.cnum
//     "@basic.Position::{fname: \"\{fname}\", lnum: \{lnum}, bol: \{bol}, cnum: \{cnum}}"
//   }

//   fn loc_codegen(loc : @basic.Location) -> String {
//     let start = position_codegen(loc.start)
//     let end = position_codegen(loc.end)
//     "@basic.Location::{start: \{start}, end: \{end}}"
//   }

//   fn attr_codegen(attr : @syntax.ApplyAttr) -> String {
//     match attr {
//       NoAttr => "NoAttr"
//       Exclamation => "Exclamation"
//       Question => "Question"
//     }
//   }

//   fn label_codegen(label : @syntax.Label) -> String {
//     "@syntax.Label::{name: \{label.name}, loc: \{loc_codegen(label.loc)}}"
//   }

//   fn argument_kind_codegen(kind : @syntax.ArgumentKind) -> String {
//     match kind {
//       Positional => "Positional"
//       Labelled(label) => "Labelled(label=\{label_codegen(label)})"
//       LabelledPun(label) => "LabelledPun(label=\{label_codegen(label)})"
//       LabelledOption(label~, question_loc~) =>
//         "LabelledOption(label=\{label_codegen(label)}, question_loc=\{loc_codegen(question_loc)})"
//       LabelledOptionPun(label~, question_loc~) =>
//         "LabelledOptionPun(label=\{label_codegen(label)}, question_loc=\{loc_codegen(question_loc)})"
//     }
//   }

//   fn argument_codegen(arg : @syntax.Argument) -> String {
//     let value = expr_codegen(arg.value)
//     let kind = argument_kind_codegen(arg.kind)
//     "Argument(\{value}, \{kind})"
//   }

//   fn long_ident_codegen(ident : @syntax.LongIdent) -> String {
//     match ident {
//       Ident(name~) => "Ident(name=\"\{name}\")"
//       Dot(pkg~, id~) => "Dot(pkg=\"\{pkg}\", id=\"\{id}\")"
//     }
//   }

//   fn var_codegen(v : @syntax.Var) -> String {
//     "@syntax.Var{name: \{long_ident_codegen(v.name)}, loc:\{loc_codegen(v.loc)})"
//   }

//   fn binder_codegen(binder : @syntax.Binder) -> String {
//     "Binder(\{binder.name}, \{loc_codegen(binder.loc)})"
//   }

//   fn dot_dot_binder_codegen(binder : @syntax.DotDotBinder) -> String {
//     match binder {
//       Underscore => "_"
//       NoBinder => ""
//       BinderAs(b) => "as \{binder_codegen(b)}"
//       Binder(b) => binder_codegen(b)
//     }
//   }

//   fn array_pattern_codegen(pat : @syntax.ArrayPattern) -> String {
//     match pat {
//       Pattern(p) => pattern_codegen(p)
//       StringSpread(s) => "StringSpread(\{s})"
//       BytesSpread(b) => "BytesSpread(\{b})"
//       ConstSpread(binder~, pkg~, loc~) => {
//         let binder = binder_codegen(binder)
//         let pkg = if pkg is Some(pkg) { Some(pkg) } else { None }
//         let loc = loc_codegen(loc)
//         "ConstSpread(binder=\{binder}, pkg=\{pkg}, loc=\{loc})"
//       }
//     }
//   }

//   fn list_codegen(list : @list.List[String]) -> String {
//     list
//     .map(item => "\{item}")
//     .fold(init="@list.of([", fn(acc, item) { "\{acc}, \{item}" }) +
//     "])"
//   }

//   fn array_patterns_codegen(pats : @syntax.ArrayPatterns) -> String {
//     match pats {
//       Closed(patterns) =>
//         list_codegen(patterns.map(pat => array_pattern_codegen(pat)))
//       Open(before, after, binder) => {
//         let before_str = before.map(pat => array_pattern_codegen(pat))
//           |> list_codegen
//         let after_str = list_codegen(
//           after.map(pat => array_pattern_codegen(pat)),
//         )
//         let binder_str = dot_dot_binder_codegen(binder)
//         if before.is_empty() && after.is_empty() {
//           "..\{binder_str}"
//         } else if before.is_empty() {
//           "..\{binder_str}, \{after_str}"
//         } else if after.is_empty() {
//           "\{before_str}, ..\{binder_str}"
//         } else {
//           "\{before_str}, ..\{binder_str}, \{after_str}"
//         }
//       }
//     }
//   }

//   fn field_pat_codegen(field : @syntax.FieldPat) -> String {
//     let label = label_codegen(field.label)
//     let pattern = pattern_codegen(field.pattern)
//     let is_pun = field.is_pun
//     let loc = loc_codegen(field.loc)
//     "@syntax.FieldPat::{label:\{label}, pattern:\{pattern}, is_pun:\{is_pun}, loc:\{loc}}"
//   }

//   fn constr_pat_arg_codegen(arg : @syntax.ConstrPatArg) -> String {
//     let pat = pattern_codegen(arg.pat)
//     let kind = argument_kind_codegen(arg.kind)
//     "@syntax.ConstrPatArg::{pat:\{pat}, kind:\{kind}}"
//   }

//   fn error_type_codegen(err : @syntax.ErrorType) -> String {
//     match err {
//       ErrorType(ty~) => {
//         let ty = type_codegen(ty)
//         "ErrorType(\{ty})"
//       }
//       DefaultErrorType(loc~) => {
//         let loc = loc_codegen(loc)
//         "DefaultErrorType(\{loc})"
//       }
//       NoErrorType => "NoErrorType"
//       Noraise(loc~) => {
//         let loc = loc_codegen(loc)
//         "Noraise(\{loc})"
//       }
//       MaybeError(ty~) => {
//         let ty = type_codegen(ty)
//         "MaybeError(\{ty})"
//       }
//     }
//   }

//   fn constructor_id_codegen(constr_id : @syntax.ConstrId) -> String {
//     let id = long_ident_codegen(constr_id.id)
//     let loc = loc_codegen(constr_id.loc)
//     "@syntax.ConstrId::{id:\{id}, loc:\{loc}}"
//   }

//   fn type_codegen(ty : @syntax.Type) -> String {
//     match ty {
//       Any(loc~) => {
//         let loc = loc_codegen(loc)
//         "Any(\{loc})"
//       }
//       Arrow(args~, res~, err~, is_async~, loc~) => {
//         let args = args.map(arg => type_codegen(arg))
//         let res = type_codegen(res)
//         let err = error_type_codegen(err)
//         let loc = loc_codegen(loc)
//         "Arrow(\{args}, \{res}, \{err}, \{is_async}, \{loc})"
//       }
//       Tuple(tys~, loc~) => {
//         let tys = tys.map(ty => type_codegen(ty))
//         let loc = loc_codegen(loc)
//         "Tuple(\{tys}, \{loc})"
//       }
//       Name(constr_id~, tys~, loc~) => {
//         let constr_id = constructor_id_codegen(constr_id)
//         let tys = tys.map(ty => type_codegen(ty))
//         let loc = loc_codegen(loc)
//         "Name(\{constr_id}, \{tys}, \{loc})"
//       }
//       Option(ty~, loc~, question_loc~) => {
//         let ty = type_codegen(ty)
//         let loc = loc_codegen(loc)
//         let question_loc = loc_codegen(question_loc)
//         "Option(\{ty}, \{loc}, \{question_loc})"
//       }
//       Object(constr_id) => {
//         let constr_id = constructor_id_codegen(constr_id)
//         "Object(\{constr_id})"
//       }
//     }
//   }

//   fn constant_codegen(constant : @syntax.Constant) -> String {
//     match constant {
//       Bool(b) => "Bool(\{b})"
//       Byte(b) => "Byte(\{b})"
//       Bytes(b) => "Bytes(\{b})"
//       Char(c) => "Char(\{c})"
//       Int(i) => "Int(\{i})"
//       Int64(i) => "Int64(\{i})"
//       UInt(u) => "UInt(\{u})"
//       UInt64(u) => "UInt64(\{u})"
//       Float(f) => "Float(\{f})"
//       Double(d) => "Double(\{d})"
//       String(s) => "String(\{s})"
//       BigInt(b) => "BigInt(\{b})"
//     }
//   }

//   fn map_pat_elem_codegen(elem : @syntax.MapPatElem) -> String {
//     let key = constant_codegen(elem.key)
//     let pat = pattern_codegen(elem.pat)
//     let match_absent = elem.match_absent
//     let key_loc = loc_codegen(elem.key_loc)
//     let loc = loc_codegen(elem.loc)
//     "@syntax.MapPatElem::{key:\{key}, pat:\{pat}, match_absent:\{match_absent}, key_loc:\{key_loc}, loc:\{loc}}"
//   }

//   fn constr_name_codegen(name : @syntax.ConstrName) -> String {
//     "@syntax.ConstrName::{name:\{name.name}, loc:\{loc_codegen(name.loc)}}"
//   }

//   fn type_name_codegen(ty_name : @syntax.TypeName) -> String {
//     let name = long_ident_codegen(ty_name.name)
//     let is_object = ty_name.is_object.to_string()
//     let loc = loc_codegen(ty_name.loc)
//     "@syntax.TypeName::{name:\{name}, is_object:\{is_object}, loc:\{loc}}"
//   }

//   fn constructor_extra_info_codegen(
//     info : @syntax.ConstructorExtraInfo,
//   ) -> String {
//     match info {
//       TypeName(name) => "TypeName(\{type_name_codegen(name)})"
//       Package(pkg) => "Package(\{pkg})"
//       NoExtraInfo => "NoExtraInfo"
//     }
//   }

//   fn constructor_codegen(constr : @syntax.Constructor) -> String {
//     let name = constr_name_codegen(constr.name)
//     let extra_info = constructor_extra_info_codegen(constr.extra_info)
//     let loc = loc_codegen(constr.loc)
//     "@syntax.Constructor::{name:\{name}, extra_info:\{extra_info}, loc:\{loc}}"
//   }

//   fn fn_kind_codegen(kind : @syntax.FnKind) -> String {
//     match kind {
//       Lambda => "Lambda"
//       Matrix => "Matrix"
//       Arrow => "Arrow"
//     }
//   }

//   fn multi_arg_case_codegen(case : @syntax.MultiArgCase) -> String {
//     let patterns = case.patterns.map(pat => pattern_codegen(pat))
//     let guard_ = if case.guard_ is Some(guard_) {
//       Some(expr_codegen(guard_))
//     } else {
//       None
//     }
//     let body = expr_codegen(case.body)
//     "MultiArgCase(patterns=\{patterns}, guard_=\{guard_}, body=\{body})"
//   }

//   fn parameter_codegen(param : @syntax.Parameter) -> String {
//     match param {
//       DiscardPositional(ty~, loc~) => {
//         let ty = if ty is Some(ty) { Some(type_codegen(ty)) } else { None }
//         let loc = loc_codegen(loc)
//         "DiscardPositional(ty=\{ty}, loc=\{loc})"
//       }
//       Positional(binder~, ty~) => {
//         let binder = binder_codegen(binder)
//         let ty = if ty is Some(ty) { Some(type_codegen(ty)) } else { None }
//         "Positional(binder=\{binder}, ty=\{ty})"
//       }
//       Labelled(binder~, ty~) => {
//         let binder = binder_codegen(binder)
//         let ty = if ty is Some(ty) { Some(type_codegen(ty)) } else { None }
//         "Labelled(binder=\{binder}, ty=\{ty})"
//       }
//       Optional(binder~, default~, ty~) => {
//         let binder = binder_codegen(binder)
//         let default = expr_codegen(default)
//         let ty = if ty is Some(ty) { Some(type_codegen(ty)) } else { None }
//         "Optional(binder=\{binder}, default=\{default}, ty=\{ty})"
//       }
//       QuestionOptional(binder~, ty~) => {
//         let binder = binder_codegen(binder)
//         let ty = if ty is Some(ty) { Some(type_codegen(ty)) } else { None }
//         "QuestionOptional(binder=\{binder}, ty=\{ty})"
//       }
//     }
//   }

//   fn parameters_codegen(params : @list.List[@syntax.Parameter]) -> String {
//     params
//     .map(param => parameter_codegen(param))
//     .fold(init="@list.of([", fn(acc, param) { "\{acc}, \{param}" }) +
//     "])"
//   }

//   fn func_codegen(func : @syntax.Func) -> String {
//     match func {
//       Lambda(
//         parameters~,
//         params_loc~,
//         body~,
//         return_type~,
//         error_type~,
//         kind~,
//         has_error~,
//         is_async~,
//         loc~
//       ) => {
//         let parameters = parameters_codegen(parameters)
//         let params_loc = loc_codegen(params_loc)
//         let body = expr_codegen(body)
//         let return_type = if return_type is Some(ty) {
//           Some(type_codegen(ty))
//         } else {
//           None
//         }
//         let error_type = error_type_codegen(error_type)
//         let kind = fn_kind_codegen(kind)
//         let has_error = if has_error is Some(loc) {
//           Some(loc_codegen(loc))
//         } else {
//           None
//         }
//         let loc = loc_codegen(loc)
//         "Lambda(parameters=\{parameters}, params_loc=\{params_loc}, body=\{body}, return_type=\{return_type}, error_type=\{error_type}, kind=\{kind}, has_error=\{has_error}, is_async=\{is_async}, loc=\{loc})"
//       }
//       Match(cases~, has_error~, is_async~, fn_loc~, loc~) => {
//         let cases = cases.map(case => multi_arg_case_codegen(case))
//         let has_error = if has_error is Some(loc) {
//           Some(loc_codegen(loc))
//         } else {
//           None
//         }
//         let fn_loc = loc_codegen(fn_loc)
//         let loc = loc_codegen(loc)
//         "Match(cases=\{cases}, has_error=\{has_error}, is_async=\{is_async}, fn_loc=\{fn_loc}, loc=\{loc})"
//       }
//     }
//   }

//   fn pattern_codegen(pattern : @syntax.Pattern) -> String {
//     match pattern {
//       Alias(pat~, alias_~, loc~) => {
//         let pat = pattern_codegen(pat)
//         let alias_ = binder_codegen(alias_)
//         let loc = loc_codegen(loc)
//         "Alias(pat=\{pat}, alias_=\{alias_}, loc=\{loc})"
//       }
//       Any(loc~) => {
//         let loc = loc_codegen(loc)
//         "Any(loc=\{loc})"
//       }
//       Array(pats~, loc~) => {
//         let pats = array_patterns_codegen(pats)
//         let loc = loc_codegen(loc)
//         "Array(pats=\{pats}, loc=\{loc})"
//       }
//       Constant(c~, loc~) => {
//         let c = constant_codegen(c)
//         let loc = loc_codegen(loc)
//         "Constant(c=\{c}, loc=\{loc})"
//       }
//       Constraint(pat~, ty~, loc~) => {
//         let pat = pattern_codegen(pat)
//         let ty = type_codegen(ty)
//         let loc = loc_codegen(loc)
//         "Constraint(pat=\{pat}, ty=\{ty}, loc=\{loc})"
//       }
//       Constr(constr~, args~, is_open~, loc~) => {
//         let constr = constructor_codegen(constr)
//         let args = if args is Some(args) {
//           Some(args.map(arg => constr_pat_arg_codegen(arg)))
//         } else {
//           None
//         }
//         let loc = loc_codegen(loc)
//         "Constr(constr=\{constr}, args=\{args}, is_open=\{is_open}, loc=\{loc})"
//       }
//       Or(pat1~, pat2~, loc~) => {
//         let pat1 = pattern_codegen(pat1)
//         let pat2 = pattern_codegen(pat2)
//         let loc = loc_codegen(loc)
//         "Or(pat1=\{pat1}, pat2=\{pat2}, loc=\{loc})"
//       }
//       Tuple(pats~, loc~) => {
//         let pats = pats.map(pat => pattern_codegen(pat))
//         let loc = loc_codegen(loc)
//         "Tuple(pats=\{pats}, loc=\{loc})"
//       }
//       Var(binder) => "Var(\{binder_codegen(binder)})"
//       Record(fields~, is_closed~, loc~) => {
//         let fields = fields.map(field => field_pat_codegen(field))
//         let loc = loc_codegen(loc)
//         "Record(fields=\{fields}, is_closed=\{is_closed}, loc=\{loc})"
//       }
//       Map(elems~, is_closed~, loc~) => {
//         let elems = elems.map(elem => map_pat_elem_codegen(elem))
//         let loc = loc_codegen(loc)
//         "Map(elems=\{elems}, is_closed=\{is_closed}, loc=\{loc})"
//       }
//       Range(lhs~, rhs~, inclusive~, loc~) => {
//         let lhs = pattern_codegen(lhs)
//         let rhs = pattern_codegen(rhs)
//         let loc = loc_codegen(loc)
//         "Range(lhs=\{lhs}, rhs=\{rhs}, inclusive=\{inclusive}, loc=\{loc})"
//       }
//     }
//   }

//   match expr {
//     Apply(func~, args~, attr~, loc~) => {
//       let func = expr_codegen(func)
//       let args = args.map(arg => argument_codegen(arg))
//       let attr = attr_codegen(attr)
//       let loc = loc_codegen(loc)
//       "Apply(func=\{func}, args=\{args}, attr=\{attr}, loc=\{loc})"
//     }
//     // /// e1 + e2
//     Infix(op~, lhs~, rhs~, loc~) => {
//       let op = var_codegen(op)
//       let lhs = expr_codegen(lhs)
//       let rhs = expr_codegen(rhs)
//       let loc = loc_codegen(loc)
//       "Infix(op=\{op}, lhs=\{lhs}, rhs=\{rhs}, loc=\{loc})"
//     }
//     If(cond~, ifso~, ifnot~, loc~) => {
//       let cond = expr_codegen(cond)
//       let ifso = expr_codegen(ifso)
//       let loc = loc_codegen(loc)
//       match ifnot {
//         Some(ifnot_expr) => {
//           let ifnot = expr_codegen(ifnot_expr)
//           "If(cond=\{cond}, ifso=\{ifso}, ifnot=\{ifnot}, loc=\{loc})"
//         }
//         None => "If(cond=\{cond}, ifso=\{ifso}, loc=\{loc})"
//       }
//     }
//     Let(pattern~, expr~, body~, loc~) => {
//       let pattern = pattern_codegen(pattern)
//       let expr = expr_codegen(expr)
//       let body = expr_codegen(body)
//       let loc = loc_codegen(loc)
//       "Let(pattern=\{pattern}, expr=\{expr}, body=\{body}, loc=\{loc})"
//     }
//     // /// `fn(args){ expr }` or `(args) => expr`
//     Function(func~, loc~) => {
//       let func = func_codegen(func)
//       let loc = loc_codegen(loc)
//       "Function(func=\{func}, loc=\{loc})"
//     }
//     // /// -e
//     // Unary(op~ : Var, expr~ : Expr, loc~ : Location)
//     // /// [e1, e2, e3]
//     // Array(exprs~ : @list.List[Expr], loc~ : Location)
//     // /// [..arr1, e1, ..arr2, e2]
//     // ArraySpread(elems~ : @list.List[SpreadableElem], loc~ : Location)
//     // /// e1[e2]
//     // ArrayGet(array~ : Expr, index~ : Expr, loc~ : Location)
//     // /// e1[e2:e3]
//     // ArrayGetSlice(
//     //   array~ : Expr,
//     //   start_index~ : Expr?,
//     //   end_index~ : Expr?,
//     //   index_loc~ : Location,
//     //   loc~ : Location
//     // )
//     // /// e1[i] = e2
//     // ArraySet(array~ : Expr, index~ : Expr, value~ : Expr, loc~ : Location)
//     // /// e1[i] += e2
//     // ArrayAugmentedSet(
//     //   op~ : Var,
//     //   array~ : Expr,
//     //   index~ : Expr,
//     //   value~ : Expr,
//     //   loc~ : Location
//     // )
//     // Constant(c~ : Constant, loc~ : Location)
//     // /// ```skip
//     // /// #| multiline
//     // /// #| string
//     // /// ```
//     // MultilineString(elems~ : @list.List[MultilineStringElem], loc~ : Location)
//     // /// `"text \{e1}"`
//     // Interp(elems~ : @list.List[InterpElem], loc~ : Location)
//     // /// `(expr : Type)`
//     // Constraint(expr~ : Expr, ty~ : Type, loc~ : Location)
//     // /// `Constructor(e1, e2, e3)`
//     // Constr(constr~ : Constructor, loc~ : Location)
//     // /// `while e1 { e2 } else { e3 }`
//     // While(
//     //   loop_cond~ : Expr,
//     //   loop_body~ : Expr,
//     //   while_else~ : Expr?,
//     //   label~ : Label?,
//     //   loc~ : Location
//     // )
//     // /// `id`
//     // Ident(id~ : Var, loc~ : Location)
//     // /// `if e1 { e2 } else { e3 }`
//     // If(cond~ : Expr, ifso~ : Expr, ifnot~ : Expr?, loc~ : Location)
//     // /// `guard e1 else {e2}; e3`
//     // Guard(cond~ : Expr, otherwise~ : Expr?, body~ : Expr, loc~ : Location)
//     // /// `expr is pattern`
//     // Is(expr~ : Expr, pat~ : Pattern, loc~ : Location)
//     // /// `defer e1; e2`
//     // Defer(expr~ : Expr, body~ : Expr, loc~ : Location)
//     // /// `fn local(args){ e1 }; e2`
//     // LetFn(name~ : Binder, func~ : Func, body~ : Expr, loc~ : Location)
//     // /// `fn f(args){ e1 }; fn g(args){ e2 }; e3`, 
//     // /// where `f` and `g` are mutually recursive functions.
//     // LetRec(bindings~ : @list.List[(Binder, Func)], body~ : Expr, loc~ : Location)
//     // LetAnd(
//     //   bindings~ : @list.List[(Binder, Type?, Func)],
//     //   body~ : Expr,
//     //   loc~ : Location
//     // )
//     // /// `let pattern = e1; e2`
//     // /// `e1; e2`
//     // Sequence(exprs~ : @list.List[Expr], last_expr~ : Expr, loc~ : Location)
//     // /// `(e1, e2, e3)`
//     // Tuple(exprs~ : @list.List[Expr], loc~ : Location)
//     // /// `TypeName::{ field1: e1, field2: e2 }`
//     // /// The `trailing` field is used to determine whether the source has a trailing separator.
//     // /// If the trailing separator is SEMI, the AST is invalid.
//     // Record(
//     //   type_name~ : TypeName?,
//     //   fields~ : @list.List[FieldDef],
//     //   trailing~ : TrailingMark,
//     //   loc~ : Location
//     // )
//     // /// `{ ..record, field1: expr, field2: expr }`
//     // RecordUpdate(
//     //   type_name~ : TypeName?,
//     //   record~ : Expr,
//     //   fields~ : @list.List[FieldDef],
//     //   loc~ : Location
//     // )
//     // /// `record.field`
//     // Field(record~ : Expr, accessor~ : Accessor, loc~ : Location)
//     // /// `TypeName::method`
//     // Method(type_name~ : TypeName, method_name~ : Label, loc~ : Location)
//     // /// `self.method(args)`
//     // DotApply(
//     //   self~ : Expr,
//     //   method_name~ : Label,
//     //   args~ : @list.List[Argument],
//     //   return_self~ : Bool,
//     //   attr~ : ApplyAttr,
//     //   loc~ : Location
//     // )
//     // /// `expr as Trait`
//     // As(expr~ : Expr, trait_~ : TypeName, loc~ : Location)
//     // /// `record.field = expr`
//     // Mutate(
//     //   record~ : Expr,
//     //   accessor~ : Accessor,
//     //   field~ : Expr,
//     //   augmented_by~ : Var?,
//     //   loc~ : Location
//     // )
//     // /// `match e0 { p1 => e1; p2 => e2 }`
//     // Match(
//     //   expr~ : Expr,
//     //   cases~ : @list.List[Case],
//     //   match_loc~ : Location,
//     //   using_~ : Label?,
//     //   loc~ : Location
//     // )
//     // /// `let mut binder : Type = expr`
//     // LetMut(
//     //   binder~ : Binder,
//     //   ty~ : Type?,
//     //   expr~ : Expr,
//     //   body~ : Expr,
//     //   loc~ : Location
//     // )
//     // /// `lhs |> rhs`
//     // /// The rhs is restricted to `f`, `f(args)`, `_.method(args)`, `Constructor`, or `Constructor(args)`.
//     // Pipe(lhs~ : Expr, rhs~ : Expr, loc~ : Location)
//     // /// `n = e` or `n += e`
//     // Assign(var_~ : Var, expr~ : Expr, augmented_by~ : Var?, loc~ : Location)
//     // /// `_`
//     // /// This expression is only allowed in partial application.
//     // Hole(loc~ : Location, kind~ : Hole)
//     // /// `return expr`
//     // Return(return_value~ : Expr?, loc~ : Location)
//     // /// `raise expr`
//     // Raise(err_value~ : Expr, loc~ : Location)
//     // /// `()`
//     // /// If `faked` is true, it means it was inserted by the parser.
//     // Unit(loc~ : Location, faked~ : Bool)
//     // /// `break expr`
//     // Break(arg~ : Expr?, label~ : Label?, loc~ : Location)
//     // /// `continue e1, e2, e3`
//     // Continue(args~ : @list.List[Expr], label~ : Label?, loc~ : Location)
//     // /// `loop args { ps1 => e1; ps2 => e2 }`
//     // Loop(
//     //   args~ : @list.List[Expr],
//     //   body~ : @list.List[MultiArgCase],
//     //   label~ : Label?,
//     //   loop_loc~ : Location,
//     //   loc~ : Location
//     // )
//     // /// `for binders; condition; continue_block { body } else { expr }`
//     // For(
//     //   binders~ : @list.List[(Binder, Expr)],
//     //   condition~ : Expr?,
//     //   continue_block~ : @list.List[(Binder, Expr)],
//     //   body~ : Expr,
//     //   for_else~ : Expr?,
//     //   label~ : Label?,
//     //   loc~ : Location
//     // )
//     // /// `for b1,b2 in e1 { e2 }`
//     // ForEach(
//     //   binders~ : @list.List[Binder?],
//     //   expr~ : Expr,
//     //   body~ : Expr,
//     //   else_block~ : Expr?,
//     //   label~ : Label?,
//     //   loc~ : Location
//     // )
//     // /// `try e0 catch { p1 => e1 } noraise { p2 => e2 }` or `e0 catch { p1 => e1 }`
//     // Try(
//     //   body~ : Expr,
//     //   catch_~ : @list.List[Case],
//     //   catch_all~ : Bool,
//     //   try_else~ : @list.List[Case]?,
//     //   has_try~ : Bool,
//     //   try_loc~ : Location,
//     //   catch_loc~ : Location,
//     //   else_loc~ : Location,
//     //   loc~ : Location
//     // )
//     // /// `try! expr` or `try? expr`
//     // TryOperator(
//     //   body~ : Expr,
//     //   kind~ : TryOperatorKind,
//     //   try_loc~ : Location,
//     //   loc~ : Location
//     // )
//     // /// `{ k1: e1, k2: e2 }`
//     // Map(elems~ : @list.List[MapExprElem], loc~ : Location)
//     // /// `(expr)` or `{expr}`
//     // Group(expr~ : Expr, group~ : Group, loc~ : Location)
//     // /// generated by compiler
//     // StaticAssert(asserts~ : @list.List[StaticAssertion], body~ : Expr)
//     _ => ""
//   }
// }

///|
fn parse_code_to_expr(
  code : String,
  top : Bool,
) -> Result[@syntax.Expr, String] {
  let buf = @buffer.new()
  @encoding.encode_to(
    if top {
      code
    } else {
      "fn init {\n\{code}\n}"
    },
    buf,
    encoding=UTF8,
  )
  let (impls, diagnostics) = @moonbitlang/parser.parse_bytes(
    buf.to_bytes(),
    parser=Handrolled,
  )
  if top {
    // For top-level evaluation, we don't extract a single expression
    return Err("Top-level parsing not supported in parse_code_to_expr")
  }
  match impls {
    @list.List::More(
      @syntax.Impl::TopFuncDef(fun_decl=_, decl_body~, loc=_),
      tail=@list.List::Empty
    ) =>
      match decl_body {
        @syntax.DeclBody::DeclBody(local_types=_, expr~) => Ok(expr)
        _ => Err("Invalid function declaration body")
      }
    _ => Err(diagnostics.fold(init="", (acc, cur) => "\{acc}\n\{cur}"))
  }
}

///|
fn expr_codegen(json : Json) -> String {
  match json {
    { "type": String(ty), .. } =>
      if json.as_object() is Some(obj) {
        let mut args = ""
        for k, v in obj {
          if k == "type" {
            continue
          }
          args = if k == "loc" {
            "\{args}\{k}=dummy_loc(), "
          } else if k == "0" {
            "\{args}\{expr_codegen(v)}, "
          } else {
            "\{args}\{k}=\{expr_codegen(v)}, "
          }
        }
        "@syntax.\{ty}(\{args})"
      } else {
        "@syntax.\{ty}()"
      }
    _ => json.stringify()
  }
}

///|
test {
  let code =
    #|  if self < 0 {
    #|    -self
    #|  } else {
    #|    self
    #|  }
  let expr = parse_code_to_expr(code, false)
  if expr is Ok(expr) {
    inspect(
      expr.to_json().stringify(),
      content=(
        #|{"type":"Expr::If","cond":{"type":"Expr::Infix","op":{"type":"Var","name":{"type":"LongIdent::Ident","0":"<"},"loc":null},"lhs":{"type":"Expr::Ident","id":{"type":"Var","name":{"type":"LongIdent::Ident","0":"self"},"loc":null},"loc":null},"rhs":{"type":"Expr::Constant","c":{"type":"Constant::Int","0":"0"},"loc":null},"loc":null},"ifso":{"type":"Expr::Unary","op":{"type":"Var","name":{"type":"LongIdent::Ident","0":"-"},"loc":null},"expr":{"type":"Expr::Ident","id":{"type":"Var","name":{"type":"LongIdent::Ident","0":"self"},"loc":null},"loc":null},"loc":null},"ifnot":{"type":"Expr::Ident","id":{"type":"Var","name":{"type":"LongIdent::Ident","0":"self"},"loc":null},"loc":null},"loc":null}
      ),
    )
    inspect(
      expr.to_json() |> expr_codegen,
      content=(
        #|@syntax.Expr::If(cond=@syntax.Expr::Infix(op=@syntax.Var(name=@syntax.LongIdent::Ident("<", ), loc=dummy_loc(), ), lhs=@syntax.Expr::Ident(id=@syntax.Var(name=@syntax.LongIdent::Ident("self", ), loc=dummy_loc(), ), loc=dummy_loc(), ), rhs=@syntax.Expr::Constant(c=@syntax.Constant::Int("0", ), loc=dummy_loc(), ), loc=dummy_loc(), ), ifso=@syntax.Expr::Unary(op=@syntax.Var(name=@syntax.LongIdent::Ident("-", ), loc=dummy_loc(), ), expr=@syntax.Expr::Ident(id=@syntax.Var(name=@syntax.LongIdent::Ident("self", ), loc=dummy_loc(), ), loc=dummy_loc(), ), loc=dummy_loc(), ), ifnot=@syntax.Expr::Ident(id=@syntax.Var(name=@syntax.LongIdent::Ident("self", ), loc=dummy_loc(), ), loc=dummy_loc(), ), loc=dummy_loc(), )

      ),
    )
  }
}
