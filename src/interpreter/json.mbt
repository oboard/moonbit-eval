///|
let json_methods : Map[String, RuntimeFunction] = {
  "stringify": json_stringify_fn,
  "array": json_array_fn,
  "boolean": json_boolean_fn,
  "null": json_null_fn,
  "number": json_number_fn,
  "object": json_object_fn,
  "string": json_string_fn,
}

///|
let json_stringify_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Json(value), .. }] => String(value.stringify())
  _ => Unit
}

///|
let json_array_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(value), .. }] =>
    Json(Json::array(value.map(i => if i is Json(i) { i } else { panic() })))
  _ => Unit
}

///|
let json_boolean_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Bool(value), .. }] => Json(Json::boolean(value))
  _ => Unit
}

///|
let json_null_fn : RuntimeFunction = _ctx => Json(Json::null())

///|
let json_number_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Double(value), .. }] => Json(Json::number(value))
  _ => Unit
}

///|
let json_object_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Map(value), .. }] =>
    Json(
      Json::object(
        value
        .to_array()
        .map(i => if i is (String(key), Json(json)) {
          (key, json)
        } else {
          panic()
        })
        |> Map::from_array,
      ),
    )
  _ => Unit
}

///|
let json_string_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(value), .. }] => Json(Json::string(value))
  _ => Unit
}
