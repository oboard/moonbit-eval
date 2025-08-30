///| 类型约束检查模块 - 专门处理类型约束验证逻辑

///|
/// 检查运行时值是否满足类型约束
pub fn RuntimeModule::check_type_constraint(
  self : RuntimeModule,
  value : RuntimeValue,
  constraint : @syntax.Type,
) -> Bool {
  match (value, constraint) {
    // 基本类型检查
    (Bool(_), Name(constr_id={ id: Ident(name="Bool"), .. }, ..))
    | (Bool(_), Name(constr_id={ id: Dot(pkg="", id="Bool"), .. }, ..)) => true
    (Int(_), Name(constr_id={ id: Ident(name="Int"), .. }, ..))
    | (Int(_), Name(constr_id={ id: Dot(pkg="", id="Int"), .. }, ..)) => true
    (UInt(_), Name(constr_id={ id: Ident(name="UInt"), .. }, ..))
    | (UInt(_), Name(constr_id={ id: Dot(pkg="", id="UInt"), .. }, ..)) => true
    (Int64(_), Name(constr_id={ id: Ident(name="Int64"), .. }, ..))
    | (Int64(_), Name(constr_id={ id: Dot(pkg="", id="Int64"), .. }, ..)) =>
      true
    (UInt64(_), Name(constr_id={ id: Ident(name="UInt64"), .. }, ..))
    | (UInt64(_), Name(constr_id={ id: Dot(pkg="", id="UInt64"), .. }, ..)) =>
      true
    (Float(_), Name(constr_id={ id: Ident(name="Float"), .. }, ..))
    | (Float(_), Name(constr_id={ id: Dot(pkg="", id="Float"), .. }, ..)) =>
      true
    (Double(_), Name(constr_id={ id: Ident(name="Double"), .. }, ..))
    | (Double(_), Name(constr_id={ id: Dot(pkg="", id="Double"), .. }, ..)) =>
      true
    (String(_), Name(constr_id={ id: Ident(name="String"), .. }, ..))
    | (String(_), Name(constr_id={ id: Dot(pkg="", id="String"), .. }, ..)) =>
      true
    (Char(_), Name(constr_id={ id: Ident(name="Char"), .. }, ..))
    | (Char(_), Name(constr_id={ id: Dot(pkg="", id="Char"), .. }, ..)) => true
    (Byte(_), Name(constr_id={ id: Ident(name="Byte"), .. }, ..))
    | (Byte(_), Name(constr_id={ id: Dot(pkg="", id="Byte"), .. }, ..)) => true
    (BigInt(_), Name(constr_id={ id: Ident(name="BigInt"), .. }, ..))
    | (BigInt(_), Name(constr_id={ id: Dot(pkg="bigint", id="BigInt"), .. }, ..)
    ) => true

    // 复合类型检查
    (Array(_), Name(constr_id={ id: Ident(name="Array"), .. }, ..))
    | (Array(_), Name(constr_id={ id: Dot(pkg="", id="Array"), .. }, ..)) =>
      true
    (Tuple(_), Tuple(..))
    | (Tuple(_), Name(constr_id={ id: Ident(name="Tuple"), .. }, ..))
    | (Tuple(_), Name(constr_id={ id: Dot(pkg="", id="Tuple"), .. }, ..)) =>
      true
    (Map(_), Name(constr_id={ id: Ident(name="Map"), .. }, ..))
    | (Map(_), Name(constr_id={ id: Dot(pkg="", id="Map"), .. }, ..)) => true

    // Unit 类型
    (Unit, Name(constr_id={ id: Ident(name="Unit"), .. }, ..))
    | (Unit, Name(constr_id={ id: Dot(pkg="", id="Unit"), .. }, ..)) => true

    // Any 类型总是匹配
    (_, Any(..))
    | (_, Name(constr_id={ id: Ident(name="Any"), .. }, ..))
    | (_, Name(constr_id={ id: Dot(pkg="", id="Any"), .. }, ..)) => true

    // Option 类型检查
    (_, Option(..))
    | (_, Name(constr_id={ id: Ident(name="Option"), .. }, ..))
    | (_, Name(constr_id={ id: Dot(pkg="", id="Option"), .. }, ..)) => true

    // 自定义结构体类型检查
    (Struct({ type_info, .. }), Name(constr_id={ id: Ident(name~), .. }, ..)) =>
      type_info.pkg == self.meta.name && type_info.name == name
    (Struct({ type_info, .. }), Name(constr_id={ id: Dot(pkg~, id~), .. }, ..)) =>
      type_info.pkg == pkg && type_info.name == id

    // 构造函数类型检查
    (
      Constructor({ type_info, .. }),
      Name(constr_id={ id: Ident(name~), .. }, ..),
    )
    | (
      Constructor({ type_info, .. }),
      Name(constr_id={ id: Dot(pkg="", id=name), .. }, ..),
    ) => type_info.name == name

    // 默认情况：类型不匹配
    _ => false
  }
}
