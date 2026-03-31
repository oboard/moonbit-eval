///|
let json_methods : Map[String, RuntimeFunction] = {
  "array": json_array_fn,
  "as_array": json_as_array_fn,
  "as_bool": json_as_bool_fn,
  "as_null": json_as_null_fn,
  "as_number": json_as_number_fn,
  "as_object": json_as_object_fn,
  "as_string": json_as_string_fn,
  "boolean": json_boolean_fn,
  "default": json_default_fn,
  "equal": json_equal_fn,
  "from_json": json_from_json_fn,
  "item": json_item_fn,
  "null": json_null_fn,
  "number": json_number_fn,
  "object": json_object_fn,
  "output": json_output_fn,
  "string": json_string_fn,
  "stringify": json_stringify_fn,
  "to_json": json_to_json_fn,
  "transform": json_transform_fn,
  "value": json_value_fn,
}

///|
let json_stringify_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }] => String(value.stringify())
    _ => Unit
  }
}

///|
let json_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(value), .. }] =>
      Json(Json::array(value.map(i => if i is Json(i) { i } else { panic() })))
    _ => Unit
  }
}

///|
let json_as_null_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }] =>
      match value {
        Null => RuntimeValue::from_option(Some(Unit))
        _ => RuntimeValue::from_option(None)
      }
    _ => RuntimeValue::from_option(None)
  }
}

///|
let json_as_bool_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }] =>
      match value {
        True => RuntimeValue::from_option(Some(Bool(true)))
        False => RuntimeValue::from_option(Some(Bool(false)))
        _ => RuntimeValue::from_option(None)
      }
    _ => RuntimeValue::from_option(None)
  }
}

///|
let json_as_number_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }] =>
      match value {
        Number(number, ..) => RuntimeValue::from_option(Some(Double(number)))
        _ => RuntimeValue::from_option(None)
      }
    _ => RuntimeValue::from_option(None)
  }
}

///|
let json_as_string_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }] =>
      match value {
        String(str) => RuntimeValue::from_option(Some(String(str)))
        _ => RuntimeValue::from_option(None)
      }
    _ => RuntimeValue::from_option(None)
  }
}

///|
let json_as_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }] =>
      match value {
        Array(array) =>
          RuntimeValue::from_option(Some(Array(array.map(x => Json(x)))))
        _ => RuntimeValue::from_option(None)
      }
    _ => RuntimeValue::from_option(None)
  }
}

///|
let json_item_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }, { val: Int(index, ..), .. }] =>
      match value {
        Array(array) =>
          RuntimeValue::from_option(array.get(index).map(x => Json(x)))
        _ => RuntimeValue::from_option(None)
      }
    _ => RuntimeValue::from_option(None)
  }
}

///|
let json_as_object_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }] =>
      match value {
        Object(object) =>
          RuntimeValue::from_option(
            Some(
              Map(
                map_from_pairs(
                  object
                  .to_array()
                  .map(pair => {
                    RuntimeValue::Tuple([String(pair.0), Json(pair.1)])
                  })
                  .iter(),
                ),
              ),
            ),
          )
        _ => RuntimeValue::from_option(None)
      }
    _ => RuntimeValue::from_option(None)
  }
}

///|
let json_value_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }, { val: String(key), .. }] =>
      match value {
        Object(object) =>
          RuntimeValue::from_option(object.get(key).map(x => Json(x)))
        _ => RuntimeValue::from_option(None)
      }
    _ => RuntimeValue::from_option(None)
  }
}

///|
let json_boolean_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bool(value), .. }] => Json(Json::boolean(value))
    _ => Unit
  }
}

///|
let json_default_fn : RuntimeFunction = _ctx => Json(Json::boolean(false))

///|
let json_equal_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(lhs), .. }, { val: Json(rhs), .. }] => Bool(lhs == rhs)
    _ => Bool(false)
  }
}

///|
let json_from_json_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }, ..] => Json(value)
    _ => Json(Json::null())
  }
}

///|
let json_null_fn : RuntimeFunction = _ctx => Json(Json::null())

///|
let json_number_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(value), .. }, { val: String(repr), .. }] =>
      Json(Json::number(value, repr~))
    [{ val: Double(value), .. }] => Json(Json::number(value))
    _ => Unit
  }
}

///|
let json_object_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Map(value), .. }] =>
      Json(
        Json::object(
          value
          .to_array()
          .map(i => {
            if i is (String(key), Json(json)) {
              (key, json)
            } else {
              panic()
            }
          })
          |> Map::from_array,
        ),
      )
    _ => Unit
  }
}

///|
let json_output_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }, { val: StringBuilder(logger), .. }] => {
      logger.write_string(value.to_string())
      Unit
    }
    _ => Unit
  }
}

///|
let json_string_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(value), .. }] => Json(Json::string(value))
    _ => Unit
  }
}

///|
let json_to_json_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }] => Json(value)
    _ => Json(Json::null())
  }
}

///|
let json_transform_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }, ..] => Json(value)
    _ => Unit
  }
}
