///| 类型约束检查模块 - 专门处理类型约束验证逻辑

///|
/// 检查运行时值是否满足类型约束
pub fn RuntimePackage::check_type_constraint(
  _self : RuntimePackage,
  value : RuntimeValue,
  constraint : @syntax.Type,
) -> Bool {
  match (value, constraint) {
    // 基本类型检查
    (
      Bool(_),
      Name(constr_id={ id: Ident(name="Bool") | Dot(id="Bool", ..), .. }, ..),
    )
    | (
      Int(_),
      Name(constr_id={ id: Ident(name="Int") | Dot(id="Int", ..), .. }, ..),
    )
    | (
      UInt(_),
      Name(constr_id={ id: Ident(name="UInt") | Dot(id="UInt", ..), .. }, ..),
    )
    | (
      Int64(_),
      Name(constr_id={ id: Ident(name="Int64") | Dot(id="Int64", ..), .. }, ..),
    )
    | (
      UInt16(_),
      Name(
        constr_id={ id: Ident(name="UInt16") | Dot(id="UInt16", ..), .. },
        ..
      ),
    )
    | (
      UInt64(_),
      Name(
        constr_id={ id: Ident(name="UInt64") | Dot(id="UInt64", ..), .. },
        ..
      ),
    )
    | (
      Float(_),
      Name(constr_id={ id: Ident(name="Float") | Dot(id="Float", ..), .. }, ..),
    )
    | (
      Double(_),
      Name(
        constr_id={ id: Ident(name="Double") | Dot(id="Double", ..), .. },
        ..
      ),
    )
    | (
      String(_),
      Name(
        constr_id={ id: Ident(name="String") | Dot(id="String", ..), .. },
        ..
      ),
    )
    | (
      Char(_),
      Name(constr_id={ id: Ident(name="Char") | Dot(id="Char", ..), .. }, ..),
    )
    | (
      Byte(_),
      Name(constr_id={ id: Ident(name="Byte") | Dot(id="Byte", ..), .. }, ..),
    )
    | (
      BigInt(_),
      Name(
        constr_id={ id: Ident(name="BigInt") | Dot(id="BigInt", ..), .. },
        ..
      ),
    )

    // 复合类型检查
    | (
      Array(_),
      Name(constr_id={ id: Ident(name="Array") | Dot(id="Array", ..), .. }, ..),
    )
    | (
      Tuple(_),
      Name(constr_id={ id: Ident(name="Tuple") | Dot(id="Tuple", ..), .. }, ..),
    )
    | (
      Map(_),
      Name(constr_id={ id: Ident(name="Map") | Dot(id="Map", ..), .. }, ..),
    )

    // Unit 类型
    | (
      Unit,
      Name(constr_id={ id: Ident(name="Unit") | Dot(id="Unit", ..), .. }, ..),
    )

    // Json 类型检查
    | (
      Json(_),
      Name(constr_id={ id: Ident(name="Json") | Dot(id="Json", ..), .. }, ..),
    )

    // Any 类型总是匹配
    | (_, Any(..))
    | (_, Name(constr_id={ id: Ident(name="Any") | Dot(id="Any", ..), .. }, ..))

    // Option 类型检查
    | (_, Option(..))
    | (
      _,
      Name(
        constr_id={ id: Ident(name="Option") | Dot(id="Option", ..), .. },
        ..
      ),
    ) => true

    // TODO: call equal
    // 构造函数类型检查
    (
      Constructor({ ty: Name(name=name1, ..), val: { fields, .. } }),
      Name(constr_id={ id: Ident(name=name2), .. }, tys~, ..),
    ) =>
      name1 == name2 &&
      fields.length() == tys.length() &&
      (for idx, ty in tys {
        if !check_type_constraint2(fields[idx].value.get_type(), ty) {
          break false
        }
      } else {
        true
      })
    (
      Object({ ty: Object(pkg={ name: pkg1, .. }, name=name1), .. }),
      Object({ id: Dot(pkg=pkg2, id=name2), .. }),
    ) => name1 == name2 && pkg1 == pkg2
    (
      Object({ ty: Object(name=name1, ..), .. }),
      Object({ id: Ident(name=name2), .. }),
    ) => name1 == name2

    // 默认情况：类型不匹配
    _ => false
  }
}

///|
pub fn check_type_constraint2(
  value : RuntimeType,
  constraint : @syntax.Type,
) -> Bool {
  match (value, constraint) {
    (Arrow(_), Arrow(_)) => true
    (Tuple(tys1), Tuple(tys=tys2, ..)) =>
      tys1.length() == tys2.length() &&
      {
        let tys2 = tys2.to_array()
        for idx, ty in tys1 {
          if !check_type_constraint2(ty, tys2[idx]) {
            break false
          }
        } else {
          true
        }
      }
    (
      Name(name=name1, tys=tys1, ..),
      Name(constr_id={ id: Ident(name=name2), .. }, tys=tys2, ..),
    ) =>
      name1 == name2 &&
      tys1.length() == tys2.length() &&
      {
        let tys2 = tys2.to_array()
        for idx, ty in tys1 {
          if !check_type_constraint2(ty, tys2[idx]) {
            break false
          }
        } else {
          true
        }
      }
    (
      Object(pkg={ name: pkg1, .. }, name=name1),
      Object({ id: Dot(pkg=pkg2, id=name2), .. }),
    ) => name1 == name2 && pkg1 == pkg2
    (Object(name=name1, ..), Object({ id: Ident(name=name2), .. })) =>
      name1 == name2
    (Option(ty1), Option(ty=ty2, ..)) => check_type_constraint2(ty1, ty2)
    (
      Option(ty),
      Name(
        constr_id={ id: Ident(name="Option") | Dot(id="Option", ..), .. },
        ..
      ),
    ) => check_type_constraint2(ty, constraint)
    _ => false
  }
}
