///|
struct Name {
  name : String?
  slot : Int
} derive(Eq, Hash, Compare)

///|
pub impl Show for Name with output(self : Name, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
pub fn Name::to_string(self : Name) -> String {
  let { name, slot } = self
  match (name, slot) {
    (None, _) => "_\{slot}"
    (Some(name), 0) => name
    (Some(name), _) => "\{name}.\{slot}"
  }
}

///|
suberror NameFromStringError {
  InvalidSlotNumber(String, String)
}

///|
pub impl Show for NameFromStringError with output(
  self : NameFromStringError,
  logger : &Logger,
) -> Unit {
  match self {
    NameFromStringError::InvalidSlotNumber(e, slot_s) =>
      logger.write_string("Invalid slot number: \{e} (input: \{slot_s})")
  }
}

///|
pub fn Name::from_string(s : String) -> Name raise NameFromStringError {
  let first_dot = s.find(".")
  if first_dot is Some(first_dot) {
    let name = s.substring(start=0, end=first_dot)
    let slot_s = s.substring(start=first_dot + 1, end=s.length())
    try {
      let slot = @strconv.parse_int(slot_s, base=10)
      Name::name_and_slot(name, slot)
    } catch {
      @strconv.StrConvError(e) =>
        raise NameFromStringError::InvalidSlotNumber(e, slot_s)
    }
  } else if s.has_prefix("_") &&
    s.length() > 1 &&
    s
    .substring(start=1, end=s.length())
    .iter()
    .all(fn(c) { c >= '0' && c <= '9' }) {
    let slot_s = s.substring(start=1, end=s.length())
    try {
      let slot = @strconv.parse_int(slot_s, base=10)
      Name::slot_only(slot)
    } catch {
      @strconv.StrConvError(e) =>
        raise NameFromStringError::InvalidSlotNumber(e, slot_s)
    }
  } else {
    Name::name_only(s)
  }
}

///|
pub fn Name::name_only(name : String) -> Name {
  { name: Some(name), slot: 0 }
}

///|
pub fn Name::name_and_slot(name : String, slot : Int) -> Name {
  { name: Some(name), slot }
}

///|
pub fn Name::slot_only(slot : Int) -> Name {
  { name: None, slot }
}

///|
pub fn Name::to_json(self : Name) -> Json {
  self.to_string().to_json()
}

///|
pub fn Name::from_json(json : Json) -> Name raise {
  match json {
    Json::String(s) => Name::from_string(s)
    _ => fail("Name::from_json: expected a string, but got \{json}")
  }
}
