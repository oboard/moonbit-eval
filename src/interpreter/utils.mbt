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
pub fn manualUnescape(input : StringView, buf : StringBuilder) -> Unit {
  try {
    loop input {
      // EOF
      "" => break
      rest =>
        continue {
            let (c, rest) = lexmatch rest with longest {
                ("\\n", rest) => ('\n', rest)
                ("\\t", rest) => ('\t', rest)
                ("\\r", rest) => ('\r', rest)
                // Backspace
                ("\\b", rest) => ('\b', rest)
                // Unicode escape
                ("\\u[0-9a-fA-F]{4}" as raw, rest) =>
                  (fromCharCode(raw[2:], 16), rest)
                ("\\x[0-9a-fA-F]{2}" as raw, rest) =>
                  (fromCharCode(raw[2:], 16), rest)
                // Unicode escape with braces
                ("\\u[{][0-9a-fA-F]+[}]" as raw, rest) =>
                  (fromCharCode(raw[3:-1], 16), rest)
                // Octal escape
                ("\\o[0-3][0-7]{2}" as raw, rest) =>
                  (fromCharCode(raw[2:], 8), rest)
                ("\\\\", rest) => ('\\', rest)
                ("." as c, rest) => (c, rest)
                _ => break
              }
            buf.write_char(c)
            rest
          }
    }
  } catch {
    _ => ()
  }
}

///|
test "manualUnescape" {
  let builder = StringBuilder::new()
  manualUnescape("\\nhello", builder)
  inspect(
    builder.to_string(),
    content=(
      #|
      #|hello
    ),
  )
  let builder = StringBuilder::new()
  manualUnescape("hello\\nworld", builder)
  inspect(
    builder.to_string(),
    content=(
      #|hello
      #|world
    ),
  )
  let builder = StringBuilder::new()
  manualUnescape("\\u0041", builder)
  inspect(builder.to_string(), content="A")
  let builder = StringBuilder::new()
  manualUnescape("\\x41", builder)
  inspect(builder.to_string(), content="A")
  let builder = StringBuilder::new()
  manualUnescape("\\o061", builder)
  inspect(builder.to_string(), content="1")
}
