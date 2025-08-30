///|
/// 记录操作模块
/// 包含记录更新(RecordUpdate)和字段赋值(Mutate)的处理逻辑

///|
/// 处理记录更新表达式 (RecordUpdate)
fn ClosureInterpreter::visit_record_update(
  self : ClosureInterpreter,
  record : @syntax.Expr,
  fields : @list.List[@syntax.FieldDef],
) -> RuntimeValue raise ControlFlow {
  // 先评估原记录
  let original_record = self.visit(record)
  match original_record {
    Struct(refer) => {
      // 复制原有字段
      let new_fields = refer.val.copy()

      // 更新指定字段
      fields.each(fn(field) {
        let field_name = field.label.name
        let field_value = self.visit(field.expr)
        new_fields.set(field_name, field_value)
      })

      // 创建新的结构体
      Struct({ val: new_fields, type_info: refer.type_info })
    }
    _ => self.error("RecordUpdate can only be applied to struct values")
  }
}

///|
/// 处理字段赋值 (Mutate)
fn ClosureInterpreter::visit_mutate(
  self : ClosureInterpreter,
  record : @syntax.Expr,
  accessor : @syntax.Accessor,
  field : @syntax.Expr,
  augmented_by : @syntax.Var?,
) -> RuntimeValue raise ControlFlow {

  // 获取记录的运行时值（支持嵌套字段访问）
  match self.visit(record) {
    Struct(refer) =>
      match accessor {
        Label(label) =>
          match augmented_by {
            Some(op) => {
              // 增强赋值操作 (+=, -=, 等)
              let op_name = match op.name {
                Ident(name~) => name
                _ => "+"
              }
              let base_op = match op_name {
                "+" => "+"
                "-" => "-"
                "*" => "*"
                "/" => "/"
                "%" => "%"
                _ => "+" // 默认
              }
              let current_val = refer.val.get(label.name).unwrap_or(Int(0))
              let right_val = self.visit(field)
              let new_val = runtime_value_infix(base_op, current_val, right_val)
              refer.val.set(label.name, new_val)
            }
            None =>
              // 普通赋值操作
              refer.val.set(label.name, self.visit(field))
          }
        Index(tuple_index~, ..) =>
          match augmented_by {
            Some(op) => {
              // 增强赋值操作 (+=, -=, 等)
              let op_name = match op.name {
                Ident(name~) => name
                _ => "+"
              }
              let base_op = match op_name {
                "+" => "+"
                "-" => "-"
                "*" => "*"
                "/" => "/"
                "%" => "%"
                _ => "+" // 默认
              }
              let current_val = refer.val
                .get(tuple_index.to_string())
                .unwrap_or(Int(0))
              let right_val = self.visit(field)
              let new_val = runtime_value_infix(base_op, current_val, right_val)
              refer.val.set(tuple_index.to_string(), new_val)
            }
            None =>
              // 普通赋值操作
              refer.val.set(tuple_index.to_string(), self.visit(field))
          }
        Newtype(_) => ()
      }
    Constructor(refer) =>
      match accessor {
        Label({ name, .. }) => {
          // 构造函数字段赋值处理
          let new_field_value = self.visit(field)
          let field = refer.val.fields.search_by(field => field.name ==
            Some(name))
          // 处理构造函数的字段赋值
          if field is Some(i) {
            refer.val.fields[i].value = new_field_value
          }
        }
        _ => () // 其他访问器类型暂不支持
      }
    _ => ()
  }
  Unit
}
