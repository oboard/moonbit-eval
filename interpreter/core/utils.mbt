///|
#callsite(autofill(loc))
pub fn[A] error(msg : String, loc~ : SourceLoc) -> A raise ControlFlow {
  raise Error(msg + " " + loc.to_string())
}

///|
pub fn control_error(msg : String) -> ControlFlow {
  Error(msg)
}

///|
fn fromCharCode(hex : StringView, base : Int) -> Char {
  (try! @string.parse_int(hex, base~)).to_char().unwrap_or('?')
}

///|
pub fn manualUnescape(input : StringView, buf : StringBuilder) -> Unit {
  for state = input {
    lexmatch state with longest {
      // EOF handled by the `_` case below
      (re"^(?:\\n)", after=rest) => {
        buf.write_char('\n')
        continue rest
      }
      (re"^(?:\\t)", after=rest) => {
        buf.write_char('\t')
        continue rest
      }
      (re"^(?:\\r)", after=rest) => {
        buf.write_char('\r')
        continue rest
      }
      // Backspace
      (re"^(?:\\b)", after=rest) => {
        buf.write_char('\b')
        continue rest
      }
      // Unicode escape
      (re"^(?:\\u[0-9a-fA-F]{4})" as raw, after=rest) => {
        buf.write_char(fromCharCode(raw.exact_view(start=2), 16))
        continue rest
      }
      (re"^(?:\\x[0-9a-fA-F]{2})" as raw, after=rest) => {
        buf.write_char(fromCharCode(raw.exact_view(start=2), 16))
        continue rest
      }
      // Unicode escape with braces
      (re"^(?:\\u[{][0-9a-fA-F]+[}])" as raw, after=rest) => {
        buf.write_char(
          fromCharCode(raw.exact_view(start=3, end=raw.length() - 1), 16),
        )
        continue rest
      }
      // Octal escape
      (re"^(?:\\o[0-3][0-7]{2})" as raw, after=rest) => {
        buf.write_char(fromCharCode(raw.exact_view(start=2), 8))
        continue rest
      }
      (re"^(?:\\\\)", after=rest) => {
        buf.write_char('\\')
        continue rest
      }
      (re"^(?:.)" as c, after=rest) => {
        buf.write_char(c)
        continue rest
      }
      _ => break
    }
  }
}

///|
test "manualUnescape" {
  let builder = @builtin.StringBuilder()
  manualUnescape("\\nhello", builder)
  inspect(
    builder.to_string(),
    content=(
      #|
      #|hello
    ),
  )
  let builder = @builtin.StringBuilder()
  manualUnescape("hello\\nworld", builder)
  inspect(
    builder.to_string(),
    content=(
      #|hello
      #|world
    ),
  )
  let builder = @builtin.StringBuilder()
  manualUnescape("\\u0041", builder)
  inspect(builder.to_string(), content="A")
  let builder = @builtin.StringBuilder()
  manualUnescape("\\x41", builder)
  inspect(builder.to_string(), content="A")
  let builder = @builtin.StringBuilder()
  manualUnescape("\\o061", builder)
  inspect(builder.to_string(), content="1")
}
