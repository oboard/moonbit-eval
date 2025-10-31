///|
#callsite(autofill(loc))
pub fn[A] error(msg : String, loc~ : SourceLoc) -> A raise ControlFlow {
  raise ControlFlow::Error(msg + " " + loc.to_string())
}

///|
fn fromCharCode(hex : StringView, base : Int) -> Char {
  (try! @strconv.parse_int(hex, base~)).to_char().unwrap_or('?')
}

///|
pub fn manualUnescape(input : StringView) -> StringView {
  try {
    lexmatch input {
      (tail, "\\n", rest) => "\{tail}\n\{manualUnescape(rest)}"
      (tail, "\\t", rest) => "\{tail}\t\{manualUnescape(rest)}"
      (tail, "\\r", rest) => "\{tail}\r\{manualUnescape(rest)}"
      // Unicode escape
      (tail, "\\u[0-9a-fA-F]{4}" as raw, rest) =>
        "\{tail}\{fromCharCode(raw[2:],16)}\{manualUnescape(rest)}"
      (tail, "\\x[0-9a-fA-F]{2}" as raw, rest) =>
        "\{tail}\{fromCharCode(raw[2:],16)}\{manualUnescape(rest)}"
      // Unicode escape with braces
      (tail, "\\u[{][0-9a-fA-F]+[}]" as raw, rest) =>
        "\{tail}\{fromCharCode(raw[3:-1],16)}\{manualUnescape(rest)}"
      // Octal escape
      (tail, "\\o[0-3][0-7]{2}" as raw, rest) =>
        "\{tail}\{fromCharCode(raw[2:],8)}\{manualUnescape(rest)}"
      (tail, "\\\\", rest) => "\{tail}\\\\\{manualUnescape(rest)}"
      _ => input
    }
  } catch {
    _ => input
  }
}

///|
test "manualUnescape" {
  inspect(manualUnescape("\\nhello"), content="\nhello")
  inspect(
    manualUnescape("hello\\nworld"),
    content=(
      #|hello
      #|world
    ),
  )
  inspect(manualUnescape("\\u0041"), content="A")
  inspect(manualUnescape("\\x41"), content="A")
  inspect(manualUnescape("\\o061"), content="1")
}
