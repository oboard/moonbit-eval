///|
/// Auto-generated core modules for moonbit-eval interpreter
/// This file contains embedded RuntimeModule definitions for all moonbitlang/core modules

///|
let core_modules : Map[String, RuntimeModule] = {
  "abort": abort_module,
  "array": array_module,
  "bench": bench_module,
  "bigint": bigint_module,
  "bool": bool_module,
  "buffer": buffer_module,
  "builtin": builtin_module,
  "byte": byte_module,
  "bytes": bytes_module,
  "char": char_module,
  "deque": deque_module,
  "double": double_module,
  "env": env_module,
  "float": float_module,
  "hashmap": hashmap_module,
  "hashset": hashset_module,
  "int": int_module,
  "int16": int16_module,
  "int64": int64_module,
  "json": json_module,
  "list": list_module,
  "math": math_module,
  "option": option_module,
  "priority_queue": priority_queue_module,
  "queue": queue_module,
  "quickcheck": quickcheck_module,
  "random": random_module,
  "rational": rational_module,
  "ref": ref_module,
  "result": result_module,
  "set": set_module,
  "sorted_map": sorted_map_module,
  "sorted_set": sorted_set_module,
  "strconv": strconv_module,
  "string": string_module,
  "test": test_module,
  "tuple": tuple_module,
  "uint": uint_module,
  "uint16": uint16_module,
  "uint64": uint64_module,
  "unit": unit_module,
}

///|
fn dummy_loc() -> @basic.Location {
  {
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
}

///|
let abort_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/abort",
  fn(_env, build) { { "_": build("msg") } },
)

///|
let array_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/array",
  fn(_env, build) {
    {
      "len": build("self.length()"),
      "arr": build("FixedArray::make(len, self[0])"),
      "array": build("Array::make(length, value(0))"),
      "n": build("self.length()"),
      "j": build("rand(i + 1) % (i + 1)"),
      "new_arr": build("self.copy()"),
      "result": build("[]"),
      "length": build("if self.length() < other.length() {"),
      "arr": build("Array::new(capacity=length)"),
      "length": build(
        "if l.length() < r.length() { l.length() } else { r.length() }",
      ),
      "arr": build("Array::new(capacity=length)"),
      "length": build("if self.length() < other.length() {"),
      "len": build("if size == 0 { 0 } else { rs.next_positive_int() % size }"),
      "join": build(
        (
          #|pub fn join(self : Array[String], separator : @string.View) -> String { self[:].join(separator) }
        ),
      ),
      "f": build("elem => {"),
      "f": build("(index, elem) => {"),
      "f": build("elem => {"),
      "len": build("self.length()"),
      "f": build("(index, elem) => {"),
      "res": build("FixedArray::make(self.length(), f(self[0]))"),
      "simple_doubled": build("simple_arr.map(x => x * 2)"),
      "doubled": build("arr.map(x => x * 2)"),
      "res": build("FixedArray::make(self.length(), f(0, self[0]))"),
      "simple_doubled": build("simple_arr.mapi((i, x) => x * 2 + i)"),
      "doubled": build("arr.mapi((i, x) => x * 2 + i)"),
      "array": build("FixedArray::make(length, value(0))"),
      "empty": build("FixedArray::makei(0, i => i)"),
      "simple_arr": build("FixedArray::makei(1, i => i)"),
      "arr": build("FixedArray::makei(2, i => i)"),
      "array": build("FixedArray::from_array([1, 2, 3, 4, 5])"),
      "sum": build(
        "([] : FixedArray[_]).fold(init=1, (sum, elem) => sum + elem)",
      ),
      "sum": build(
        "([1] : FixedArray[_]).fold(init=2, (sum, elem) => sum + elem)",
      ),
      "sum": build(
        "([1, 2, 3, 4, 5] : FixedArray[_]).fold(init=0, (sum, elem) => sum +",
      ),
      "sum": build(
        "([] : FixedArray[_]).rev_fold(init=1, (sum, elem) => sum + elem)",
      ),
      "sum": build(
        "([1] : FixedArray[_]).rev_fold(init=2, (sum, elem) => sum + elem)",
      ),
      "sum": build(
        "([1, 2, 3, 4, 5] : FixedArray[_]).rev_fold(init=0, (sum, elem) => sum +",
      ),
      "f": build("(index, sum, elem) => index + sum + elem"),
      "sum": build("([] : FixedArray[_]).foldi(init=1, f)"),
      "sum": build("([1] : FixedArray[_]).foldi(init=2, f)"),
      "sum": build("([1, 2, 3, 4, 5] : FixedArray[_]).foldi(init=0, f)"),
      "len": build("self.length()"),
      "f": build("(index, sum, elem) => index + sum + elem"),
      "sum": build("([] : FixedArray[_]).rev_foldi(init=1, f)"),
      "sum": build("([1] : FixedArray[_]).rev_foldi(init=2, f)"),
      "sum": build("([1, 2, 3, 4, 5] : FixedArray[_]).rev_foldi(init=0, f)"),
      "mid_len": build("self.length() / 2"),
      "j": build("self.length() - i - 1"),
      "temp": build("self[i]"),
      "res": build("FixedArray::make(self.length(), first)"),
      "len": build("self.length()"),
      "temp": build("self[i]"),
      "self_len": build("self.length()"),
      "suf_len": build("suffix.length()"),
      "len_self": build("self.length()"),
      "len_other": build("other.length()"),
      "cmp": build("len_self.compare(len_other)"),
      "cmp": build("self.unsafe_get(i).compare(other.unsafe_get(i))"),
      "slen": build("self.length()"),
      "nlen": build("other.length()"),
      "iter": build("arr.iter()"),
      "exb": build("StringBuilder::new()"),
      "len": build("self.length()"),
      "first": build("self[0]"),
      "string": build("StringBuilder::new(size_hint~)"),
      "len": build("if size == 0 { 0 } else { rs.next_positive_int() % size }"),
      "bubble_sort_len": Int(16),
      "len": build("arr.length()"),
      "left": build("arr[0:pivot]"),
      "right": build("arr[pivot + 1:len]"),
      "max_tries": Int(8),
      "pivot": build("arr[arr.length() - 1]"),
      "len": build("arr.length()"),
      "use_median_of_medians": Int(50),
      "max_swaps": build("4 * 3"),
      "b": build("len / 4 * 2"),
      "a": build("len / 4 * 1"),
      "c": build("len / 4 * 3"),
      "sort_2": build("(a : Int, b : Int) => if cmp(arr[a], arr[b]) > 0 {"),
      "sort_3": build("(a : Int, b : Int, c : Int) => {"),
      "len": build("arr.length()"),
      "len": build("arr.length()"),
      "arr": build("[8, 7, 6, 5, 4, 3, 2, 1]"),
      "sorted": build("try_bubble_sort_by(arr[0:8], (a, b) => a - b)"),
      "arr": build("[5, 1, 3, 4, 2]"),
      "large_arr": build("FixedArray::makei(1000, i => 1000 - i)"),
      "expected": build("FixedArray::makei(1000, i => i + 1)"),
      "bubble_sort_len": Int(16),
      "len": build("arr.length()"),
      "left": build("arr.slice(0, pivot)"),
      "right": build("arr.slice(pivot + 1, len)"),
      "max_tries": Int(8),
      "sorted": build(
        "fixed_try_bubble_sort_by({ array: arr, start: 0, end: 8 }, (a, b) => a -",
      ),
      "pivot": build("arr[arr.length() - 1]"),
      "len": build("arr.length()"),
      "use_median_of_medians": Int(50),
      "max_swaps": build("4 * 3"),
      "b": build("len / 4 * 2"),
      "a": build("len / 4 * 1"),
      "c": build("len / 4 * 3"),
      "sort_2": build("(a : Int, b : Int) => if cmp(arr[a], arr[b]) > 0 {"),
      "sort_3": build("(a : Int, b : Int, c : Int) => {"),
      "len": build("arr.length()"),
      "len": build("arr.length()"),
      "arr": build("[5, 1, 3, 4, 2]"),
      "arr": build(
        "FixedArray::makei(100, i => if i % 2 == 0 { 1 } else { 0 })",
      ),
      "len": build("self.length()"),
      "arr": build("Array::make(len, self[0])"),
      "max_insertion": Int(20),
      "len": build("arr.length()"),
      "left": build("runs[r]"),
      "right": build("runs[r + 1]"),
      "buf_len": build("arr.length() - mid"),
      "buf": build("{ array: buf, start: 0, end: buf_len }"),
      "buf_remaining": build(
        "for p1 = mid - 1, p2 = buf_len - 1, p = mid + buf_len - 1; p1 >=",
      ),
      "len": build("arr.length()"),
      "assume_reverse": build("arr[1] < arr[0]"),
      "len": build("arr.length()"),
      "min_insertion_run": Int(10),
      "start_end_diff": build("end - start"),
      "sort_end": build("minimum(len, start + min_insertion_run)"),
      "collapse": build(
        (
          #|fn collapse(runs : Array[TimSortRun], stop : Int) -> Int? { let n : Int = runs.length()
          #|  if n >= 2 &&
          #|    (
          #|      runs[n - 1].start + runs[n - 1].len == stop ||
          #|      runs[n - 2].len <= runs[n - 1].len ||
          #|      (n >= 3 && runs[n - 3].len <= runs[n - 2].len + runs[n - 1].len) ||
          #|      (n >= 4 && runs[n - 4].len <= runs[n - 3].len + runs[n - 2].len)
          #|    ) {
          #|    if n >= 3 && runs[n - 3].len < runs[n - 1].len {
          #|      Some(n - 3)
          #|    } else {
          #|      Some(n - 2)
          #|    }
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "bubble_sort_len": Int(16),
      "len": build("arr.length()"),
      "left": build("arr.slice(0, pivot)"),
      "right": build("arr.slice(pivot + 1, len)"),
      "fixed_get_limit": build(
        (
          #|fn fixed_get_limit(len : Int) -> Int { let mut len = len
          #|  let mut limit = 0
          #|  while len > 0 {
          #|    len = len / 2
          #|    limit += 1
          #|  }
          #|  limit }
        ),
      ),
      "max_tries": Int(8),
      "sorted": build("fixed_try_bubble_sort({ array: arr, start: 0, end: 8 })"),
      "pivot": build("arr[arr.length() - 1]"),
      "len": build("arr.length()"),
      "use_median_of_medians": Int(50),
      "max_swaps": build("4 * 3"),
      "b": build("len / 4 * 2"),
      "a": build("len / 4 * 1"),
      "c": build("len / 4 * 3"),
      "sort_2": build("(a : Int, b : Int) => if arr[a] > arr[b] {"),
      "sort_3": build("(a : Int, b : Int, c : Int) => {"),
      "len": build("arr.length()"),
      "len": build("arr.length()"),
      "fixed_test_sort": build(
        (
          #|fn fixed_test_sort(f : (FixedArray[Int]) -> Unit) -> Unit raise { let arr : FixedArray[_] = [5, 4, 3, 2, 1]
          #|  f(arr)
          #|  assert_eq(arr, [1, 2, 3, 4, 5])
          #|  let arr : FixedArray[_] = [5, 5, 5, 5, 1]
          #|  f(arr)
          #|  assert_eq(arr, [1, 5, 5, 5, 5])
          #|  let arr : FixedArray[_] = [1, 2, 3, 4, 5]
          #|  f(arr)
          #|  assert_eq(arr, [1, 2, 3, 4, 5])
          #|  let arr = FixedArray::make(1000, 0)
          #|  for i in 0..<1000 {
          #|    arr[i] = 1000 - i - 1
          #|  }
          #|  for i = 10; i < 1000; i = i + 10 {
          #|    arr.swap(i, i - 1)
          #|  }
          #|  f(arr)
          #|  let expected = FixedArray::make(1000, 0)
          #|  for i in 0..<1000 {
          #|    expected[i] = i
          #|  }
          #|  assert_eq(arr, expected) }
        ),
      ),
      "arr": build("FixedArray::make(1000, 0)"),
      "expected": build("FixedArray::make(1000, 0)"),
      "run_lens": build("[86, 64, 21, 20, 22]"),
      "total_len": build("run_lens.fold(init=0, (acc, x) => acc + x)"),
      "arr": build("FixedArray::make(total_len, 0)"),
      "end": build(
        "provide_sorted_batch({ array: arr, start: 0, end: 5 }, 0, 5)",
      ),
      "minimum": build(
        (
          #|fn minimum(x : Int, y : Int) -> Int { if x > y {
          #|    y
          #|  } else {
          #|    x
          #|  } }
        ),
      ),
      "b": build("a.copy()"),
      "c": build("FixedArray::make(8, 0)"),
      "mid_len": build("self.length() / 2"),
      "j": build("self.length() - i - 1"),
      "len": build("self.length()"),
      "arr": build("[]"),
      "len": build("self.length()"),
      "arr": build("Array::make(len, self[0])"),
      "join": build(
        (
          #|pub fn View::join(self : ArrayView[String], separator : @string.View) -> String { match self {
          #|    [] => \"\"
          #|    [hd, .. tl] => {
          #|      let mut size_hint = hd.length()
          #|      for s in tl {
          #|        size_hint += s.length() + separator.length()
          #|      }
          #|      size_hint = size_hint << 1
          #|      let buf = StringBuilder::new(size_hint~)
          #|      buf.write_string(hd)
          #|      if separator is \"\" {
          #|        for s in tl {
          #|          buf.write_string(s)
          #|        }
          #|      } else {
          #|        for s in tl {
          #|          buf.write_substring(
          #|            separator.data(),
          #|            separator.start_offset(),
          #|            separator.length(),
          #|          )
          #|          buf.write_string(s)
          #|        }
          #|      }
          #|      buf.to_string()
          #|    }
          #|  } }
        ),
      ),
      "len_self": build("self.length()"),
      "len_other": build("other.length()"),
      "cmp": build("len_self.compare(len_other)"),
      "cmp": build("self[i].compare(other[i])"),
      "len": build("self.length()"),
      "insertion_sort_len": Int(16),
      "len": build("arr.length()"),
      "left": build("arr[0:pivot]"),
      "right": build("arr[pivot + 1:len]"),
      "get_limit": build(
        (
          #|fn get_limit(len : Int) -> Int { let mut len = len
          #|  let mut limit = 0
          #|  while len > 0 {
          #|    len = len / 2
          #|    limit += 1
          #|  }
          #|  limit }
        ),
      ),
      "max_tries": Int(8),
      "pivot": build("arr[arr.length() - 1]"),
      "len": build("arr.length()"),
      "use_median_of_medians": Int(50),
      "max_swaps": build("4 * 3"),
      "b": build("len / 4 * 2"),
      "a": build("len / 4 * 1"),
      "c": build("len / 4 * 3"),
      "sort_2": build("(a : Int, b : Int) => if arr[a] > arr[b] {"),
      "sort_3": build("(a : Int, b : Int, c : Int) => {"),
      "len": build("arr.length()"),
      "len": build("arr.length()"),
      "test_sort": build(
        (
          #|fn test_sort(f : (Array[Int]) -> Unit) -> Unit raise { let arr = [5, 4, 3, 2, 1]
          #|  f(arr)
          #|  assert_eq(arr, [1, 2, 3, 4, 5])
          #|  let arr = [5, 5, 5, 5, 1]
          #|  f(arr)
          #|  assert_eq(arr, [1, 5, 5, 5, 5])
          #|  let arr = [1, 2, 3, 4, 5]
          #|  f(arr)
          #|  assert_eq(arr, [1, 2, 3, 4, 5])
          #|  let arr = Array::new(capacity=1000)
          #|  for i in 0..<1000 {
          #|    arr.push(1000 - i - 1)
          #|  }
          #|  for i = 10; i < 1000; i = i + 10 {
          #|    arr.swap(i, i - 1)
          #|  }
          #|  f(arr)
          #|  let expected = Array::new(capacity=1000)
          #|  for i in 0..<1000 {
          #|    expected.push(i)
          #|  }
          #|  assert_eq(arr, expected) }
        ),
      ),
      "arr": build("[8, 7, 6, 5, 4, 3, 2, 1]"),
      "sorted": build("try_bubble_sort(arr[0:8])"),
      "arr": build("["),
      "arr": build("[5, 4, 3, 2, 1]"),
      "arr2": build("[1, 2, 3, 4, 5]"),
      "arr2": build("[1, 2, 3, 4, 5]"),
      "arr3": build("[5, 5, 5, 5, 1]"),
      "arr": build("[5, 4, 3, 2, 1]"),
      "arr2": build("[1, 2, 3, 4, 5]"),
      "arr3": build("[5, 5, 5, 5, 1]"),
      "arr": build("[]"),
      "arr": build("[5, 4, 3, 2, 1]"),
      "arr2": build("[1, 2, 3, 4, 5]"),
      "arr3": build("[5, 5, 5, 5, 1]"),
      "arr": build("[]"),
      "arr": build("[5, 4, 3, 2, 1]"),
      "arr2": build("[1, 2, 3, 4, 5]"),
      "arr3": build("[5, 5, 5, 5, 1]"),
      "arr": build("[5, 4, 3, 2, 1]"),
      "arr": build("[5, 4, 3, 2, 1]"),
      "arr": build("[5, 4, 3, 2, 1]"),
      "len": build("self.length()"),
      "mid_len": build("len / 2"),
      "j": build("len - i - 1"),
    }
  },
)

///|
let bench_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bench",
  fn(_env, build) {
    {
      "iter_n_microseconds": build(
        (
          #|fn iter_n_microseconds(inner : () -> Unit, k : Int) -> Double { let ts = monotonic_clock_start()
          #|  for i in 0..<k {
          #|    inner()
          #|  }
          #|  let diff = monotonic_clock_end(ts)
          #|  diff }
        ),
      ),
      "iter_count": build(
        (
          #|fn iter_count(name? : String, inner : () -> Unit, count : UInt) -> Summary { let count = count.land(0x7FFFFFFF).reinterpret_as_int()
          #|  let threshold = 100000.0 // 100 ms
          #|  let target_batch_size = loop 1 {
          #|    trial => {
          #|      let single_us = iter_n_microseconds(inner, trial) / trial.to_double()
          #|      let target_batch_size = threshold /
          #|        (if single_us < 1.0 { 1.0 } else { single_us })
          #|      if trial.to_double() * single_us > threshold {
          #|        break target_batch_size
          #|      }
          #|      continue trial * 2
          #|    }
          #|  }
          #|  let batch_size = if target_batch_size < 1.0 {
          #|    1
          #|  } else {
          #|    target_batch_size.ceil().to_int()
          #|  }
          #|  let samples = Array::makei(count, _ => iter_n_microseconds(inner, batch_size) /
          #|    batch_size.to_double())
          #|  samples.sort()
          #|  winsorize(sorted_data=samples, 5.0)
          #|  Summary::new(name?, sorted_data=samples, batch_size) }
        ),
      ),
      "summary": build("iter_count(name?, f, count)"),
      "dump_summaries": build(
        (
          #|\"[\\{self.buffer.to_string()}]\"
        ),
      ),
      "bench_result": build("single_bench("),
      "x": build("1 + 1"),
      "bench_result": build("single_bench("),
      "x": Int(1),
      "bench_obj": build("new()"),
      "x": build("20 * 20"),
      "y": build("30 * 30"),
      "start": build("monotonic_clock_start()"),
      "elapsed": build("monotonic_clock_end(start)"),
      "b": build("new()"),
      "monotonic_clock_end": build(
        (
          #|pub fn monotonic_clock_end(ts : Timestamp) -> Double { let elapsed_secs : Double = instant_elapsed_as_secs_f64(ts)
          #|  elapsed_secs * 1000000.0 }
        ),
      ),
      "new": build(
        (
          #|let buffer = StringBuilder::new()
          #|  let summaries = Array::new()
          #|  { buffer, summaries, _storage: () }
        ),
      ),
      "sum": build("sum(sorted_data)"),
      "min": build("min(sorted_data~)"),
      "max": build("max(sorted_data~)"),
      "mean": build("mean(sorted_data, sum~)"),
      "median": build("median(sorted_data~)"),
      "variance": build("variance(sorted_data, mean~)"),
      "std_dev": build("std_dev(variance~)"),
      "std_dev_pct": build("std_dev_pct(mean~, std_dev~)"),
      "median_abs_dev": build("median_abs_dev(sorted_data, median_=median)"),
      "median_abs_dev_pct": build(
        "median_abs_dev_pct(median~, median_abs_dev~)",
      ),
      "quartiles": build("quartiles(sorted_data~)"),
      "iqr": build("iqr(quartiles~)"),
      "sum": build(
        (
          #|fn sum(data : Array[Double]) -> Double { let mut sum = 0.0
          #|  for i in data {
          #|    sum += i
          #|  }
          #|  sum }
        ),
      ),
      "min": build(
        (
          #|fn min(sorted_data~ : Array[Double]) -> Double { sorted_data[0] }
        ),
      ),
      "max": build(
        (
          #|fn max(sorted_data~ : Array[Double]) -> Double { sorted_data[sorted_data.length() - 1] }
        ),
      ),
      "mean": build(
        (
          #|fn mean(data : Array[Double], sum~ : Double) -> Double { let count = data.length()
          #|  sum / count.to_double() }
        ),
      ),
      "median": build(
        (
          #|fn median(sorted_data~ : Array[Double]) -> Double { percentile(sorted_data~, pct=50.0) }
        ),
      ),
      "variance": build(
        (
          #|fn variance(data : Array[Double], mean~ : Double) -> Double { if data.length() < 2 {
          #|    return 0.0
          #|  }
          #|  let mut v = 0.0
          #|  for i in data {
          #|    let d = i - mean
          #|    v += d * d
          #|  }
          #|  v / (data.length() - 1).to_double() }
        ),
      ),
      "std_dev": build(
        (
          #|fn std_dev(variance~ : Double) -> Double { variance.sqrt() }
        ),
      ),
      "std_dev_pct": build(
        (
          #|fn std_dev_pct(mean~ : Double, std_dev~ : Double) -> Double { if mean == 0.0 {
          #|    return 0.0
          #|  }
          #|  std_dev / mean * 100.0 }
        ),
      ),
      "median_abs_dev": build(
        (
          #|fn median_abs_dev(data : Array[Double], median_~ : Double) -> Double { let abs_devs = data.map(x => (median_ - x).abs())
          #|  abs_devs.sort()
          #|  // https://en.wikipedia.org/wiki/Median_absolute_deviation
          #|  median(sorted_data=abs_devs) * 1.4826 }
        ),
      ),
      "median_abs_dev_pct": build(
        (
          #|fn median_abs_dev_pct(median~ : Double, median_abs_dev~ : Double) -> Double { if median == 0.0 {
          #|    return 0.0
          #|  }
          #|  median_abs_dev / median * 100.0 }
        ),
      ),
      "quartiles": build(
        (
          #|fn quartiles(sorted_data~ : Array[Double]) -> (Double, Double, Double) { let q1 = percentile(sorted_data~, pct=25.0)
          #|  let q2 = percentile(sorted_data~, pct=50.0)
          #|  let q3 = percentile(sorted_data~, pct=75.0)
          #|  (q1, q2, q3) }
        ),
      ),
      "iqr": build(
        (
          #|fn iqr(quartiles~ : (Double, Double, Double)) -> Double { let (q1, _, q3) = quartiles
          #|  q3 - q1 }
        ),
      ),
      "percentile": build(
        (
          #|fn percentile(sorted_data~ : Array[Double], pct~ : Double) -> Double { guard sorted_data.length() > 0
          #|  guard pct >= 0.0 && pct <= 100.0
          #|  if sorted_data.length() == 1 {
          #|    return sorted_data[0]
          #|  }
          #|  if pct == 100.0 {
          #|    return sorted_data[sorted_data.length() - 1]
          #|  }
          #|  let length = (sorted_data.length() - 1).to_double()
          #|  let rank = pct / 100 * length
          #|  let lrank = rank.floor()
          #|  let d = rank - lrank
          #|  let n = lrank.to_int()
          #|  let lo = sorted_data[n]
          #|  let hi = sorted_data[n + 1]
          #|  lo + (hi - lo) * d }
        ),
      ),
      "winsorize": build(
        (
          #|fn winsorize(sorted_data~ : Array[Double], pct : Double) -> Unit { let lo = percentile(sorted_data~, pct~)
          #|  let hi = percentile(sorted_data~, pct=100.0 - pct)
          #|  for i, samp in sorted_data {
          #|    if samp > hi {
          #|      sorted_data[i] = hi
          #|    } else if samp < lo {
          #|      sorted_data[i] = lo
          #|    }
          #|  } }
        ),
      ),
      "data": build("[1.1, 21.4, 2.2, 3.3, 4.5, 12.5, 33.3, 14.4]"),
      "summary": build("Summary::new(sorted_data=data, 3)"),
    }
  },
)

///|
let bigint_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bigint",
  fn(_env, build) {
    {
      "radix_bit_len": Int(32),
      "decimal_ratio": build("0.302 // log10(2)"),
      "karatsuba_threshold": Int(50),
      "from_int": build(
        (
          #|pub fn BigInt::from_int(n : Int) -> BigInt { BigInt::from_int64(n.to_int64()) }
        ),
      ),
      "from_uint": build(
        (
          #|pub fn BigInt::from_uint(n : UInt) -> BigInt { BigInt::from_uint64(n.to_uint64()) }
        ),
      ),
      "from_int64": build(
        (
          #|pub fn BigInt::from_int64(n : Int64) -> BigInt { if n < 0L {
          #|    -BigInt::from_uint64((-n).reinterpret_as_uint64())
          #|  } else {
          #|    BigInt::from_uint64(n.reinterpret_as_uint64())
          #|  } }
        ),
      ),
      "from_uint64": build(
        (
          #|pub fn BigInt::from_uint64(n : UInt64) -> BigInt { if n == 0UL {
          #|    return { limbs: FixedArray::make(1, 0), sign: Positive, len: 1 }
          #|  }
          #|  let limbs = FixedArray::make(64 / radix_bit_len, 0U)
          #|  let mut m = n
          #|  let mut i = 0
          #|  while m > 0 {
          #|    limbs[i] = (m % radix).to_uint()
          #|    m /= radix
          #|    i += 1
          #|  }
          #|  { limbs, sign: Positive, len: i } }
        ),
      ),
      "self_len": build("self.len"),
      "other_len": build("other.len"),
      "limbs": build("FixedArray::make(1 + max(self_len, other_len), 0U)"),
      "a": build("if i < self_len { self.limbs[i].to_uint64() } else { 0 }"),
      "b": build("if i < other_len { other.limbs[i].to_uint64() } else { 0 }"),
      "sum": build("a + b + carry"),
      "self_len": build("self.len"),
      "other_len": build("other.len"),
      "limbs": build("FixedArray::make(max(self_len, other_len), 0U)"),
      "a": build("if i < self_len { self.limbs[i].to_int64() } else { 0 }"),
      "b": build("if i < other_len { other.limbs[i].to_int64() } else { 0 }"),
      "diff": build(
        "a - b - borrow // 0 <= a < radix, 0 <= b < radix, 0 <= borrow <= 1 => -radix <= diff < radix",
      ),
      "ret": build(
        "if self.len < karatsuba_threshold || other.len < karatsuba_threshold {",
      ),
      "grade_school_mul": build(
        (
          #|fn BigInt::grade_school_mul(self : BigInt, other : BigInt) -> BigInt { let self_len = self.len
          #|  let other_len = other.len
          #|  let mut len = self_len + other_len
          #|  let limbs = FixedArray::make(len, 0U)
          #|  for i in 0..<self_len {
          #|    let mut carry = 0UL
          #|    for j = 0; j < other_len || carry != 0; j = j + 1 {
          #|      let product = limbs[i + j].to_uint64() +
          #|        self.limbs[i].to_uint64() *
          #|        (if j < other_len { other.limbs[j].to_uint64() } else { 0 }) +
          #|        carry
          #|      limbs[i + j] = (product % radix).to_uint()
          #|      carry = product / radix
          #|    }
          #|  }
          #|  if limbs[self_len + other_len - 1] == 0 {
          #|    len -= 1
          #|  }
          #|  { limbs, sign: Positive, len } }
        ),
      ),
      "karatsuba_mul": build(
        (
          #|fn BigInt::karatsuba_mul(self : BigInt, other : BigInt) -> BigInt { let half = (max(self.len, other.len) + 1) / 2
          #|  let (xl, xh) = self.split(half)
          #|  let (yl, yh) = other.split(half)
          #|  let p1 = xh * yh
          #|  let p2 = xl * yl
          #|  let p3 = (xh + xl) * (yh + yl)
          #|  (p1 << (radix_bit_len * 2 * half)) +
          #|  ((p3 - p1 - p2) << (radix_bit_len * half)) +
          #|  p2 }
        ),
      ),
      "split": build(
        (
          #|fn BigInt::split(self : BigInt, half : Int) -> (BigInt, BigInt) { if self.len <= half {
          #|    return ({ ..self, sign: Positive }, zero)
          #|  }
          #|  let lower_len = for i = half - 1; i > 0; i = i - 1 {
          #|    if self.limbs[i] > 0 {
          #|      break i + 1
          #|    }
          #|  } else {
          #|    1
          #|  }
          #|  let lower = FixedArray::make(lower_len, 0U)
          #|  lower.unsafe_blit(0, self.limbs, 0, lower_len)
          #|  let upper = FixedArray::make(self.len - half, 0U)
          #|  upper.unsafe_blit(0, self.limbs, half, self.len - half)
          #|  (
          #|    { limbs: lower, sign: Positive, len: lower_len },
          #|    { limbs: upper, sign: Positive, len: self.len - half },
          #|  ) }
        ),
      ),
      "grade_school_div": build(
        (
          #|fn BigInt::grade_school_div(self : BigInt, other : BigInt) -> (BigInt, BigInt) { // Handle edge cases
          #|  if self < other {
          #|    return (zero, self)
          #|  } else if self == other {
          #|    return (one, zero)
          #|  }
          #|  if other.len == 1 {
          #|    let number = other.limbs[0]
          #|    let ret = self.copy()
          #|    if number == 1 {
          #|      return (ret, zero)
          #|    }
          #|    let a = ret.limbs
          #|    let x = number.to_uint64()
          #|    let mut y = 0UL
          #|    for i = self.len - 1; i >= 0; i = i - 1 {
          #|      y = y << radix_bit_len
          #|      y += a[i].to_uint64()
          #|      a[i] = ((y / x) & radix_mask).to_uint()
          #|      y %= x
          #|    }
          #|    if ret.limbs[ret.len - 1] == 0 {
          #|      return (
          #|        { ..ret, len: ret.len - 1 },
          #|        { limbs: FixedArray::make(1, y.to_uint()), sign: Positive, len: 1 },
          #|      )
          #|    }
          #|    return (
          #|      ret,
          #|      { limbs: FixedArray::make(1, y.to_uint()), sign: Positive, len: 1 },
          #|    )
          #|  }
          #|  // Cite: TAOCP Vol. 2, 4.3.1
          #|  let dividend = self
          #|  let divisor = other
          #|  // D1. normalize
          #|  // m = dividend.len - divisor.len
          #|  // left shift dividend & divisor such that
          #|  // - b[b.length() - 1] >= radix / 2
          #|  // - a.length() == self.len + 1
          #|  // where a and b represent the limbs of the adjusted dividend and divisor
          #|  let lshift = max(
          #|    0,
          #|    radix_bit_len - (64 - divisor.limbs[divisor.len - 1].to_int64().clz()),
          #|  )
          #|  let a_len = dividend.len
          #|  let dividend = dividend << lshift
          #|  let divisor = divisor << lshift
          #|  let b_len = divisor.len
          #|  let b = FixedArray::make(b_len, 0UL)
          #|  for i in 0..<b_len {
          #|    b[i] = divisor.limbs[i].to_uint64()
          #|  }
          #|  let a = FixedArray::make(a_len + 1, 0UL)
          #|  for i in 0..<a_len {
          #|    a[i] = dividend.limbs[i].to_uint64()
          #|  } else {
          #|    if dividend.limbs.length() > i {
          #|      a[i] = dividend.limbs[i].to_uint64()
          #|    }
          #|  }
          #|  // invariant : divisor.limbs.last() >= radix / 2
          #|  // if b[b_len - 1] < radix / 2 {
          #|  //   panic()
          #|  // }
          #|  let a_len = a_len + 1
          #|  // a is the adjusted dividend and b is the adjusted divisor
          #|  let v1 = b[b_len - 1]
          #|  let v2 = b[b_len - 2]
          #|  let q = FixedArray::make(a_len - b_len, 0U)
          #|  // D2 - D7 loop through m to 0
          #|  for i = q.length() - 1; i >= 0; i = i - 1 {
          #|    let u0 = a[i + b_len]
          #|    let u1 = a[i + b_len - 1]
          #|    let u2 = a[i + b_len - 2]
          #|    // D3 compute qh
          #|    let mut qh = (u0 * radix + u1) / v1
          #|    if qh * v2 > radix * (u0 * radix + u1 - qh * v1) + u2 {
          #|      qh -= 1
          #|    }
          #|    // D4 divident = divident - qh * divisor
          #|    let mut borrow = 0L
          #|    let mut carry = 0UL
          #|    for j in 0..<b_len {
          #|      carry += qh * b[j]
          #|      borrow += a[i + j].reinterpret_as_int64()
          #|      borrow -= (carry & radix_mask).reinterpret_as_int64()
          #|      a[i + j] = (borrow & radix_mask.reinterpret_as_int64()).reinterpret_as_uint64()
          #|      borrow = borrow >> radix_bit_len
          #|      carry = carry >> radix_bit_len
          #|    }
          #|    borrow = borrow + a[i + b_len].reinterpret_as_int64()
          #|    borrow -= carry.reinterpret_as_int64()
          #|    a[i + b_len] = (borrow & radix_mask.reinterpret_as_int64()).reinterpret_as_uint64()
          #|    borrow = borrow >> radix_bit_len
          #|    if borrow < 0L {
          #|      carry = 0UL
          #|      for j in 0..<b_len {
          #|        carry += a[i + j]
          #|        carry += b[j]
          #|        a[i + j] = carry & radix_mask
          #|        carry = carry >> radix_bit_len
          #|      }
          #|      carry += a[i + b_len]
          #|      a[i + b_len] = carry & radix_mask
          #|      carry = carry >> radix_bit_len
          #|      borrow += carry.reinterpret_as_int64()
          #|      qh -= 1
          #|    }
          #|    q[i] = qh.to_uint()
          #|  }
          #|  let len = if q[q.length() - 1] == 0 { q.length() - 1 } else { q.length() }
          #|  // strip leading zeros
          #|  let mut i = a.length() - 1
          #|  while i >= 0 && a[i] == 0 {
          #|    i -= 1
          #|  }
          #|  if i < 0 {
          #|    i = 1
          #|  } else {
          #|    i += 1
          #|  }
          #|  let modulo = FixedArray::make(i, 0U)
          #|  for j in 0..<i {
          #|    modulo[j] = a[j].to_uint()
          #|  }
          #|  let modulo = { limbs: modulo, sign: Positive, len: i }
          #|  ({ limbs: q, sign: Positive, len }, modulo >> lshift) }
        ),
      ),
      "new_limbs": build("FixedArray::make("),
      "a": build("self.limbs"),
      "r": build("n % radix_bit_len"),
      "lz": build("n / radix_bit_len // number of leading zeros"),
      "r": build("n % radix_bit_len"),
      "lz": build("n / radix_bit_len"),
      "new_limbs": build("FixedArray::make(new_len, 0U)"),
      "new_limbs": build("FixedArray::make(new_len, 0U)"),
      "a": build("self.limbs"),
      "x": build("a[i].to_uint64()"),
      "is_zero": build(
        (
          #|self.len == 1 && self.limbs[0] == 0
        ),
      ),
      "self_len": build("self.len"),
      "other_len": build("other.len"),
      "to_string": build(
        (
          #|// This function first converts the BigInt to a decimal representation, with a radix of 2^(`decimal_radix_bit_len`).
          #|  // Then it converts the decimal representation to a string slot by slot.
          #|  if self.is_zero() {
          #|    return \"0\"
          #|  }
          #|  let decimal_radix_bit_len = 19 - 1 - (1 + radix_bit_len) / 3 // < len(9,223,372,036,854,775,807) - len(2^radix_bit_len). len means the number of digits in decimal.
          #|  let decimal_mask = 10_000_000L // 10^(decimal_radix_bit_len). TODO: compute it when we have power function.
          #|  // The following value should fit well into an Int without precision loss.
          #|  // This is an approximation of the number of slots needed to represent the decimal value.
          #|  let decimal_len = unchecked_double_to_int(
          #|    (self.len * radix_bit_len).to_double() *
          #|    decimal_ratio /
          #|    decimal_radix_bit_len.to_double() +
          #|    1,
          #|  )
          #|  let s = if self.sign == Negative { \"-\" } else { \"\" }
          #|  let v = Array::make(decimal_len, 0L)
          #|  let mut v_idx = 0
          #|  for i = self.len - 1; i >= 0; i = i - 1 {
          #|    let mut x = self.limbs[i].to_int64()
          #|    for j in 0..<v_idx {
          #|      let y = (v[j] << radix_bit_len) | x
          #|      x = y / decimal_mask
          #|      v[j] = y % decimal_mask
          #|    }
          #|    while x > 0L {
          #|      v[v_idx] = x % decimal_mask
          #|      v_idx += 1
          #|      x /= decimal_mask
          #|    }
          #|  }
          #|  let mut ret = \"\"
          #|  for i in 0..<(v_idx - 1) {
          #|    for j in 0..<decimal_radix_bit_len {
          #|      let x = v[i] % 10L
          #|      v[i] /= 10L
          #|      ret = x.to_string() + ret
          #|    }
          #|  }
          #|  let mut x = v[v_idx - 1] // v_idx is at least 1, we check is_zero() at the beginning.
          #|  while x > 0L {
          #|    let y = x % 10L
          #|    x /= 10L
          #|    ret = y.to_string() + ret
          #|  }
          #|  s + ret
        ),
      ),
      "from_string": build(
        (
          #|pub fn BigInt::from_string(input : String) -> BigInt { let len = input.length()
          #|  if len == 0 {
          #|    abort(\"empty string\")
          #|  }
          #|  let sign : Sign = if input.unsafe_charcode_at(0) == '-' {
          #|    Negative
          #|  } else {
          #|    Positive
          #|  }
          #|  let mut b_len = (
          #|      unchecked_double_to_int(len.to_double() / decimal_ratio) +
          #|      1 +
          #|      radix_bit_len
          #|    ) /
          #|    radix_bit_len +
          #|    1
          #|  let b = FixedArray::make(b_len, 0U)
          #|  for
          #|    i in (match sign {
          #|      Negative => 1
          #|      Positive => 0
          #|    })..<input.length() {
          #|    let x = input.unsafe_charcode_at(i) - '0'
          #|    if x < 0 || x > 9 {
          #|      abort(\"invalid character\")
          #|    }
          #|    let mut carry = x.reinterpret_as_uint().to_uint64()
          #|    for j in 0..<b_len {
          #|      carry += b[j].to_uint64() * 10
          #|      b[j] = (carry % radix).to_uint()
          #|      carry /= radix
          #|    }
          #|  }
          #|  while b[b_len - 1] == 0 && b_len > 1 {
          #|    b_len -= 1
          #|  }
          #|  { limbs: b, sign, len: b_len } }
        ),
      ),
      "from_hex": build(
        (
          #|pub fn BigInt::from_hex(input : String) -> BigInt { // WARN: this implementation assumes that `radix_bit_len` is a multiple of 4.
          #|  fn char_from_hex(x : Int) -> UInt {
          #|    (match x {
          #|      '0'..='9' => x - '0'
          #|      'A'..='F' => x + (10 - 'A')
          #|      'a'..='f' => x + (10 - 'a')
          #|      _ => abort(\"invalid character\")
          #|    }).reinterpret_as_uint()
          #|  }
          #|  let len = input.length()
          #|  if len == 0 {
          #|    abort(\"empty string\")
          #|  }
          #|  let (sign, number_len) = if input.unsafe_charcode_at(0) == '-' {
          #|    (Negative, len - 1)
          #|  } else {
          #|    (Positive, len)
          #|  }
          #|  let nb_char = radix_bit_len / 4 // number of char per limb
          #|  let quotient = number_len / nb_char
          #|  let mod = number_len % nb_char
          #|  let mut b_len = if mod == 0 { quotient } else { quotient + 1 }
          #|  let b = FixedArray::make(b_len, 0U)
          #|  if mod != 0 {
          #|    let start = len - quotient * nb_char - mod
          #|    for i in 0..<mod {
          #|      b[b_len - 1] = (b[b_len - 1] << 4) |
          #|        char_from_hex(input.unsafe_charcode_at(start + i))
          #|    }
          #|  }
          #|  for i in 0..<quotient {
          #|    let start = len - (i + 1) * nb_char
          #|    for j in 0..<nb_char {
          #|      b[i] = (b[i] << 4) | char_from_hex(input.unsafe_charcode_at(start + j))
          #|    }
          #|  }
          #|  while b[b_len - 1] == 0 && b_len > 1 {
          #|    b_len -= 1
          #|  }
          #|  { limbs: b, sign, len: b_len } }
        ),
      ),
      "to_hex": build(
        (
          #|pub fn BigInt::to_hex(self : BigInt, uppercase~ : Bool = true) -> String { if self.is_zero() {
          #|    return \"0\"
          #|  }
          #|  // WARN: this implementation assumes that `radix_bit_len` is a multiple of 4.
          #|  let digits_per_limb = radix_bit_len / 4
          #|  let buf = if self.sign is Negative {
          #|    let builder = StringBuilder::new(size_hint=self.len * digits_per_limb + 2)
          #|    builder.write_char('-')
          #|    builder
          #|  } else {
          #|    StringBuilder::new(size_hint=self.len * digits_per_limb)
          #|  }
          #|  for i = self.len - 1; i >= 0; i = i - 1 { // TODO: reverse iteration would be a bit faster.
          #|    // split the limb into 4-bit chunks
          #|    let mut x = self.limbs[i]
          #|    let digits = FixedArray::make(digits_per_limb, '0')
          #|    let mut idx = 0
          #|    while x > 0 {
          #|      let y = x % 16
          #|      x /= 16
          #|      digits[idx] = if y < 10 {
          #|        (y.reinterpret_as_int() + '0'.to_int()).unsafe_to_char()
          #|      } else if uppercase {
          #|        (y.reinterpret_as_int() - 10 + 'A'.to_int()).unsafe_to_char()
          #|      } else {
          #|        (y.reinterpret_as_int() - 10 + 'a'.to_int()).unsafe_to_char()
          #|      }
          #|      idx += 1
          #|    }
          #|    if i != self.len - 1 {
          #|      idx = digits_per_limb
          #|    }
          #|    for j in 0..<idx {
          #|      buf.write_char(digits[idx - 1 - j])
          #|    }
          #|  }
          #|  buf.to_string() }
        ),
      ),
      "copy": build(
        (
          #|let new_limbs = FixedArray::make(self.len, 0U)
          #|  new_limbs.unsafe_blit(0, self.limbs, 0, self.len)
          #|  { limbs: new_limbs, sign: self.sign, len: self.len }
        ),
      ),
      "pow": build(
        (
          #|pub fn BigInt::pow(self : BigInt, exp : BigInt, modulus? : BigInt) -> BigInt { if exp.sign == Negative {
          #|    abort(\"negative exponent\")
          #|  }
          #|  match modulus {
          #|    None => {
          #|      let mut result = 1N
          #|      let mut base = self
          #|      let mut exp = exp
          #|      while exp > 0 {
          #|        if exp % 2 == 1 {
          #|          result = result * base
          #|        }
          #|        base = base * base
          #|        exp = exp / 2
          #|      }
          #|      result
          #|    }
          #|    Some(modulus) => {
          #|      guard !(modulus.is_zero() || modulus.sign == Negative)
          #|      let mut result = 1N
          #|      let mut base = self
          #|      let mut exp = exp
          #|      while exp > 0 {
          #|        if exp % 2 == 1 {
          #|          result = result * base % modulus
          #|        }
          #|        base = base * base % modulus
          #|        exp = exp / 2
          #|      }
          #|      result
          #|    }
          #|  } }
        ),
      ),
      "from_octets": build(
        (
          #|pub fn BigInt::from_octets(input : Bytes, signum~ : Int = 1) -> BigInt { let len = input.length() // number of bytes
          #|  if signum == 0 {
          #|    return zero
          #|  } else if signum < 0 {
          #|    return -BigInt::from_octets(input)
          #|  }
          #|  if len == 0 {
          #|    abort(\"empty octet string\")
          #|  }
          #|  let div = len * 8 / radix_bit_len
          #|  let mod = len * 8 % radix_bit_len // number of bits in the first limb
          #|  let limbs_len = if mod == 0 { div } else { div + 1 }
          #|  let limbs = FixedArray::make(limbs_len, 0U)
          #|  // head at most significant limb
          #|  for i in 0..<(mod / 8) {
          #|    limbs[limbs_len - 1] = (limbs[limbs_len - 1] << 8) | input[i].to_uint()
          #|  }
          #|  let byte_per_limb = radix_bit_len / 8
          #|  // tail
          #|  for i in 0..<div {
          #|    for j in 0..<byte_per_limb {
          #|      let bytes_idx = len - byte_per_limb - i * byte_per_limb + j
          #|      limbs[i] = (limbs[i] << 8) | input[bytes_idx].to_uint()
          #|    }
          #|  }
          #|  if limbs[limbs_len - 1] == 0 {
          #|    { limbs, sign: Positive, len: max(1, limbs_len - 1) }
          #|  } else {
          #|    { limbs, sign: Positive, len: limbs_len }
          #|  } }
        ),
      ),
      "to_octets": build(
        (
          #|pub fn BigInt::to_octets(self : BigInt, length? : Int) -> Bytes { let length = match length {
          #|    None => 1
          #|    Some(l) => if l <= 0 { abort(\"negative length\") } else { l }
          #|  }
          #|  if self.is_zero() {
          #|    return Bytes::new(max(1, length))
          #|  }
          #|  if self.sign == Negative {
          #|    abort(\"negative BigInt\")
          #|  }
          #|  let head_bits = 32 - self.limbs[self.len - 1].reinterpret_as_int().clz()
          #|  let tail_len = self.len - 1
          #|  let len = (head_bits + 7) / 8 + tail_len * (radix_bit_len / 8)
          #|  let len = max(length, len)
          #|  let result = FixedArray::make(len, Byte::default())
          #|  for i = 0; i < len && i / 4 < self.len; i = i + 1 {
          #|    result[len - 1 - i] = ((self.limbs[i / 4] >> (i % 4 * 8)) & 0xffU)
          #|      .reinterpret_as_int()
          #|      .to_byte()
          #|  }
          #|  unsafe_fixedarray_to_bytes(result) }
        ),
      ),
      "max_length": build("if self.limbs.length() < other.limbs.length() {"),
      "x_limbs": build("FixedArray::make(max_length, 0U)"),
      "y_limbs": build("FixedArray::make(max_length, 0U)"),
      "new_sign": build("if x_limbs[x_limbs.length() - 1] == 0xFFFFFFFFU {"),
      "limbs": build("FixedArray::make(max_length - 1, 0U)"),
      "max_length": build("if self.limbs.length() < other.limbs.length() {"),
      "x_limbs": build("FixedArray::make(max_length, 0U)"),
      "y_limbs": build("FixedArray::make(max_length, 0U)"),
      "new_sign": build("if x_limbs[x_limbs.length() - 1] == 0xFFFFFFFFU {"),
      "limbs": build("FixedArray::make(max_length - 1, 0U)"),
      "max_length": build("if self.limbs.length() < other.limbs.length() {"),
      "x_limbs": build("FixedArray::make(max_length, 0U)"),
      "y_limbs": build("FixedArray::make(max_length, 0U)"),
      "new_sign": build("if x_limbs[x_limbs.length() - 1] == 0xFFFFFFFFU {"),
      "limbs": build("FixedArray::make(max_length - 1, 0U)"),
      "to_int": build(
        (
          #|self.to_uint().reinterpret_as_int()
        ),
      ),
      "to_uint": build(
        (
          #|let value = if self.sign == Negative { (1N << 32) + self } else { self }
          #|  value.limbs[0]
        ),
      ),
      "to_int64": build(
        (
          #|self.to_uint64().reinterpret_as_int64()
        ),
      ),
      "to_uint64": build(
        (
          #|let value = if self.sign == Negative { (1N << 64) + self } else { self }
          #|  let len = 64 / radix_bit_len
          #|  let len = if value.len < len { value.len } else { len }
          #|  let mut result = 0UL
          #|  for i = len - 1; i >= 0; i = i - 1 {
          #|    result = result << radix_bit_len
          #|    result = result | (value.limbs[i].to_uint64() & radix_mask)
          #|  }
          #|  result
        ),
      ),
      "bit_length": build(
        (
          #|if self.len == 0 {
          #|    return 0
          #|  }
          #|  let mut bit_length = (self.len - 1) * radix_bit_len +
          #|    (radix_bit_len - self.limbs[self.len - 1].clz())
          #|  if self.sign == Negative {
          #|    // check if this number is a power of two
          #|    let mut pow2 = self.limbs[0].popcnt() == 1
          #|    for i = 1; i < self.len && pow2; i = i + 1 {
          #|      pow2 = self.limbs[i] == 0
          #|    }
          #|    if pow2 {
          #|      bit_length -= 1
          #|    }
          #|  }
          #|  bit_length
        ),
      ),
      "ctz": build(
        (
          #|if self.is_zero() {
          #|    return 0
          #|  }
          #|  // Find first non-zero limb
          #|  let mut i = 0
          #|  while i < self.len && self.limbs[i] == 0 {
          #|    i = i + 1
          #|  }
          #|  radix_bit_len * i + self.limbs[i].ctz()
        ),
      ),
      "can_convert_to_int": build(
        (
          #|fn can_convert_to_int(x : BigInt) -> Bool { // bigint range from [-(2^32 - 1), 2^32 - 1] has len == 1. But here we only
          #|  // want bigint from [-2^31, 2^31 - 1]
          #|  x.len == 1 &&
          #|  (if x.sign == Negative {
          #|    x.limbs[0] <= 0x80000000
          #|  } else {
          #|    x.limbs[0] < 0x80000000
          #|  }) }
        ),
      ),
      "can_convert_to_int64": build(
        (
          #|fn can_convert_to_int64(x : BigInt) -> Bool { x.len <= 2 &&
          #|  (if x.sign == Negative {
          #|    x.limbs[1] < 0x80000000 || (x.limbs[1] == 0x80000000 && x.limbs[0] == 0)
          #|  } else {
          #|    x.limbs[1] < 0x80000000
          #|  }) }
        ),
      ),
      "is_neg": build(
        (
          #|fn is_neg(x : BigInt) -> Bool { x.sign == Negative }
        ),
      ),
      "limbs": build(
        (
          #|self.limbs.iter().take(self.len)
        ),
      ),
      "zero": build("0N"),
      "from_string": build(
        (
          #|pub fn BigInt::from_string(str : String) -> BigInt { if str.length() == 0 {
          #|    abort(\"empty string\")
          #|  }
          #|  BigInt::js_from_string(str) }
        ),
      ),
      "from_octets": build(
        (
          #|pub fn BigInt::from_octets(octets : Bytes, signum~ : Int = 1) -> BigInt { if signum < 0 {
          #|    return -1N * BigInt::from_octets(octets, signum=1)
          #|  }
          #|  if signum == 0 {
          #|    return 0N
          #|  }
          #|  let str = StringBuilder::new()
          #|  str.write_string(\"0x\")
          #|  for octet in octets {
          #|    str.write_string(hex2(octet))
          #|  }
          #|  BigInt::from_string(str.to_string()) }
        ),
      ),
      "to_octets": build(
        (
          #|pub fn BigInt::to_octets(self : BigInt, length? : Int) -> Bytes { if self < 0 {
          #|    abort(\"negative BigInt\")
          #|  }
          #|  if self == 0 {
          #|    return match length {
          #|      Some(len) => Bytes::make(len, 0)
          #|      None => [0]
          #|    }
          #|  }
          #|  let buf = []
          #|  loop self {
          #|    v =>
          #|      if v > 0 {
          #|        buf.push(v.to_byte())
          #|        continue v >> 8
          #|      }
          #|  }
          #|  let buf_len = buf.length()
          #|  match length {
          #|    Some(len) => {
          #|      if len <= 0 {
          #|        abort(\"negative length\")
          #|      }
          #|      if len > buf_len {
          #|        Bytes::makei(len, i => {
          #|          let padding = len - buf_len
          #|          if i < padding {
          #|            0
          #|          } else {
          #|            buf[buf_len - (i - padding) - 1]
          #|          }
          #|        })
          #|      } else {
          #|        Bytes::makei(buf_len, i => buf[buf_len - i - 1])
          #|      }
          #|    }
          #|    None => Bytes::makei(buf_len, i => buf[buf_len - i - 1])
          #|  } }
        ),
      ),
      "to_uint64": build(
        (
          #|let hi = (self >> 32).to_uint()
          #|  let lo = self.to_uint()
          #|  (hi.to_uint64() << 32) | lo.to_uint64()
        ),
      ),
      "to_int64": build(
        (
          #|let hi = (self >> 32).to_uint()
          #|  let lo = self.to_uint()
          #|  (hi.to_int64() << 32) | lo.to_int64()
        ),
      ),
      "limbs": build(
        (
          #|guard !self.is_zero() else { Iter::singleton(0) }
          #|  Iter::new(yield_ => for n = self * BigInt::from_int(self.signum())
          #|                          n > 0
          #|                          n = n >> 32 {
          #|    let limb = n.to_uint()
          #|    guard yield_(limb) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  })
        ),
      ),
      "asr": build(
        (
          #|pub fn BigInt::asr(self : BigInt, n : Int) -> BigInt { self >> n }
        ),
      ),
      "shl": build(
        (
          #|pub fn BigInt::shl(self : BigInt, n : Int) -> BigInt { self << n }
        ),
      ),
      "lsl": build(
        (
          #|pub fn BigInt::lsl(self : BigInt, n : Int) -> BigInt { self << n }
        ),
      ),
      "shr": build(
        (
          #|pub fn BigInt::shr(self : BigInt, n : Int) -> BigInt { self >> n }
        ),
      ),
      "equal_int": build(
        (
          #|pub fn BigInt::equal_int(self : BigInt, other : Int) -> Bool { can_convert_to_int(self) && self.to_int() == other }
        ),
      ),
      "equal_int64": build(
        (
          #|pub fn BigInt::equal_int64(self : BigInt, other : Int64) -> Bool { can_convert_to_int64(self) && self.to_int64() == other }
        ),
      ),
      "compare_int": build(
        (
          #|pub fn BigInt::compare_int(self : BigInt, other : Int) -> Int { guard can_convert_to_int(self) else {
          #|    return if is_neg(self) { -1 } else { 1 }
          #|  }
          #|  let self = self.to_int()
          #|  Int::compare(self, other) }
        ),
      ),
      "compare_int64": build(
        (
          #|pub fn BigInt::compare_int64(self : BigInt, other : Int64) -> Int { guard can_convert_to_int64(self) else {
          #|    return if is_neg(self) { -1 } else { 1 }
          #|  }
          #|  let self = self.to_int64()
          #|  Int64::compare(self, other) }
        ),
      ),
      "signum": build(
        (
          #|if self.is_zero() {
          #|    0
          #|  } else if is_neg(self) {
          #|    -1
          #|  } else {
          #|    1
          #|  }
        ),
      ),
      "to_uint16": build(
        (
          #|self.to_int().to_uint16()
        ),
      ),
      "to_int16": build(
        (
          #|self.to_int().to_int16()
        ),
      ),
    }
  },
)

///|
let bool_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/bool", fn(
  _env,
  build,
) {
  {
    "to_int": build(
      (
        #|if self {
        #|    1
        #|  } else {
        #|    0
        #|  }
      ),
    ),
    "to_int64": build(
      (
        #|if self {
        #|    1
        #|  } else {
        #|    0
        #|  }
      ),
    ),
    "to_uint": build(
      (
        #|if self {
        #|    1
        #|  } else {
        #|    0
        #|  }
      ),
    ),
    "to_uint64": build(
      (
        #|if self {
        #|    1
        #|  } else {
        #|    0
        #|  }
      ),
    ),
    "to_uint16": build(
      (
        #|if self {
        #|    1
        #|  } else {
        #|    0
        #|  }
      ),
    ),
    "to_int16": build(
      (
        #|if self {
        #|    1
        #|  } else {
        #|    0
        #|  }
      ),
    ),
  }
})

///|
let buffer_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/buffer",
  fn(_env, build) {
    {
      "grow_if_necessary": build(
        (
          #|fn grow_if_necessary(self : T, required : Int) -> Unit { let start = if self.data.length() <= 0 { 1 } else { self.data.length() }
          #|  let enough_space = for space = start {
          #|    if space >= required {
          #|      break space
          #|    }
          #|    continue space * 2
          #|  }
          #|  if enough_space != self.data.length() {
          #|    let new_data = FixedArray::make(enough_space, Byte::default())
          #|    new_data.unsafe_blit(0, self.data, 0, self.len)
          #|    self.data = new_data
          #|  } }
        ),
      ),
      "length": build(
        (
          #|self.len
        ),
      ),
      "is_empty": build(
        (
          #|self.len == 0
        ),
      ),
      "contents": build(
        (
          #|@bytes.from_fixedarray(self.data, len=self.len)
        ),
      ),
      "new": build(
        (
          #|pub fn new(size_hint~ : Int = 0) -> T { let initial = if size_hint < 1 { 1 } else { size_hint }
          #|  let data = FixedArray::make(initial, Byte::default())
          #|  { data, len: 0, initial_data: data } }
        ),
      ),
      "from_bytes": build(
        (
          #|pub fn from_bytes(bytes : Bytes) -> T { let val_len = bytes.length()
          #|  let buf = new(size_hint=val_len)
          #|  // inline write_bytes, skip grow_if_necessary check
          #|  // SAFETY: known bytes size
          #|  buf.data.blit_from_bytes(0, bytes, 0, val_len)
          #|  buf.len = val_len
          #|  buf }
        ),
      ),
      "from_array": build(
        (
          #|pub fn from_array(arr : Array[Byte]) -> T { let buf = new(size_hint=arr.length())
          #|  for byte in arr {
          #|    // inline write_byte, skip grow_if_necessary check
          #|    // SAFETY: known array size
          #|    buf.data[buf.len] = byte
          #|    buf.len += 1
          #|  }
          #|  buf }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn from_iter(iter : Iter[Byte]) -> T { let buf = new()
          #|  let mut capacity = buf.data.length()
          #|  for byte in iter {
          #|    // inline write_byte and grow_if_necessary
          #|    // only call grow_if_necessary when necessary
          #|    if buf.len == capacity {
          #|      buf.grow_if_necessary(capacity + 1)
          #|      capacity = buf.data.length()
          #|    }
          #|    buf.data[buf.len] = byte
          #|    buf.len += 1
          #|  }
          #|  buf }
        ),
      ),
      "write_uint64_be": build(
        (
          #|pub fn write_uint64_be(self : T, value : UInt64) -> Unit { self.write_byte((value >> 56).to_byte())
          #|  self.write_byte((value >> 48).to_byte())
          #|  self.write_byte((value >> 40).to_byte())
          #|  self.write_byte((value >> 32).to_byte())
          #|  self.write_byte((value >> 24).to_byte())
          #|  self.write_byte((value >> 16).to_byte())
          #|  self.write_byte((value >> 8).to_byte())
          #|  self.write_byte(value.to_byte()) }
        ),
      ),
      "write_uint64_le": build(
        (
          #|pub fn write_uint64_le(self : T, value : UInt64) -> Unit { self.write_byte(value.to_byte())
          #|  self.write_byte((value >> 8).to_byte())
          #|  self.write_byte((value >> 16).to_byte())
          #|  self.write_byte((value >> 24).to_byte())
          #|  self.write_byte((value >> 32).to_byte())
          #|  self.write_byte((value >> 40).to_byte())
          #|  self.write_byte((value >> 48).to_byte())
          #|  self.write_byte((value >> 56).to_byte()) }
        ),
      ),
      "write_int64_be": build(
        (
          #|pub fn write_int64_be(self : T, value : Int64) -> Unit { self.write_uint64_be(value.reinterpret_as_uint64()) }
        ),
      ),
      "write_int64_le": build(
        (
          #|pub fn write_int64_le(self : T, value : Int64) -> Unit { self.write_uint64_le(value.reinterpret_as_uint64()) }
        ),
      ),
      "write_uint_be": build(
        (
          #|pub fn write_uint_be(self : T, value : UInt) -> Unit { self.write_byte((value >> 24).to_byte())
          #|  self.write_byte((value >> 16).to_byte())
          #|  self.write_byte((value >> 8).to_byte())
          #|  self.write_byte(value.to_byte()) }
        ),
      ),
      "write_uint_le": build(
        (
          #|pub fn write_uint_le(self : T, value : UInt) -> Unit { self.write_byte(value.to_byte())
          #|  self.write_byte((value >> 8).to_byte())
          #|  self.write_byte((value >> 16).to_byte())
          #|  self.write_byte((value >> 24).to_byte()) }
        ),
      ),
      "write_int_be": build(
        (
          #|pub fn write_int_be(self : T, value : Int) -> Unit { self.write_uint_be(value.reinterpret_as_uint()) }
        ),
      ),
      "write_int_le": build(
        (
          #|pub fn write_int_le(self : T, value : Int) -> Unit { self.write_uint_le(value.reinterpret_as_uint()) }
        ),
      ),
      "write_double_be": build(
        (
          #|pub fn write_double_be(self : T, value : Double) -> Unit { self.write_uint64_be(value.reinterpret_as_uint64()) }
        ),
      ),
      "write_double_le": build(
        (
          #|pub fn write_double_le(self : T, value : Double) -> Unit { self.write_uint64_le(value.reinterpret_as_uint64()) }
        ),
      ),
      "write_float_be": build(
        (
          #|pub fn write_float_be(self : T, value : Float) -> Unit { self.write_uint_be(value.reinterpret_as_uint()) }
        ),
      ),
      "write_float_le": build(
        (
          #|pub fn write_float_le(self : T, value : Float) -> Unit { self.write_uint_le(value.reinterpret_as_uint()) }
        ),
      ),
      "write_object": build(
        (
          #|pub fn write_object(self : T, value : &Show) -> Unit { self.write_string(value.to_string()) }
        ),
      ),
      "write_bytes": build(
        (
          #|pub fn write_bytes(self : T, value : Bytes) -> Unit { let val_len = value.length()
          #|  self.grow_if_necessary(self.len + val_len)
          #|  self.data.blit_from_bytes(self.len, value, 0, val_len)
          #|  self.len += val_len }
        ),
      ),
      "write_bytesview": build(
        (
          #|pub fn write_bytesview(self : T, value : @bytes.View) -> Unit { let val_len = value.length()
          #|  self.grow_if_necessary(self.len + val_len)
          #|  self.data.blit_from_bytes(
          #|    self.len,
          #|    value.data(),
          #|    value.start_offset(),
          #|    value.length(),
          #|  )
          #|  self.len += val_len }
        ),
      ),
      "write_stringview": build(
        (
          #|pub fn write_stringview(self : T, value : @string.View) -> Unit { let len = value.length()
          #|  self.grow_if_necessary(self.len + len * 2)
          #|  for i = 0, j = self.len; i < len; i = i + 1, j = j + 2 {
          #|    let c = value.unsafe_charcode_at(i).reinterpret_as_uint()
          #|    self.data[j] = (c & 0xff).to_byte()
          #|    self.data[j + 1] = (c >> 8).to_byte()
          #|  }
          #|  self.len += len * 2 }
        ),
      ),
      "inc": build("self.data.set_utf16le_char(self.len, value)"),
      "write_byte": build(
        (
          #|pub fn write_byte(self : T, value : Byte) -> Unit { self.grow_if_necessary(self.len + 1)
          #|  self.data[self.len] = value
          #|  self.len += 1 }
        ),
      ),
      "write_iter": build(
        (
          #|pub fn write_iter(self : T, iter : Iter[Byte]) -> Unit { for byte in iter {
          #|    self.write_byte(byte)
          #|  } }
        ),
      ),
      "reset": build(
        (
          #|self.data = self.initial_data
          #|  self.len = 0
        ),
      ),
      "to_bytes": build(
        (
          #|@bytes.from_fixedarray(self.data, len=self.len)
        ),
      ),
    }
  },
)

///|
let builtin_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/builtin",
  fn(_env, build) {
    {
      "next": build("i + step"),
      "next": build("i + step"),
      "next": build("i + step"),
      "next": build("i + step"),
      "result": build("[]"),
      "result": build("[]"),
      "join": build(
        (
          #|pub fn Iter::join(self : Iter[String], sep : String) -> String { let buf = StringBuilder::new()
          #|  let mut first = true
          #|  for str in self {
          #|    if first {
          #|      first = false
          #|    } else {
          #|      buf.write_string(sep)
          #|    }
          #|    buf.write_string(str)
          #|  }
          #|  buf.to_string() }
        ),
      ),
      "result": build("Map::new()"),
      "key": build("f(element)"),
      "_": build("self"),
      "len": build("self.length()"),
      "end": build("match end {"),
      "view": build("arr[1:4]"),
      "to_int64": build(
        (
          #|MyInt64::from_double(self).to_int64()
        ),
      ),
      "to_uint64": build(
        (
          #|MyInt64::from_double_unsigned(self).to_uint64()
        ),
      ),
      "t0": build("self.0.compare(other.0)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t6": build("self.6.compare(other.6)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t6": build("self.6.compare(other.6)"),
      "t7": build("self.7.compare(other.7)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t6": build("self.6.compare(other.6)"),
      "t7": build("self.7.compare(other.7)"),
      "t8": build("self.8.compare(other.8)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t6": build("self.6.compare(other.6)"),
      "t7": build("self.7.compare(other.7)"),
      "t8": build("self.8.compare(other.8)"),
      "t9": build("self.9.compare(other.9)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t6": build("self.6.compare(other.6)"),
      "t7": build("self.7.compare(other.7)"),
      "t8": build("self.8.compare(other.8)"),
      "t9": build("self.9.compare(other.9)"),
      "t10": build("self.10.compare(other.10)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t6": build("self.6.compare(other.6)"),
      "t7": build("self.7.compare(other.7)"),
      "t8": build("self.8.compare(other.8)"),
      "t9": build("self.9.compare(other.9)"),
      "t10": build("self.10.compare(other.10)"),
      "t11": build("self.11.compare(other.11)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t6": build("self.6.compare(other.6)"),
      "t7": build("self.7.compare(other.7)"),
      "t8": build("self.8.compare(other.8)"),
      "t9": build("self.9.compare(other.9)"),
      "t10": build("self.10.compare(other.10)"),
      "t11": build("self.11.compare(other.11)"),
      "t12": build("self.12.compare(other.12)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t6": build("self.6.compare(other.6)"),
      "t7": build("self.7.compare(other.7)"),
      "t8": build("self.8.compare(other.8)"),
      "t9": build("self.9.compare(other.9)"),
      "t10": build("self.10.compare(other.10)"),
      "t11": build("self.11.compare(other.11)"),
      "t12": build("self.12.compare(other.12)"),
      "t13": build("self.13.compare(other.13)"),
      "t0": build("self.0.compare(other.0)"),
      "t1": build("self.1.compare(other.1)"),
      "t2": build("self.2.compare(other.2)"),
      "t3": build("self.3.compare(other.3)"),
      "t4": build("self.4.compare(other.4)"),
      "t5": build("self.5.compare(other.5)"),
      "t6": build("self.6.compare(other.6)"),
      "t7": build("self.7.compare(other.7)"),
      "t8": build("self.8.compare(other.8)"),
      "t9": build("self.9.compare(other.9)"),
      "t10": build("self.10.compare(other.10)"),
      "t11": build("self.11.compare(other.11)"),
      "t12": build("self.12.compare(other.12)"),
      "t13": build("self.13.compare(other.13)"),
      "t14": build("self.14.compare(other.14)"),
      "len": build("arr.length()"),
      "arr2": build("Array::make_uninit(len)"),
      "arr": build("Array::make_uninit(len)"),
      "len": build("self.length()"),
      "len": build("self.length()"),
      "len": build("self.length()"),
      "self_len": build("self.length()"),
      "other_len": build("other.length()"),
      "len_self": build("self.length()"),
      "len_other": build("other.length()"),
      "cmp": build("len_self.compare(len_other)"),
      "cmp": build("self.unsafe_get(i).compare(other.unsafe_get(i))"),
      "result": build("Array::make_uninit(self.length() + other.length())"),
      "len": build("self.length()"),
      "len": build("self.length()"),
      "arr": build("Array::make_uninit(self.length())"),
      "arr": build("Array::make_uninit(self.length())"),
      "arr": build("[]"),
      "len": build("self.length()"),
      "temp": build("self.unsafe_get(i)"),
      "len": build("self.length()"),
      "arr": build("Array::make_uninit(len)"),
      "len": build("self.length()"),
      "v1": build("Array::make_uninit(index)"),
      "v2": build("Array::make_uninit(self.length() - index)"),
      "v": build("Array::make_uninit(self.length() - prefix.length())"),
      "v": build("Array::make_uninit(self.length() - suffix.length())"),
      "len": build("self.length() - suffix.length()"),
      "len": build("self.length()"),
      "h": build("i + (j - i) / 2"),
      "len": build("self.length()"),
      "h": build("i + (j - i) / 2"),
      "len": build("self.length()"),
      "temp": build("self.unsafe_get(i)"),
      "len": build("self.length()"),
      "item": build("self.unsafe_get(i)"),
      "len": build("self.length()"),
      "res": build("Array::make_uninit(len)"),
      "v": build("Array::new(capacity=self.length() * times)"),
      "len": build("self.length()"),
      "v": build("[]"),
      "indices": build("[]"),
      "chunks": build("[]"),
      "chunk": build("Array::new(capacity=size)"),
      "chunks": build("[]"),
      "chunk": build("[]"),
      "len": build("self.length() - size + 1"),
      "windows": build("Array::new(capacity=len)"),
      "chunks": build("[]"),
      "chunk": build("[]"),
      "buf": build("self.buffer()"),
      "len": build("self.length()"),
      "val": build("buf[read_idx]"),
      "len": build("self.length()"),
      "len": build("self.length()"),
      "h": build("i + (j - i) / 2"),
      "len": build("self.length()"),
      "h": build("i + (j - i) / 2"),
      "arr": build("[]"),
      "add_hi_lo": build(
        (
          #|fn MyInt64::add_hi_lo(self : MyInt64, bhi : Int, blo : Int) -> MyInt64 { let { hi: ahi, lo: alo } = self
          #|  let lo = alo + blo
          #|  let s = lo >> 31
          #|  let as_ = alo >> 31
          #|  let bs = blo >> 31
          #|  let c = ((as_ & bs) | (s.lnot() & (as_ ^ bs))) & 1
          #|  let hi = ahi + bhi + c
          #|  { hi, lo } }
        ),
      ),
      "ahi": build("ahi.reinterpret_as_uint()"),
      "alo": build("alo.reinterpret_as_uint()"),
      "bhi": build("bhi.reinterpret_as_uint()"),
      "blo": build("blo.reinterpret_as_uint()"),
      "a48": build("ahi >> 16"),
      "a32": build("ahi & 0xffff"),
      "a16": build("alo >> 16"),
      "a00": build("alo & 0xffff"),
      "b48": build("bhi >> 16"),
      "b32": build("bhi & 0xffff"),
      "b16": build("blo >> 16"),
      "b00": build("blo & 0xffff"),
      "c00": build("a00 * b00"),
      "c16": build("c00 >> 16"),
      "c00": build("c00 & 0xffff"),
      "c16": build("c16 + a16 * b00"),
      "c32": build("c16 >> 16"),
      "c16": build("c16 & 0xffff"),
      "c16": build("c16 + a00 * b16"),
      "c32": build("c32 + (c16 >> 16)"),
      "c16": build("c16 & 0xffff"),
      "c32": build("c32 + a32 * b00"),
      "c48": build("c32 >> 16"),
      "c32": build("c32 & 0xffff"),
      "c32": build("c32 + a16 * b16"),
      "c48": build("c48 + (c32 >> 16)"),
      "c32": build("c32 & 0xffff"),
      "c32": build("c32 + a00 * b32"),
      "c48": build("c48 + (c32 >> 16)"),
      "c32": build("c32 & 0xffff"),
      "c48": build("c48 + a48 * b00 + a32 * b16 + a16 * b32 + a00 * b48"),
      "c48": build("c48 & 0xffff"),
      "exports": build("get_int64_wasm_helper()"),
      "lo": build("(exports.div_s)(alo, ahi, blo, bhi)"),
      "hi": build("(exports.get_high)()"),
      "div_u": build(
        (
          #|fn MyInt64::div_u(self : MyInt64, other : MyInt64) -> MyInt64 { let exports = get_int64_wasm_helper()
          #|  let { hi: ahi, lo: alo } = self
          #|  let { hi: bhi, lo: blo } = other
          #|  let lo = (exports.div_u)(alo, ahi, blo, bhi)
          #|  let hi = (exports.get_high)()
          #|  { hi, lo } }
        ),
      ),
      "exports": build("get_int64_wasm_helper()"),
      "lo": build("(exports.rem_s)(alo, ahi, blo, bhi)"),
      "hi": build("(exports.get_high)()"),
      "mod_u": build(
        (
          #|fn MyInt64::mod_u(self : MyInt64, other : MyInt64) -> MyInt64 { let exports = get_int64_wasm_helper()
          #|  let { hi: ahi, lo: alo } = self
          #|  let { hi: bhi, lo: blo } = other
          #|  let lo = (exports.rem_u)(alo, ahi, blo, bhi)
          #|  let hi = (exports.get_high)()
          #|  { hi, lo } }
        ),
      ),
      "lnot": build(
        (
          #|{ hi: self.hi.lnot(), lo: self.lo.lnot() }
        ),
      ),
      "land": build(
        (
          #|fn MyInt64::land(self : MyInt64, other : MyInt64) -> MyInt64 { { hi: self.hi & other.hi, lo: self.lo & other.lo } }
        ),
      ),
      "lor": build(
        (
          #|fn MyInt64::lor(self : MyInt64, other : MyInt64) -> MyInt64 { { hi: self.hi | other.hi, lo: self.lo | other.lo } }
        ),
      ),
      "lxor": build(
        (
          #|fn MyInt64::lxor(self : MyInt64, other : MyInt64) -> MyInt64 { { hi: self.hi ^ other.hi, lo: self.lo ^ other.lo } }
        ),
      ),
      "lsl": build(
        (
          #|fn MyInt64::lsl(self : MyInt64, shift : Int) -> MyInt64 { let shift = shift & 63
          #|  if shift == 0 {
          #|    self
          #|  } else if shift < 32 {
          #|    let { hi, lo } = self
          #|    let hi = hi.reinterpret_as_uint()
          #|    let lo = lo.reinterpret_as_uint()
          #|    let hi = (hi << shift) | (lo >> (32 - shift))
          #|    let lo = lo << shift
          #|    { hi: hi.reinterpret_as_int(), lo: lo.reinterpret_as_int() }
          #|  } else {
          #|    { hi: self.lo << (shift - 32), lo: 0 }
          #|  } }
        ),
      ),
      "lsr": build(
        (
          #|fn MyInt64::lsr(self : MyInt64, shift : Int) -> MyInt64 { let shift = shift & 63
          #|  if shift == 0 {
          #|    self
          #|  } else if shift < 32 {
          #|    {
          #|      hi: (self.hi.reinterpret_as_uint() >> shift).reinterpret_as_int(),
          #|      lo: (self.lo.reinterpret_as_uint() >> shift).reinterpret_as_int() |
          #|      (self.hi << (32 - shift)),
          #|    }
          #|  } else {
          #|    {
          #|      hi: 0,
          #|      lo: (self.hi.reinterpret_as_uint() >> (shift - 32)).reinterpret_as_int(),
          #|    }
          #|  } }
        ),
      ),
      "asr": build(
        (
          #|fn MyInt64::asr(self : MyInt64, shift : Int) -> MyInt64 { let shift = shift & 63
          #|  if shift == 0 {
          #|    self
          #|  } else if shift < 32 {
          #|    {
          #|      hi: self.hi >> shift,
          #|      lo: (self.lo.reinterpret_as_uint() >> shift).reinterpret_as_int() |
          #|      (self.hi << (32 - shift)),
          #|    }
          #|  } else {
          #|    { hi: self.hi >> 31, lo: self.hi >> (shift - 32) }
          #|  } }
        ),
      ),
      "clz": build(
        (
          #|if self.hi != 0 {
          #|    self.hi.clz()
          #|  } else {
          #|    32 + self.lo.clz()
          #|  }
        ),
      ),
      "ctz": build(
        (
          #|if self.lo != 0 {
          #|    self.lo.ctz()
          #|  } else {
          #|    32 + self.hi.ctz()
          #|  }
        ),
      ),
      "popcnt": build(
        (
          #|self.hi.popcnt() + self.lo.popcnt()
        ),
      ),
      "from_int": build(
        (
          #|fn MyInt64::from_int(value : Int) -> MyInt64 { { hi: (value >> 31) & -1, lo: value | 0 } }
        ),
      ),
      "to_int": build(
        (
          #|self.lo
        ),
      ),
      "to_uint": build(
        (
          #|self.lo.reinterpret_as_uint()
        ),
      ),
      "extend_i32_u": build(
        (
          #|fn MyInt64::extend_i32_u(value : Int) -> MyInt64 { { hi: 0, lo: value } }
        ),
      ),
      "lnot": build(
        (
          #|MyInt64::from_int64(self).lnot().to_int64()
        ),
      ),
      "lsl": build(
        (
          #|pub fn Int64::lsl(self : Int64, other : Int) -> Int64 { MyInt64::from_int64(self).lsl(other).to_int64() }
        ),
      ),
      "shl": build(
        (
          #|pub fn Int64::shl(self : Int64, other : Int) -> Int64 { MyInt64::from_int64(self).lsl(other).to_int64() }
        ),
      ),
      "lsr": build(
        (
          #|pub fn Int64::lsr(self : Int64, other : Int) -> Int64 { MyInt64::from_int64(self).lsr(other).to_int64() }
        ),
      ),
      "shr": build(
        (
          #|pub fn Int64::shr(self : Int64, other : Int) -> Int64 { MyInt64::from_int64(self).asr(other).to_int64() }
        ),
      ),
      "asr": build(
        (
          #|pub fn Int64::asr(self : Int64, other : Int) -> Int64 { MyInt64::from_int64(self).asr(other).to_int64() }
        ),
      ),
      "ctz": build(
        (
          #|MyInt64::from_int64(self).ctz()
        ),
      ),
      "clz": build(
        (
          #|MyInt64::from_int64(self).clz()
        ),
      ),
      "popcnt": build(
        (
          #|MyInt64::from_int64(self).popcnt()
        ),
      ),
      "to_int": build(
        (
          #|MyInt64::from_int64(self).to_int()
        ),
      ),
      "to_double": build(
        (
          #|Double::convert_int64(self)
        ),
      ),
      "to_byte": build(
        (
          #|MyInt64::from_int64(self).to_int().to_byte()
        ),
      ),
      "to_int16": build(
        (
          #|MyInt64::from_int64(self).to_int().to_int16()
        ),
      ),
      "to_uint16": build(
        (
          #|MyInt64::from_int64(self).to_int().to_uint16()
        ),
      ),
      "extend_uint": build(
        (
          #|pub fn UInt64::extend_uint(value : UInt) -> UInt64 { MyInt64::extend_i32_u(value.reinterpret_as_int()).to_uint64() }
        ),
      ),
      "reinterpret_as_double": build(
        (
          #|MyInt64::reinterpret_as_double(MyInt64::from_int64(self))
        ),
      ),
      "reinterpret_as_double": build(
        (
          #|MyInt64::reinterpret_as_double(MyInt64::from_uint64(self))
        ),
      ),
      "to_int64": build(
        (
          #|MyInt64::from_int(self).to_int64()
        ),
      ),
      "to_int64": build(
        (
          #|MyInt64::from_int(self.to_int()).to_int64()
        ),
      ),
      "to_int64": build(
        (
          #|MyInt64::from_int(self.to_int()).to_int64()
        ),
      ),
      "reinterpret_as_i64": build(
        (
          #|MyInt64::reinterpret_double(self).to_int64()
        ),
      ),
      "reinterpret_as_int64": build(
        (
          #|MyInt64::reinterpret_double(self).to_int64()
        ),
      ),
      "reinterpret_as_u64": build(
        (
          #|MyInt64::reinterpret_double(self).to_uint64()
        ),
      ),
      "reinterpret_as_uint64": build(
        (
          #|MyInt64::reinterpret_double(self).to_uint64()
        ),
      ),
      "convert_uint64": build(
        (
          #|pub fn Double::convert_uint64(value : UInt64) -> Double { MyInt64::convert_to_double_u(MyInt64::from_uint64(value)) }
        ),
      ),
      "convert_int64": build(
        (
          #|fn Double::convert_int64(value : Int64) -> Double { MyInt64::convert_to_double(MyInt64::from_int64(value)) }
        ),
      ),
      "to_uint": build(
        (
          #|MyInt64::from_uint64(self).to_uint()
        ),
      ),
      "to_int": build(
        (
          #|MyInt64::from_uint64(self).to_int()
        ),
      ),
      "to_double": build(
        (
          #|Double::convert_uint64(self)
        ),
      ),
      "trunc_double": build(
        (
          #|pub fn UInt64::trunc_double(value : Double) -> UInt64 { MyInt64::trunc_double_u(value).to_uint64() }
        ),
      ),
      "lnot": build(
        (
          #|MyInt64::lnot(MyInt64::from_uint64(self)).to_uint64()
        ),
      ),
      "lsl": build(
        (
          #|pub fn UInt64::lsl(self : UInt64, shift : Int) -> UInt64 { MyInt64::lsl(MyInt64::from_uint64(self), shift).to_uint64() }
        ),
      ),
      "lsr": build(
        (
          #|pub fn UInt64::lsr(self : UInt64, shift : Int) -> UInt64 { MyInt64::lsr(MyInt64::from_uint64(self), shift).to_uint64() }
        ),
      ),
      "shl": build(
        (
          #|pub fn UInt64::shl(self : UInt64, shift : Int) -> UInt64 { MyInt64::lsl(MyInt64::from_uint64(self), shift).to_uint64() }
        ),
      ),
      "shr": build(
        (
          #|pub fn UInt64::shr(self : UInt64, shift : Int) -> UInt64 { MyInt64::lsr(MyInt64::from_uint64(self), shift).to_uint64() }
        ),
      ),
      "clz": build(
        (
          #|MyInt64::from_uint64(self).clz()
        ),
      ),
      "ctz": build(
        (
          #|MyInt64::from_uint64(self).ctz()
        ),
      ),
      "popcnt": build(
        (
          #|MyInt64::from_uint64(self).popcnt()
        ),
      ),
      "to_float": build(
        (
          #|self.to_double().to_float()
        ),
      ),
      "to_float": build(
        (
          #|Double::convert_uint64(self).to_float()
        ),
      ),
      "logger": build("StringBuilder::new()"),
      "logger": build("StringBuilder::new()"),
      "to_hex_digit": build(
        (
          #|fn to_hex_digit(i : Int) -> Char { if i < 10 {
          #|    (i + '0').unsafe_to_char()
          #|  } else {
          #|    (i + 'a' - 10).unsafe_to_char()
          #|  } }
        ),
      ),
      "byte": build("b.to_int()"),
      "flush_segment": build(
        (
          #|fn flush_segment(seg : Int, i : Int) { if i > seg {
          #|      logger.write_substring(self, seg, i - seg)
          #|    } }
        ),
      ),
      "len": build("self.length()"),
      "code": build("self.unsafe_charcode_at(i)"),
      "escape": build(
        (
          #|let buf = StringBuilder::new()
          #|  Show::output(self, buf)
          #|  buf.to_string()
        ),
      ),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build("[1, 2, 3]"),
      "dst": build("[4, 5, 6]"),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0]"),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build("[10, 20, 30, 40, 50]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build("[1, 2, 3, 4, 5]"),
      "dst": build("[0, 0, 0, 0, 0]"),
      "src": build(
        "FixedArray::make(3, 1) // Create a FixedArray with 3 elements of value 1",
      ),
      "dst": build(
        "Array::make(5, 0) // Create an Array with 5 elements of value 0",
      ),
      "lsr": build(
        (
          #|pub fn Int::lsr(self : Int, other : Int) -> Int { (self.reinterpret_as_uint() >> other).reinterpret_as_int() }
        ),
      ),
      "to_uint64": build(
        (
          #|self.to_int64().reinterpret_as_uint64()
        ),
      ),
      "to_uint": build(
        (
          #|self.to_int().reinterpret_as_uint()
        ),
      ),
      "make": build(
        (
          #|pub fn Bytes::make(len : Int, init : Byte) -> Bytes { if len < 0 {
          #|    return []
          #|  }
          #|  Bytes::unsafe_make(len, init) }
        ),
      ),
      "new": build(
        (
          #|pub fn Bytes::new(len : Int) -> Bytes { Bytes::make(len, b'\\x00') }
        ),
      ),
      "to_char": build(
        (
          #|if self is (0..=0xD7FF) || self is (0xE000..=0x10FFFF) {
          #|    Some(self.unsafe_to_char())
          #|  } else {
          #|    None
          #|  }
        ),
      ),
      "to_byte": build(
        (
          #|self.to_int().to_byte()
        ),
      ),
      "to_char": build(
        (
          #|self.to_int().unsafe_to_char()
        ),
      ),
      "to_int64": build(
        (
          #|self.to_int().to_int64()
        ),
      ),
      "to_uint64": build(
        (
          #|UInt64::extend_uint(self)
        ),
      ),
      "to_byte": build(
        (
          #|self.reinterpret_as_int().to_byte()
        ),
      ),
      "to_double": build(
        (
          #|self.to_int().to_double()
        ),
      ),
      "null": build(
        (
          #|return Null
        ),
      ),
      "number": build(
        (
          #|pub fn Json::number(number : Double, repr? : String) -> Json { return Number(number, repr~) }
        ),
      ),
      "string": build(
        (
          #|pub fn Json::string(string : String) -> Json { return String(string) }
        ),
      ),
      "boolean": build(
        (
          #|pub fn Json::boolean(boolean : Bool) -> Json { if boolean {
          #|    True
          #|  } else {
          #|    False
          #|  } }
        ),
      ),
      "array": build(
        (
          #|pub fn Json::array(array : Array[Json]) -> Json { return Array(array) }
        ),
      ),
      "object": build(
        (
          #|pub fn Json::object(object : Map[String, Json]) -> Json { return Object(object) }
        ),
      ),
      "len": build("self.length()"),
      "res": build("Array::make_uninit(self.length())"),
      "len": build("self.length()"),
      "res": build("Array::make_uninit(self.length())"),
      "object": build("Map::new(capacity=self.capacity)"),
      "to_string": build(
        (
          #|pub fn Int64::to_string(self : Int64, radix~ : Int = 10) -> String { let buf = StringBuilder::new(size_hint=Int64::output_size_hint(radix~))
          #|  self.output(buf, radix~)
          #|  buf.to_string() }
        ),
      ),
      "to_string": build(
        (
          #|pub fn Int::to_string(self : Int, radix~ : Int = 10) -> String { let buf = StringBuilder::new(size_hint=Int::output_size_hint(radix~))
          #|  self.output(buf, radix~)
          #|  buf.to_string() }
        ),
      ),
      "to_string": build(
        (
          #|pub fn UInt::to_string(self : UInt, radix~ : Int = 10) -> String { let buf = StringBuilder::new(size_hint=UInt::output_size_hint(radix~))
          #|  self.output(buf, radix~)
          #|  buf.to_string() }
        ),
      ),
      "to_string": build(
        (
          #|pub fn UInt64::to_string(self : UInt64, radix~ : Int = 10) -> String { let buf = StringBuilder::new(size_hint=UInt64::output_size_hint(radix~))
          #|  self.output(buf, radix~)
          #|  buf.to_string() }
        ),
      ),
      "to_string": build(
        (
          #|pub fn Int16::to_string(self : Int16, radix~ : Int = 10) -> String { self.to_int().to_string(radix~) }
        ),
      ),
      "to_string": build(
        (
          #|pub fn UInt16::to_string(self : UInt16, radix~ : Int = 10) -> String { self.to_int().to_string(radix~) }
        ),
      ),
      "len": build("self.length()"),
      "arr": build("[1, 2, 3, 4, 5]"),
      "new_buf": build("UninitializedArray::make(new_capacity)"),
      "old_buf": build("self.buf"),
      "old_cap": build("old_buf.0.length()"),
      "copy_len": build(
        "if old_cap < new_capacity { old_cap } else { new_capacity }",
      ),
      "src": build("FixedArray::make(5, 0)"),
      "dst": build("UninitializedArray::make(5)"),
      "src": build("FixedArray::make(5, 0)"),
      "dst": build("UninitializedArray::make(5)"),
      "src": build("FixedArray::make(5, 0)"),
      "dst": build("UninitializedArray::make(5)"),
      "arr": build("Array::new(capacity=2)"),
      "old_cap": build("self.length()"),
      "new_cap": build("if old_cap == 0 { 8 } else { old_cap * 2 }"),
      "length": build("self.length()"),
      "len": build("self.length()"),
      "index": build("len - 1"),
      "v": build("self.unsafe_get(index)"),
      "len": build("self.length()"),
      "index": build("len - 1"),
      "v": build("self.unsafe_get(index)"),
      "value": build("self.unsafe_get(index)"),
      "num": build("end - begin"),
      "v": build("Array::make_uninit(num)"),
      "length": build("self.length()"),
      "new_buf": build("UninitializedArray::make(new_len)"),
      "new": build(
        (
          #|pub fn Hasher::new(seed~ : Int = 0) -> Hasher { { acc: seed.reinterpret_as_uint() + GPRIME5 } }
        ),
      ),
      "combine_unit": build(
        (
          #|self.combine_uint(0)
        ),
      ),
      "combine_bool": build(
        (
          #|pub fn Hasher::combine_bool(self : Hasher, value : Bool) -> Unit { self.combine_uint(if value { 1 } else { 0 }) }
        ),
      ),
      "combine_int": build(
        (
          #|pub fn Hasher::combine_int(self : Hasher, value : Int) -> Unit { self.combine_uint(value.reinterpret_as_uint()) }
        ),
      ),
      "combine_int64": build(
        (
          #|pub fn Hasher::combine_int64(self : Hasher, value : Int64) -> Unit { self.acc += 8
          #|  self.consume4(value.reinterpret_as_uint64().to_uint())
          #|  self.consume4((value.reinterpret_as_uint64() >> 32).to_uint()) }
        ),
      ),
      "combine_uint": build(
        (
          #|pub fn Hasher::combine_uint(self : Hasher, value : UInt) -> Unit { self.acc += 4
          #|  self.consume4(value) }
        ),
      ),
      "combine_uint64": build(
        (
          #|pub fn Hasher::combine_uint64(self : Hasher, value : UInt64) -> Unit { self.combine_int64(value.reinterpret_as_int64()) }
        ),
      ),
      "combine_double": build(
        (
          #|pub fn Hasher::combine_double(self : Hasher, value : Double) -> Unit { self.combine_int64(value.reinterpret_as_int64()) }
        ),
      ),
      "combine_float": build(
        (
          #|pub fn Hasher::combine_float(self : Hasher, value : Float) -> Unit { self.combine_uint(value.reinterpret_as_uint()) }
        ),
      ),
      "combine_byte": build(
        (
          #|pub fn Hasher::combine_byte(self : Hasher, value : Byte) -> Unit { self.consume1(value) }
        ),
      ),
      "combine_bytes": build(
        (
          #|pub fn Hasher::combine_bytes(self : Hasher, value : Bytes) -> Unit { let mut remain = value.length()
          #|  let mut cur = 0
          #|  while remain >= 4 {
          #|    self.consume4(endian32(value, cur))
          #|    cur += 4
          #|    remain -= 4
          #|  }
          #|  while remain >= 1 {
          #|    self.consume1(value[cur])
          #|    cur += 1
          #|    remain -= 1
          #|  } }
        ),
      ),
      "combine_string": build(
        (
          #|pub fn Hasher::combine_string(self : Hasher, value : String) -> Unit { for i in 0..<value.length() {
          #|    self.combine_uint(value.unsafe_charcode_at(i).reinterpret_as_uint())
          #|  } }
        ),
      ),
      "combine_char": build(
        (
          #|pub fn Hasher::combine_char(self : Hasher, value : Char) -> Unit { self.combine_uint(value.to_uint()) }
        ),
      ),
      "finalize": build(
        (
          #|self.avalanche().reinterpret_as_int()
        ),
      ),
      "avalanche": build(
        (
          #|let mut acc = self.acc
          #|  acc = acc ^ (acc >> 15)
          #|  acc *= GPRIMES2
          #|  acc = acc ^ (acc >> 13)
          #|  acc *= GPRIME3
          #|  acc = acc ^ (acc >> 16)
          #|  acc
        ),
      ),
      "consume4": build(
        (
          #|fn Hasher::consume4(self : Hasher, input : UInt) -> Unit { self.acc = rotl(self.acc + input * GPRIME3, 17) * GPRIME4 }
        ),
      ),
      "consume1": build(
        (
          #|fn Hasher::consume1(self : Hasher, input : Byte) -> Unit { self.acc = rotl(self.acc + input.to_uint() * GPRIME5, 11) * GPRIME1 }
        ),
      ),
      "rotl": build(
        (
          #|fn rotl(x : UInt, r : Int) -> UInt { (x << r) | (x >> (32 - r)) }
        ),
      ),
      "endian32": build(
        (
          #|fn endian32(input : Bytes, cur : Int) -> UInt { input[cur + 0].to_uint() |
          #|  (
          #|    (input[cur + 1].to_uint() << 8) |
          #|    (input[cur + 2].to_uint() << 16) |
          #|    (input[cur + 3].to_uint() << 24)
          #|  ) }
        ),
      ),
      "self": build("self.reinterpret_as_uint()"),
      "src": build("FixedArray::make(5, 0)"),
      "dst": build("UninitializedArray::make(5)"),
      "src": build("FixedArray::make(5, 0)"),
      "dst": build("UninitializedArray::make(5)"),
      "src": build("FixedArray::make(5, 0)"),
      "dst": build("UninitializedArray::make(5)"),
      "v": build("self.unsafe_pop()"),
      "value": build("self.buffer()[index]"),
      "_": build("JSArray::ofAnyArray(self).splice(index, 1)"),
      "_": build(
        "JSArray::ofAnyArray(self).splice1(index, 0, JSValue::ofAny(value))",
      ),
      "temp": build("self.buf()[self.start() + i]"),
      "len": build("self.length()"),
      "end": build("match end {"),
      "start": build("if start < 0 { len + start } else { start }"),
      "len": build("self.length()"),
      "end": build("match end {"),
      "start": build("if start < 0 { len + start } else { start }"),
      "upto": build(
        (
          #|pub fn Int::upto(self : Int, end : Int, inclusive~ : Bool = false) -> Iter[Int] { yield_ => {
          #|    let mut i = self
          #|    while i < end || (inclusive && i == end) {
          #|      if yield_(i) == IterEnd {
          #|        break IterEnd
          #|      }
          #|      if i == end {
          #|        break IterContinue
          #|      }
          #|      i += 1
          #|    } else {
          #|      IterContinue
          #|    }
          #|  } }
        ),
      ),
      "of_string": build(
        (
          #|pub fn Bytes::of_string(str : String) -> Bytes { FixedArray::make(str.length() * 2, Byte::default())
          #|  ..blit_from_string(0, str, 0, str.length())
          #|  .unsafe_reinterpret_as_bytes() }
        ),
      ),
      "copy": build(
        (
          #|Bytes::makei(self.length(), i => self[i])
        ),
      ),
      "lsl": build(
        (
          #|pub fn Byte::lsl(self : Byte, count : Int) -> Byte { (self.to_int() << count).to_byte() }
        ),
      ),
      "lsr": build(
        (
          #|pub fn Byte::lsr(self : Byte, count : Int) -> Byte { (self.to_uint() >> count).reinterpret_as_int().to_byte() }
        ),
      ),
      "name": build("match name {"),
      "codepoint_at": build(
        (
          #|pub fn String::codepoint_at(self : String, index : Int) -> Char { let charcode_len = self.length()
          #|  guard index >= 0 && index < charcode_len else { abort(\"index out of bounds\") }
          #|  for char_count = 0, utf16_offset = 0
          #|      char_count < charcode_len && utf16_offset < index
          #|      char_count = char_count + 1, utf16_offset = utf16_offset + 1 {
          #|    let c1 = self.unsafe_charcode_at(char_count)
          #|    if c1.is_leading_surrogate() && char_count + 1 < charcode_len {
          #|      let c2 = self.unsafe_charcode_at(char_count + 1)
          #|      if c2.is_trailing_surrogate() {
          #|        continue char_count + 2, utf16_offset + 1
          #|      } else {
          #|        abort(\"invalid surrogate pair\")
          #|      }
          #|    }
          #|  } else {
          #|    guard utf16_offset == index && char_count < charcode_len else {
          #|      abort(\"index out of bounds\")
          #|    }
          #|    let c1 = self.unsafe_charcode_at(char_count)
          #|    if c1.is_leading_surrogate() && char_count + 1 < charcode_len {
          #|      let c2 = self.unsafe_charcode_at(char_count + 1)
          #|      if c2.is_trailing_surrogate() {
          #|        code_point_of_surrogate_pair(c1, c2)
          #|      } else {
          #|        abort(\"invalid surrogate pair\")
          #|      }
          #|    } else {
          #|      c1.unsafe_to_char()
          #|    }
          #|  } }
        ),
      ),
      "charcode_at": build(
        (
          #|pub fn String::charcode_at(self : String, index : Int) -> Int { self[index] }
        ),
      ),
      "unsafe_char_at": build(
        (
          #|pub fn String::unsafe_char_at(self : String, index : Int) -> Char { let c1 = self.unsafe_charcode_at(index)
          #|  if c1.is_leading_surrogate() {
          #|    let c2 = self.unsafe_charcode_at(index + 1)
          #|    code_point_of_surrogate_pair(c1, c2)
          #|  } else {
          #|    c1.unsafe_to_char()
          #|  } }
        ),
      ),
      "capacity": build("capacity.next_power_of_two()"),
      "m": build("Map::new(capacity=arr.length())"),
      "hash": build("key.hash()"),
      "entry": build("{ prev: self.tail, next: None, psl, key, value, hash }"),
      "hash": build("key.hash()"),
      "hash": build("key.hash()"),
      "v": build("default()"),
      "hash": build("key.hash()"),
      "hash": build("key.hash()"),
      "hash": build("key.hash()"),
      "next": build("(idx + 1) & self.capacity_mask"),
      "old_head": build("self.head"),
      "new_capacity": build("self.capacity << 1"),
      "calc_grow_threshold": build(
        (
          #|fn calc_grow_threshold(capacity : Int) -> Int { capacity * 13 / 16 }
        ),
      ),
      "arr": build("Array::make_uninit(self.size)"),
      "length": build("arr.length()"),
      "m": build("Map::new(capacity=length)"),
      "e": build("arr[i]"),
      "m": build("{}"),
      "other": build("{"),
      "new_value": build("f(key, value)"),
      "new_entry": build("{ prev, next, psl, hash, key, value: new_value }"),
      "other": build("{"),
      "new_entry": build("{ prev, next, psl, hash, key, value }"),
      "hash": build("key.hash()"),
      "entry": build("{"),
      "new": build(
        (
          #|pub fn StringBuilder::new(size_hint~ : Int = 0) -> StringBuilder { ignore(size_hint)
          #|  { val: \"\" } }
        ),
      ),
      "is_empty": build(
        (
          #|self.val == \"\"
        ),
      ),
      "char_to_string": build(
        (
          #|fn char_to_string(char : Char) -> String { [char] }
        ),
      ),
      "to_string": build(
        (
          #|self.val
        ),
      ),
      "reset": build(
        (
          #|self.val = \"\"
        ),
      ),
      "new": build(
        (
          #|pub fn StringBuilder::new(size_hint~ : Int = 0) -> StringBuilder { let initial = if size_hint < 1 { 1 } else { size_hint }
          #|  let data : FixedArray[Byte] = FixedArray::make(initial, 0)
          #|  { data, len: 0 } }
        ),
      ),
      "is_empty": build(
        (
          #|self.len == 0
        ),
      ),
      "current_len": build("self.data.length()"),
      "new_data": build("FixedArray::make(enough_space, Byte::default())"),
      "inc": build("self.data.set_utf16le_char(self.len, ch)"),
      "to_string": build(
        (
          #|self.data
          #|  .unsafe_reinterpret_as_bytes()
          #|  .to_unchecked_string(offset=0, length=self.len)
        ),
      ),
      "reset": build(
        (
          #|self.len = 0
        ),
      ),
      "make": build(
        (
          #|pub fn String::make(length : Int, value : Char) -> String { guard length >= 0 else { abort(\"invalid length\") }
          #|  if value.to_int() <= 0xFFFF {
          #|    unsafe_make_string(length, value)
          #|  } else {
          #|    let buf = StringBuilder::new(size_hint=2 * length)
          #|    for _ in 0..<length {
          #|      buf.write_char(value)
          #|    }
          #|    buf.to_string()
          #|  } }
        ),
      ),
      "code_point_of_surrogate_pair": build(
        (
          #|fn code_point_of_surrogate_pair(leading : Int, trailing : Int) -> Char { ((leading - 0xD800) * 0x400 + trailing - 0xDC00 + 0x10000).unsafe_to_char() }
        ),
      ),
      "end_offset": build(
        "if end_offset is Some(o) { o } else { self.length() }",
      ),
      "c1": build("self.unsafe_charcode_at(utf16_index)"),
      "c2": build("self.unsafe_charcode_at(utf16_index + 1)"),
      "unsafe_substring": build(
        (
          #|fn unsafe_substring(str : String, start : Int, end : Int) -> String { let len = end - start
          #|  let bytes = FixedArray::make(len * 2, Byte::default())
          #|  bytes.blit_from_string(0, str, start, len)
          #|  bytes.unsafe_reinterpret_as_bytes().to_unchecked_string() }
        ),
      ),
      "substring": build(
        (
          #|pub fn String::substring(self : String, start~ : Int = 0, end? : Int) -> String { let len = self.length()
          #|  let end = match end {
          #|    Some(end) => end
          #|    None => len
          #|  }
          #|  guard start >= 0 && start <= end && end <= len
          #|  unsafe_substring(self, start, end) }
        ),
      ),
      "s": String("test"),
      "s": String("test"),
      "to_int64": build(
        (
          #|if self != self {
          #|    0
          #|  } else if self >= 9223372036854775807 {
          #|    9223372036854775807L
          #|  } else if self <= -9223372036854775808 {
          #|    -9223372036854775808L
          #|  } else {
          #|    self.to_unchecked_int64()
          #|  }
        ),
      ),
      "to_uint64": build(
        (
          #|if self != self {
          #|    0
          #|  } else if self >= 9223372036854775807 {
          #|    18446744073709551615UL
          #|  } else if self <= 0 {
          #|    0UL
          #|  } else {
          #|    self.to_unchecked_uint64()
          #|  }
        ),
      ),
      "to_json": build(
        (
          #|let buf = StringBuilder::new(size_hint=10)
          #|  let ArgsLoc(self) = self
          #|  buf.write_char('[')
          #|  for i in 0..<self.length() {
          #|    if i != 0 {
          #|      buf.write_string(\", \")
          #|    }
          #|    let item = self[i]
          #|    match item {
          #|      None => buf.write_string(\"null\")
          #|      Some(loc) => loc.to_string() |> Show::output(buf)
          #|    }
          #|  }
          #|  buf.write_char(']')
          #|  buf.to_string()
        ),
      ),
      "output": build(
        (
          #|fn Int64::output(self : Int64, logger : &Logger, radix~ : Int = 10) -> Unit { fn abs(n : Int64) -> Int64 {
          #|    if n < 0L {
          #|      0L - n
          #|    } else {
          #|      n
          #|    }
          #|  }
          #|  if self < 0L {
          #|    logger.write_char('-')
          #|  }
          #|  let radix : Int64 = radix.to_int64()
          #|  fn write_digits(num : Int64) {
          #|    let num2 = num / radix
          #|    if num2 != 0L {
          #|      write_digits(num2)
          #|    }
          #|    logger.write_char(
          #|      ALPHABET.charcode_at(abs(num % radix).to_int()).unsafe_to_char(),
          #|    )
          #|  }
          #|  write_digits(abs(self)) }
        ),
      ),
      "output": build(
        (
          #|fn Int::output(self : Int, logger : &Logger, radix~ : Int = 10) -> Unit { fn abs(n : Int) -> Int {
          #|    if n < 0 {
          #|      0 - n
          #|    } else {
          #|      n
          #|    }
          #|  }
          #|  if self < 0 {
          #|    logger.write_char('-')
          #|  }
          #|  fn write_digits(num : Int) {
          #|    let num2 = num / radix
          #|    if num2 != 0 {
          #|      write_digits(num2)
          #|    }
          #|    logger.write_char(ALPHABET.charcode_at(abs(num % radix)).unsafe_to_char())
          #|  }
          #|  write_digits(abs(self)) }
        ),
      ),
      "output": build(
        (
          #|fn UInt::output(self : UInt, logger : &Logger, radix~ : Int = 10) -> Unit { let radix : UInt = radix.reinterpret_as_uint()
          #|  fn write_digits(num : UInt) {
          #|    let num2 = num / radix
          #|    if num2 != 0U {
          #|      write_digits(num2)
          #|    }
          #|    logger.write_char(
          #|      ALPHABET.charcode_at((num % radix).reinterpret_as_int()).unsafe_to_char(),
          #|    )
          #|  }
          #|  write_digits(self) }
        ),
      ),
      "output": build(
        (
          #|fn UInt64::output(self : UInt64, logger : &Logger, radix~ : Int = 10) -> Unit { let radix : UInt64 = radix.to_uint64()
          #|  fn write_digits(num : UInt64) {
          #|    let num2 = num / radix
          #|    if num2 != 0UL {
          #|      write_digits(num2)
          #|    }
          #|    logger.write_char(
          #|      ALPHABET.charcode_at((num % radix).to_int()).unsafe_to_char(),
          #|    )
          #|  }
          #|  write_digits(self) }
        ),
      ),
      "output_size_hint": build(
        (
          #|fn Int64::output_size_hint(radix~ : Int = 10) -> Int { match radix {
          #|    2..<7 => 70 // max length is 64, 70 is enough
          #|    8..<15 => 30 // max length is 23, 30 is enough
          #|    16..=36 => 20 // max length is 17, 20 is enough
          #|    _ => abort(\"radix must be between 2 and 36\")
          #|  } }
        ),
      ),
      "output_size_hint": build(
        (
          #|fn Int::output_size_hint(radix~ : Int = 10) -> Int { match radix {
          #|    2..<7 => 36 // max length is 32, 36 is enough
          #|    8..<15 => 18 // max length is 12, 18 is enough
          #|    16..=36 => 10 // max length is 8, 10 is enough
          #|    _ => abort(\"radix must be between 2 and 36\")
          #|  } }
        ),
      ),
      "output_size_hint": build(
        (
          #|fn UInt::output_size_hint(radix~ : Int = 10) -> Int { Int::output_size_hint(radix~) }
        ),
      ),
      "output_size_hint": build(
        (
          #|fn UInt64::output_size_hint(radix~ : Int = 10) -> Int { Int64::output_size_hint(radix~) }
        ),
      ),
      "to_int": build(
        (
          #|if self != self {
          #|    0
          #|  } else if self >= 2147483647 {
          #|    2147483647
          #|  } else if self <= -2147483648 {
          #|    -2147483648
          #|  } else {
          #|    self.to_unchecked_int()
          #|  }
        ),
      ),
      "makei": build(
        (
          #|pub fn Bytes::makei(length : Int, value : (Int) -> Byte raise?) -> Bytes raise? { if length <= 0 {
          #|    return []
          #|  }
          #|  let arr = FixedArray::make(length, value(0))
          #|  for i in 1..<length {
          #|    arr[i] = value(i)
          #|  }
          #|  FixedArray::unsafe_reinterpret_as_bytes(arr) }
        ),
      ),
      "len": build("self.length()"),
      "length": build("if length is Some(l) { l } else { len - offset }"),
      "s1": build("bytes_offset"),
      "s2": build("str_offset"),
      "e1": build("bytes_offset + length * 2 - 1"),
      "e2": build("str_offset + length - 1"),
      "len1": build("self.length()"),
      "len2": build("str.length()"),
      "end_str_offset": build("str_offset + length"),
      "c": build("str.unsafe_charcode_at(i).reinterpret_as_uint()"),
      "s1": build("bytes_offset"),
      "s2": build("src_offset"),
      "e1": build("bytes_offset + length - 1"),
      "e2": build("src_offset + length - 1"),
      "len1": build("self.length()"),
      "len2": build("src.length()"),
      "code": build("value.to_uint()"),
      "code": build("value.to_uint()"),
      "hi": build("code - 0x10000"),
      "lo": build("(hi >> 10) | 0xD800"),
      "hi": build("(hi & 0x3FF) | 0xDC00"),
      "code": build("value.to_uint()"),
      "hi": build("code - 0x10000"),
      "lo": build("(hi >> 10) | 0xD800"),
      "hi": build("(hi & 0x3FF) | 0xDC00"),
      "len": build("self.length()"),
      "self_len": build("self.length()"),
      "other_len": build("other.length()"),
      "cmp": build("self_len.compare(other_len)"),
      "b1": build("self.unsafe_get(i)"),
      "b2": build("other.unsafe_get(i)"),
      "cmp": build("b1.compare(b2)"),
      "next_power_of_two": build(
        (
          #|guard self >= 0
          #|  if self <= 1 {
          #|    return 1
          #|  }
          #|  // The largest power of 2 that fits in a 32-bit signed integer is 2^30
          #|  let max_power_of_two = 1073741824 // 2^30
          #|  if self > max_power_of_two {
          #|    return max_power_of_two
          #|  }
          #|  // 2147483647 is the largest value of an integer
          #|  (2147483647 >> ((self - 1).clz() - 1)) + 1
        ),
      ),
      "min": build(
        (
          #|pub fn Int::min(self : Int, other : Int) -> Int { if self < other {
          #|    self
          #|  } else {
          #|    other
          #|  } }
        ),
      ),
      "max": build(
        (
          #|pub fn Int::max(self : Int, other : Int) -> Int { if self > other {
          #|    self
          #|  } else {
          #|    other
          #|  } }
        ),
      ),
      "clamp": build(
        (
          #|pub fn Int::clamp(self : Int, min~ : Int, max~ : Int) -> Int { guard min <= max
          #|  if self < min {
          #|    min
          #|  } else if self > max {
          #|    max
          #|  } else {
          #|    self
          #|  } }
        ),
      ),
      "is_leading_surrogate": build(
        (
          #|0xD800 <= self && self <= 0xDBFF
        ),
      ),
      "is_trailing_surrogate": build(
        (
          #|0xDC00 <= self && self <= 0xDFFF
        ),
      ),
      "is_surrogate": build(
        (
          #|0xD800 <= self && self <= 0xDFFF
        ),
      ),
      "base64_encode": build(
        (
          #|fn base64_encode(data : FixedArray[Byte]) -> String { let base64 = b\"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/\"
          #|  let buf = StringBuilder::new()
          #|  let len = data.length()
          #|  let rem = len % 3
          #|  for i = 0; i < len - rem; i = i + 3 {
          #|    let b0 = data[i].to_int()
          #|    let b1 = data[i + 1].to_int()
          #|    let b2 = data[i + 2].to_int()
          #|    let x0 = base64[(b0 & 0xFC) >> 2]
          #|    let x1 = base64[((b0 & 0x03) << 4) | ((b1 & 0xF0) >> 4)]
          #|    let x2 = base64[((b1 & 0x0F) << 2) | ((b2 & 0xC0) >> 6)]
          #|    let x3 = base64[b2 & 0x3F]
          #|    buf.write_char(x0.to_char())
          #|    buf.write_char(x1.to_char())
          #|    buf.write_char(x2.to_char())
          #|    buf.write_char(x3.to_char())
          #|  }
          #|  if rem == 1 {
          #|    let b0 = data[len - 1].to_int()
          #|    let x0 = base64[(b0 & 0xFC) >> 2]
          #|    let x1 = base64[(b0 & 0x03) << 4]
          #|    buf.write_char(x0.to_char())
          #|    buf.write_char(x1.to_char())
          #|    buf.write_char('=')
          #|    buf.write_char('=')
          #|  } else if rem == 2 {
          #|    let b0 = data[len - 2].to_int()
          #|    let b1 = data[len - 1].to_int()
          #|    let x0 = base64[(b0 & 0xFC) >> 2]
          #|    let x1 = base64[((b0 & 0x03) << 4) | ((b1 & 0xF0) >> 4)]
          #|    let x2 = base64[(b1 & 0x0F) << 2]
          #|    buf.write_char(x0.to_char())
          #|    buf.write_char(x1.to_char())
          #|    buf.write_char(x2.to_char())
          #|    buf.write_char('=')
          #|  }
          #|  buf.to_string() }
        ),
      ),
      "base64_encode_string_codepoint": build(
        (
          #|fn base64_encode_string_codepoint(s : String) -> String { // the input string is expected to be valid utf-16 string
          #|  let codepoint_length = s.char_length()
          #|  let data : FixedArray[Byte] = FixedArray::make(codepoint_length * 4, 0)
          #|  for i = 0, utf16_index = 0
          #|      i < codepoint_length
          #|      i = i + 1, utf16_index = utf16_index + 1 {
          #|    let c = s.unsafe_char_at(utf16_index).to_int()
          #|    if c > 0xFFFF {
          #|      data[i * 4] = (c & 0xFF).to_byte()
          #|      data[i * 4 + 1] = ((c >> 8) & 0xFF).to_byte()
          #|      data[i * 4 + 2] = ((c >> 16) & 0xFF).to_byte()
          #|      data[i * 4 + 3] = ((c >> 24) & 0xFF).to_byte()
          #|      continue i + 1, utf16_index + 2
          #|    } else {
          #|      data[i * 4] = (c & 0xFF).to_byte()
          #|      data[i * 4 + 1] = ((c >> 8) & 0xFF).to_byte()
          #|      data[i * 4 + 2] = 0
          #|      data[i * 4 + 3] = 0
          #|    }
          #|  }
          #|  base64_encode(data) }
        ),
      ),
      "actual": build("obj.to_string()"),
      "loc": build("loc.to_string().escape()"),
      "args_loc": build("args_loc.to_json().escape()"),
      "expect_escaped": build("content.escape()"),
      "actual_escaped": build("actual.escape()"),
      "expect_base64": build(
        "\"\\\"\\{base64_encode_string_codepoint(content)}\\\"\"",
      ),
      "actual_base64": build(
        "\"\\\"\\{base64_encode_string_codepoint(actual)}\\\"\"",
      ),
      "buf": build("StringBuilder::new(size_hint=50)"),
      "fail_msg": build("match msg {"),
      "fail_msg": build("match msg {"),
      "assert_true": build(
        (
          #|pub fn assert_true(x : Bool, msg? : String, loc~ : SourceLoc) -> Unit raise { if !x {
          #|    let fail_msg = match msg {
          #|      Some(msg) => msg
          #|      None => \"`\\{x}` is not true\"
          #|    }
          #|    fail(fail_msg, loc~)
          #|  } }
        ),
      ),
      "assert_false": build(
        (
          #|pub fn assert_false(x : Bool, msg? : String, loc~ : SourceLoc) -> Unit raise { if x {
          #|    let fail_msg = match msg {
          #|      Some(msg) => msg
          #|      None => \"`\\{x}` is not false\"
          #|    }
          #|    fail(fail_msg, loc~)
          #|  } }
        ),
      ),
      "alphabet": build(
        (
          #|fn alphabet(x : Int) -> String { match x {
          #|    0 => \"0\"
          #|    1 => \"1\"
          #|    2 => \"2\"
          #|    3 => \"3\"
          #|    4 => \"4\"
          #|    5 => \"5\"
          #|    6 => \"6\"
          #|    7 => \"7\"
          #|    8 => \"8\"
          #|    9 => \"9\"
          #|    10 => \"A\"
          #|    11 => \"B\"
          #|    12 => \"C\"
          #|    13 => \"D\"
          #|    14 => \"E\"
          #|    15 => \"F\"
          #|    _ => abort(\"impossible\")
          #|  } }
        ),
      ),
      "to_string": build(
        (
          #|let i = self.to_int()
          #|  let hi = alphabet(i / 16)
          #|  let lo = alphabet(i % 16)
          #|  \"b'\\\\x\\{hi}\\{lo}'\"
        ),
      ),
      "lnot": build(
        (
          #|self.to_int().lnot().to_byte()
        ),
      ),
      "to_uint": build(
        (
          #|self.to_int().reinterpret_as_uint()
        ),
      ),
    }
  },
)

///|
let byte_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/byte", fn(
  _env,
  build,
) {
  {
    "to_uint64": build(
      (
        #|self.to_uint().to_uint64()
      ),
    ),
    "popcnt": build(
      (
        #|let mut n = self
        #|  n = (n & 0x55) + ((n >> 1) & 0x55)
        #|  n = (n & 0x33) + ((n >> 2) & 0x33)
        #|  n = (n & 0x0F) + ((n >> 4) & 0x0F)
        #|  n.to_int()
      ),
    ),
  }
})

///|
let bytes_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bytes",
  fn(_env, build) {
    {
      "gPRIME1": build("0x9E3779B1"),
      "gPRIME2": build("0x85EBCA77"),
      "gPRIME3": build("0xC2B2AE3D"),
      "gPRIME4": build("0x27D4EB2F"),
      "gPRIME5": build("0x165667B1"),
      "xxhash32": build(
        (
          #|fn xxhash32(input : Bytes, seed : Int) -> Int { let len = input.length()
          #|  let h = (if len >= 16 {
          #|      h16bytes(input, 0, len, seed)
          #|    } else {
          #|      seed + gPRIME5
          #|    }) +
          #|    len
          #|  finalize(h, input, len & -16, len & 0xF) }
        ),
      ),
      "rotl": build(
        (
          #|fn rotl(x : Int, r : Int) -> Int { (x << r) | (x.reinterpret_as_uint() >> (32 - r)).reinterpret_as_int() }
        ),
      ),
      "round": build(
        (
          #|fn round(acc : Int, input : Int) -> Int { rotl(acc + input * gPRIME2, 13) * gPRIME1 }
        ),
      ),
      "avalanche_step": build(
        (
          #|fn avalanche_step(h : Int, rshift : Int, prime : Int) -> Int { (h ^ (h.reinterpret_as_uint() >> rshift).reinterpret_as_int()) * prime }
        ),
      ),
      "avalanche": build(
        (
          #|fn avalanche(h : Int) -> Int { avalanche_step(
          #|    avalanche_step(avalanche_step(h, 15, gPRIME2), 13, gPRIME3),
          #|    16,
          #|    1,
          #|  ) }
        ),
      ),
      "endian32": build(
        (
          #|fn endian32(input : Bytes, cur : Int) -> Int { input[cur + 0].to_int() |
          #|  (
          #|    (input[cur + 1].to_int() << 8) |
          #|    ((input[cur + 2].to_int() << 16) | (input[cur + 3].to_int() << 24))
          #|  ) }
        ),
      ),
      "fetch32": build(
        (
          #|fn fetch32(input : Bytes, cur : Int, v : Int) -> Int { round(v, endian32(input, cur)) }
        ),
      ),
      "finalize": build(
        (
          #|fn finalize(h : Int, input : Bytes, cur : Int, remain : Int) -> Int { if remain >= 4 {
          #|    finalize(
          #|      rotl(h + endian32(input, cur) * gPRIME3, 17) * gPRIME4,
          #|      input,
          #|      cur + 4,
          #|      remain - 4,
          #|    )
          #|  } else if remain > 0 {
          #|    finalize(
          #|      rotl(h + input[cur].to_int() * gPRIME5, 11) * gPRIME1,
          #|      input,
          #|      cur + 1,
          #|      remain - 1,
          #|    )
          #|  } else {
          #|    avalanche(h)
          #|  } }
        ),
      ),
      "h16bytes": build(
        (
          #|fn h16bytes(input : Bytes, cur : Int, len : Int, seed : Int) -> Int { _h16bytes(
          #|    input,
          #|    cur,
          #|    len,
          #|    seed + gPRIME1 + gPRIME2,
          #|    seed + gPRIME2,
          #|    seed,
          #|    seed - gPRIME1,
          #|  ) }
        ),
      ),
      "hasher": build("Hasher::new()"),
      "length": build(
        (
          #|self.len()
        ),
      ),
      "op_get": build(
        (
          #|pub fn View::op_get(self : View, index : Int) -> Byte { guard index >= 0 && index < self.len() else {
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{self.len()} but the index is \\{index}\",
          #|    )
          #|  }
          #|  self.bytes()[self.start() + index] }
        ),
      ),
      "get": build(
        (
          #|pub fn View::get(self : View, index : Int) -> Byte? { guard index >= 0 && index < self.len() else { None }
          #|  Some(self.bytes().unsafe_get(self.start() + index)) }
        ),
      ),
      "unsafe_get": build(
        (
          #|pub fn View::unsafe_get(self : View, index : Int) -> Byte { self.bytes()[self.start() + index] }
        ),
      ),
      "op_as_view": build(
        (
          #|pub fn Bytes::op_as_view(self : Bytes, start~ : Int = 0, end? : Int) -> View { let len = self.length()
          #|  let end = match end {
          #|    None => len
          #|    Some(end) => if end < 0 { len + end } else { end }
          #|  }
          #|  let start = if start < 0 { len + start } else { start }
          #|  guard start >= 0 && start <= end && end <= len else {
          #|    abort(\"Invalid index for View\")
          #|  }
          #|  View::make(self, start, end - start) }
        ),
      ),
      "op_as_view": build(
        (
          #|pub fn View::op_as_view(self : View, start~ : Int = 0, end? : Int) -> View { let len = self.length()
          #|  let end = match end {
          #|    None => len
          #|    Some(end) => if end < 0 { len + end } else { end }
          #|  }
          #|  let start = if start < 0 { len + start } else { start }
          #|  guard start >= 0 && start <= end && end <= len else {
          #|    abort(\"Invalid index for View\")
          #|  }
          #|  View::make(self.bytes(), self.start() + start, end - start) }
        ),
      ),
      "iter": build(
        (
          #|Iter::new(yield_ => for i in 0..<self.len() {
          #|    guard yield_(self[i]) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  })
        ),
      ),
      "to_uint_be": build(
        (
          #|(self[0].to_uint() << 24) +
          #|  (self[1].to_uint() << 16) +
          #|  (self[2].to_uint() << 8) +
          #|  self[3].to_uint()
        ),
      ),
      "to_uint_le": build(
        (
          #|self[0].to_uint() +
          #|  (self[1].to_uint() << 8) +
          #|  (self[2].to_uint() << 16) +
          #|  (self[3].to_uint() << 24)
        ),
      ),
      "to_uint64_be": build(
        (
          #|(self[0].to_uint().to_uint64() << 56) +
          #|  (self[1].to_uint().to_uint64() << 48) +
          #|  (self[2].to_uint().to_uint64() << 40) +
          #|  (self[3].to_uint().to_uint64() << 32) +
          #|  (self[4].to_uint().to_uint64() << 24) +
          #|  (self[5].to_uint().to_uint64() << 16) +
          #|  (self[6].to_uint().to_uint64() << 8) +
          #|  self[7].to_uint().to_uint64()
        ),
      ),
      "to_uint64_le": build(
        (
          #|self[0].to_uint().to_uint64() +
          #|  (self[1].to_uint().to_uint64() << 8) +
          #|  (self[2].to_uint().to_uint64() << 16) +
          #|  (self[3].to_uint().to_uint64() << 24) +
          #|  (self[4].to_uint().to_uint64() << 32) +
          #|  (self[5].to_uint().to_uint64() << 40) +
          #|  (self[6].to_uint().to_uint64() << 48) +
          #|  (self[7].to_uint().to_uint64() << 56)
        ),
      ),
      "to_int_be": build(
        (
          #|self.to_uint_be().reinterpret_as_int()
        ),
      ),
      "to_int_le": build(
        (
          #|self.to_uint_le().reinterpret_as_int()
        ),
      ),
      "to_int64_be": build(
        (
          #|self.to_uint64_be().reinterpret_as_int64()
        ),
      ),
      "to_int64_le": build(
        (
          #|self.to_uint64_le().reinterpret_as_int64()
        ),
      ),
      "to_float_be": build(
        (
          #|self.to_uint_be().reinterpret_as_float()
        ),
      ),
      "to_float_le": build(
        (
          #|self.to_uint_le().reinterpret_as_float()
        ),
      ),
      "to_double_be": build(
        (
          #|self.to_uint64_be().reinterpret_as_double()
        ),
      ),
      "to_double_le": build(
        (
          #|self.to_uint64_le().reinterpret_as_double()
        ),
      ),
      "to_hex_digit": build(
        (
          #|fn to_hex_digit(i : Int) -> Char { if i < 10 {
          #|      ('0'.to_int() + i).unsafe_to_char()
          #|    } else {
          #|      ('a'.to_int() + (i - 10)).unsafe_to_char()
          #|    } }
        ),
      ),
      "byte": build("self[i].to_int()"),
      "self_len": build("self.len()"),
      "other_len": build("other.len()"),
      "cmp": build("self_len.compare(other_len)"),
      "b1": build("self.unsafe_get(i)"),
      "b2": build("other.unsafe_get(i)"),
      "cmp": build("b1.compare(b2)"),
      "data": build(
        (
          #|self.bytes()
        ),
      ),
      "start_offset": build(
        (
          #|self.start()
        ),
      ),
      "to_bytes": build(
        (
          #|if self.len() == 0 && self.len() == self.bytes().length() {
          #|    return self.bytes()
          #|  }
          #|  let bytes = FixedArray::make(self.len(), (0 : Byte))
          #|  bytes.blit_from_bytes(0, self.bytes(), self.start_offset(), self.len())
          #|  unsafe_to_bytes(bytes)
        ),
      ),
      "from_array": build(
        (
          #|pub fn Bytes::from_array(arr : Array[Byte]) -> Bytes { Bytes::makei(arr.length(), i => arr[i]) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn from_array(arr : Array[Byte]) -> Bytes { Bytes::makei(arr.length(), i => arr[i]) }
        ),
      ),
      "from_fixedarray": build(
        (
          #|pub fn Bytes::from_fixedarray(arr : FixedArray[Byte], len? : Int) -> Bytes { let len = match len {
          #|    None => arr.length()
          #|    Some(x) => x
          #|  }
          #|  Bytes::makei(len, i => arr[i]) }
        ),
      ),
      "from_fixedarray": build(
        (
          #|pub fn from_fixedarray(arr : FixedArray[Byte], len? : Int) -> Bytes { Bytes::from_fixedarray(arr, len?) }
        ),
      ),
      "to_fixedarray": build(
        (
          #|pub fn to_fixedarray(self : Bytes, len? : Int) -> FixedArray[Byte] { let len = match len {
          #|    None => self.length()
          #|    Some(x) => x
          #|  }
          #|  let arr = FixedArray::make(len, Byte::default())
          #|  for i in 0..<len {
          #|    arr[i] = self[i]
          #|  }
          #|  arr }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn Bytes::from_iter(iter : Iter[Byte]) -> Bytes { from_array(iter.collect()) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn from_iter(iter : Iter[Byte]) -> Bytes { from_array(iter.collect()) }
        ),
      ),
      "of": build(
        (
          #|pub fn Bytes::of(arr : FixedArray[Byte]) -> Bytes { Bytes::makei(arr.length(), i => arr[i]) }
        ),
      ),
      "of": build(
        (
          #|pub fn of(arr : FixedArray[Byte]) -> Bytes { Bytes::makei(arr.length(), i => arr[i]) }
        ),
      ),
      "to_array": build(
        (
          #|let len = self.length()
          #|  let rv = Array::make(len, b'0')
          #|  for i in 0..<len {
          #|    rv[i] = self[i]
          #|  }
          #|  rv
        ),
      ),
      "iter": build(
        (
          #|Iter::new(yield_ => for i in 0..<self.length() {
          #|    if yield_(self[i]) == IterEnd {
          #|      break IterEnd
          #|    }
          #|  } else {
          #|    IterContinue
          #|  })
        ),
      ),
      "iter2": build(
        (
          #|Iter2::new(yield_ => for i in 0..<self.length() {
          #|    if yield_(i, self[i]) == IterEnd {
          #|      break IterEnd
          #|    }
          #|  } else {
          #|    IterContinue
          #|  })
        ),
      ),
      "get": build(
        (
          #|pub fn get(self : Bytes, index : Int) -> Byte? { guard index >= 0 && index < self.length() else { None }
          #|  Some(self[index]) }
        ),
      ),
      "default": build(
        (
          #|b\"\"
        ),
      ),
      "len_self": build("self.length()"),
      "len_other": build("other.length()"),
    }
  },
)

///|
let char_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/char", fn(
  _env,
  build,
) {
  {
    "is_ascii": build(
      (
        #|self is ('\\u{00}'..='\\u{7F}')
      ),
    ),
    "is_ascii_alphabetic": build(
      (
        #|self is ('A'..='Z' | 'a'..='z')
      ),
    ),
    "is_ascii_control": build(
      (
        #|self is ('\\u{00}'..='\\u{1F}' | '\\u{7F}')
      ),
    ),
    "is_ascii_digit": build(
      (
        #|self is ('0'..='9')
      ),
    ),
    "is_ascii_graphic": build(
      (
        #|self is ('\\u{21}'..='\\u{7E}')
      ),
    ),
    "is_ascii_hexdigit": build(
      (
        #|self is ('0'..='9' | 'A'..='F' | 'a'..='f')
      ),
    ),
    "is_ascii_lowercase": build(
      (
        #|self is ('a'..='z')
      ),
    ),
    "is_ascii_octdigit": build(
      (
        #|self is ('0'..='7')
      ),
    ),
    "is_ascii_punctuation": build(
      (
        #|self
        #|  is ('\\u{21}'..='\\u{2F}'
        #|  | '\\u{3A}'..='\\u{40}'
        #|  | '\\u{5B}'..='\\u{60}'
        #|  | '\\u{7B}'..='\\u{7E}')
      ),
    ),
    "is_ascii_uppercase": build(
      (
        #|self is ('A'..='Z')
      ),
    ),
    "is_ascii_whitespace": build(
      (
        #|self is ('\\u{20}' | '\\u{09}' | '\\u{0A}' | '\\u{0B}' | '\\u{0C}' | '\\u{0D}')
      ),
    ),
    "is_control": build(
      (
        #|self is ('\\u0000'..='\\u001F' | '\\u007F'..='\\u009F')
      ),
    ),
    "is_digit": build(
      (
        #|pub fn Char::is_digit(self : Self, radix : UInt) -> Bool { let v = self.to_uint()
        #|  match radix {
        #|    2..=10 => v >= 48 && v <= radix + 47
        #|    11..=36 =>
        #|      (v >= 48 && v <= 57) ||
        #|      (v >= 65 && v <= radix + 54) ||
        #|      (v >= 97 && v <= radix + 86)
        #|    _ => panic()
        #|  } }
      ),
    ),
    "is_whitespace": build(
      (
        #|self
        #|  is ('\\u0009'..='\\u000D'
        #|  | '\\u0020'
        #|  | '\\u0085'
        #|  | '\\u00A0'
        #|  | '\\u1680'
        #|  | '\\u2000'..='\\u200A'
        #|  | '\\u2028'
        #|  | '\\u2029'
        #|  | '\\u202F'
        #|  | '\\u205F'
        #|  | '\\u3000')
      ),
    ),
    "is_numeric": build(
      (
        #|self
        #|  is ('\\u0030'..='\\u0039'
        #|  | '\\u00B2'
        #|  | '\\u00B3'
        #|  | '\\u00B9'
        #|  | '\\u00BC'
        #|  | '\\u00BD'
        #|  | '\\u00BE'
        #|  | '\\u0660'..='\\u0669'
        #|  | '\\u06F0'..='\\u06F9'
        #|  | '\\u07C0'..='\\u07F9'
        #|  | '\\u0966'..='\\u096F'
        #|  | '\\u09E6'..='\\u09EF'
        #|  | '\\u09F4'..='\\u09F9'
        #|  | '\\u0A66'..='\\u0A6F'
        #|  | '\\u0AE6'..='\\u0AEF'
        #|  | '\\u0B66'..='\\u0B6F'
        #|  | '\\u0B72'..='\\u0B77'
        #|  | '\\u0BE6'..='\\u0BEF'
        #|  | '\\u0BF0'..='\\u0BF2'
        #|  | '\\u0C66'..='\\u0C6F'
        #|  | '\\u0C78'..='\\u0C7E'
        #|  | '\\u0CE6'..='\\u0CEF'
        #|  | '\\u0D58'..='\\u0D5E'
        #|  | '\\u0D66'..='\\u0D6F'
        #|  | '\\u0D70'..='\\u0D78'
        #|  | '\\u0DE6'..='\\u0DEF'
        #|  | '\\u0E50'..='\\u0E59'
        #|  | '\\u0ED0'..='\\u0ED9'
        #|  | '\\u0F20'..='\\u0F33'
        #|  | '\\u1040'..='\\u1049'
        #|  | '\\u1090'..='\\u1099'
        #|  | '\\u1369'..='\\u137C'
        #|  | '\\u16EE'..='\\u16F0'
        #|  | '\\u17E0'..='\\u17E9'
        #|  | '\\u17F0'..='\\u17F9'
        #|  | '\\u1810'..='\\u1819'
        #|  | '\\u1946'..='\\u194F'
        #|  | '\\u19D0'..='\\u19DA'
        #|  | '\\u1A80'..='\\u1A89'
        #|  | '\\u1A90'..='\\u1A99'
        #|  | '\\u1B50'..='\\u1B59'
        #|  | '\\u1BB0'..='\\u1BB9'
        #|  | '\\u1C40'..='\\u1C49'
        #|  | '\\u1C50'..='\\u1C59'
        #|  | '\\u2070'
        #|  | '\\u2074'..='\\u2079'
        #|  | '\\u2080'..='\\u2089'
        #|  | '\\u2150'..='\\u2189'
        #|  | '\\u2460'..='\\u249B'
        #|  | '\\u24EA'..='\\u24FF'
        #|  | '\\u2776'..='\\u2793'
        #|  | '\\u2CFD'
        #|  | '\\u3007'
        #|  | '\\u3021'..='\\u3029'
        #|  | '\\u3038'..='\\u303A'
        #|  | '\\u3192'..='\\u3195'
        #|  | '\\u3220'..='\\u3229'
        #|  | '\\u3248'..='\\u324F'
        #|  | '\\u3251'..='\\u325F'
        #|  | '\\u3280'..='\\u3289'
        #|  | '\\u32B1'..='\\u32BF'
        #|  | '\\uA620'..='\\uA629'
        #|  | '\\uA6E6'..='\\uA6EF'
        #|  | '\\uA830'..='\\uA835'
        #|  | '\\uA8D0'..='\\uA8D9'
        #|  | '\\uA900'..='\\uA909'
        #|  | '\\uA9D0'..='\\uA9D9'
        #|  | '\\uA9F0'..='\\uA9F9'
        #|  | '\\uAA50'..='\\uAA59'
        #|  | '\\uABF0'..='\\uABF9'
        #|  | '\\uFF10'..='\\uFF19'
        #|  | '\\u{10107}'..='\\u{10133}'
        #|  | '\\u{10140}'..='\\u{10178}'
        #|  | '\\u{1018A}'..='\\u{1018B}'
        #|  | '\\u{102E1}'..='\\u{102FB}'
        #|  | '\\u{10320}'..='\\u{10323}'
        #|  | '\\u{10341}'
        #|  | '\\u{1034A}'
        #|  | '\\u{103D1}'..='\\u{103D5}'
        #|  | '\\u{104A0}'..='\\u{104A9}'
        #|  | '\\u{10858}'..='\\u{1085F}'
        #|  | '\\u{10879}'..='\\u{1087F}'
        #|  | '\\u{108A7}'..='\\u{108AF}'
        #|  | '\\u{108FB}'..='\\u{108FF}'
        #|  | '\\u{10916}'..='\\u{1091B}'
        #|  | '\\u{109BC}'..='\\u{109BD}'
        #|  | '\\u{109C0}'..='\\u{109CF}'
        #|  | '\\u{10A40}'..='\\u{10A48}'
        #|  | '\\u{10A7D}'..='\\u{10A7E}'
        #|  | '\\u{10A9D}'..='\\u{10A9F}'
        #|  | '\\u{10AEB}'..='\\u{10AEF}'
        #|  | '\\u{10B58}'..='\\u{10B5F}'
        #|  | '\\u{10B78}'..='\\u{10B7F}'
        #|  | '\\u{10BA9}'..='\\u{10BAF}'
        #|  | '\\u{10CFA}'..='\\u{10CFF}'
        #|  | '\\u{10D30}'..='\\u{10D39}'
        #|  | '\\u{10D40}'..='\\u{10D49}'
        #|  | '\\u{10E60}'..='\\u{10E7E}'
        #|  | '\\u{10F1D}'..='\\u{10F26}'
        #|  | '\\u{10F51}'..='\\u{10F54}'
        #|  | '\\u{10FC5}'..='\\u{10FCB}'
        #|  | '\\u{11052}'..='\\u{1106F}'
        #|  | '\\u{110F0}'..='\\u{110F9}'
        #|  | '\\u{11136}'..='\\u{1113F}'
        #|  | '\\u{111D0}'..='\\u{111D9}'
        #|  | '\\u{111E1}'..='\\u{111F4}'
        #|  | '\\u{112F0}'..='\\u{112F9}'
        #|  | '\\u{11450}'..='\\u{11459}'
        #|  | '\\u{114D0}'..='\\u{114D9}'
        #|  | '\\u{11650}'..='\\u{11659}'
        #|  | '\\u{116C0}'..='\\u{116C9}'
        #|  | '\\u{116D0}'..='\\u{116E3}'
        #|  | '\\u{11730}'..='\\u{1173B}'
        #|  | '\\u{118E0}'..='\\u{118F2}'
        #|  | '\\u{11950}'..='\\u{11959}'
        #|  | '\\u{11BF0}'..='\\u{11BF9}'
        #|  | '\\u{11C50}'..='\\u{11C6C}'
        #|  | '\\u{11D50}'..='\\u{11D59}'
        #|  | '\\u{11DA0}'..='\\u{11DA9}'
        #|  | '\\u{11F50}'..='\\u{11F59}'
        #|  | '\\u{11FC0}'..='\\u{11FD4}'
        #|  | '\\u{12400}'..='\\u{1246E}'
        #|  | '\\u{16130}'..='\\u{16139}'
        #|  | '\\u{16A60}'..='\\u{16A69}'
        #|  | '\\u{16AC0}'..='\\u{16AC9}'
        #|  | '\\u{16B50}'..='\\u{16B59}'
        #|  | '\\u{16B5B}'..='\\u{16B61}'
        #|  | '\\u{16D70}'..='\\u{16D79}'
        #|  | '\\u{16D80}'..='\\u{16E96}'
        #|  | '\\u{1CCF0}'..='\\u{1CCF9}'
        #|  | '\\u{1D2C0}'..='\\u{1D2F3}'
        #|  | '\\u{1D360}'..='\\u{1D378}'
        #|  | '\\u{1D7CE}'..='\\u{1D7FF}'
        #|  | '\\u{1E140}'..='\\u{1E149}'
        #|  | '\\u{1E2F0}'..='\\u{1E2F9}'
        #|  | '\\u{1E4F0}'..='\\u{1E4F9}'
        #|  | '\\u{1E5F1}'..='\\u{1E5FA}'
        #|  | '\\u{1E8C7}'..='\\u{1E8CF}'
        #|  | '\\u{1E950}'..='\\u{1E959}'
        #|  | '\\u{1EC71}'..='\\u{1ECB4}'
        #|  | '\\u{1ED01}'..='\\u{1ED3D}'
        #|  | '\\u{1F100}'..='\\u{1F10C}'
        #|  | '\\u{1FBF0}'..='\\u{1FBF9}')
      ),
    ),
    "is_printable": build(
      (
        #|// Check for control characters (Cc)
        #|  if self.is_control() {
        #|    return false
        #|  }
        #|  let self = self.to_int()
        #|  // Private use areas (Co)
        #|  if self is (0xE000..=0xF8FF | 0xF0000..=0xFFFFD | 0x100000..=0x10FFFD) {
        #|    return false
        #|  }
        #|  // Format characters (Cf)
        #|  if self
        #|    is ('\\u{00AD}'
        #|    | '\\u{0600}'..='\\u{0605}'
        #|    | '\\u{061C}'
        #|    | '\\u{06DD}'
        #|    | '\\u{070F}'
        #|    | '\\u{0890}'..='\\u{0891}'
        #|    | '\\u{08E2}'
        #|    | '\\u{180E}'
        #|    | '\\u{200B}'..='\\u{200F}'
        #|    | '\\u{202A}'..='\\u{202E}'
        #|    | '\\u{2060}'..='\\u{2064}'
        #|    | '\\u{2066}'..='\\u{206F}'
        #|    | '\\u{feff}'
        #|    | '\\u{FFF9}'..='\\u{FFFB}'
        #|    | '\\u{110BD}'
        #|    | '\\u{110CD}'
        #|    | '\\u{13430}'..='\\u{1343F}'
        #|    | '\\u{1BCA0}'..='\\u{1BCA3}'
        #|    | '\\u{1D173}'..='\\u{1D17A}'
        #|    | '\\u{E0001}'
        #|    | '\\u{E0020}'..='\\u{E007F}') {
        #|    return false
        #|  }
        #|  // Surrogate (Cs)
        #|  if self.is_surrogate() {
        #|    return false
        #|  }
        #|  // Line and paragraph separators (Zl, Zp)
        #|  if self == '\\u{2028}' || self == '\\u{2029}' {
        #|    return false
        #|  }
        #|  // Noncharacter
        #|  if self
        #|    is (0xFDD0..=0xFDEF
        #|    | 0xFFFE..=0xFFFF
        #|    | 0x1FFFE..=0x1FFFF
        #|    | 0x2FFFE..=0x2FFFF
        #|    | 0x3FFFE..=0x3FFFF
        #|    | 0x4FFFE..=0x4FFFF
        #|    | 0x5FFFE..=0x5FFFF
        #|    | 0x6FFFE..=0x6FFFF
        #|    | 0x7FFFE..=0x7FFFF
        #|    | 0x8FFFE..=0x8FFFF
        #|    | 0x9FFFE..=0x9FFFF
        #|    | 0xAFFFE..=0xAFFFF
        #|    | 0xBFFFE..=0xBFFFF
        #|    | 0xCFFFE..=0xCFFFF
        #|    | 0xDFFFE..=0xDFFFF
        #|    | 0xEFFFE..=0xEFFFF
        #|    | 0xFFFFE..=0xFFFFF
        #|    | 0x10FFFE..=0x10FFFF) {
        #|    return false
        #|  }
        #|  true
      ),
    ),
    "to_ascii_lowercase": build(
      (
        #|if self.is_ascii_uppercase() {
        #|    return (self.to_int() + 32).unsafe_to_char()
        #|  }
        #|  self
      ),
    ),
    "to_ascii_uppercase": build(
      (
        #|if self.is_ascii_lowercase() {
        #|    return (self.to_int() - 32).unsafe_to_char()
        #|  }
        #|  self
      ),
    ),
    "char_to_string": build(
      (
        #|fn char_to_string(char : Char) -> String { [char] }
      ),
    ),
    "to_hex_digit": build(
      (
        #|fn to_hex_digit(i : Int) -> Char { if i < 10 {
        #|      (i + '0').unsafe_to_char()
        #|    } else {
        #|      (i + 'a' - 10).unsafe_to_char()
        #|    } }
      ),
    ),
    "code": build("self.to_int()"),
    "hex_len": build("if code <= 0xFF {"),
    "utf16_len": build(
      (
        #|let code = self.to_int()
        #|  if code <= 0xFFFF {
        #|    1
        #|  } else {
        #|    2
        #|  }
      ),
    ),
    "is_bmp": build(
      (
        #|self.to_int() <= 0xFFFF
      ),
    ),
  }
})

///|
let deque_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/deque",
  fn(_env, build) {
    {
      "deq": build("T::{"),
      "len": build("self.len"),
      "deq": build("T::{"),
      "deq": build("T::{"),
      "old_cap": build("self.len"),
      "new_cap": build("if old_cap == 0 { 8 } else { old_cap * 2 }"),
      "new_buf": build("UninitializedArray::make(new_cap)"),
      "origin_head": build("self.buf[self.head]"),
      "origin_head": build("self.buf[self.head]"),
      "origin_back": build("self.buf[self.tail]"),
      "origin_back": build("self.buf[self.tail]"),
      "len": build("self.len"),
      "len": build("self.len"),
      "cap": build("buf.length()"),
      "head_len": build("cap - head"),
      "cap": build("buf.length()"),
      "head_len": build("cap - head"),
      "idx": build("(head + i) % buf.length()"),
      "idx": build("(head + i) % buf.length()"),
      "start": build("len - front.length()"),
      "start": build("head + len"),
      "cap": build("buf.length()"),
      "head_len": build("cap - head"),
      "cap": build("buf.length()"),
      "head_len": build("cap - head"),
      "cap": build("buf.length()"),
      "head_len": build("cap - head"),
      "cap": build("buf.length()"),
      "head_len": build("cap - head"),
      "cap": build("buf.length()"),
      "head_len": build("cap - head"),
      "cap": build("buf.length()"),
      "head_len": build("cap - head"),
      "dq": build("new()"),
      "len": build("self.length()"),
      "xs": build("Array::make(len, self[0])"),
      "join": build(
        (
          #|pub fn T::join(self : T[String], separator : @string.View) -> String { let str = separator.to_string()
          #|  self.iter().join(str) }
        ),
      ),
      "res": build("Array::make(self.length(), Json::null())"),
      "len": build("arr.length()"),
      "buf": build("UninitializedArray::make(len)"),
      "head": Int(0),
      "tail": build("len"),
      "target": build("T::{"),
      "cap": build("deque.buf.length()"),
      "head_len": build("cap - deque.head"),
      "len": build("match len {"),
      "deque": build("T::{"),
      "cap": build("self.buf.length()"),
      "start_idx": build("(self.head + start) % cap"),
      "start_len": build("cap - start_idx"),
      "new_head": build("self.head + len"),
      "len": build("self.len"),
      "h": build("i + (j - i) / 2"),
      "ord": build("cmp(self[h])"),
      "physical_index": build("(self.head + index) % self.buf.length()"),
      "len_self": build("self.length()"),
      "len_other": build("other.length()"),
      "cmp": build("len_self.compare(len_other)"),
      "cmp": build("self[i].compare(other[i])"),
      "cap": build("self.buf.length()"),
      "temp": build("self.buf[left]"),
      "len": build("self.len"),
      "new_buf": build("UninitializedArray::make(len)"),
      "src_idx": build("(self.head + len - i - 1) % self.buf.length()"),
      "n": build("self.len"),
      "buf_length": build("self.buf.length()"),
      "j": build("rand(i + 1)"),
      "i_pos": build("(self.head + i) % buf_length"),
      "j_pos": build("(self.head + j) % buf_length"),
      "tmp": build("self.buf[i_pos]"),
      "new_deque": build("self.copy()"),
    }
  },
)

///|
let double_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/double",
  fn(_env, build) {
    {
      "sinh": build(
        (
          #|if self.is_nan() || self.is_inf() {
          #|    return self
          #|  }
          #|  let ix = get_high_word(self).reinterpret_as_int() & 0x7fffffff
          #|  let abs_x = self.abs()
          #|  let shuge = 1.0e307
          #|  let h = if self < 0.0 { -0.5 } else { 0.5 }
          #|  if ix < 0x40360000 {
          #|    if ix < 0x3e300000 {
          #|      if shuge + self > 1.0 {
          #|        return self
          #|      }
          #|    }
          #|    let t = abs_x.expm1()
          #|    if ix < 0x3ff00000 {
          #|      return h * (2.0 * t - t * t / (t + 1.0))
          #|    }
          #|    return h * (t + t / (t + 1.0))
          #|  }
          #|  if ix < 0x40862E42 {
          #|    return h * abs_x.exp()
          #|  }
          #|  if abs_x.reinterpret_as_uint64() < 0x408633ce8fb9f87d {
          #|    let w = exp(0.5 * abs_x)
          #|    let t = h * w
          #|    return t * w
          #|  }
          #|  self * shuge
        ),
      ),
      "cosh": build(
        (
          #|if self.is_nan() {
          #|    return self
          #|  }
          #|  if self.is_inf() {
          #|    return infinity
          #|  }
          #|  let ix = get_high_word(self).reinterpret_as_int() & 0x7fffffff
          #|  if ix < 0x3fd62e43 {
          #|    let t = self.abs().expm1()
          #|    let w = 1.0 + t
          #|    if ix < 0x3c800000 {
          #|      return w
          #|    }
          #|    return 1.0 + t * t / (w + w)
          #|  }
          #|  if ix < 0x40360000 {
          #|    let t = self.abs().exp()
          #|    return 0.5 * t + 0.5 / t
          #|  }
          #|  if ix < 0x40862E42 {
          #|    return 0.5 * self.abs().exp()
          #|  }
          #|  let lx = get_low_word(self).reinterpret_as_int()
          #|  if ix < 0x408633ce || (ix == 0x408633ce && lx <= 0x8fb9f87d) {
          #|    let w = exp(0.5 * self.abs())
          #|    let t = 0.5 * w
          #|    return t * w
          #|  }
          #|  infinity
        ),
      ),
      "tanh": build(
        (
          #|if self.is_nan() {
          #|    return self
          #|  }
          #|  if self.is_pos_inf() {
          #|    return 1.0
          #|  }
          #|  if self.is_neg_inf() {
          #|    return -1.0
          #|  }
          #|  let ix = get_high_word(self).reinterpret_as_int() & 0x7fffffff
          #|  let tiny = 1.0e-300
          #|  let z = if ix < 0x40360000 {
          #|    if ix < 0x3c800000 {
          #|      self * (1.0 + self)
          #|    } else if ix >= 0x3ff00000 {
          #|      let t = (2.0 * self.abs()).expm1()
          #|      1.0 - 2.0 / (t + 2.0)
          #|    } else {
          #|      let t = (-2.0 * self.abs()).expm1()
          #|      -t / (t + 2.0)
          #|    }
          #|  } else {
          #|    1.0 - tiny
          #|  }
          #|  if self >= 0.0 {
          #|    z
          #|  } else {
          #|    -z
          #|  }
        ),
      ),
      "asinh": build(
        (
          #|if self.is_nan() || self.is_inf() {
          #|    return self
          #|  }
          #|  let one : Double = 1.0
          #|  let ln2 : Double = 6.93147180559945286227e-01
          #|  let huge : Double = 1.0e300
          #|  let hx = get_high_word(self).reinterpret_as_int()
          #|  let ix = hx & 0x7fffffff
          #|  if ix < 0x3e300000 {
          #|    if huge + self > one {
          #|      return self
          #|    }
          #|  }
          #|  let w : Double = if ix > 0x41b00000 {
          #|    self.abs().ln() + ln2
          #|  } else if ix > 0x40000000 {
          #|    let t = self.abs()
          #|    (2.0 * t + one / ((self * self + one).sqrt() + t)).ln()
          #|  } else {
          #|    let t = self * self
          #|    (self.abs() + t / (one + (one + t).sqrt())).ln_1p()
          #|  }
          #|  if hx > 0 {
          #|    w
          #|  } else {
          #|    -w
          #|  }
        ),
      ),
      "acosh": build(
        (
          #|let one = 1.0
          #|  let hx = get_high_word(self).reinterpret_as_int()
          #|  if self < 1.0 || self.is_nan() {
          #|    return not_a_number
          #|  } else if self == 1.0 {
          #|    return 0.0
          #|  } else if self.is_pos_inf() {
          #|    return infinity
          #|  } else if hx >= 0x41b00000 {
          #|    return self.ln() + ln2
          #|  } else if hx > 0x40000000 {
          #|    let t = self * self
          #|    return (2.0 * self - one / (self + (t - one).sqrt())).ln()
          #|  } else {
          #|    let t = self - one
          #|    return (t + (2.0 * t + t * t).sqrt()).ln_1p()
          #|  }
        ),
      ),
      "atanh": build(
        (
          #|let hx : Int = get_high_word(self).reinterpret_as_int()
          #|  let ix = hx & 0x7fffffff
          #|  if self.abs() > 1.0 {
          #|    return not_a_number
          #|  }
          #|  if self == 1.0 {
          #|    return infinity
          #|  }
          #|  if self == -1.0 {
          #|    return neg_infinity
          #|  }
          #|  if ix < 0x3e300000 && 1.0e300 + self > 0.0 {
          #|    return self
          #|  }
          #|  let self = self.abs()
          #|  let t = if self <= 0.5 {
          #|    let t = self + self
          #|    0.5 * (t + t * self / (1.0 - self)).ln_1p()
          #|  } else {
          #|    0.5 * ((self + self) / (1.0 - self)).ln_1p()
          #|  }
          #|  if hx >= 0 {
          #|    t
          #|  } else {
          #|    -t
          #|  }
        ),
      ),
      "set_low_word": build(
        (
          #|fn set_low_word(d : Double, v : UInt) -> Double { let bits : UInt64 = d.reinterpret_as_uint64()
          #|  let bits = bits & 0xFFFF_FFFF_0000_0000
          #|  let bits = bits | v.to_uint64()
          #|  bits.reinterpret_as_double() }
        ),
      ),
      "set_high_word": build(
        (
          #|fn set_high_word(d : Double, v : UInt) -> Double { let bits : UInt64 = d.reinterpret_as_uint64()
          #|  let bits = bits & 0x0000_0000_FFFF_FFFF
          #|  let bits = bits | (v.to_uint64() << 32)
          #|  bits.reinterpret_as_double() }
        ),
      ),
      "get_high_word": build(
        (
          #|fn get_high_word(x : Double) -> UInt { (x.reinterpret_as_uint64() >> 32).to_uint() }
        ),
      ),
      "get_low_word": build(
        (
          #|fn get_low_word(x : Double) -> UInt { x.reinterpret_as_uint64().to_uint() }
        ),
      ),
      "rem_pio2": build(
        (
          #|fn rem_pio2(x : Double, y : Array[Double]) -> Int { let hx = get_high_word(x).reinterpret_as_int()
          #|  let ix : Int = hx & 0x7fffffff
          #|  let mut z = 0.0
          #|  if ix <= 0x3fe921fb {
          #|    // |x| <= pi/4, no reduction needed
          #|    y[0] = x
          #|    y[1] = 0.0
          #|    return 0
          #|  }
          #|  if ix < 0x4002d97c {
          #|    // |x| < 3pi/4, special case with n = +-1
          #|    if hx > 0 {
          #|      z = x - PIO2_1
          #|      if ix != 0x3ff921fb {
          #|        // 33+53 bit pi is good enough
          #|        y[0] = z - PIO2_1T
          #|        y[1] = z - y[0] - PIO2_1T
          #|      } else {
          #|        // Near pi/2, use 33+33+53 bit pi
          #|        z = z - PIO2_2
          #|        y[0] = z - PIO2_2T
          #|        y[1] = z - y[0] - PIO2_2T
          #|      }
          #|      return 1
          #|    } else {
          #|      // Negative x
          #|      z = x + PIO2_1
          #|      if ix != 0x3ff921fb {
          #|        // 33+53 bit pi is good enough
          #|        y[0] = z + PIO2_1T
          #|        y[1] = z - y[0] + PIO2_1T
          #|      } else {
          #|        // Near pi/2, use 33+33+53 bit pi
          #|        let z = z + PIO2_2
          #|        y[0] = z + PIO2_2T
          #|        y[1] = z - y[0] + PIO2_2T
          #|      }
          #|      return -1
          #|    }
          #|  }
          #|  if ix <= 0x413921fb {
          #|    // |x| <= 2^19 * (pi/2), medium size
          #|    let t = x.abs()
          #|    let n = (t * INV_PIO2 + HALF).to_int()
          #|    let fn_ = n.to_double()
          #|    let mut r = t - fn_ * PIO2_1
          #|    let mut w = fn_ * PIO2_1T
          #|    if n < 32 && ix != npio2_hw[n - 1] {
          #|      y[0] = r - w
          #|    } else {
          #|      let j = ix >> 20
          #|      y[0] = r - w
          #|      let i = j - ((get_high_word(y[0]) >> 20).reinterpret_as_int() & 0x7ff)
          #|      if i > 16 {
          #|        // 2nd iteration needed, good to 118 bits
          #|        let t = r
          #|        w = fn_ * PIO2_2
          #|        r = t - w
          #|        w = fn_ * PIO2_2T - (t - r - w)
          #|        y[0] = r - w
          #|        let i = j - ((get_high_word(y[0]) >> 20).reinterpret_as_int() & 0x7ff)
          #|        if i > 49 {
          #|          // 3rd iteration needed, 151 bits accuracy
          #|          let t = r
          #|          w = fn_ * PIO2_3
          #|          r = t - w
          #|          w = fn_ * PIO2_3T - (t - r - w)
          #|          y[0] = r - w
          #|        }
          #|      }
          #|    }
          #|    y[1] = r - y[0] - w
          #|    if hx > 0 {
          #|      return n
          #|    } else {
          #|      y[0] = -y[0]
          #|      y[1] = -y[1]
          #|      return -n
          #|    }
          #|  }
          #|  // All other (large) arguments
          #|  if ix >= 0x7ff00000 {
          #|    // x is inf or NaN
          #|    y[0] = x - x
          #|    y[1] = y[0]
          #|    return 0
          #|  }
          #|  // Set z = scalbn(|x|, ilogb(x) - 23)
          #|  z = set_low_word(z, get_low_word(x))
          #|  let e0 = (ix >> 20) - 1046 // e0 = ilogb(z) - 23
          #|  z = set_high_word(z, (ix - (e0 << 20)).reinterpret_as_uint())
          #|  let tx = [0.0, 0.0, 0.0]
          #|  for i in 0..<2 {
          #|    tx[i] = z.to_int().to_double()
          #|    z = (z - tx[i]) * TWO24
          #|  }
          #|  tx[2] = z
          #|  let mut nx = 3
          #|  while tx[nx - 1] == 0.0 {
          #|    nx -= 1
          #|  }
          #|  let n = __kernel_rem_pio2(tx, y, e0, nx, 2)
          #|  if hx > 0 {
          #|    n
          #|  } else {
          #|    y[0] = -y[0]
          #|    y[1] = -y[1]
          #|    -n
          #|  } }
        ),
      ),
      "init_jk": build("[2, 3, 4, 6]"),
      "__kernel_sin": build(
        (
          #|fn __kernel_sin(x : Double, y : Double, iy : Int) -> Double { let s1 = -1.66666666666666324348e-01
          #|  let s2 = 8.33333333332248946124e-03
          #|  let s3 = -1.98412698298579493134e-04
          #|  let s4 = 2.75573137070700676789e-06
          #|  let s5 = -2.50507602534068634195e-08
          #|  let s6 = 1.58969099521155010221e-10
          #|  let mut z = 0.0
          #|  let mut r = 0.0
          #|  let mut v = 0.0
          #|  let ix = get_high_word(x) & 0x7fffffff
          #|  if ix < 0x3e400000 {
          #|    if x.to_int() == 0 {
          #|      return x
          #|    }
          #|  }
          #|  z = x * x
          #|  v = z * x
          #|  r = s2 + z * (s3 + z * (s4 + z * (s5 + z * s6)))
          #|  if iy == 0 {
          #|    x + v * (s1 + z * r)
          #|  } else {
          #|    x - (z * (0.5 * y - v * r) - y - v * s1)
          #|  } }
        ),
      ),
      "__kernel_cos": build(
        (
          #|fn __kernel_cos(x : Double, y : Double) -> Double { let one = 1.00000000000000000000e+00
          #|  let c1 = 4.16666666666666019037e-02
          #|  let c2 = -1.38888888888741095749e-03
          #|  let c3 = 2.48015872894767294178e-05
          #|  let c4 = -2.75573143513906633035e-07
          #|  let c5 = 2.08757232129817482790e-09
          #|  let c6 = -1.13596475577881948265e-11
          #|  let mut a = 0.0
          #|  let mut hz = 0.0
          #|  let mut z = 0.0
          #|  let mut r = 0.0
          #|  let mut qx = 0.0
          #|  let ix = get_high_word(x) & 0x7fffffff
          #|  if ix < 0x3e400000 {
          #|    if x.to_int() == 0 {
          #|      return one
          #|    }
          #|  }
          #|  z = x * x
          #|  r = z * (c1 + z * (c2 + z * (c3 + z * (c4 + z * (c5 + z * c6)))))
          #|  if ix < 0x3fd33333 {
          #|    return one - (0.5 * z - (z * r - x * y))
          #|  } else {
          #|    if ix > 0x3fe90000 {
          #|      qx = 0.28125
          #|    } else {
          #|      qx = ((ix - 0x00200000).to_uint64() << 32).reinterpret_as_double()
          #|    }
          #|    hz = 0.5 * z - qx
          #|    a = one - qx
          #|    return a - (hz - (z * r - x * y))
          #|  } }
        ),
      ),
      "__kernal_tan": build(
        (
          #|fn __kernal_tan(x : Double, y : Double, iy : Int) -> Double { let one = 1.0
          #|  let pio4 = 7.85398163397448278999e-01
          #|  let pio4lo = 3.06161699786838301793e-17
          #|  let mut x = x
          #|  let mut y = y
          #|  let mut z = 0.0
          #|  let mut r = 0.0
          #|  let mut v = 0.0
          #|  let mut w = 0.0
          #|  let mut s = 0.0
          #|  let t = [
          #|    3.33333333333334091986e-01, // 3FD55555, 55555563 */
          #|     1.33333333333201242699e-01, // 3FC11111, 1110FE7A */
          #|     5.39682539762260521377e-02, // 3FABA1BA, 1BB341FE */
          #|     2.18694882948595424599e-02, // 3F9664F4, 8406D637 */
          #|     8.86323982359930005737e-03, // 3F8226E3, E96E8493 */
          #|     3.59207910759131235356e-03, // 3F6D6D22, C9560328 */
          #|     1.45620945432529025516e-03, // 3F57DBC8, FEE08315 */
          #|     5.88041240820264096874e-04, // 3F4344D8, F2F26501 */
          #|     2.46463134818469906812e-04, // 3F3026F7, 1A8D1068 */
          #|     7.81794442939557092300e-05, // 3F147E88, A03792A6 */
          #|     7.14072491382608190305e-05, // 3F12B80F, 32F0A7E9 */
          #|     -1.85586374855275456654e-05, // BEF375CB, DB605373 */
          #|     2.59073051863633712884e-05, // 3EFB2A70, 74BF7AD4 */
          #|     1.00000000000000000000e+00, // 3FF00000, 00000000 (one) */
          #|     7.85398163397448278999e-01, // 3FE921FB, 54442D18 (pio4) */
          #|     3.06161699786838301793e-17, // 3C81A626, 33145C07 (pio4lo) */
          #|  ]
          #|  let hx = get_high_word(x).reinterpret_as_int()
          #|  let ix = hx & 0x7fffffff
          #|  if ix < 0x3e300000 {
          #|    if x.to_int() == 0 {
          #|      if (ix | get_low_word(x).reinterpret_as_int() | (iy + 1)) == 0 {
          #|        return one / x.abs()
          #|      } else if iy == 1 {
          #|        return x
          #|      } else {
          #|        w = x + y
          #|        z = w
          #|        z = set_low_word(z, 0)
          #|        v = y - (z - x)
          #|        let a = -one / w
          #|        let mut t = a
          #|        t = set_low_word(t, 0)
          #|        s = one + t * z
          #|        return t + a * (s + t * v)
          #|      }
          #|    }
          #|  }
          #|  if ix >= 0x3fe59428 {
          #|    if hx < 0 {
          #|      x = -x
          #|      y = -y
          #|    }
          #|    z = pio4 - x
          #|    w = pio4lo - y
          #|    x = z + w
          #|    y = 0.0
          #|  }
          #|  z = x * x
          #|  w = z * z
          #|  r = t[1] + w * (t[3] + w * (t[5] + w * (t[7] + w * (t[9] + w * t[11]))))
          #|  v = z *
          #|    (t[2] + w * (t[4] + w * (t[6] + w * (t[8] + w * (t[10] + w * t[12])))))
          #|  s = z * x
          #|  r = y + z * (s * (r + v) + y)
          #|  r += t[0] * s
          #|  w = x + r
          #|  if ix >= 0x3fe59428 {
          #|    v = iy.to_double()
          #|    return (1 - ((hx >> 30) & 2)).to_double() *
          #|      (v - 2.0 * (x - (w * w / (w + v) - r)))
          #|  }
          #|  if iy == 1 {
          #|    w
          #|  } else {
          #|    z = w
          #|    z = set_low_word(z, 0)
          #|    v = r - (z - x)
          #|    let a = -1.0 / w
          #|    let mut t = a
          #|    t = set_low_word(t, 0)
          #|    s = 1.0 + t * z
          #|    t + a * (s + t * v)
          #|  } }
        ),
      ),
      "sin": build(
        (
          #|if self.is_inf() || self.is_nan() {
          #|    return not_a_number
          #|  }
          #|  let y = [0.0, 0.0]
          #|  let z = 0.0
          #|  if self.abs() <= PI_OVER_4 {
          #|    return __kernel_sin(self, z, 0)
          #|  } else {
          #|    let n = rem_pio2(self, y)
          #|    match n & 3 {
          #|      0 => __kernel_sin(y[0], y[1], 1)
          #|      1 => __kernel_cos(y[0], y[1])
          #|      2 => -__kernel_sin(y[0], y[1], 1)
          #|      _ => -__kernel_cos(y[0], y[1])
          #|    }
          #|  }
        ),
      ),
      "cos": build(
        (
          #|if self.is_inf() || self.is_nan() {
          #|    return not_a_number
          #|  }
          #|  let y = [0.0, 0.0]
          #|  let z = 0.0
          #|  if self.abs() <= PI_OVER_4 {
          #|    return __kernel_cos(self, z)
          #|  } else {
          #|    let n = rem_pio2(self, y)
          #|    match n & 3 {
          #|      0 => __kernel_cos(y[0], y[1])
          #|      1 => -__kernel_sin(y[0], y[1], 1)
          #|      2 => -__kernel_cos(y[0], y[1])
          #|      _ => __kernel_sin(y[0], y[1], 1)
          #|    }
          #|  }
        ),
      ),
      "tan": build(
        (
          #|if self.is_inf() || self.is_nan() {
          #|    return not_a_number
          #|  }
          #|  let y = Array::make(2, 0.0)
          #|  let z = 0.0
          #|  if self.abs() <= PI_OVER_4 {
          #|    __kernal_tan(self, z, 1)
          #|  } else {
          #|    let n = rem_pio2(self, y)
          #|    __kernal_tan(y[0], y[1], 1 - ((n & 1) << 1))
          #|  }
        ),
      ),
      "asin": build(
        (
          #|let huge = 1.0e+300
          #|  let pio4_hi = 7.85398163397448278999e-01
          #|  let pio2_hi = 1.57079632679489655800
          #|  let pio2_lo = 6.12323399573676603587e-17
          #|  let ps0 = 1.66666666666666657415e-01
          #|  let ps1 = -3.25565818622400915405e-01
          #|  let ps2 = 2.01212532134862925881e-01
          #|  let ps3 = -4.00555345006794114027e-02
          #|  let ps4 = 7.91534994289814532176e-04
          #|  let ps5 = 3.47933107596021167570e-05
          #|  let qs1 = -2.40339491173441421878e+00
          #|  let qs2 = 2.02094576023350569471e+00
          #|  let qs3 = -6.88283971605453293030e-01
          #|  let qs4 = 7.70381505559019352791e-02
          #|  let ix = get_high_word(self).reinterpret_as_int() & 0x7fffffff
          #|  let absx = self.abs()
          #|  if absx >= 1.0 {
          #|    if absx == 1.0 {
          #|      return self * pio2_hi + self * pio2_lo
          #|    } else {
          #|      return not_a_number
          #|    }
          #|  } else if absx < 0.5 {
          #|    if ix < 0x3e400000 {
          #|      if huge + self > 1.0 {
          #|        return self
          #|      }
          #|    } else {
          #|      let t = self * self
          #|      let p = t *
          #|        (ps0 + t * (ps1 + t * (ps2 + t * (ps3 + t * (ps4 + t * ps5)))))
          #|      let q = 1.0 + t * (qs1 + t * (qs2 + t * (qs3 + t * qs4)))
          #|      let w = p / q
          #|      return self + self * w
          #|    }
          #|  }
          #|  let w = 1.0 - absx
          #|  let t = w * 0.5
          #|  let p = t * (ps0 + t * (ps1 + t * (ps2 + t * (ps3 + t * (ps4 + t * ps5)))))
          #|  let q = 1.0 + t * (qs1 + t * (qs2 + t * (qs3 + t * qs4)))
          #|  let s = t.sqrt()
          #|  if ix >= 0x3FEF3333 {
          #|    let w = p / q
          #|    let t = pio2_hi - (2.0 * (s + s * w) - pio2_lo)
          #|    return if self > 0.0 { t } else { -t }
          #|  } else {
          #|    let mut w = s
          #|    w = set_low_word(w, 0)
          #|    let c = (t - w * w) / (s + w)
          #|    let r = p / q
          #|    let p = 2.0 * s * r - (pio2_lo - 2.0 * c)
          #|    let q = pio4_hi - 2.0 * w
          #|    let t = pio4_hi - (p - q)
          #|    return if self > 0.0 { t } else { -t }
          #|  }
        ),
      ),
      "acos": build(
        (
          #|let one : Double = 1.0
          #|  let pi : Double = 3.14159265358979311600
          #|  let pio2_hi : Double = 1.57079632679489655800
          #|  let pio2_lo : Double = 6.12323399573676603587e-17
          #|  let ps0 : Double = 1.66666666666666657415e-01
          #|  let ps1 : Double = -3.25565818622400915405e-01
          #|  let ps2 : Double = 2.01212532134862925881e-01
          #|  let ps3 : Double = -4.00555345006794114027e-02
          #|  let ps4 : Double = 7.91534994289814532176e-04
          #|  let ps5 : Double = 3.47933107596021167570e-05
          #|  let qs1 : Double = -2.40339491173441421878e+00
          #|  let qs2 : Double = 2.02094576023350569471e+00
          #|  let qs3 : Double = -6.88283971605453293030e-01
          #|  let qs4 : Double = 7.70381505559019352791e-02
          #|  let ix = get_high_word(self).reinterpret_as_int() & 0x7fffffff
          #|  let absx = self.abs()
          #|  if absx >= 1.0 {
          #|    if absx == 1.0 {
          #|      if self > 0 {
          #|        return 0.0
          #|      } else {
          #|        return pi + 2.0 * pio2_lo
          #|      }
          #|    }
          #|    return not_a_number
          #|  }
          #|  if absx < 0.5 {
          #|    if ix <= 0x3c600000 {
          #|      return pio2_hi + pio2_lo
          #|    }
          #|    let z = self * self
          #|    let p = z * (ps0 + z * (ps1 + z * (ps2 + z * (ps3 + z * (ps4 + z * ps5)))))
          #|    let q = one + z * (qs1 + z * (qs2 + z * (qs3 + z * qs4)))
          #|    let r = p / q
          #|    pio2_hi - (self - (pio2_lo - self * r))
          #|  } else if self < 0 {
          #|    let z = (one + self) * 0.5
          #|    let p = z * (ps0 + z * (ps1 + z * (ps2 + z * (ps3 + z * (ps4 + z * ps5)))))
          #|    let q = one + z * (qs1 + z * (qs2 + z * (qs3 + z * qs4)))
          #|    let s = z.sqrt()
          #|    let r = p / q
          #|    let w = r * s - pio2_lo
          #|    pi - 2.0 * (s + w)
          #|  } else {
          #|    let z = (one - self) * 0.5
          #|    let s = z.sqrt()
          #|    let df = s
          #|    let c = (z - df * df) / (s + df)
          #|    let p = z * (ps0 + z * (ps1 + z * (ps2 + z * (ps3 + z * (ps4 + z * ps5)))))
          #|    let q = one + z * (qs1 + z * (qs2 + z * (qs3 + z * qs4)))
          #|    let r = p / q
          #|    let w = r * s + c
          #|    2.0 * (df + w)
          #|  }
        ),
      ),
      "atan": build(
        (
          #|if self.is_nan() || self == 0.0 {
          #|    return self
          #|  }
          #|  let atan_hi = [
          #|    4.63647609000806093515e-01, 7.85398163397448278999e-01, 9.82793723247329054082e-01,
          #|    1.57079632679489655800e+00,
          #|  ]
          #|  let atan_lo = [
          #|    2.26987774529616870924e-17, 3.06161699786838301793e-17, 1.39033110312309984516e-17,
          #|    6.12323399573676603587e-17,
          #|  ]
          #|  let a_t = [
          #|    3.33333333333329318027e-01, -1.99999999998764832476e-01, 1.42857142725034663711e-01,
          #|    -1.11111104054623557880e-01, 9.09088713343650656196e-02, -7.69187620504482999495e-02,
          #|    6.66107313738753120669e-02, -5.83357013379057348645e-02, 4.97687799461593236017e-02,
          #|    -3.65315727442169155270e-02, 1.62858201153657823623e-02,
          #|  ]
          #|  let one = 1.0
          #|  let huge = 1.0e300
          #|  let ix = get_high_word(self).reinterpret_as_int() & 0x7fffffff
          #|  let mut id = 0
          #|  let mut z = 0.0
          #|  let mut w = 0.0
          #|  let mut self = self
          #|  let x_is_neg = self < 0.0
          #|  if ix >= 0x44100000 {
          #|    if self > 0 {
          #|      return atan_hi[3] + atan_lo[3]
          #|    } else {
          #|      return -atan_hi[3] - atan_lo[3]
          #|    }
          #|  }
          #|  if ix < 0x3fdc0000 {
          #|    if ix < 0x3e200000 {
          #|      if huge + self > one {
          #|        return self
          #|      }
          #|    }
          #|    id = -1
          #|  } else {
          #|    self = self.abs()
          #|    if ix < 0x3ff30000 {
          #|      if ix < 0x3fe60000 {
          #|        id = 0
          #|        self = (2.0 * self - one) / (2.0 + self)
          #|      } else {
          #|        id = 1
          #|        self = (self - one) / (self + one)
          #|      }
          #|    } else if ix < 0x40038000 {
          #|      id = 2
          #|      self = (self - 1.5) / (one + 1.5 * self)
          #|    } else {
          #|      id = 3
          #|      self = -1.0 / self
          #|    }
          #|  }
          #|  z = self * self
          #|  w = z * z
          #|  let s1 = z *
          #|    (
          #|      a_t[0] +
          #|      w * (a_t[2] + w * (a_t[4] + w * (a_t[6] + w * (a_t[8] + w * a_t[10]))))
          #|    )
          #|  let s2 = w *
          #|    (a_t[1] + w * (a_t[3] + w * (a_t[5] + w * (a_t[7] + w * a_t[9]))))
          #|  if id < 0 {
          #|    self - self * (s1 + s2)
          #|  } else {
          #|    z = atan_hi[id] - (self * (s1 + s2) - atan_lo[id] - self)
          #|    if x_is_neg {
          #|      -z
          #|    } else {
          #|      z
          #|    }
          #|  }
        ),
      ),
      "atan2": build(
        (
          #|pub fn Double::atan2(self : Double, x : Double) -> Double { if x.is_nan() || self.is_nan() {
          #|    return not_a_number
          #|  }
          #|  let tiny = 1.0e-300
          #|  let zero = 0.0
          #|  let pi_o_4 = 7.8539816339744827900E-01
          #|  let pi_o_2 = 1.5707963267948965580E+00
          #|  let pi = 3.1415926535897931160E+00
          #|  let pi_lo = 1.2246467991473531772E-16
          #|  let hx = get_high_word(x).reinterpret_as_int()
          #|  let hy = get_high_word(self).reinterpret_as_int()
          #|  let ix = hx & 0x7fffffff
          #|  let iy = hy & 0x7fffffff
          #|  if x == 1.0 {
          #|    return self.atan()
          #|  }
          #|  let m = ((hy >> 31) & 1) | ((hx >> 30) & 2)
          #|  if self == 0 {
          #|    match m {
          #|      0 | 1 => return self
          #|      2 => return pi + tiny
          #|      _ => return -pi - tiny
          #|    }
          #|  }
          #|  if x == 0 {
          #|    return if hy < 0 { -pi_o_2 - tiny } else { pi_o_2 + tiny }
          #|  }
          #|  if x.is_inf() {
          #|    if self.is_inf() {
          #|      match m {
          #|        0 => return pi_o_4 + tiny
          #|        1 => return -pi_o_4 - tiny
          #|        2 => return 3.0 * pi_o_4 + tiny
          #|        _ => return -3.0 * pi_o_4 - tiny
          #|      }
          #|    } else {
          #|      match m {
          #|        0 => return zero
          #|        1 => return -zero
          #|        2 => return pi + tiny
          #|        _ => return -pi - tiny
          #|      }
          #|    }
          #|  }
          #|  if self.is_inf() {
          #|    return if hy < 0 { -pi_o_2 - tiny } else { pi_o_2 + tiny }
          #|  }
          #|  let k = (iy - ix) >> 20
          #|  let z = if k > 60 {
          #|    pi_o_2 + 0.5 * pi_lo
          #|  } else if hx < 0 && k < -60 {
          #|    0.0
          #|  } else {
          #|    (self / x).abs().atan()
          #|  }
          #|  match m {
          #|    0 => z
          #|    1 => -z
          #|    2 => pi - (z - pi_lo)
          #|    _ => z - pi_lo - pi
          #|  } }
        ),
      ),
      "exp_bias": Int(1023),
      "exp_bits": Int(11),
      "frac_bits": Int(52),
      "trunc": build(
        (
          #|let u64 = self.reinterpret_as_uint64()
          #|  let biased_exp = ((u64 >> frac_bits) & ((0x1UL << exp_bits) - 1)).to_int()
          #|  if biased_exp < exp_bias {
          #|    return (u64 & sign_mask).reinterpret_as_double()
          #|  } else if biased_exp >= exp_bias + frac_bits {
          #|    return self
          #|  }
          #|  let mask_shift = biased_exp - exp_bias + exp_bits
          #|  let trunc_mask = (sign_mask.reinterpret_as_int64() >> mask_shift).reinterpret_as_uint64()
          #|  return (u64 & trunc_mask).reinterpret_as_double()
        ),
      ),
      "ceil": build(
        (
          #|let trunced = self.trunc()
          #|  if self > trunced {
          #|    return trunced + 1.0
          #|  } else {
          #|    return trunced
          #|  }
        ),
      ),
      "floor": build(
        (
          #|let trunced = self.trunc()
          #|  if self < trunced {
          #|    return trunced - 1.0
          #|  } else {
          #|    return trunced
          #|  }
        ),
      ),
      "round": build(
        (
          #|floor(self + 0.5)
        ),
      ),
      "pow": build(
        (
          #|pub fn Double::pow(self : Double, other : Double) -> Double { fn set_low_word(d : Double, v : UInt) -> Double {
          #|    let bits : UInt64 = d.reinterpret_as_uint64()
          #|    let bits = bits & 0xFFFF_FFFF_0000_0000
          #|    let bits = bits | v.to_uint64()
          #|    bits.reinterpret_as_double()
          #|  }
          #|  fn set_high_word(d : Double, v : UInt) -> Double {
          #|    let bits : UInt64 = d.reinterpret_as_uint64()
          #|    let bits = bits & 0x0000_0000_FFFF_FFFF
          #|    let bits = bits | (v.to_uint64() << 32)
          #|    bits.reinterpret_as_double()
          #|  }
          #|  fn get_high_word(x : Double) -> UInt {
          #|    (x.reinterpret_as_uint64() >> 32).to_uint()
          #|  }
          #|  fn get_low_word(x : Double) -> UInt {
          #|    x.reinterpret_as_uint64().to_uint()
          #|  }
          #|  let x = self
          #|  let y = other
          #|  // double z, ax, z_h, z_l, p_h, p_l;
          #|  let mut z : Double = 0.0
          #|  let mut ax : Double = 0.0
          #|  let mut z_h : Double = 0.0
          #|  let mut z_l : Double = 0.0
          #|  let mut p_h : Double = 0.0
          #|  let mut p_l : Double = 0.0
          #|  // double y1, t1, t2, r, s, t, u, v, w
          #|  let mut y1 : Double = 0.0
          #|  let mut t1 : Double = 0.0
          #|  let mut t2 : Double = 0.0
          #|  let mut r : Double = 0.0
          #|  let mut s : Double = 0.0
          #|  let mut t : Double = 0.0
          #|  let mut u : Double = 0.0
          #|  let mut v : Double = 0.0
          #|  let mut w : Double = 0.0
          #|  // int i, j, k, yisint, n
          #|  let mut i : Int = 0
          #|  let mut j : Int = 0
          #|  let mut k : Int = 0
          #|  let mut yisint : Int = 0
          #|  let mut n : Int = 0
          #|  // int hx, hy, ix, iy;
          #|  // unsigned lx, ly;
          #|  //
          #|  // EXTRACT_WORDS(hx, lx, x);
          #|  // EXTRACT_WORDS(hy, ly, y);
          #|  // ix = hx & 0x7fffffff;
          #|  // iy = hy & 0x7fffffff;
          #|  let hx : Int = (x.reinterpret_as_uint64() >> 32).to_int()
          #|  let lx : UInt = (x.reinterpret_as_uint64() & 0xFFFFFFFF).to_uint()
          #|  let hy : Int = (y.reinterpret_as_uint64() >> 32).to_int()
          #|  let ly : UInt = (y.reinterpret_as_uint64() & 0xFFFFFFFF).to_uint()
          #|  let mut ix : Int = hx & 0x7FFFFFFF
          #|  let iy : Int = hy & 0x7FFFFFFF
          #|  // y==zero: x**0 = 1
          #|  if (iy.reinterpret_as_uint() | ly) == 0 {
          #|    return ONE
          #|  }
          #|  // +-NaN return x+y
          #|  if ix > 0x7FF00000 ||
          #|    (ix == 0x7FF00000 && lx != 0) ||
          #|    iy > 0x7FF00000 ||
          #|    (iy == 0x7FF00000 && ly != 0) {
          #|    return x + y
          #|  }
          #|  // determine if y is an odd int when x < 0
          #|  // yisint = 0 ... y is not an integer
          #|  // yisint = 1 ... y is an odd int
          #|  // yisint = 2 ... y is an even int
          #|  if hx < 0 {
          #|    if iy >= 0x43400000 {
          #|      yisint = 2 // even integer y
          #|    } else if iy >= 0x3ff00000 {
          #|      k = (iy >> 20) - 0x3ff // exponent
          #|      if k > 20 {
          #|        j = (ly >> (52 - k)).reinterpret_as_int()
          #|        if j << (52 - k) == ly.reinterpret_as_int() {
          #|          yisint = 2 - (j & 1)
          #|        }
          #|      } else if ly == 0 {
          #|        j = iy >> (20 - k)
          #|        if j << (20 - k) == iy {
          #|          yisint = 2 - (j & 1)
          #|        }
          #|      }
          #|    }
          #|  }
          #|  // special value of y
          #|  if ly == 0 {
          #|    if iy == 0x7ff00000 { // y is +-inf
          #|      if ((ix.reinterpret_as_uint() - 0x3ff00000) | lx) == 0 {
          #|        return y - y // inf**+-1 is NaN
          #|      } else if ix >= 0x3ff00000 { // (|x|>1)**+-inf = inf,0
          #|        return if hy >= 0 { y } else { ZERO }
          #|      } else { // (|x|<1)**-,+inf = inf,0
          #|        return if hy < 0 { -y } else { ZERO }
          #|      }
          #|    }
          #|    if iy == 0x3ff00000 { // y is  +-1
          #|      if hy < 0 {
          #|        return ONE / x
          #|      } else {
          #|        return x
          #|      }
          #|    }
          #|    if hy == 0x40000000 { // y is 2
          #|      return x * x
          #|    }
          #|    if hy == 0x3fe00000 { // y is 0.5
          #|      if hx >= 0 { // x >= +0
          #|        return x.sqrt()
          #|      }
          #|    }
          #|  }
          #|  ax = x.abs()
          #|  // special value of x
          #|  if lx == 0 {
          #|    if ix == 0x7ff00000 || ix == 0 || ix == 0x3ff00000 {
          #|      z = ax // x is +-0,+-inf,+-1 */
          #|      if hy < 0 {
          #|        z = ONE / z // z = (1/|x|)
          #|      }
          #|      if hx < 0 {
          #|        if ((ix - 0x3ff00000) | yisint) == 0 {
          #|          // (-1)**non-int is NaN
          #|          z = not_a_number
          #|        } else if yisint == 1 {
          #|          z = -z // (x<0)**odd = -(|x|**odd)
          #|        }
          #|      }
          #|      return z
          #|    }
          #|  }
          #|  n = (hx >> 31) + 1
          #|  // (x<0)**(non-int) is NaN
          #|  if (n | yisint) == 0 {
          #|    return not_a_number
          #|  }
          #|  s = ONE // s (sign of result -ve**odd) = -1 else = 1
          #|  if (n | (yisint - 1)) == 0 {
          #|    s = -ONE // (-ve)**(odd int)
          #|  }
          #|  // |y| is huge
          #|  if iy > 0x41e00000 { // if |y| > 2**31 */
          #|    if iy > 0x43f00000 { // if |y| > 2**64, must o/uflow */
          #|      if ix <= 0x3fefffff {
          #|        return if hy < 0 { POW_huge * POW_huge } else { POW_tiny * POW_tiny }
          #|      }
          #|      if ix >= 0x3ff00000 {
          #|        return if hy > 0 { POW_huge * POW_huge } else { POW_tiny * POW_tiny }
          #|      }
          #|    }
          #|    // over/underflow if x is not close to one */
          #|    if ix < 0x3fefffff {
          #|      return if hy < 0 {
          #|        s * POW_huge * POW_huge
          #|      } else {
          #|        s * POW_tiny * POW_tiny
          #|      }
          #|    }
          #|    if ix > 0x3ff00000 {
          #|      return if hy > 0 {
          #|        s * POW_huge * POW_huge
          #|      } else {
          #|        s * POW_tiny * POW_tiny
          #|      }
          #|    }
          #|    // now |1-x| is tiny <= 2**-20, suffice to compute
          #|    // log(x) by x-x^2/2+x^3/3-x^4/4 */
          #|    t = ax - ONE // t has 20 trailing zeros */
          #|    w = t * t * (0.5 - t * (0.3333333333333333333333 - t * 0.25))
          #|    u = POW_ivln2_h * t // POW_ivln2_h has 21 sig. bits */
          #|    v = t * POW_ivln2_l - w * POW_ivln2
          #|    t1 = u + v
          #|    t1 = set_low_word(t1, 0)
          #|    t2 = v - (t1 - u)
          #|  } else {
          #|    n = 0
          #|    // take care subnormal number
          #|    if ix < 0x00100000 {
          #|      ax *= POW_two53
          #|      n -= 53
          #|      ix = get_high_word(ax).reinterpret_as_int()
          #|    }
          #|    n += (ix >> 20) - 0x3ff
          #|    j = ix & 0x000fffff
          #|    // determine interval
          #|    ix = j | 0x3ff00000 // normalize ix
          #|    if j <= 0x3988E {
          #|      k = 0 // |x|<sqrt(3/2)
          #|    } else if j < 0xBB67A {
          #|      k = 1 // |x|<sqrt(3)
          #|    } else {
          #|      k = 0
          #|      n += 1
          #|      ix -= 0x00100000
          #|    }
          #|    ax = set_high_word(ax, ix.reinterpret_as_uint())
          #|    // compute ss = s_h+s_l = (x-1)/(x+1) or (x-1.5)/(x+1.5)
          #|    u = ax - pow_bp[k] // bp[0]=1.0, bp[1]=1.5
          #|    v = ONE / (ax + pow_bp[k])
          #|    let ss : Double = u * v
          #|    let mut s_h : Double = ss
          #|    s_h = set_low_word(s_h, 0)
          #|    // t_h=ax+bp[k] High
          #|    let mut t_h : Double = ZERO
          #|    t_h = set_high_word(
          #|      t_h,
          #|      ((ix.reinterpret_as_uint() >> 1) | 0x20000000) +
          #|      0x00080000 +
          #|      (k.reinterpret_as_uint() << 18),
          #|    )
          #|    let mut t_l : Double = ax - (t_h - pow_bp[k])
          #|    let s_l : Double = v * (u - s_h * t_h - s_h * t_l)
          #|    // compute log(ax)
          #|    let mut s2 : Double = ss * ss
          #|    r = s2 *
          #|      s2 *
          #|      (
          #|        POW_L1 +
          #|        s2 *
          #|        (POW_L2 + s2 * (POW_L3 + s2 * (POW_L4 + s2 * (POW_L5 + s2 * POW_L6))))
          #|      )
          #|    r += s_l * (s_h + ss)
          #|    s2 = s_h * s_h
          #|    t_h = 3.0 + s2 + r
          #|    t_h = set_low_word(t_h, 0)
          #|    t_l = r - (t_h - 3.0 - s2)
          #|    // u+v = ss*(1+...)
          #|    u = s_h * t_h
          #|    v = s_l * t_h + t_l * ss
          #|    // 2/(3log2)*(ss+...)
          #|    p_h = u + v
          #|    p_h = set_low_word(p_h, 0)
          #|    p_l = v - (p_h - u)
          #|    z_h = POW_cp_h * p_h // cp_h+cp_l = 2/(3*log2)
          #|    z_l = POW_cp_l * p_h + p_l * POW_cp + pow_dp_l[k]
          #|    // log2(ax) = (ss+..)*2/(3*log2) = n + dp_h + z_h + z_l
          #|    t = n.to_double()
          #|    t1 = z_h + z_l + pow_dp_h[k] + t
          #|    t1 = set_low_word(t1, 0)
          #|    t2 = z_l - (t1 - t - pow_dp_h[k] - z_h)
          #|  }
          #|  // split up y into y1+y2 and compute (y1+y2)*(t1+t2)
          #|  y1 = y
          #|  y1 = set_low_word(y1, 0)
          #|  p_l = (y - y1) * t1 + y * t2
          #|  p_h = y1 * t1
          #|  z = p_l + p_h
          #|  j = get_high_word(z).reinterpret_as_int()
          #|  i = get_low_word(z).reinterpret_as_int()
          #|  if j >= 0x40900000 { // z >= 1024
          #|    if ((j - 0x40900000) | i) != 0 { // if z > 1024
          #|      return s * POW_huge * POW_huge // overflow
          #|    } else if p_l + POW_ovt > z - p_h {
          #|      return s * POW_huge * POW_huge // overflow
          #|    }
          #|  } else if (j & 0x7fffffff) >= 0x4090cc00 { // z <= -1075
          #|    if ((j - 0xc090cc00) | i) != 0 { // z < -1075
          #|      return s * POW_tiny * POW_tiny // underflow
          #|    } else if p_l <= z - p_h {
          #|      return s * POW_tiny * POW_tiny // underflow
          #|    }
          #|  }
          #|  //
          #|  // compute 2**(p_h+p_l)
          #|  //
          #|  i = j & 0x7fffffff
          #|  k = (i >> 20) - 0x3ff
          #|  n = 0
          #|  if i > 0x3fe00000 { // if |z| > 0.5, set n = [z+0.5]
          #|    n = j + (0x00100000 >> (k + 1))
          #|    k = ((n & 0x7fffffff) >> 20) - 0x3ff // new k for n
          #|    t = ZERO
          #|    t = set_high_word(t, (n & (0x000fffff >> k).lnot()).reinterpret_as_uint())
          #|    n = ((n & 0x000fffff) | 0x00100000) >> (20 - k)
          #|    if j < 0 {
          #|      n = -n
          #|    }
          #|    p_h -= t
          #|  }
          #|  t = p_l + p_h
          #|  t = set_low_word(t, 0)
          #|  u = t * POW_lg2_h
          #|  v = (p_l - (t - p_h)) * POW_lg2 + t * POW_lg2_l
          #|  z = u + v
          #|  w = v - (z - u)
          #|  t = z * z
          #|  t1 = z -
          #|    t * (POW_P1 + t * (POW_P2 + t * (POW_P3 + t * (POW_P4 + t * POW_P5))))
          #|  r = z * t1 / (t1 - TWO - (w + z * w))
          #|  z = ONE - (r - z)
          #|  j = get_high_word(z).reinterpret_as_int()
          #|  j += (n.reinterpret_as_uint() << 20).reinterpret_as_int()
          #|  if j >> 20 <= 0 {
          #|    z = scalbn(z, n)
          #|  } else { // subnormal output */
          #|    let tmp = get_high_word(z).reinterpret_as_int()
          #|    z = set_high_word(
          #|      z,
          #|      (tmp + (n.reinterpret_as_uint() << 20).reinterpret_as_int()).reinterpret_as_uint(),
          #|    )
          #|  }
          #|  return s * z }
        ),
      ),
      "from_int": build(
        (
          #|pub fn Double::from_int(i : Int) -> Double { i.to_double() }
        ),
      ),
      "from_int": build(
        (
          #|pub fn from_int(i : Int) -> Double { i.to_double() }
        ),
      ),
      "signum": build(
        (
          #|if self < 0.0 {
          #|    -1.0
          #|  } else if self > 0.0 {
          #|    1.0
          #|  } else {
          #|    self // handles 0.0, -0.0, NaN
          #|  }
        ),
      ),
      "is_nan": build(
        (
          #|// only NaNs satisfy f != f.
          #|  self != self
        ),
      ),
      "is_inf": build(
        (
          #|self > max_value || self < min_value
        ),
      ),
      "is_pos_inf": build(
        (
          #|self > max_value
        ),
      ),
      "is_neg_inf": build(
        (
          #|self < min_value
        ),
      ),
      "d": build("-1.0"),
      "d": build("-2.0"),
      "to_string": build(
        (
          #|@ryu.ryu_to_string(self)
        ),
      ),
      "diff": build("(other - self).abs()"),
      "to_be_bytes": build(
        (
          #|self.reinterpret_as_uint64().to_be_bytes()
        ),
      ),
      "to_le_bytes": build(
        (
          #|self.reinterpret_as_uint64().to_le_bytes()
        ),
      ),
      "hypot": build(
        (
          #|pub fn Double::hypot(self : Double, y : Double) -> Double { if self.is_nan() || y.is_nan() {
          #|    return not_a_number
          #|  }
          #|  if self.is_inf() || y.is_inf() {
          #|    return infinity
          #|  }
          #|  let x = self.abs()
          #|  let y = y.abs()
          #|  let double_epsilon : Double = 0x0.0000000000001P-1022
          #|  let (x, y) = if y > x { (y, x) } else { (x, y) }
          #|  if x * double_epsilon >= y {
          #|    return x
          #|  }
          #|  let r = y / x
          #|  x * (1.0 + r * r).sqrt() }
        ),
      ),
      "nan": build(
        (
          #|not_a_number
        ),
      ),
      "inf": build(
        (
          #|pub fn Double::inf(sign : Int) -> Double { if sign >= 0 {
          #|    infinity
          #|  } else {
          #|    neg_infinity
          #|  } }
        ),
      ),
      "min_normal": build(
        (
          #|min_positive
        ),
      ),
      "x": build("self"),
      "y": build("other"),
      "sign_x": build("uint64_x >> 63"),
      "exp": build(
        (
          #|fn get_high_word(x : Double) -> UInt {
          #|    (x.reinterpret_as_uint64() >> 32).to_uint()
          #|  }
          #|  fn get_low_word(x : Double) -> UInt {
          #|    x.reinterpret_as_uint64().to_uint()
          #|  }
          #|  fn insert_words(ix0 : UInt64, ix1 : UInt64) -> Double {
          #|    let mut bits : UInt64 = 0
          #|    bits = bits | (ix0 << 32)
          #|    bits = bits | ix1
          #|    bits.reinterpret_as_double()
          #|  }
          #|  let mut x = self
          #|  let one = 1.0
          #|  let halF = [0.5, -0.5]
          #|  let o_threshold = 7.09782712893383973096e+02
          #|  let u_threshold = -7.45133219101941108420e+02
          #|  let ln2HI = [6.93147180369123816490e-01, -6.93147180369123816490e-01]
          #|  let ln2LO = [1.90821492927058770002e-10, -1.90821492927058770002e-10]
          #|  let invln2 = 1.44269504088896338700e+00
          #|  let p1 = 1.66666666666666019037e-01
          #|  let p2 = -2.77777777770155933842e-03
          #|  let p3 = 6.61375632143793436117e-05
          #|  let p4 = -1.65339022054652515390e-06
          #|  let p5 = 4.13813679705723846039e-08
          #|  let e = 2.718281828459045
          #|  let mut hi = 0.0
          #|  let mut lo = 0.0
          #|  let huge = 1.0e+300
          #|  let twom1000 = 9.33263618503218878990e-302
          #|  let two1023 = 8.988465674311579539e307
          #|  let mut k : Int = 0
          #|  let mut hx : UInt = get_high_word(self)
          #|  let xsb : Int = ((hx >> 31) & 1).reinterpret_as_int()
          #|  hx = hx & 0x7FFFFFFF
          #|  if hx >= 0x40862E42 {
          #|    if hx >= 0x7FF00000 {
          #|      let lx : UInt = get_low_word(self)
          #|      if ((hx & 0xFFFFF) | lx) != 0 {
          #|        return self + self
          #|      } else if xsb == 0 {
          #|        return self
          #|      } else {
          #|        return 0.0
          #|      }
          #|    }
          #|    if self > o_threshold {
          #|      return huge * huge
          #|    }
          #|    if self < u_threshold {
          #|      return twom1000 * twom1000
          #|    }
          #|  }
          #|  if hx > 0x3FD62E42 {
          #|    if hx < 0x3FF0A2B2 {
          #|      if self == 1.0 {
          #|        return e
          #|      }
          #|      hi = self - ln2HI[xsb]
          #|      lo = ln2LO[xsb]
          #|      k = 1 - xsb - xsb
          #|    } else {
          #|      k = (invln2 * self + halF[xsb]).to_int()
          #|      let t = k.to_double()
          #|      hi = self - t * ln2HI[0]
          #|      lo = t * ln2LO[0]
          #|    }
          #|    x = hi - lo
          #|  } else if hx < 0x3E300000 {
          #|    if huge + x > one {
          #|      return one + x
          #|    }
          #|  } else {
          #|    k = 0
          #|  }
          #|  let t = x * x
          #|  let twopk = if k >= -1021 {
          #|    insert_words(
          #|      (0x3FF00000 + (k.reinterpret_as_uint() << 20).reinterpret_as_int())
          #|      .to_int64()
          #|      .reinterpret_as_uint64(),
          #|      0,
          #|    )
          #|  } else {
          #|    insert_words(
          #|      0x3FF00000UL + ((k + 1000).reinterpret_as_uint() << 20).to_uint64(),
          #|      0,
          #|    )
          #|  }
          #|  let c = x - t * (p1 + t * (p2 + t * (p3 + t * (p4 + t * p5))))
          #|  if k == 0 {
          #|    return one - (x * c / (c - 2.0) - x)
          #|  }
          #|  let y = one - (lo - x * c / (2.0 - c) - hi)
          #|  if k >= -1021 {
          #|    if k == 1024 {
          #|      return y * 2.0 * two1023
          #|    } else {
          #|      return y * twopk
          #|    }
          #|  } else {
          #|    return y * twopk * twom1000
          #|  }
        ),
      ),
      "expm1": build(
        (
          #|if self.is_nan() {
          #|    return not_a_number
          #|  }
          #|  let o_threshold = 7.09782712893383973096e+02
          #|  if self > o_threshold {
          #|    return infinity
          #|  }
          #|  if self.is_inf() {
          #|    return -1.0
          #|  }
          #|  let huge = 1.0e+300
          #|  let tiny = 1.0e-300
          #|  let ln2_hi = 6.93147180369123816490e-01
          #|  let ln2_lo = 1.90821492927058770002e-10
          #|  let invln2 = 1.44269504088896338700e+00
          #|  let q1 = -3.33333333333331316428e-02
          #|  let q2 = 1.58730158725481460165e-03
          #|  let q3 = -7.93650757867487942473e-05
          #|  let q4 = 4.00821782732936239552e-06
          #|  let q5 = -2.01099218183624371326e-07
          #|  let mut x = self
          #|  let mut hx = get_high_word(x)
          #|  let xsb : Int = (hx & 0x80000000).reinterpret_as_int()
          #|  let mut y : Double = if xsb == 0 { x } else { -x }
          #|  hx = hx & 0x7fffffff
          #|  if hx >= 0x4043687A {
          #|    if xsb != 0 {
          #|      if x + tiny < 0.0 {
          #|        return tiny - 1.0
          #|      }
          #|    }
          #|  }
          #|  let mut hi = 0.0
          #|  let mut lo = 0.0
          #|  let mut k = 0
          #|  let mut c = 0.0
          #|  let mut t = 0.0
          #|  if hx > 0x3fd62e42 {
          #|    if hx < 0x3FF0A2B2 {
          #|      hi = if xsb == 0 { x - ln2_hi } else { x + ln2_hi }
          #|      lo = if xsb == 0 { ln2_lo } else { -ln2_lo }
          #|      k = if xsb == 0 { 1 } else { -1 }
          #|    } else {
          #|      k = (invln2 * x + (if xsb == 0 { 0.5 } else { -0.5 })).to_int()
          #|      t = k.to_double()
          #|      hi = x - t * ln2_hi
          #|      lo = t * ln2_lo
          #|    }
          #|    x = hi - lo
          #|    c = hi - x - lo
          #|  } else if hx < 0x3c900000 {
          #|    t = huge + x
          #|    return x - (t - (huge + x))
          #|  } else {
          #|    k = 0
          #|  }
          #|  let hfx : Double = 0.5 * x
          #|  let hxs : Double = x * hfx
          #|  let r1 : Double = 1.0 +
          #|    hxs * (q1 + hxs * (q2 + hxs * (q3 + hxs * (q4 + hxs * q5))))
          #|  let t : Double = 3.0 - r1 * hfx
          #|  let e : Double = hxs * ((r1 - t) / (6.0 - x * t))
          #|  if k == 0 {
          #|    return x - (x * e - hxs)
          #|  } else {
          #|    let e : Double = x * (e - c) - c
          #|    let e : Double = e - hxs
          #|    if k == -1 {
          #|      return 0.5 * (x - e) - 0.5
          #|    }
          #|    if k == 1 {
          #|      return if x < -0.25 {
          #|        -2.0 * (e - (x + 0.5))
          #|      } else {
          #|        1.0 + 2.0 * (x - e)
          #|      }
          #|    }
          #|    if k <= -2 || k > 56 {
          #|      y = 1.0 - (e - x)
          #|      y = set_high_word(y, get_high_word(y) + (k << 20).reinterpret_as_uint())
          #|      return y - 1.0
          #|    }
          #|    let mut t : Double = 1.0
          #|    if k < 20 {
          #|      t = set_high_word(0, (0x3ff00000 - (0x200000 >> k)).reinterpret_as_uint())
          #|      y = t - (e - x)
          #|      y = set_high_word(y, get_high_word(y) + (k << 20).reinterpret_as_uint())
          #|    } else {
          #|      t = set_high_word(0, ((0x3ff - k) << 20).reinterpret_as_uint())
          #|      y = x - (e + t) + 1.0
          #|      y = set_high_word(y, get_high_word(y) + (k << 20).reinterpret_as_uint())
          #|    }
          #|  }
          #|  y
        ),
      ),
      "round": build(
        (
          #|floor(self + 0.5)
        ),
      ),
      "to_uint": build(
        (
          #|if self != self {
          #|    0
          #|  } else if self >= 4294967295.0 {
          #|    4294967295U
          #|  } else if self <= 0 {
          #|    0
          #|  } else {
          #|    UInt::trunc_double(self)
          #|  }
        ),
      ),
      "scalbn": build(
        (
          #|fn scalbn(x : Double, exp : Int) -> Double { let mut n = exp
          #|  let mut y : Double = x
          #|  if n > 1023 {
          #|    y *= 0x1.0p1023
          #|    n -= 1023
          #|    if n > 1023 {
          #|      y *= 0x1.0p1023
          #|      n -= 1023
          #|      if n > 1023 {
          #|        n = 1023
          #|      }
          #|    }
          #|  } else if n < -1022 {
          #|    // make sure final n < -53 to avoid double
          #|    // rounding in the subnormal range
          #|    y *= 0x1.0p-1022 * 0x1.0p53
          #|    n += 1022 - 53
          #|    if n < -1022 {
          #|      y *= 0x1.0p-1022 * 0x1.0p53
          #|      n += 1022 - 53
          #|      if n < -1022 {
          #|        n = -1022
          #|      }
          #|    }
          #|  }
          #|  let ui = (0x3ff + n).to_uint64() << 52
          #|  return y * ui.reinterpret_as_double() }
        ),
      ),
      "sqrt2": build(
        "1.41421356237309504880168872420969807856967187537694807317667974",
      ),
      "ln2": build(
        "0.693147180559945309417232121458176568075500134360255254120680009",
      ),
      "ln2_hi": build("6.93147180369123816490e-01 // 3fe62e42 fee00000"),
      "ln2_lo": build("1.90821492927058770002e-10 // 3dea39ef 35793c76"),
      "l1": build("6.666666666666735130e-01 // 3FE55555 55555593"),
      "l2": build("3.999999999940941908e-01 // 3FD99999 9997FA04"),
      "l3": build("2.857142874366239149e-01 // 3FD24924 94229359"),
      "l4": build("2.222219843214978396e-01 // 3FCC71C5 1D8E78AF"),
      "l5": build("1.818357216161805012e-01 // 3FC74664 96CB03DE"),
      "l6": build("1.531383769920937332e-01 // 3FC39A09 D078C69F"),
      "l7": build("1.479819860511658591e-01 // 3FC2F112 DF3E5244"),
      "normalize": build(
        (
          #|fn normalize(f : Double) -> (Double, Int) { if f.abs() < min_positive {
          #|    return (f * (1L << 52).to_double(), -52)
          #|  }
          #|  (f, 0) }
        ),
      ),
      "frexp": build(
        (
          #|fn frexp(f : Double) -> (Double, Int) { if f == 0.0 || f.is_inf() || f.is_nan() {
          #|    return (f, 0)
          #|  }
          #|  let (norm_f, exp) = normalize(f)
          #|  let u = norm_f.reinterpret_as_uint64()
          #|  let exp = exp + ((u >> 52) & 0x7FF).to_int() - 1022
          #|  let frac = ((u & (0x7FFUL << 52).lnot()) | (1022UL << 52)).reinterpret_as_double()
          #|  return (frac, exp) }
        ),
      ),
      "ln": build(
        (
          #|if self < 0.0 {
          #|    return not_a_number
          #|  } else if self.is_nan() || self.is_inf() {
          #|    return self
          #|  } else if self == 0.0 {
          #|    return neg_infinity
          #|  }
          #|  let (f1, ki) = frexp(self)
          #|  let (f, k) = if f1 < sqrt2 / 2.0 {
          #|    (f1 * 2.0 - 1.0, (ki - 1).to_double())
          #|  } else {
          #|    (f1 - 1.0, ki.to_double())
          #|  }
          #|  let s = f / (2.0 + f)
          #|  let s2 = s * s
          #|  let s4 = s2 * s2
          #|  let t1 = s2 * (l1 + s4 * (l3 + s4 * (l5 + s4 * l7)))
          #|  let t2 = s4 * (l2 + s4 * (l4 + s4 * l6))
          #|  let r = t1 + t2
          #|  let hfsq = 0.5 * f * f
          #|  k * ln2_hi - (hfsq - (s * (hfsq + r) + k * ln2_lo) - f)
        ),
      ),
      "log2": build(
        (
          #|let (f, e) = frexp(self)
          #|  if f == 0.5 {
          #|    return e.to_double() - 1.0
          #|  }
          #|  ln(f) / ln2 + e.to_double()
        ),
      ),
      "log10": build(
        (
          #|if self < 0.0 {
          #|    return not_a_number
          #|  } else if self.is_nan() || self.is_inf() {
          #|    return self
          #|  } else if self == 0.0 {
          #|    return neg_infinity
          #|  }
          #|  let ivln10 = 4.34294481903251816668e-01
          #|  let log10_2hi = 3.01029995663611771306e-01
          #|  let log10_2lo = 3.69423907715893078616e-13
          #|  let (f, e) = frexp(self)
          #|  let (f, e) = if e >= 1 {
          #|    (f * 2.0, (e - 1).to_double())
          #|  } else {
          #|    (f, e.to_double())
          #|  }
          #|  let z = e * log10_2lo + ivln10 * f.ln()
          #|  z + e * log10_2hi
        ),
      ),
      "ln_1p": build(
        (
          #|if self < -1.0 || self.is_nan() {
          #|    return not_a_number
          #|  }
          #|  if self == -1.0 {
          #|    return neg_infinity
          #|  }
          #|  if self.is_inf() {
          #|    return infinity
          #|  }
          #|  let ln2_hi = 6.93147180369123816490e-01
          #|  let ln2_lo = 1.90821492927058770002e-10
          #|  let two54 = 1.80143985094819840000e+16
          #|  let lp1 = 6.666666666666735130e-01
          #|  let lp2 = 3.999999999940941908e-01
          #|  let lp3 = 2.857142874366239149e-01
          #|  let lp4 = 2.222219843214978396e-01
          #|  let lp5 = 1.818357216161805012e-01
          #|  let lp6 = 1.531383769920937332e-01
          #|  let zero = 0.0
          #|  let lp7 = 1.479819860511658591e-01
          #|  let hx = get_high_word(self).reinterpret_as_int()
          #|  let ax = hx & 0x7fffffff
          #|  let mut f = 0.0
          #|  let mut c = 0.0
          #|  let mut s = 0.0
          #|  let mut z = 0.0
          #|  let mut r = 0.0
          #|  let mut u = 0.0
          #|  let mut hu = 0
          #|  let mut k = 1
          #|  if hx < 0x3FDA827A {
          #|    if ax < 0x3e200000 {
          #|      if two54 + self > zero && ax < 0x3c900000 {
          #|        return self
          #|      } else {
          #|        return self - self * self * 0.5
          #|      }
          #|    }
          #|    if hx > 0 || hx <= 0xbfd2bec3 {
          #|      k = 0
          #|      f = self
          #|      hu = 1
          #|    }
          #|  }
          #|  if k != 0 {
          #|    if hx < 0x43400000 {
          #|      u = 1.0 + self
          #|      hu = get_high_word(u).reinterpret_as_int()
          #|      k = (hu >> 20) - 1023
          #|      c = if k > 0 { 1.0 - (u - self) } else { self - (u - 1.0) }
          #|      c /= u
          #|    } else {
          #|      u = self
          #|      hu = get_high_word(u).reinterpret_as_int()
          #|      k = (hu >> 20) - 1023
          #|      c = 0.0
          #|    }
          #|    hu = hu & 0x000fffff
          #|    if hu < 0x6a09e {
          #|      u = set_high_word(u, hu.reinterpret_as_uint() | 0x3ff00000)
          #|    } else {
          #|      k += 1
          #|      u = set_high_word(u, hu.reinterpret_as_uint() | 0x3fe00000)
          #|      hu = (0x00100000 - hu) >> 2
          #|    }
          #|    f = u - 1.0
          #|  }
          #|  let hfsq = 0.5 * f * f
          #|  if hu == 0 {
          #|    if f == zero {
          #|      if k == 0 {
          #|        return zero
          #|      } else {
          #|        c += k.to_double() * ln2_lo
          #|        return k.to_double() * ln2_hi + c
          #|      }
          #|    }
          #|    r = hfsq * (1.0 - 0.66666666666666666 * f)
          #|    if k == 0 {
          #|      return f - r
          #|    } else {
          #|      return k.to_double() * ln2_hi - (r - (k.to_double() * ln2_lo + c) - f)
          #|    }
          #|  }
          #|  s = f / (2.0 + f)
          #|  z = s * s
          #|  r = z *
          #|    (lp1 + z * (lp2 + z * (lp3 + z * (lp4 + z * (lp5 + z * (lp6 + z * lp7))))))
          #|  if k == 0 {
          #|    return f - (hfsq - s * (hfsq + r))
          #|  } else {
          #|    return k.to_double() * ln2_hi -
          #|      (hfsq - (s * (hfsq + r) + (k.to_double() * ln2_lo + c)) - f)
          #|  }
        ),
      ),
      "cbrt": build(
        (
          #|if self.is_inf() || self.is_nan() || self == 0.0 {
          #|    return self
          #|  }
          #|  let b1 : UInt = 715094163 // B1 = (682-0.03306235651)*2**20
          #|  let b2 : UInt = 696219795 // B2 = (664-0.03306235651)*2**20
          #|  let c = 5.42857142857142815906e-01 // 19/35     = 0x3FE15F15, 0xF15F15F1
          #|  let d = -7.05306122448979611050e-01 // -864/1225 = 0xBFE691DE, 0x2532C834
          #|  let e = 1.41428571428571436819e+00 // 99/70     = 0x3FF6A0EA, 0x0EA0EA0F
          #|  let f = 1.60714285714285720630e+00 // 45/28     = 0x3FF9B6DB, 0x6DB6DB6E
          #|  let g = 3.57142857142857150787e-01 // 5/14      = 0x3FD6DB6D, 0xB6DB6DB7
          #|  let hx = get_high_word(self).reinterpret_as_int()
          #|  let sign = if self < 0.0 { true } else { false }
          #|  let self = abs(self)
          #|  let t = if hx < 0x00100000 {
          #|    let t : UInt64 = 0x43500000_00000000
          #|    let t : Double = t.reinterpret_as_double()
          #|    let t = t * self
          #|    set_high_word(0, get_high_word(t) / 3 + b2)
          #|  } else {
          #|    set_high_word(0, hx.reinterpret_as_uint() / 3 + b1)
          #|  }
          #|  let r = t * t / self
          #|  let s = c + r * t
          #|  let t = t * (g + f / (s + e + d / s))
          #|  let t = set_high_word(0, get_high_word(t) + 0x00000001)
          #|  let s = t * t
          #|  let r = self / s
          #|  let w = t + t
          #|  let r = (r - t) / (w + r)
          #|  let t = t + t * r
          #|  if sign {
          #|    -t
          #|  } else {
          #|    t
          #|  }
        ),
      ),
    }
  },
)

///|
let env_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/env", fn(
  _env,
  build,
) {
  {
    "args": build(
      (
        #|get_cli_args_internal()
      ),
    ),
    "now": build(
      (
        #|now_internal()
      ),
    ),
    "current_dir": build(
      (
        #|current_dir_internal()
      ),
    ),
    "string_from_extern": build(
      (
        #|fn string_from_extern(e : XExternString) -> String { let buf = StringBuilder::new()
        #|  let handle = begin_read_string(e)
        #|  while true {
        #|    let ch = string_read_char(handle)
        #|    if ch == -1 {
        #|      break
        #|    } else {
        #|      buf.write_char(ch.unsafe_to_char())
        #|    }
        #|  }
        #|  finish_read_string(handle)
        #|  buf.to_string() }
      ),
    ),
    "string_array_from_extern": build(
      (
        #|fn string_array_from_extern(e : XExternStringArray) -> Array[String] { let buf = Array::new()
        #|  let handle = begin_read_string_array(e)
        #|  while true {
        #|    let extern_str = string_array_read_string(handle)
        #|    let str = string_from_extern(extern_str)
        #|    // keep \"ffi_end_of_/string_array\" same with moonrun
        #|    if str == \"ffi_end_of_/string_array\" {
        #|      break
        #|    } else {
        #|      buf.push(str)
        #|    }
        #|  }
        #|  finish_read_string_array(handle)
        #|  buf }
      ),
    ),
    "get_cli_args_internal": build(
      (
        #|let args = get_cli_args_ffi()
        #|  string_array_from_extern(args)
      ),
    ),
    "current_dir_internal": build(
      (
        #|let dir = current_dir_ffi()
        #|  let dir = string_from_extern(dir)
        #|  if dir == \"\" {
        #|    None
        #|  } else {
        #|    Some(dir)
        #|  }
      ),
    ),
    "get_cli_args_internal": build(
      (
        #|let tmp = get_cli_args_ffi()
        #|  let res = Array::new(capacity=tmp.length())
        #|  for i in 0..<tmp.length() {
        #|    res.push(utf8_bytes_to_mbt_string(tmp[i]))
        #|  }
        #|  res
      ),
    ),
    "utf8_bytes_to_mbt_string": build(
      (
        #|fn utf8_bytes_to_mbt_string(bytes : Bytes) -> String { let res = StringBuilder::new()
        #|  let len = bytes.length()
        #|  let mut i = 0
        #|  while i < len {
        #|    let mut c = bytes[i].to_int()
        #|    // zero byte indicates end of string
        #|    if c == 0 {
        #|      break
        #|    } else if c < 0x80 {
        #|      res.write_char(c.unsafe_to_char())
        #|      i += 1
        #|    } else if c < 0xE0 {
        #|      if i + 1 >= len {
        #|        break
        #|      }
        #|      c = ((c & 0x1F) << 6) | (bytes[i + 1].to_int() & 0x3F)
        #|      res.write_char(c.unsafe_to_char())
        #|      i += 2
        #|    } else if c < 0xF0 {
        #|      if i + 2 >= len {
        #|        break
        #|      }
        #|      c = ((c & 0x0F) << 12) |
        #|        ((bytes[i + 1].to_int() & 0x3F) << 6) |
        #|        (bytes[i + 2].to_int() & 0x3F)
        #|      res.write_char(c.unsafe_to_char())
        #|      i += 3
        #|    } else {
        #|      if i + 3 >= len {
        #|        break
        #|      }
        #|      c = ((c & 0x07) << 18) |
        #|        ((bytes[i + 1].to_int() & 0x3F) << 12) |
        #|        ((bytes[i + 2].to_int() & 0x3F) << 6) |
        #|        (bytes[i + 3].to_int() & 0x3F)
        #|      c -= 0x10000
        #|      res.write_char(((c >> 10) + 0xD800).unsafe_to_char())
        #|      res.write_char(((c & 0x3FF) + 0xDC00).unsafe_to_char())
        #|      i += 4
        #|    }
        #|  }
        #|  res.to_string() }
      ),
    ),
    "now_internal": build(
      (
        #|// time returns seconds since 1970-01-01 00:00:00 UTC
        #|  // to be consistent with other backends, we convert to milliseconds
        #|  time(0) * 1000
      ),
    ),
    "current_dir_internal": build(
      (
        #|// TODO: On Windows getcwd may fail if the path is too long(Windows allows paths up to 32k characters)
        #|  let buf = Bytes::new(4096)
        #|  let res = getcwd(buf, buf.length())
        #|  if res == 0 {
        #|    None
        #|  } else {
        #|    Some(utf8_bytes_to_mbt_string(buf))
        #|  }
      ),
    ),
  }
})

///|
let float_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/float",
  fn(_env, build) {
    {
      "exp_bias": Int(127),
      "exp_bits": Int(8),
      "frac_bits": Int(23),
      "trunc": build(
        (
          #|let u32 = self.reinterpret_as_uint()
          #|  let biased_exp = ((u32 >> frac_bits) & ((0x1U << exp_bits) - 1)).reinterpret_as_int()
          #|  if biased_exp < exp_bias {
          #|    return (u32 & sign_mask).reinterpret_as_float()
          #|  } else if biased_exp >= exp_bias + frac_bits {
          #|    return self
          #|  }
          #|  let mask_shift = biased_exp - exp_bias + exp_bits
          #|  let trunc_mask = (sign_mask.reinterpret_as_int() >> mask_shift).reinterpret_as_uint()
          #|  return (u32 & trunc_mask).reinterpret_as_float()
        ),
      ),
      "ceil": build(
        (
          #|let trunced = self.trunc()
          #|  if self > trunced {
          #|    return trunced + 1.0
          #|  } else {
          #|    return trunced
          #|  }
        ),
      ),
      "floor": build(
        (
          #|let trunced = self.trunc()
          #|  if self < trunced {
          #|    return trunced - 1.0
          #|  } else {
          #|    return trunced
          #|  }
        ),
      ),
      "round": build(
        (
          #|floor(self + 0.5)
        ),
      ),
      "default": build(
        (
          #|0.0
        ),
      ),
      "to_be_bytes": build(
        (
          #|self.reinterpret_as_uint().to_be_bytes()
        ),
      ),
      "to_le_bytes": build(
        (
          #|self.reinterpret_as_uint().to_le_bytes()
        ),
      ),
      "is_inf": build(
        (
          #|self.is_pos_inf() || self.is_neg_inf()
        ),
      ),
      "is_pos_inf": build(
        (
          #|self > max_value
        ),
      ),
      "is_neg_inf": build(
        (
          #|self < min_value
        ),
      ),
      "is_nan": build(
        (
          #|self != self
        ),
      ),
      "diff": build("(other - self).abs()"),
      "cbrt": build(
        (
          #|let b1 : UInt = 709958130 // B1 = (127-127.0/3-0.03306235651)*2**23 */
          #|  let b2 : UInt = 642849266 // B2 = (127-127.0/3-24/3-0.03306235651)*2**23 */
          #|  let mut ui : UInt = self.reinterpret_as_uint()
          #|  let mut hx : UInt = ui & 0x7fffffff
          #|  if hx >= 0x7f800000 {
          #|    // cbrt(NaN,INF) is itx
          #|    return self + self
          #|  }
          #|  // rough cbrt to 5 bits
          #|  if hx < 0x00800000 {
          #|    // zero or subnormal?
          #|    if hx == 0 {
          #|      return self
          #|    } // cbrt(+-0) is itx
          #|    ui = (self * (0x1.0p24 : Float)).reinterpret_as_uint()
          #|    hx = ui & 0x7fffffff
          #|    hx = hx / 3 + b2
          #|  } else {
          #|    hx = hx / 3 + b1
          #|  }
          #|  ui = ui & 0x80000000
          #|  ui = ui | hx
          #|  //
          #|  // First step Newton iteration (solving t*t-x/t == 0) to 16 bits.  In
          #|  // double precision so that its terms can be arranged for efficiency
          #|  // without causing overflow or underflow.
          #|  //
          #|  let dx = self.to_double()
          #|  let t = ui.reinterpret_as_float().to_double()
          #|  let r = t * t * t
          #|  let t = t * (dx + dx + r) / (dx + r + r)
          #|  //
          #|  // Second step Newton iteration to 47 bits.  In double precision for
          #|  // efficiency and accuracy.
          #|  //
          #|  let r = t * t * t
          #|  let t = t * (dx + dx + r) / (dx + r + r)
          #|  // rounding to 24 bits is perfect in round-to-nearest mode
          #|  t.to_float()
        ),
      ),
      "hypot": build(
        (
          #|pub fn Float::hypot(self : Float, y : Float) -> Float { let epsilon : Float = 1.1920928955078125e-7
          #|  let x = self.abs()
          #|  let y = y.abs()
          #|  if self.is_inf() || y.is_inf() {
          #|    return infinity
          #|  }
          #|  let (x, y) = if y > x { (y, x) } else { (x, y) }
          #|  if x * epsilon >= y {
          #|    return x
          #|  }
          #|  let rat = y / x
          #|  x * (rat * rat + 1.0).sqrt() }
        ),
      ),
      "exp": build(
        (
          #|let xd = self.to_double()
          #|  let abstop = top12(self) & 0x7ff
          #|  if abstop >= top12(88.0) {
          #|    if self.reinterpret_as_uint() == neg_infinity.reinterpret_as_uint() {
          #|      return 0.0
          #|    }
          #|    if abstop >= top12(infinity) {
          #|      return self + self
          #|    }
          #|    if self > 0x1.62e42ep6 {
          #|      return __math_oflowf(0)
          #|    }
          #|    if self < -0x1.9fe368p6 {
          #|      return __math_uflowf(0)
          #|    }
          #|  }
          #|  let z = exp2f_data.invln2_scaled * xd
          #|  let kd = z + exp2f_data.shift
          #|  let ki = kd.reinterpret_as_uint64()
          #|  let kd = kd - exp2f_data.shift
          #|  let r = z - kd
          #|  let t = exp2f_data.tab[(ki % expf_n).to_int()]
          #|  let t = t + (ki << (52 - exp2f_table_bits))
          #|  let s = t.reinterpret_as_double()
          #|  let z = exp2f_data.poly_scaled[0] * r + exp2f_data.poly_scaled[1]
          #|  let r2 = r * r
          #|  let y = exp2f_data.poly_scaled[2] * r + 1
          #|  let y = z * r2 + y
          #|  let y = y * s
          #|  y.to_float()
        ),
      ),
      "expm1": build(
        (
          #|let float_ln2_hi : Float = 6.9314575195e-01 // 0x3f317200
          #|  let float_ln2_lo : Float = 1.4286067653e-06 // 0x35bfbe8e
          #|  let inv_ln2 : Float = 1.4426950216e+00 // 0x3fb8aa3b
          #|  let mut x = self
          #|  let q1 : Float = -3.3333212137e-2 // -0x888868.0p-28
          #|  let q2 : Float = 1.5807170421e-3 //  0xcf3010.0p-33
          #|  let mut hx = x.reinterpret_as_uint()
          #|  let sign = hx >> 31 != 0
          #|  hx = hx & 0x7fffffff
          #|  // filter out huge and non-finite argument
          #|  if hx >= 0x4195b844 {
          #|    // if |x|>=27*ln2
          #|    if hx > 0x7f800000 {
          #|      // NaN
          #|      return x
          #|    }
          #|    if sign {
          #|      return -1.0
          #|    }
          #|    if hx > 0x42b17217 {
          #|      x *= (0x1.0p127 : Float)
          #|      return x
          #|    }
          #|  }
          #|  let mut k : Int = 0
          #|  let mut hi : Float = 0
          #|  let mut lo : Float = 0
          #|  let mut c : Float = 0
          #|  // argument reduction
          #|  if hx > 0x3eb17218 {
          #|    // if  |x| > 0.5 ln2
          #|    if hx < 0x3F851592 {
          #|      // and |x| < 1.5 ln2
          #|      if !sign {
          #|        hi = x - float_ln2_hi
          #|        lo = float_ln2_lo
          #|        k = 1
          #|      } else {
          #|        hi = x + float_ln2_hi
          #|        lo = -float_ln2_lo
          #|        k = -1
          #|      }
          #|    } else {
          #|      k = (inv_ln2 * x + (if sign { -0.5 } else { 0.5 })).to_int()
          #|      let t = k.to_float()
          #|      hi = x - t * float_ln2_hi // t*ln2_hi is exact here
          #|      lo = t * float_ln2_lo
          #|    }
          #|    x = hi - lo
          #|    c = hi - x - lo
          #|  } else if hx < 0x33000000 {
          #|    // when |x|<2**-25, return x
          #|    //if hx < 0x00800000 {
          #|    //    force_eval(x * x);
          #|    //}
          #|    return x
          #|  } else {
          #|    k = 0
          #|  }
          #|  // x is now in primary range
          #|  let hfx = (0.5 : Float) * x
          #|  let hxs = x * hfx
          #|  let r1 = (1.0 : Float) + hxs * (q1 + hxs * q2)
          #|  let t = (3.0 : Float) - r1 * hfx
          #|  let mut e = hxs * ((r1 - t) / ((6.0 : Float) - x * t))
          #|  if k == 0 {
          #|    // c is 0
          #|    return x - (x * e - hxs)
          #|  }
          #|  e = x * (e - c) - c
          #|  e -= hxs
          #|  // exp(x) ~ 2^k (x_reduced - e + 1)
          #|  if k == -1 {
          #|    return (0.5 : Float) * (x - e) - 0.5
          #|  }
          #|  if k == 1 {
          #|    if x < -0.25 {
          #|      return -(2.0 : Float) * (e - (x + 0.5))
          #|    }
          #|    return (1.0 : Float) + (2.0 : Float) * (x - e)
          #|  }
          #|  let twopk = ((0x7f + k) << 23).reinterpret_as_float() // 2^k
          #|  if !(k is (0..=56)) {
          #|    // suffice to return exp(x)-1
          #|    let mut y = x - e + 1.0
          #|    if k == 128 {
          #|      y = y * 2.0 * (0x1.0p127 : Float)
          #|    } else {
          #|      y = y * twopk
          #|    }
          #|    return y - 1.0
          #|  }
          #|  let uf = ((0x7f - k) << 23).reinterpret_as_float() // 2^-k
          #|  if k < 23 {
          #|    (x - e + ((1.0 : Float) - uf)) * twopk
          #|  } else {
          #|    (x - (e + uf) + 1.0) * twopk
          #|  }
        ),
      ),
      "sinh": build(
        (
          #|let x = self
          #|  let mut h : Float = 0.5
          #|  let mut ix = x.reinterpret_as_uint()
          #|  if ix >> 31 != 0 {
          #|    h = -h
          #|  }
          #|  // |x|
          #|  ix = ix & 0x7fffffff
          #|  let absx = ix.reinterpret_as_float()
          #|  let w = ix
          #|  // |self| < log(FLT_MAX)
          #|  if w < 0x42b17217 {
          #|    let t = absx.expm1()
          #|    if w < 0x3f800000 {
          #|      if w < 0x3f800000U - (12U << 23) {
          #|        return x
          #|      }
          #|      return h * ((2.0 : Float) * t - t * t / (t + 1.0))
          #|    }
          #|    return h * (t + t / (t + 1.0))
          #|  }
          #|  // |self| > logf(FLT_MAX) or nan
          #|  h * k_expo2f(absx) * 2.0
        ),
      ),
      "cosh": build(
        (
          #|let mut x = self
          #|  let mut ix = x.reinterpret_as_uint()
          #|  ix = ix & 0x7fffffff
          #|  x = ix.reinterpret_as_float()
          #|  let w = ix
          #|  // |x| < log(2)
          #|  if w < 0x3f317217 {
          #|    if w < 0x3f800000U - (12U << 23) {
          #|      return 1.0
          #|    }
          #|    let t = x.expm1()
          #|    return (1.0 : Float) + t * t / ((2.0 : Float) * (t + 1.0))
          #|  }
          #|  // |x| < log(FLT_MAX)
          #|  if w < 0x42b17217 {
          #|    let t = x.exp()
          #|    return (t + (1.0 : Float) / t) * 0.5
          #|  }
          #|  // |x| > log(FLT_MAX) or nan
          #|  k_expo2f(x)
        ),
      ),
      "tanh": build(
        (
          #|let x = self
          #|  let mut ix = x.reinterpret_as_uint()
          #|  let sign = ix >> 31 != 0
          #|  ix = ix & 0x7fffffff
          #|  let x = ix.reinterpret_as_float()
          #|  let w = ix
          #|  let tt = if w > 0x3f0c9f54 {
          #|    // |x| > log(3)/2 ~= 0.5493 or nan
          #|    if w > 0x41200000 {
          #|      // |x| > 10
          #|      (1.0 : Float) + (0.0 : Float) / x
          #|    } else {
          #|      let t = (x * 2.0).expm1()
          #|      (1.0 : Float) - (2.0 : Float) / (t + 2.0)
          #|    }
          #|  } else if w > 0x3e82c578 {
          #|    // |x| > log(5/3)/2 ~= 0.2554
          #|    let t = (x * 2.0).expm1()
          #|    t / (t + 2.0)
          #|  } else if w >= 0x00800000 {
          #|    // |x| >= 0x1p-126
          #|    let t = (x * -2.0).expm1()
          #|    -t / (t + 2.0)
          #|  } else {
          #|    // |x| is subnormal
          #|    x
          #|  }
          #|  if sign {
          #|    -tt
          #|  } else {
          #|    tt
          #|  }
        ),
      ),
      "asinh": build(
        (
          #|let x = self
          #|  let u = x.reinterpret_as_uint()
          #|  let i = u & 0x7fffffff
          #|  let sign = u >> 31 != 0
          #|  let ln2 : Float = 0.693147180559945309417232121458176568
          #|  let x = i.reinterpret_as_float()
          #|  let x = if i >= 0x3f800000U + (12U << 23) {
          #|    // |x| >= 0x1p12 or inf or nan
          #|    x.ln() + ln2
          #|  } else if i >= 0x3f800000U + (1U << 23) {
          #|    // |x| >= 2
          #|    (x * 2.0 + (1.0 : Float) / ((x * x + 1.0).sqrt() + x)).ln()
          #|  } else if i >= 0x3f800000U - (12U << 23) {
          #|    // |x| >= 0x1p-12, up to 1.6ulp error in [0.125,0.5]
          #|    (x + x * x / ((x * x + 1.0).sqrt() + 1.0)).ln_1p()
          #|  } else {
          #|    // |x| < 0x1p-12, raise inexact if x!=0
          #|    // x + 0x1.0p120
          #|    x
          #|  }
          #|  if sign {
          #|    -x
          #|  } else {
          #|    x
          #|  }
        ),
      ),
      "acosh": build(
        (
          #|let x = self
          #|  let ln2 : Float = 693147180559945309417232121458176568
          #|  let u = x.reinterpret_as_uint()
          #|  let a = u & 0x7fffffffU
          #|  if a < 0x3f800000U + (1U << 23) {
          #|    // |x| < 2, invalid if x < 1 or nan
          #|    // up to 2ulp error in [1,1.125]
          #|    return (x - 1.0 + ((x - 1.0) * (x - 1.0) + (2.0 : Float) * (x - 1.0)).sqrt()).ln_1p()
          #|  }
          #|  if a < 0x3f800000U + (12U << 23) {
          #|    // |x| < 0x1p12
          #|    return (x * 2.0 - (1.0 : Float) / (x + (x * x - 1.0).sqrt())).ln()
          #|  }
          #|  // x >= 0x1p12
          #|  return x.ln() + ln2
        ),
      ),
      "atanh": build(
        (
          #|let x = self
          #|  let u = x.reinterpret_as_uint()
          #|  let sign = u >> 31 != 0
          #|  let u = u & 0x7fffffff
          #|  let x = u.reinterpret_as_float()
          #|  let x = if u < 0x3f800000U - (1U << 23) {
          #|    if u < 0x3f800000U - (32U << 23) {
          #|      x
          #|    } else {
          #|      // |x| < 0.5, up to 1.7ulp error
          #|      (x * 2.0 + x * 2.0 * x / ((1.0 : Float) - x)).ln_1p() * 0.5
          #|    }
          #|  } else {
          #|    // avoid overflow
          #|    (x / ((1.0 : Float) - x) * 2.0).ln_1p() * 0.5
          #|  }
          #|  if sign {
          #|    -x
          #|  } else {
          #|    x
          #|  }
        ),
      ),
      "ln": build(
        (
          #|let mut ix : UInt = self.reinterpret_as_uint()
          #|  if ix == 0x3f800000U {
          #|    return 0.0
          #|  }
          #|  if ix - 0x00800000U >= 0x7f800000U - 0x00800000U {
          #|    if ix * 2 == 0 {
          #|      return neg_infinity
          #|    }
          #|    if ix == 0x7f800000U {
          #|      return self
          #|    }
          #|    if (ix & 0x80000000U) != 0 || ix * 2 >= 0xff000000U {
          #|      return not_a_number
          #|    }
          #|    ix = (self * 0x1.0p23).reinterpret_as_uint()
          #|    ix -= (23 << 23).reinterpret_as_uint()
          #|  }
          #|  let tmp = ix - logf_off
          #|  let i = ((tmp >> (23 - logf_table_bits)) % logf_n).reinterpret_as_int()
          #|  let k = tmp.reinterpret_as_int() >> 23
          #|  let iz = ix - (tmp & 0xff800000U)
          #|  let invc = logf_data.invc[i]
          #|  let logc = logf_data.logc[i]
          #|  let z = iz.reinterpret_as_float().to_double()
          #|  let r = z * invc - 1
          #|  let y0 = logc + k.to_double() * logf_data.ln2
          #|  let r2 = r * r
          #|  let y = logf_data.poly[1] * r + logf_data.poly[2]
          #|  let y = logf_data.poly[0] * r2 + y
          #|  let y = y * r2 + (y0 + r)
          #|  y.to_float()
        ),
      ),
      "ln_1p": build(
        (
          #|let lg1_f : Float = 0.66666662693
          #|  let lg2_f : Float = 0.40000972152
          #|  let lg3_f : Float = 0.28498786688
          #|  let lg4_f : Float = 0.24279078841
          #|  let float_ln2_hi : Float = 6.9314575195e-01 // 0x3f317200
          #|  let float_ln2_lo : Float = 1.4286067653e-06 // 0x35bfbe8e
          #|  let mut ui : UInt = self.reinterpret_as_uint()
          #|  let mut f : Float = 0
          #|  let mut c : Float = 0
          #|  let mut iu : UInt = 0
          #|  let one : Float = 1.0
          #|  let mut k = 1
          #|  if ui < 0x3ed413d0 || ui >> 31 > 0 {
          #|    if ui >= 0xbf800000 {
          #|      if self == -1.0 {
          #|        return self / 0.0
          #|      }
          #|      return (self - self) / 0.0
          #|    }
          #|    if ui << 1 < 0x33800000U << 1 {
          #|      return self
          #|    }
          #|    if ui <= 0xbe95f619 {
          #|      k = 0
          #|      c = 0.0
          #|      f = self
          #|    }
          #|  } else if ui >= 0x7f800000 {
          #|    return self
          #|  }
          #|  if k > 0 {
          #|    ui = (one + self).reinterpret_as_uint()
          #|    iu = ui
          #|    iu += 0x3f800000U - 0x3f3504f3U
          #|    k = (iu >> 23).reinterpret_as_int() - 0x7f
          #|    if k < 25 {
          #|      let fui = ui.reinterpret_as_float()
          #|      c = if k >= 2 { one - (fui - self) } else { self - (fui - 1.0) }
          #|      c /= ui.reinterpret_as_float()
          #|    } else {
          #|      c = 0.0
          #|    }
          #|    iu = (iu & 0x007fffff) + 0x3f3504f3
          #|    ui = iu
          #|    f = ui.reinterpret_as_float() - 1.0
          #|  }
          #|  let s = f / (f + 2.0)
          #|  let z = s * s
          #|  let w = z * z
          #|  let t1 = w * (lg2_f + w * lg4_f)
          #|  let t2 = z * (lg1_f + w * lg3_f)
          #|  let r = t2 + t1
          #|  let hfsq = f * f * 0.5
          #|  let dk = k.to_float()
          #|  s * (hfsq + r) + (dk * float_ln2_lo + c) - hfsq + f + dk * float_ln2_hi
        ),
      ),
      "sin": build(
        (
          #|let x = self
          #|  if x.is_nan() || x.is_inf() {
          #|    return not_a_number
          #|  }
          #|  if x == 0.0 {
          #|    return x
          #|  }
          #|  let (x, q) = trig_reduce(x, SIN_SWITCHOVER)
          #|  sin_cos_core(x, q)
        ),
      ),
      "cos": build(
        (
          #|let x = self
          #|  if x.is_nan() || x.is_inf() {
          #|    return not_a_number
          #|  }
          #|  if x == 0.0 {
          #|    return 1.0
          #|  }
          #|  let (x, q) = trig_reduce(x, COS_SWITCHOVER)
          #|  sin_cos_core(x, q + 1)
        ),
      ),
      "tan": build(
        (
          #|let x = self
          #|  if x.is_nan() || x.is_inf() {
          #|    return not_a_number
          #|  }
          #|  if x == 0.0 {
          #|    return x
          #|  }
          #|  let (x, q) = trig_reduce(x, COS_SWITCHOVER)
          #|  tanf_poly(x, (q & 1) != 0)
        ),
      ),
      "asin": build(
        (
          #|let x = self
          #|  let x1p120 = 0x3870000000000000UL.reinterpret_as_double()
          #|  let pio2 : Double = 1.570796326794896558e+00
          #|  // coefficients for R(x^2)
          #|  let ps0 : Float = 1.6666586697e-01
          #|  let ps1 : Float = -4.2743422091e-02
          #|  let ps2 : Float = -8.6563630030e-03
          #|  let qs2 : Float = -7.0662963390e-01
          #|  fn r(z : Float) -> Float {
          #|    let p = z * (ps0 + z * (ps1 + z * ps2))
          #|    let q = z * qs2 + 1.0
          #|    p / q
          #|  }
          #|  let hx = x.reinterpret_as_uint()
          #|  let ix = hx & 0x7fffffff
          #|  if ix >= 0x3f800000 {
          #|    if ix == 0x3f800000 {
          #|      return (x.to_double() * pio2 + x1p120).to_float()
          #|    }
          #|    return not_a_number // asin(|x|>1) is NaN
          #|  }
          #|  if ix < 0x3f000000 {
          #|    if ix is (0x00800000..=0x39800000) {
          #|      return x
          #|    }
          #|    return x + x * r(x * x)
          #|  }
          #|  let z = ((1.0 : Float) - x.abs()) * 0.5
          #|  let s = z.to_double().sqrt()
          #|  let x = (pio2 - 2.0 * (s + s * r(z).to_double())).to_float()
          #|  if hx >> 31 != 0 {
          #|    -x
          #|  } else {
          #|    x
          #|  }
        ),
      ),
      "acos": build(
        (
          #|let x = self
          #|  let pio2_hi : Float = 1.5707962513
          #|  let pio2_lo : Float = 7.5497894159e-08
          #|  let ps0 : Float = 1.6666586697e-01
          #|  let ps1 : Float = -4.2743422091e-02
          #|  let ps2 : Float = -8.6563630030e-03
          #|  let qs1 : Float = -7.0662963390e-01
          #|  let one : Float = 1.0
          #|  let two : Float = 2.0
          #|  fn r(z : Float) -> Float {
          #|    let p = z * (ps0 + z * (ps1 + z * ps2))
          #|    let q = z * qs1 + 1.0
          #|    p / q
          #|  }
          #|  let hx = x.reinterpret_as_int()
          #|  let ix = hx & 0x7fffffff
          #|  if ix >= 0x3f800000 {
          #|    if ix == 0x3f800000 {
          #|      if hx >> 31 != 0 {
          #|        return two * pio2_hi + 0x1.0p-120
          #|      }
          #|      return 0.0
          #|    }
          #|    return not_a_number
          #|  }
          #|  if ix < 0x3f000000 {
          #|    if ix <= 0x32800000 {
          #|      return pio2_hi + 0x1.0p-120
          #|    }
          #|    return pio2_hi - (x - (pio2_lo - x * r(x * x)))
          #|  }
          #|  if hx >> 31 != 0 {
          #|    let z = (x + 1.0) * 0.5
          #|    let s = z.sqrt()
          #|    let w = r(z) * s - pio2_lo
          #|    return two * (pio2_hi - (s + w))
          #|  }
          #|  let z = (one - x) * 0.5
          #|  let s = z.sqrt()
          #|  let df = s
          #|  let c = (z - df * df) / (s + df)
          #|  let w = r(z) * s + c
          #|  two * (df + w)
        ),
      ),
      "atan": build(
        (
          #|let x = self
          #|  let atanhi : Array[Float] = [
          #|    4.6364760399e-01, 7.8539812565e-01, 9.8279368877e-01, 1.5707962513e+00,
          #|  ]
          #|  let atanlo : Array[Float] = [
          #|    5.0121582440e-09, 3.7748947079e-08, 3.4473217170e-08, 7.5497894159e-08,
          #|  ]
          #|  let a_t : Array[Float] = [
          #|    3.3333328366e-01, -1.9999158382e-01, 1.4253635705e-01, -1.0648017377e-01, 6.1687607318e-02,
          #|  ]
          #|  let ix = x.reinterpret_as_int()
          #|  let sign = ix >> 31
          #|  let ix = ix & 0x7fffffff
          #|  let mut id = 0
          #|  let mut x = x
          #|  let one : Float = 1.0
          #|  let two : Float = 2.0
          #|  if ix >= 0x4c800000 {
          #|    if x.is_nan() {
          #|      return x
          #|    }
          #|    let z = atanhi[3] + 0x1.0p-120
          #|    let z = if sign != 0 { -z } else { z }
          #|    return z
          #|  }
          #|  if ix < 0x3ee00000 {
          #|    if ix < 0x39800000 {
          #|      return x
          #|    }
          #|    id = -1
          #|  } else {
          #|    x = x.abs()
          #|    if ix < 0x3f980000 {
          #|      if ix < 0x3f300000 {
          #|        id = 0
          #|        x = (two * x - one) / (two + x)
          #|      } else {
          #|        id = 1
          #|        x = (x - one) / (x + one)
          #|      }
          #|    } else if ix < 0x401c0000 {
          #|      id = 2
          #|      x = (x - 1.5) / (one + x * 1.5)
          #|    } else {
          #|      id = 3
          #|      x = -one / x
          #|    }
          #|  }
          #|  let z = x * x
          #|  let w = z * z
          #|  let s1 = z * (a_t[0] + w * (a_t[2] + w * a_t[4]))
          #|  let s2 = w * (a_t[1] + w * a_t[3])
          #|  if id < 0 {
          #|    return x - x * (s1 + s2)
          #|  }
          #|  let z = atanhi[id] - (x * (s1 + s2) - atanlo[id] - x)
          #|  if sign != 0 {
          #|    -z
          #|  } else {
          #|    z
          #|  }
        ),
      ),
      "atan2": build(
        (
          #|pub fn Float::atan2(self : Float, other : Float) -> Float { let (y, x) = (self, other)
          #|  if x.is_nan() || y.is_nan() {
          #|    return not_a_number
          #|  }
          #|  let pi : Float = 3.1415927410e+00
          #|  let pi_lo : Float = -8.7422776573e-08
          #|  let zero : Float = 0.0
          #|  let ix = x.reinterpret_as_uint()
          #|  let iy = y.reinterpret_as_uint()
          #|  if ix == 0x3f800000 {
          #|    return y.atan()
          #|  }
          #|  let m = ((iy >> 31) & 1) | ((ix >> 30) & 2)
          #|  let ix = ix & 0x7fffffff
          #|  let iy = iy & 0x7fffffff
          #|  if iy == 0 {
          #|    match m {
          #|      0 | 1 => return y
          #|      2 => return pi
          #|      _ => return -pi
          #|    }
          #|  }
          #|  if ix == 0 {
          #|    let res = if (m & 1) != 0 { -pi / 2 } else { pi / 2 }
          #|    return res
          #|  }
          #|  if ix == 0x7f800000 {
          #|    if iy == 0x7f800000 {
          #|      match m {
          #|        0 => return pi / 4
          #|        1 => return -pi / 4
          #|        2 => return pi * 3.0 / 4
          #|        _ => return -pi * 3.0 / 4
          #|      }
          #|    } else {
          #|      match m {
          #|        0 => return 0.0
          #|        1 => return -0.0
          #|        2 => return pi
          #|        _ => return -pi
          #|      }
          #|    }
          #|  }
          #|  if ix + (26U << 23) < iy || iy == 0x7f800000 {
          #|    let res = if (m & 1) != 0 { -pi / 2 } else { pi / 2 }
          #|    return res
          #|  }
          #|  let z = if (m & 2) != 0 && iy + (26U << 23) < ix {
          #|    zero
          #|  } else {
          #|    (y / x).atan()
          #|  }
          #|  match m {
          #|    0 => z
          #|    1 => -z
          #|    2 => pi - (z - pi_lo)
          #|    _ => z - pi_lo - pi
          #|  } }
        ),
      ),
      "logf_off": UInt(0x3f330000U),
      "logf_table_bits": Int(4),
      "k_expo2f": build(
        (
          #|fn k_expo2f(x : Float) -> Float { let k = 235
          #|  let k_ln2 = (0x4322e3bc).reinterpret_as_float()
          #|  // note that k is odd and scale*scale overflows */
          #|  let scale = ((0x7f + k / 2) << 23).reinterpret_as_float()
          #|  // exp(x - k ln2) * 2**(k-1) */
          #|  (x - k_ln2).exp() * scale * scale }
        ),
      ),
      "round": build(
        (
          #|floor(self + 0.5)
        ),
      ),
      "mulh": build(
        (
          #|fn mulh(a : UInt, b : UInt) -> UInt { let a = a.to_uint64()
          #|  let b = b.to_uint64()
          #|  let res = a * b
          #|  (res >> 32).to_uint() }
        ),
      ),
      "mul": build(
        (
          #|fn mul(a : UInt, b : UInt) -> (UInt, UInt) { let a = a.to_uint64()
          #|  let b = b.to_uint64()
          #|  let res = a * b
          #|  ((res >> 32).to_uint(), res.to_uint()) }
        ),
      ),
      "trig_reduce": build(
        (
          #|fn trig_reduce(x : Float, switch_over : Float) -> (Float, Int) { if x.abs() <= switch_over {
          #|    let mut j : Float = 0.0
          #|    let mut r : Float = 0.0
          #|    j = x * (0x3f22f983).reinterpret_as_float() +
          #|      (0x4b40_0000).reinterpret_as_float()
          #|    j = (j.reinterpret_as_int() - 0x4b40_0000).to_float()
          #|    r = x - j * (0x3fc90f80).reinterpret_as_float()
          #|    r = r - j * (0x37354440).reinterpret_as_float()
          #|    r = r - j * (0x2c34611a).reinterpret_as_float()
          #|    return (r, j.to_int())
          #|  }
          #|  let xispos = x > 0.0
          #|  let mut exp : Int = ((x.reinterpret_as_int() >> 23) & 0xff) - 126
          #|  let ix = ((x.reinterpret_as_uint() & 0x007fffff) << 8) | 0x80000000
          #|  let ind = exp >> 5
          #|  exp = exp & 0x1f
          #|  let two_over_pi : Array[UInt] = [
          #|    0x00000000, 0x28be60db, 0x9391054a, 0x7f09d5f4, 0x7d4d3770, 0x36d8a566, 0x4f10e410,
          #|    0000000000,
          #|  ]
          #|  let mut hi = two_over_pi[ind]
          #|  let mut mi = two_over_pi[ind + 1]
          #|  let mut lo = two_over_pi[ind + 2]
          #|  let tp = two_over_pi[ind + 3]
          #|  if exp > 0 {
          #|    hi = (hi << exp) | (mi >> (32 - exp))
          #|    mi = (mi << exp) | (lo >> (32 - exp))
          #|    lo = (lo << exp) | (tp >> (32 - exp))
          #|  }
          #|  let phi = 0U
          #|  let (h, l) = mul(ix, lo)
          #|  let plo = phi + l
          #|  let phi = h + (if plo < l { 1 } else { 0 })
          #|  let (h, l) = mul(ix, mi)
          #|  let mut plo = phi + l
          #|  let phi = h + (if plo < l { 1 } else { 0 })
          #|  let l = ix * hi
          #|  let mut phi = phi + l
          #|  let mut q : Int = (phi >> 30).reinterpret_as_int()
          #|  phi = phi & 0x3fffffff
          #|  if (phi & 0x2000_0000) != 0 {
          #|    phi = phi - 0x4000_0000
          #|    q = q + 1
          #|  }
          #|  let s : UInt = phi & 0x8000_0000
          #|  if phi >= 0x8000_0000 {
          #|    phi = phi.lnot()
          #|    plo = 0U - plo
          #|    //phi += (plo == 0).to_uint()
          #|    phi += if plo == 0 { 1 } else { 0 }
          #|  }
          #|  exp = 0
          #|  while phi < 0x8000_0000 {
          #|    phi = (phi << 1) | (plo >> 31)
          #|    plo = plo << 1
          #|    exp = exp - 1
          #|  }
          #|  phi = mulh(phi, 0xc90f_daa2)
          #|  if phi < 0x8000_0000 {
          #|    phi = phi << 1
          #|    exp = exp - 1
          #|  }
          #|  let mut r = s +
          #|    ((exp + 128) << 23).reinterpret_as_uint() +
          #|    (phi >> 8) +
          #|    (if (phi & 0xff) > 0x7e { 1 } else { 0 })
          #|  if !xispos {
          #|    r = r ^ 0x8000_0000
          #|    q = -q
          #|  }
          #|  let r = r.reinterpret_as_float()
          #|  return (r, q) }
        ),
      ),
      "sinf_poly": build(
        (
          #|fn sinf_poly(x : Float) -> Float { let s = x * x
          #|  let mut r = (0x3640_5000).reinterpret_as_float()
          #|  r = r * s - (0x3950_3486).reinterpret_as_float()
          #|  r = r * s + (0x3c08_88c1).reinterpret_as_float()
          #|  r = r * s - (0x3e2a_aaab).reinterpret_as_float()
          #|  let t = x * s
          #|  r = r * t + x
          #|  r }
        ),
      ),
      "cosf_poly": build(
        (
          #|fn cosf_poly(x : Float) -> Float { let s = x * x
          #|  let mut r = (0x37cd_4000).reinterpret_as_float()
          #|  r = r * s - (0x3ab6_077d).reinterpret_as_float()
          #|  r = r * s + (0x3d2a_aaa8).reinterpret_as_float()
          #|  r = r * s - (0x3f00_0000).reinterpret_as_float()
          #|  r = r * s + (0x3f80_0000).reinterpret_as_float()
          #|  r }
        ),
      ),
      "sin_cos_core": build(
        (
          #|fn sin_cos_core(x : Float, q : Int) -> Float { let mut r = if (q & 1) != 0 { cosf_poly(x) } else { sinf_poly(x) }
          #|  if (q & 2) != 0 {
          #|    r = -r
          #|  }
          #|  r }
        ),
      ),
      "tanf_poly": build(
        (
          #|fn tanf_poly(x : Float, odd : Bool) -> Float { let x = x.to_double()
          #|  let coef : FixedArray[Double] = [
          #|    0.333331395030791399758, // 0x15554d3418c99f.0p-54 */
          #|     0.133392002712976742718, // 0x1112fd38999f72.0p-55 */
          #|     0.0533812378445670393523, // 0x1b54c91d865afe.0p-57 */
          #|     0.0245283181166547278873, // 0x191df3908c33ce.0p-58 */
          #|     0.00297435743359967304927, // 0x185dadfcecf44e.0p-61 */
          #|     0.00946564784943673166728, // 0x1362b9bf971bcd.0p-59 */
          #|  ]
          #|  let z = x * x
          #|  let mut r = coef[4] + z * coef[5]
          #|  let t = coef[2] + z * coef[3]
          #|  let w = z * z
          #|  let s = z * x
          #|  let u = coef[0] + z * coef[1]
          #|  r = x + s * u + s * w * (t + w * r)
          #|  (if odd { -1.0 / r } else { r }).to_float() }
        ),
      ),
      "top12": build(
        (
          #|fn top12(x : Float) -> UInt { x.reinterpret_as_uint() >> 20 }
        ),
      ),
      "__math_xflowf": build(
        (
          #|fn __math_xflowf(sign : UInt, y : Float) -> Float { return (if sign != 0 { -y } else { y }) * y }
        ),
      ),
      "__math_oflowf": build(
        (
          #|fn __math_oflowf(sign : UInt) -> Float { return __math_xflowf(sign, 0x1.0p97) }
        ),
      ),
      "__math_uflowf": build(
        (
          #|fn __math_uflowf(sign : UInt) -> Float { return __math_xflowf(sign, 0x1.0p-95) }
        ),
      ),
      "exp2f_table_bits": Int(5),
      "pow": build(
        (
          #|pub fn Float::pow(self : Float, other : Float) -> Float { self.to_double().pow(other.to_double()).to_float() }
        ),
      ),
      "to_int": build(
        (
          #|if self != self {
          #|    0
          #|  } else if self >= 2147483647 {
          #|    2147483647
          #|  } else if self <= -2147483648 {
          #|    -2147483648
          #|  } else {
          #|    self.to_unchecked_int()
          #|  }
        ),
      ),
    }
  },
)

///|
let hashmap_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/hashmap",
  fn(_env, build) {
    {
      "object": build("Map::new(capacity=self.capacity)"),
      "s": build("if i > 0 { s + \",\" } else { s }"),
      "m": build("new()"),
      "res": build("while i < self.capacity {"),
      "capacity": build("capacity.next_power_of_two()"),
      "m": build("new(capacity=arr.length())"),
      "curr_entry": build("if entry.psl > curr_entry.psl {"),
      "hash": build("key.hash()"),
      "hash": build("key.hash()"),
      "v": build("init()"),
      "hash": build("key.hash()"),
      "hash": build("key.hash()"),
      "hash": build("key.hash()"),
      "hash": build("key.hash()"),
      "old_entries": build("self.entries"),
      "new_capacity": build("self.capacity << 1"),
      "m": build("new(capacity=arr.length())"),
      "m": build("of([(1, 2), (3, 4)])"),
      "m": build("new()"),
    }
  },
)

///|
let hashset_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/hashset",
  fn(_env, build) {
    {
      "default_init_capacity": Int(8),
      "m": build("new()"),
      "m": build("new()"),
      "hash": build("key.hash()"),
      "entry": build("{ psl: 0, hash, key }"),
      "hash": build("key.hash()"),
      "hash": build("key.hash()"),
      "m": build("new()"),
      "m": build("new()"),
      "m": build("new()"),
      "m": build("new()"),
      "s": build("new()"),
      "old_entries": build("self.entries"),
      "abs": build(
        (
          #|fn abs(n : Int) -> Int { if n < 0 {
          #|    -n
          #|  } else {
          #|    n
          #|  } }
        ),
      ),
      "calc_grow_threshold": build(
        (
          #|fn calc_grow_threshold(capacity : Int) -> Int { capacity * 13 / 16 }
        ),
      ),
      "i": build(
        (
          #|fn i(s) { MyString::MyString(s) }
        ),
      ),
      "i": build(
        (
          #|fn i(s) { MyString::MyString(s) }
        ),
      ),
      "i": build(
        (
          #|fn i(s) { MyString::MyString(s) }
        ),
      ),
      "res": build("while i < self.capacity {"),
    }
  },
)

///|
let int_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/int", fn(
  _env,
  build,
) {
  {
    "max_value": Int(2147483647),
    "min_value": Int(-2147483648),
    "abs": build(
      (
        #|if self < 0 {
        #|    -self
        #|  } else {
        #|    self
        #|  }
      ),
    ),
    "to_be_bytes": build(
      (
        #|self.reinterpret_as_uint().to_be_bytes()
      ),
    ),
    "to_le_bytes": build(
      (
        #|self.reinterpret_as_uint().to_le_bytes()
      ),
    ),
  }
})

///|
let int16_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/int16",
  fn(_env, build) {
    {
      "abs": build(
        (
          #|if self < 0 {
          #|    -self
          #|  } else {
          #|    self
          #|  }
        ),
      ),
      "reinterpret_as_uint16": build(
        (
          #|self.to_int().to_uint16()
        ),
      ),
    }
  },
)

///|
let int64_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/int64",
  fn(_env, build) {
    {
      "max_value": Int64(9223372036854775807L),
      "min_value": Int64(-9223372036854775808L),
      "from_int": build(
        (
          #|pub fn Int64::from_int(i : Int) -> Int64 { i.to_int64() }
        ),
      ),
      "from_int": build(
        (
          #|pub fn from_int(i : Int) -> Int64 { i.to_int64() }
        ),
      ),
      "abs": build(
        (
          #|if self < 0L {
          #|    -self
          #|  } else {
          #|    self
          #|  }
        ),
      ),
      "to_be_bytes": build(
        (
          #|self.reinterpret_as_uint64().to_be_bytes()
        ),
      ),
      "to_le_bytes": build(
        (
          #|self.reinterpret_as_uint64().to_le_bytes()
        ),
      ),
      "gPRIME2": UInt(0x85EBCA77U),
      "gPRIME3": UInt(0xC2B2AE3DU),
      "gPRIME4": UInt(0x27D4EB2FU),
      "gPRIME5": UInt(0x165667B1U),
      "seed": UInt(0U),
      "r": Int(17),
      "slow_hash": build(
        (
          #|let self = self.reinterpret_as_uint64()
          #|  let b : Bytes = [
          #|    (self & 0xFF).to_byte(),
          #|    ((self >> 8) & 0xFF).to_byte(),
          #|    ((self >> 16) & 0xFF).to_byte(),
          #|    ((self >> 24) & 0xFF).to_byte(),
          #|    ((self >> 32) & 0xFF).to_byte(),
          #|    ((self >> 40) & 0xFF).to_byte(),
          #|    ((self >> 48) & 0xFF).to_byte(),
          #|    ((self >> 56) & 0xFF).to_byte(),
          #|  ]
          #|  b.hash()
        ),
      ),
      "i0": build("9_223_372_036_854_775_807L // INT64_MAX"),
      "i1": build("-9_223_372_036_854_775_808L // INT64_MIN"),
      "i2": build("gPRIME2.to_int64()"),
      "i3": build("gPRIME3.to_int64()"),
      "i4": build("gPRIME4.to_int64()"),
      "i5": build("gPRIME5.to_int64()"),
      "i6": Int64(0L),
    }
  },
)

///|
let json_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/json", fn(
  _env,
  build,
) {
  {
    "read_char": build(
      (
        #|fn ParseContext::read_char(ctx : ParseContext) -> Char? { if ctx.offset < ctx.end_offset {
        #|    let c1 = ctx.input.unsafe_charcode_at(ctx.offset)
        #|    ctx.offset += 1
        #|    if c1 >= 0xD800 && c1 <= 0xDBFF {
        #|      if ctx.offset < ctx.end_offset {
        #|        let c2 = ctx.input.unsafe_charcode_at(ctx.offset)
        #|        if c2 >= 0xDC00 && c2 <= 0xDFFF {
        #|          ctx.offset += 1
        #|          let c3 = (c1 << 10) + c2 - 0x35fdc00
        #|          return Some(c3.unsafe_to_char())
        #|        }
        #|      }
        #|    }
        #|    Some(c1.unsafe_to_char())
        #|  } else {
        #|    None
        #|  } }
      ),
    ),
    "c1": build("ctx.input.unsafe_charcode_at(ctx.offset)"),
    "c0": build("c.to_int()"),
    "c2": build("ctx.input.unsafe_charcode_at(ctx.offset)"),
    "c3": build("(c1 << 10) + c2 - 0x35fdc00"),
    "c1": build("ctx.input.unsafe_charcode_at(ctx.offset)"),
    "ctx": build("ParseContext::make(\"abc\")"),
    "ctx": build("ParseContext::make(\"a\\u{1F600}bc\\u{1F600}c\")"),
    "lex_skip_whitespace": build(
      (
        #|fn ParseContext::lex_skip_whitespace(ctx : ParseContext) -> Unit { for {
        #|    match ctx.read_char() {
        #|      Some('\\t' | ' ' | '\\n' | '\\r') => continue
        #|      Some(c) => {
        #|        if c > '\\u{7f}' && non_ascii_whitespace.contains(c) {
        #|          continue
        #|        }
        #|        ctx.offset -= 1
        #|        break
        #|      }
        #|      None => break
        #|    }
        #|  } }
      ),
    ),
    "s": build("ctx.lex_string()"),
    "s": build("ctx.lex_string()"),
    "s": build("ctx.input.substring(start~, end~)"),
    "parsed_int": build("try? @strconv.parse_int64(s)"),
    "parsed_double": build("try? @strconv.parse_double(s)"),
    "len": build("a.length()"),
    "c1": build("a.unsafe_charcode_at(0)"),
    "c2": build("a.unsafe_charcode_at(1)"),
    "c3": build("(c1 << 10) + c2 - 0x35fdc00"),
    "len": build("a.length()"),
    "res": build("FixedArray::make("),
    "res": build("{}"),
    "as_null": build(
      (
        #|guard self is Null else { return None }
        #|  Some(())
      ),
    ),
    "as_bool": build(
      (
        #|match self {
        #|    True => Some(true)
        #|    False => Some(false)
        #|    _ => None
        #|  }
      ),
    ),
    "as_number": build(
      (
        #|guard self is Number(n, ..) else { return None }
        #|  Some(n)
      ),
    ),
    "as_string": build(
      (
        #|guard self is String(s) else { return None }
        #|  Some(s)
      ),
    ),
    "as_array": build(
      (
        #|guard self is Array(arr) else { return None }
        #|  Some(arr)
      ),
    ),
    "item": build(
      (
        #|pub fn item(self : JsonValue, index : Int) -> JsonValue? { match self.as_array() {
        #|    Some(arr) => arr.get(index)
        #|    None => None
        #|  } }
      ),
    ),
    "as_object": build(
      (
        #|guard self is Object(obj) else { return None }
        #|  Some(obj)
      ),
    ),
    "value": build(
      (
        #|pub fn value(self : JsonValue, key : String) -> JsonValue? { match self.as_object() {
        #|    Some(obj) => obj.get(key)
        #|    None => None
        #|  } }
      ),
    ),
    "indent_str": build(
      (
        #|fn indent_str(level : Int, indent : Int) -> String { if indent == 0 {
        #|    \"\"
        #|  } else {
        #|    \"\\n\" + \" \".repeat(indent * level)
        #|  } }
      ),
    ),
    "buf": build("StringBuilder::new(size_hint=0)"),
    "stringify_inner": build(
      (
        #|fn stringify_inner(value : JsonValue, level : Int) -> Unit { match value {
        #|      Object(members) => {
        #|        if members.is_empty() {
        #|          buf.write_string(\"{}\")
        #|          return
        #|        }
        #|        buf.write_char('{')
        #|        buf.write_string(indent_str(level + 1, indent))
        #|        let mut first = true
        #|        for k, v in members {
        #|          if first {
        #|            first = false
        #|          } else {
        #|            buf.write_char(',')
        #|            buf.write_string(indent_str(level + 1, indent))
        #|          }
        #|          buf
        #|          ..write_char('\\\"')
        #|          ..write_string(escape(k, escape_slash~))
        #|          ..write_char('\\\"')
        #|          if indent == 0 {
        #|            buf.write_char(':')
        #|          } else {
        #|            buf.write_string(\": \")
        #|          }
        #|          stringify_inner(v, level + 1)
        #|        }
        #|        buf.write_string(indent_str(level, indent))
        #|        buf.write_char('}')
        #|      }
        #|      Array(arr) => {
        #|        if arr.is_empty() {
        #|          buf.write_string(\"[]\")
        #|          return
        #|        }
        #|        buf.write_char('[')
        #|        buf.write_string(indent_str(level + 1, indent))
        #|        for i, v in arr {
        #|          if i > 0 {
        #|            buf.write_char(',')
        #|            buf.write_string(indent_str(level + 1, indent))
        #|          }
        #|          stringify_inner(v, level + 1)
        #|        }
        #|        buf.write_string(indent_str(level, indent))
        #|        buf.write_char(']')
        #|      }
        #|      String(s) =>
        #|        buf
        #|        ..write_char('\\\"')
        #|        ..write_string(escape(s, escape_slash~))
        #|        ..write_char('\\\"')
        #|      Number(n, repr~) =>
        #|        match repr {
        #|          None => buf.write_object(n)
        #|          Some(r) => buf.write_string(r)
        #|        }
        #|      True => buf.write_string(\"true\")
        #|      False => buf.write_string(\"false\")
        #|      Null => buf.write_string(\"null\")
        #|    } }
      ),
    ),
    "escape": build(
      (
        #|fn escape(str : String, escape_slash~ : Bool) -> String { fn to_hex_digit(i : Int) -> Char {
        #|    if i < 10 {
        #|      ('0'.to_int() + i).unsafe_to_char()
        #|    } else {
        #|      ('a'.to_int() + (i - 10)).unsafe_to_char()
        #|    }
        #|  }
        #|  let buf = StringBuilder::new(size_hint=str.length())
        #|  for c in str {
        #|    match c {
        #|      '\"' => buf.write_string(\"\\\\\\\"\")
        #|      '\\\\' => buf.write_string(\"\\\\\\\\\")
        #|      '/' =>
        #|        if escape_slash {
        #|          buf.write_string(\"\\\\/\")
        #|        } else {
        #|          buf.write_char(c)
        #|        }
        #|      '\\n' => buf.write_string(\"\\\\n\")
        #|      '\\r' => buf.write_string(\"\\\\r\")
        #|      '\\b' => buf.write_string(\"\\\\b\")
        #|      '\\t' => buf.write_string(\"\\\\t\")
        #|      _ => {
        #|        let code = c.to_int()
        #|        if code == 0x0C {
        #|          buf.write_string(\"\\\\f\")
        #|        } else if code < 0x20 {
        #|          buf.write_string(\"\\\\u00\")
        #|          buf.write_char(to_hex_digit(code / 16))
        #|          buf.write_char(to_hex_digit(code % 16))
        #|        } else {
        #|          buf.write_char(c)
        #|        }
        #|      }
        #|    }
        #|  }
        #|  buf.to_string() }
      ),
    ),
    "loc": build("loc.to_string().escape()"),
    "args_loc": build("args_loc.to_json().escape()"),
    "actual": build("obj.to_json().stringify(escape_slash=false)"),
    "want": build("match content {"),
    "add_index": build(
      (
        #|pub fn add_index(self : JsonPath, index : Int) -> JsonPath { Index(self, index~) }
      ),
    ),
    "add_key": build(
      (
        #|pub fn add_key(self : JsonPath, key : String) -> JsonPath { Key(self, key~) }
      ),
    ),
    "path": build("Key(Index(Root, index=0), key=\"foo\")"),
    "lex_string": build(
      (
        #|fn ParseContext::lex_string(ctx : ParseContext) -> String raise ParseError { let buf = StringBuilder::new()
        #|  let mut start = ctx.offset
        #|  fn flush(end : Int) {
        #|    if start > 0 && end > start {
        #|      buf.write_substring(ctx.input, start, end - start)
        #|    }
        #|  }
        #|  for {
        #|    match ctx.read_char() {
        #|      Some('\"') => {
        #|        flush(ctx.offset - 1)
        #|        break
        #|      }
        #|      Some('\\n' | '\\r') => ctx.invalid_char(shift=-1)
        #|      Some('\\\\') => {
        #|        flush(ctx.offset - 1)
        #|        match ctx.read_char() {
        #|          Some('b') => buf.write_char('\\b')
        #|          Some('f') => buf.write_char('\\u{0C}')
        #|          Some('n') => buf.write_char('\\n')
        #|          Some('r') => buf.write_char('\\r')
        #|          Some('t') => buf.write_char('\\t')
        #|          Some('\"') => buf.write_char('\"')
        #|          Some('\\\\') => buf.write_char('\\\\')
        #|          Some('/') => buf.write_char('/')
        #|          Some('u') => {
        #|            let c = ctx.lex_hex_digits(4)
        #|            buf.write_char(c.unsafe_to_char())
        #|          }
        #|          Some(_) => ctx.invalid_char(shift=-1)
        #|          None => raise InvalidEof
        #|        }
        #|        start = ctx.offset
        #|      }
        #|      Some(ch) =>
        #|        if ch.to_int() < 32 {
        #|          ctx.invalid_char(shift=-1)
        #|        } else {
        #|          continue
        #|        }
        #|      None => raise InvalidEof
        #|    }
        #|  }
        #|  buf.to_string() }
      ),
    ),
    "d": build("(c.to_int() & (32).lnot()) - 'A'.to_int() + 10"),
    "d": build("c.to_int() - '0'.to_int()"),
    "valid": build(
      (
        #|pub fn valid(input : String) -> Bool { try {
        #|    parse(input) |> ignore
        #|    true
        #|  } catch {
        #|    _ => return false
        #|  } }
      ),
    ),
    "parse": build(
      (
        #|pub fn parse(input : String) -> JsonValue raise ParseError { let ctx = ParseContext::make(input)
        #|  let val = ctx.parse_value()
        #|  ctx.lex_skip_whitespace()
        #|  if ctx.offset >= ctx.end_offset {
        #|    val
        #|  } else {
        #|    ctx.invalid_char()
        #|  } }
      ),
    ),
    "parse_value": build(
      (
        #|fn ParseContext::parse_value(ctx : ParseContext) -> JsonValue raise ParseError { let tok = ctx.lex_value(allow_rbracket=false)
        #|  ctx.parse_value2(tok) }
      ),
    ),
    "parse_object": build(
      (
        #|fn ParseContext::parse_object(ctx : ParseContext) -> JsonValue raise ParseError { let map = Map::new()
        #|  loop ctx.lex_property_name() {
        #|    RBrace => Json::object(map)
        #|    String(name) => {
        #|      ctx.lex_after_property_name()
        #|      map[name] = ctx.parse_value()
        #|      match ctx.lex_after_object_value() {
        #|        Comma => continue ctx.lex_property_name2()
        #|        RBrace => Json::object(map)
        #|        _ => abort(\"unreachable\")
        #|      }
        #|    }
        #|    _ => abort(\"unreachable\")
        #|  } }
      ),
    ),
    "parse_array": build(
      (
        #|fn ParseContext::parse_array(ctx : ParseContext) -> JsonValue raise ParseError { let vec = []
        #|  loop ctx.lex_value(allow_rbracket=true) {
        #|    RBracket => Json::array(vec)
        #|    tok => {
        #|      vec.push(ctx.parse_value2(tok))
        #|      let tok2 = ctx.lex_after_array_value()
        #|      match tok2 {
        #|        Comma => continue ctx.lex_value(allow_rbracket=false)
        #|        RBracket => Json::array(vec)
        #|        _ => abort(\"unreachable\")
        #|      }
        #|    }
        #|  } }
      ),
    ),
    "offset_to_position": build(
      (
        #|fn offset_to_position(input : String, offset : Int) -> Position { let mut line = 1
        #|  let mut column = 0
        #|  for i in 0..<offset {
        #|    if input.unsafe_charcode_at(i) == '\\n' {
        #|      line += 1
        #|      column = 0
        #|    } else {
        #|      column += 1
        #|    }
        #|  }
        #|  return Position::{ line, column } }
      ),
    ),
    "offset": build("ctx.offset + shift"),
    "make": build(
      (
        #|fn ParseContext::make(input : String) -> ParseContext { { offset: 0, input, end_offset: input.length() } }
      ),
    ),
    "of": build(
      (
        #|fn CharClass::of(array : Array[(Char, Char)]) -> CharClass { CharClass(array) }
      ),
    ),
    "contains": build(
      (
        #|fn contains(self : CharClass, c : Char) -> Bool { let CharClass(self) = self
        #|  for left = 0, right = self.length(); left < right; {
        #|    let middle = (left + right) / 2
        #|    let (min, max) = self[middle]
        #|    if c < min {
        #|      continue left, middle
        #|    } else if c > max {
        #|      continue middle + 1, right
        #|    } else {
        #|      break true
        #|    }
        #|  } else {
        #|    false
        #|  } }
      ),
    ),
    "s": build("ctx.lex_string()"),
    "shift": build("-c.utf16_len()"),
  }
})

///|
let list_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/list", fn(
  _env,
  build,
) {
  {
    "capacity": build("self.length()"),
    "jsons": build("Array::new(capacity~)"),
    "dest": build("More(f(hd), tail=Empty)"),
    "dest": build("More(f(0, hd), tail=Empty)"),
    "arr": build("[x]"),
    "dest": build("More(head, tail=Empty)"),
    "dest": build("More(hd, tail=Empty)"),
    "res": build("loop (self, other, Empty) {"),
    "dest": build("More(hd, tail=Empty)"),
    "dest1": build("loop (dest, tl) {"),
    "dest": build("More(head, tail=Empty)"),
    "dest": build("More(head, tail=Empty)"),
    "new_tail": build("More(hd, tail=Empty)"),
    "xs": build("More(x, tail=Empty)"),
    "ys": build("More(y, tail=Empty)"),
    "dest": build("More(hd, tail=Empty)"),
    "dest1": build("loop (dest, tl) {"),
    "arr": build("self.to_array()"),
    "dest": build("More(element, tail=Empty)"),
    "dest": build("More(head, tail=Empty)"),
    "dest": build("More(head, tail=Empty)"),
    "dest": build("More(init, tail=Empty)"),
    "dest": build("More(head, tail=Empty)"),
    "dest": build("More(head, tail~)"),
    "xs": build("self.to_array()"),
  }
})

///|
let math_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/math", fn(
  _env,
  build,
) {
  {
    "ln": build(
      (
        #|pub fn ln(x : Double) -> Double { let l1 = 6.666666666666735130e-01 // 3FE55555 55555593
        #|  let l2 = 3.999999999940941908e-01 // 3FD99999 9997FA04
        #|  let l3 = 2.857142874366239149e-01 // 3FD24924 94229359
        #|  let l4 = 2.222219843214978396e-01 // 3FCC71C5 1D8E78AF
        #|  let l5 = 1.818357216161805012e-01 // 3FC74664 96CB03DE
        #|  let l6 = 1.531383769920937332e-01 // 3FC39A09 D078C69F
        #|  let l7 = 1.479819860511658591e-01 // 3FC2F112 DF3E5244
        #|  if x < 0.0 {
        #|    return @double.not_a_number
        #|  } else if x.is_nan() || x.is_inf() {
        #|    return x
        #|  } else if x == 0.0 {
        #|    return @double.neg_infinity
        #|  }
        #|  let (f1, ki) = frexp(x)
        #|  let (f, k) = if f1 < SQRT2 / 2.0 {
        #|    (f1 * 2.0 - 1.0, (ki - 1).to_double())
        #|  } else {
        #|    (f1 - 1.0, ki.to_double())
        #|  }
        #|  let s = f / (2.0 + f)
        #|  let s2 = s * s
        #|  let s4 = s2 * s2
        #|  let t1 = s2 * (l1 + s4 * (l3 + s4 * (l5 + s4 * l7)))
        #|  let t2 = s4 * (l2 + s4 * (l4 + s4 * l6))
        #|  let r = t1 + t2
        #|  let hfsq = 0.5 * f * f
        #|  k * LN2_HI - (hfsq - (s * (hfsq + r) + k * LN2_LO) - f) }
      ),
    ),
    "log2": build(
      (
        #|pub fn log2(x : Double) -> Double { let (f, e) = frexp(x)
        #|  if f == 0.5 {
        #|    return e.to_double() - 1.0
        #|  }
        #|  ln(f) / LN2 + e.to_double() }
      ),
    ),
    "log10": build(
      (
        #|pub fn log10(x : Double) -> Double { if x < 0.0 {
        #|    return @double.not_a_number
        #|  } else if x.is_nan() || x.is_inf() {
        #|    return x
        #|  } else if x == 0.0 {
        #|    return @double.neg_infinity
        #|  }
        #|  let ivln10 = 4.34294481903251816668e-01
        #|  let log10_2hi = 3.01029995663611771306e-01
        #|  let log10_2lo = 3.69423907715893078616e-13
        #|  let (f, e) = frexp(x)
        #|  let (f, e) = if e >= 1 {
        #|    (f * 2.0, (e - 1).to_double())
        #|  } else {
        #|    (f, e.to_double())
        #|  }
        #|  let z = e * log10_2lo + ivln10 * ln(f)
        #|  z + e * log10_2hi }
      ),
    ),
    "ln_1p": build(
      (
        #|pub fn ln_1p(x : Double) -> Double { if x < -1.0 || x.is_nan() {
        #|    return @double.not_a_number
        #|  }
        #|  if x == -1.0 {
        #|    return @double.neg_infinity
        #|  }
        #|  if x.is_inf() {
        #|    return @double.infinity
        #|  }
        #|  let ln2_hi = 6.93147180369123816490e-01
        #|  let ln2_lo = 1.90821492927058770002e-10
        #|  let two54 = 1.80143985094819840000e+16
        #|  let lp1 = 6.666666666666735130e-01
        #|  let lp2 = 3.999999999940941908e-01
        #|  let lp3 = 2.857142874366239149e-01
        #|  let lp4 = 2.222219843214978396e-01
        #|  let lp5 = 1.818357216161805012e-01
        #|  let lp6 = 1.531383769920937332e-01
        #|  let zero = 0.0
        #|  let lp7 = 1.479819860511658591e-01
        #|  let hx = get_high_word(x).reinterpret_as_int()
        #|  let ax = hx & 0x7fffffff
        #|  let mut f = 0.0
        #|  let mut c = 0.0
        #|  let mut s = 0.0
        #|  let mut z = 0.0
        #|  let mut r = 0.0
        #|  let mut u = 0.0
        #|  let mut hu = 0
        #|  let mut k = 1
        #|  if hx < 0x3FDA827A {
        #|    if ax < 0x3e200000 {
        #|      if two54 + x > zero && ax < 0x3c900000 {
        #|        return x
        #|      } else {
        #|        return x - x * x * 0.5
        #|      }
        #|    }
        #|    if hx > 0 || hx <= 0xbfd2bec3 {
        #|      k = 0
        #|      f = x
        #|      hu = 1
        #|    }
        #|  }
        #|  if k != 0 {
        #|    if hx < 0x43400000 {
        #|      u = 1.0 + x
        #|      hu = get_high_word(u).reinterpret_as_int()
        #|      k = (hu >> 20) - 1023
        #|      c = if k > 0 { 1.0 - (u - x) } else { x - (u - 1.0) }
        #|      c /= u
        #|    } else {
        #|      u = x
        #|      hu = get_high_word(u).reinterpret_as_int()
        #|      k = (hu >> 20) - 1023
        #|      c = 0.0
        #|    }
        #|    hu = hu & 0x000fffff
        #|    if hu < 0x6a09e {
        #|      u = set_high_word(u, hu.reinterpret_as_uint() | 0x3ff00000)
        #|    } else {
        #|      k += 1
        #|      u = set_high_word(u, hu.reinterpret_as_uint() | 0x3fe00000)
        #|      hu = (0x00100000 - hu) >> 2
        #|    }
        #|    f = u - 1.0
        #|  }
        #|  let hfsq = 0.5 * f * f
        #|  if hu == 0 {
        #|    if f == zero {
        #|      if k == 0 {
        #|        return zero
        #|      } else {
        #|        c += k.to_double() * ln2_lo
        #|        return k.to_double() * ln2_hi + c
        #|      }
        #|    }
        #|    r = hfsq * (1.0 - 0.66666666666666666 * f)
        #|    if k == 0 {
        #|      return f - r
        #|    } else {
        #|      return k.to_double() * ln2_hi - (r - (k.to_double() * ln2_lo + c) - f)
        #|    }
        #|  }
        #|  s = f / (2.0 + f)
        #|  z = s * s
        #|  r = z *
        #|    (lp1 + z * (lp2 + z * (lp3 + z * (lp4 + z * (lp5 + z * (lp6 + z * lp7))))))
        #|  if k == 0 {
        #|    return f - (hfsq - s * (hfsq + r))
        #|  } else {
        #|    return k.to_double() * ln2_hi -
        #|      (hfsq - (s * (hfsq + r) + (k.to_double() * ln2_lo + c)) - f)
        #|  } }
      ),
    ),
    "sin": build(
      (
        #|pub fn sin(x : Double) -> Double { if x.is_inf() || x.is_nan() {
        #|    return @double.not_a_number
        #|  }
        #|  let y = [0.0, 0.0]
        #|  let z = 0.0
        #|  if x.abs() <= PI_OVER_4 {
        #|    return __kernel_sin(x, z, 0)
        #|  } else {
        #|    let n = rem_pio2(x, y)
        #|    match n & 3 {
        #|      0 => __kernel_sin(y[0], y[1], 1)
        #|      1 => __kernel_cos(y[0], y[1])
        #|      2 => -__kernel_sin(y[0], y[1], 1)
        #|      _ => -__kernel_cos(y[0], y[1])
        #|    }
        #|  } }
      ),
    ),
    "cos": build(
      (
        #|pub fn cos(x : Double) -> Double { if x.is_inf() || x.is_nan() {
        #|    return @double.not_a_number
        #|  }
        #|  let y = [0.0, 0.0]
        #|  let z = 0.0
        #|  if x.abs() <= PI_OVER_4 {
        #|    return __kernel_cos(x, z)
        #|  } else {
        #|    let n = rem_pio2(x, y)
        #|    match n & 3 {
        #|      0 => __kernel_cos(y[0], y[1])
        #|      1 => -__kernel_sin(y[0], y[1], 1)
        #|      2 => -__kernel_cos(y[0], y[1])
        #|      _ => __kernel_sin(y[0], y[1], 1)
        #|    }
        #|  } }
      ),
    ),
    "tan": build(
      (
        #|pub fn tan(x : Double) -> Double { if x.is_inf() || x.is_nan() {
        #|    return @double.not_a_number
        #|  }
        #|  let y = Array::make(2, 0.0)
        #|  let z = 0.0
        #|  if x.abs() <= PI_OVER_4 {
        #|    __kernal_tan(x, z, 1)
        #|  } else {
        #|    let n = rem_pio2(x, y)
        #|    __kernal_tan(y[0], y[1], 1 - ((n & 1) << 1))
        #|  } }
      ),
    ),
    "asin": build(
      (
        #|pub fn asin(x : Double) -> Double { let huge = 1.0e+300
        #|  let pio4_hi = 7.85398163397448278999e-01
        #|  let pio2_hi = 1.57079632679489655800
        #|  let pio2_lo = 6.12323399573676603587e-17
        #|  let ps0 = 1.66666666666666657415e-01
        #|  let ps1 = -3.25565818622400915405e-01
        #|  let ps2 = 2.01212532134862925881e-01
        #|  let ps3 = -4.00555345006794114027e-02
        #|  let ps4 = 7.91534994289814532176e-04
        #|  let ps5 = 3.47933107596021167570e-05
        #|  let qs1 = -2.40339491173441421878e+00
        #|  let qs2 = 2.02094576023350569471e+00
        #|  let qs3 = -6.88283971605453293030e-01
        #|  let qs4 = 7.70381505559019352791e-02
        #|  let ix = get_high_word(x).reinterpret_as_int() & 0x7fffffff
        #|  let absx = x.abs()
        #|  if absx >= 1.0 {
        #|    if absx == 1.0 {
        #|      return x * pio2_hi + x * pio2_lo
        #|    } else {
        #|      return @double.not_a_number
        #|    }
        #|  } else if absx < 0.5 {
        #|    if ix < 0x3e400000 {
        #|      if huge + x > 1.0 {
        #|        return x
        #|      }
        #|    } else {
        #|      let t = x * x
        #|      let p = t *
        #|        (ps0 + t * (ps1 + t * (ps2 + t * (ps3 + t * (ps4 + t * ps5)))))
        #|      let q = 1.0 + t * (qs1 + t * (qs2 + t * (qs3 + t * qs4)))
        #|      let w = p / q
        #|      return x + x * w
        #|    }
        #|  }
        #|  let w = 1.0 - absx
        #|  let t = w * 0.5
        #|  let p = t * (ps0 + t * (ps1 + t * (ps2 + t * (ps3 + t * (ps4 + t * ps5)))))
        #|  let q = 1.0 + t * (qs1 + t * (qs2 + t * (qs3 + t * qs4)))
        #|  let s = t.sqrt()
        #|  if ix >= 0x3FEF3333 {
        #|    let w = p / q
        #|    let t = pio2_hi - (2.0 * (s + s * w) - pio2_lo)
        #|    return if x > 0.0 { t } else { -t }
        #|  } else {
        #|    let mut w = s
        #|    w = set_low_word(w, 0)
        #|    let c = (t - w * w) / (s + w)
        #|    let r = p / q
        #|    let p = 2.0 * s * r - (pio2_lo - 2.0 * c)
        #|    let q = pio4_hi - 2.0 * w
        #|    let t = pio4_hi - (p - q)
        #|    return if x > 0.0 { t } else { -t }
        #|  } }
      ),
    ),
    "acos": build(
      (
        #|pub fn acos(x : Double) -> Double { let one : Double = 1.0
        #|  let pi : Double = 3.14159265358979311600
        #|  let pio2_hi : Double = 1.57079632679489655800
        #|  let pio2_lo : Double = 6.12323399573676603587e-17
        #|  let ps0 : Double = 1.66666666666666657415e-01
        #|  let ps1 : Double = -3.25565818622400915405e-01
        #|  let ps2 : Double = 2.01212532134862925881e-01
        #|  let ps3 : Double = -4.00555345006794114027e-02
        #|  let ps4 : Double = 7.91534994289814532176e-04
        #|  let ps5 : Double = 3.47933107596021167570e-05
        #|  let qs1 : Double = -2.40339491173441421878e+00
        #|  let qs2 : Double = 2.02094576023350569471e+00
        #|  let qs3 : Double = -6.88283971605453293030e-01
        #|  let qs4 : Double = 7.70381505559019352791e-02
        #|  let ix = get_high_word(x).reinterpret_as_int() & 0x7fffffff
        #|  let absx = x.abs()
        #|  if absx >= 1.0 {
        #|    if absx == 1.0 {
        #|      if x > 0 {
        #|        return 0.0
        #|      } else {
        #|        return pi + 2.0 * pio2_lo
        #|      }
        #|    }
        #|    return @double.not_a_number
        #|  }
        #|  if absx < 0.5 {
        #|    if ix <= 0x3c600000 {
        #|      return pio2_hi + pio2_lo
        #|    }
        #|    let z = x * x
        #|    let p = z * (ps0 + z * (ps1 + z * (ps2 + z * (ps3 + z * (ps4 + z * ps5)))))
        #|    let q = one + z * (qs1 + z * (qs2 + z * (qs3 + z * qs4)))
        #|    let r = p / q
        #|    pio2_hi - (x - (pio2_lo - x * r))
        #|  } else if x < 0 {
        #|    let z = (one + x) * 0.5
        #|    let p = z * (ps0 + z * (ps1 + z * (ps2 + z * (ps3 + z * (ps4 + z * ps5)))))
        #|    let q = one + z * (qs1 + z * (qs2 + z * (qs3 + z * qs4)))
        #|    let s = z.sqrt()
        #|    let r = p / q
        #|    let w = r * s - pio2_lo
        #|    pi - 2.0 * (s + w)
        #|  } else {
        #|    let z = (one - x) * 0.5
        #|    let s = z.sqrt()
        #|    let df = s
        #|    let c = (z - df * df) / (s + df)
        #|    let p = z * (ps0 + z * (ps1 + z * (ps2 + z * (ps3 + z * (ps4 + z * ps5)))))
        #|    let q = one + z * (qs1 + z * (qs2 + z * (qs3 + z * qs4)))
        #|    let r = p / q
        #|    let w = r * s + c
        #|    2.0 * (df + w)
        #|  } }
      ),
    ),
    "atan": build(
      (
        #|pub fn atan(x : Double) -> Double { if x.is_nan() || x == 0.0 {
        #|    return x
        #|  }
        #|  let atan_hi = [
        #|    4.63647609000806093515e-01, 7.85398163397448278999e-01, 9.82793723247329054082e-01,
        #|    1.57079632679489655800e+00,
        #|  ]
        #|  let atan_lo = [
        #|    2.26987774529616870924e-17, 3.06161699786838301793e-17, 1.39033110312309984516e-17,
        #|    6.12323399573676603587e-17,
        #|  ]
        #|  let a_t = [
        #|    3.33333333333329318027e-01, -1.99999999998764832476e-01, 1.42857142725034663711e-01,
        #|    -1.11111104054623557880e-01, 9.09088713343650656196e-02, -7.69187620504482999495e-02,
        #|    6.66107313738753120669e-02, -5.83357013379057348645e-02, 4.97687799461593236017e-02,
        #|    -3.65315727442169155270e-02, 1.62858201153657823623e-02,
        #|  ]
        #|  let one = 1.0
        #|  let huge = 1.0e300
        #|  let ix = get_high_word(x).reinterpret_as_int() & 0x7fffffff
        #|  let mut id = 0
        #|  let mut z = 0.0
        #|  let mut w = 0.0
        #|  let mut x = x
        #|  let x_is_neg = x < 0.0
        #|  if ix >= 0x44100000 {
        #|    if x > 0 {
        #|      return atan_hi[3] + atan_lo[3]
        #|    } else {
        #|      return -atan_hi[3] - atan_lo[3]
        #|    }
        #|  }
        #|  if ix < 0x3fdc0000 {
        #|    if ix < 0x3e200000 {
        #|      if huge + x > one {
        #|        return x
        #|      }
        #|    }
        #|    id = -1
        #|  } else {
        #|    x = x.abs()
        #|    if ix < 0x3ff30000 {
        #|      if ix < 0x3fe60000 {
        #|        id = 0
        #|        x = (2.0 * x - one) / (2.0 + x)
        #|      } else {
        #|        id = 1
        #|        x = (x - one) / (x + one)
        #|      }
        #|    } else if ix < 0x40038000 {
        #|      id = 2
        #|      x = (x - 1.5) / (one + 1.5 * x)
        #|    } else {
        #|      id = 3
        #|      x = -1.0 / x
        #|    }
        #|  }
        #|  z = x * x
        #|  w = z * z
        #|  let s1 = z *
        #|    (
        #|      a_t[0] +
        #|      w * (a_t[2] + w * (a_t[4] + w * (a_t[6] + w * (a_t[8] + w * a_t[10]))))
        #|    )
        #|  let s2 = w *
        #|    (a_t[1] + w * (a_t[3] + w * (a_t[5] + w * (a_t[7] + w * a_t[9]))))
        #|  if id < 0 {
        #|    x - x * (s1 + s2)
        #|  } else {
        #|    z = atan_hi[id] - (x * (s1 + s2) - atan_lo[id] - x)
        #|    if x_is_neg {
        #|      -z
        #|    } else {
        #|      z
        #|    }
        #|  } }
      ),
    ),
    "atan2": build(
      (
        #|pub fn atan2(y : Double, x : Double) -> Double { if x.is_nan() || y.is_nan() {
        #|    return @double.not_a_number
        #|  }
        #|  let tiny = 1.0e-300
        #|  let zero = 0.0
        #|  let pi_o_4 = 7.8539816339744827900E-01
        #|  let pi_o_2 = 1.5707963267948965580E+00
        #|  let pi = 3.1415926535897931160E+00
        #|  let pi_lo = 1.2246467991473531772E-16
        #|  let hx = get_high_word(x).reinterpret_as_int()
        #|  let hy = get_high_word(y).reinterpret_as_int()
        #|  let ix = hx & 0x7fffffff
        #|  let iy = hy & 0x7fffffff
        #|  if x == 1.0 {
        #|    return atan(y)
        #|  }
        #|  let m = ((hy >> 31) & 1) | ((hx >> 30) & 2)
        #|  if y == 0 {
        #|    match m {
        #|      0 | 1 => return y
        #|      2 => return pi + tiny
        #|      _ => return -pi - tiny
        #|    }
        #|  }
        #|  if x == 0 {
        #|    return if hy < 0 { -pi_o_2 - tiny } else { pi_o_2 + tiny }
        #|  }
        #|  if x.is_inf() {
        #|    if y.is_inf() {
        #|      match m {
        #|        0 => return pi_o_4 + tiny
        #|        1 => return -pi_o_4 - tiny
        #|        2 => return 3.0 * pi_o_4 + tiny
        #|        _ => return -3.0 * pi_o_4 - tiny
        #|      }
        #|    } else {
        #|      match m {
        #|        0 => return zero
        #|        1 => return -zero
        #|        2 => return pi + tiny
        #|        _ => return -pi - tiny
        #|      }
        #|    }
        #|  }
        #|  if y.is_inf() {
        #|    return if hy < 0 { -pi_o_2 - tiny } else { pi_o_2 + tiny }
        #|  }
        #|  let k = (iy - ix) >> 20
        #|  let z = if k > 60 {
        #|    pi_o_2 + 0.5 * pi_lo
        #|  } else if hx < 0 && k < -60 {
        #|    0.0
        #|  } else {
        #|    atan(abs(y / x))
        #|  }
        #|  match m {
        #|    0 => z
        #|    1 => -z
        #|    2 => pi - (z - pi_lo)
        #|    _ => z - pi_lo - pi
        #|  } }
      ),
    ),
    "rem_pio2": build(
      (
        #|fn rem_pio2(x : Double, y : Array[Double]) -> Int { let hx = get_high_word(x).reinterpret_as_int()
        #|  let ix : Int = hx & 0x7fffffff
        #|  let mut z = 0.0
        #|  if ix <= 0x3fe921fb {
        #|    // |x| <= pi/4, no reduction needed
        #|    y[0] = x
        #|    y[1] = 0.0
        #|    return 0
        #|  }
        #|  if ix < 0x4002d97c {
        #|    // |x| < 3pi/4, special case with n = +-1
        #|    if hx > 0 {
        #|      z = x - PIO2_1
        #|      if ix != 0x3ff921fb {
        #|        // 33+53 bit pi is good enough
        #|        y[0] = z - PIO2_1T
        #|        y[1] = z - y[0] - PIO2_1T
        #|      } else {
        #|        // Near pi/2, use 33+33+53 bit pi
        #|        z = z - PIO2_2
        #|        y[0] = z - PIO2_2T
        #|        y[1] = z - y[0] - PIO2_2T
        #|      }
        #|      return 1
        #|    } else {
        #|      // Negative x
        #|      z = x + PIO2_1
        #|      if ix != 0x3ff921fb {
        #|        // 33+53 bit pi is good enough
        #|        y[0] = z + PIO2_1T
        #|        y[1] = z - y[0] + PIO2_1T
        #|      } else {
        #|        // Near pi/2, use 33+33+53 bit pi
        #|        let z = z + PIO2_2
        #|        y[0] = z + PIO2_2T
        #|        y[1] = z - y[0] + PIO2_2T
        #|      }
        #|      return -1
        #|    }
        #|  }
        #|  if ix <= 0x413921fb {
        #|    // |x| <= 2^19 * (pi/2), medium size
        #|    let t = x.abs()
        #|    let n = (t * INV_PIO2 + HALF).to_int()
        #|    let fn_ = n.to_double()
        #|    let mut r = t - fn_ * PIO2_1
        #|    let mut w = fn_ * PIO2_1T
        #|    if n < 32 && ix != npio2_hw[n - 1] {
        #|      y[0] = r - w
        #|    } else {
        #|      let j = ix >> 20
        #|      y[0] = r - w
        #|      let i = j - ((get_high_word(y[0]) >> 20).reinterpret_as_int() & 0x7ff)
        #|      if i > 16 {
        #|        // 2nd iteration needed, good to 118 bits
        #|        let t = r
        #|        w = fn_ * PIO2_2
        #|        r = t - w
        #|        w = fn_ * PIO2_2T - (t - r - w)
        #|        y[0] = r - w
        #|        let i = j - ((get_high_word(y[0]) >> 20).reinterpret_as_int() & 0x7ff)
        #|        if i > 49 {
        #|          // 3rd iteration needed, 151 bits accuracy
        #|          let t = r
        #|          w = fn_ * PIO2_3
        #|          r = t - w
        #|          w = fn_ * PIO2_3T - (t - r - w)
        #|          y[0] = r - w
        #|        }
        #|      }
        #|    }
        #|    y[1] = r - y[0] - w
        #|    if hx > 0 {
        #|      return n
        #|    } else {
        #|      y[0] = -y[0]
        #|      y[1] = -y[1]
        #|      return -n
        #|    }
        #|  }
        #|  // All other (large) arguments
        #|  if ix >= 0x7ff00000 {
        #|    // x is inf or NaN
        #|    y[0] = x - x
        #|    y[1] = y[0]
        #|    return 0
        #|  }
        #|  // Set z = scalbn(|x|, ilogb(x) - 23)
        #|  z = set_low_word(z, get_low_word(x))
        #|  let e0 = (ix >> 20) - 1046 // e0 = ilogb(z) - 23
        #|  z = set_high_word(z, (ix - (e0 << 20)).reinterpret_as_uint())
        #|  let tx = [0.0, 0.0, 0.0]
        #|  for i in 0..<2 {
        #|    tx[i] = z.to_int().to_double()
        #|    z = (z - tx[i]) * TWO24
        #|  }
        #|  tx[2] = z
        #|  let mut nx = 3
        #|  while tx[nx - 1] == 0.0 {
        #|    nx -= 1
        #|  }
        #|  let n = __kernel_rem_pio2(tx, y, e0, nx, 2)
        #|  if hx > 0 {
        #|    n
        #|  } else {
        #|    y[0] = -y[0]
        #|    y[1] = -y[1]
        #|    -n
        #|  } }
      ),
    ),
    "init_jk": build("[2, 3, 4, 6]"),
    "__kernel_sin": build(
      (
        #|fn __kernel_sin(x : Double, y : Double, iy : Int) -> Double { let s1 = -1.66666666666666324348e-01
        #|  let s2 = 8.33333333332248946124e-03
        #|  let s3 = -1.98412698298579493134e-04
        #|  let s4 = 2.75573137070700676789e-06
        #|  let s5 = -2.50507602534068634195e-08
        #|  let s6 = 1.58969099521155010221e-10
        #|  let mut z = 0.0
        #|  let mut r = 0.0
        #|  let mut v = 0.0
        #|  let ix = get_high_word(x) & 0x7fffffff
        #|  if ix < 0x3e400000 {
        #|    if x.to_int() == 0 {
        #|      return x
        #|    }
        #|  }
        #|  z = x * x
        #|  v = z * x
        #|  r = s2 + z * (s3 + z * (s4 + z * (s5 + z * s6)))
        #|  if iy == 0 {
        #|    x + v * (s1 + z * r)
        #|  } else {
        #|    x - (z * (0.5 * y - v * r) - y - v * s1)
        #|  } }
      ),
    ),
    "__kernel_cos": build(
      (
        #|fn __kernel_cos(x : Double, y : Double) -> Double { let one = 1.00000000000000000000e+00
        #|  let c1 = 4.16666666666666019037e-02
        #|  let c2 = -1.38888888888741095749e-03
        #|  let c3 = 2.48015872894767294178e-05
        #|  let c4 = -2.75573143513906633035e-07
        #|  let c5 = 2.08757232129817482790e-09
        #|  let c6 = -1.13596475577881948265e-11
        #|  let mut a = 0.0
        #|  let mut hz = 0.0
        #|  let mut z = 0.0
        #|  let mut r = 0.0
        #|  let mut qx = 0.0
        #|  let ix = get_high_word(x) & 0x7fffffff
        #|  if ix < 0x3e400000 {
        #|    if x.to_int() == 0 {
        #|      return one
        #|    }
        #|  }
        #|  z = x * x
        #|  r = z * (c1 + z * (c2 + z * (c3 + z * (c4 + z * (c5 + z * c6)))))
        #|  if ix < 0x3fd33333 {
        #|    return one - (0.5 * z - (z * r - x * y))
        #|  } else {
        #|    if ix > 0x3fe90000 {
        #|      qx = 0.28125
        #|    } else {
        #|      qx = ((ix - 0x00200000).to_uint64() << 32).reinterpret_as_double()
        #|    }
        #|    hz = 0.5 * z - qx
        #|    a = one - qx
        #|    return a - (hz - (z * r - x * y))
        #|  } }
      ),
    ),
    "__kernal_tan": build(
      (
        #|fn __kernal_tan(x : Double, y : Double, iy : Int) -> Double { let one = 1.0
        #|  let pio4 = 7.85398163397448278999e-01
        #|  let pio4lo = 3.06161699786838301793e-17
        #|  let mut x = x
        #|  let mut y = y
        #|  let mut z = 0.0
        #|  let mut r = 0.0
        #|  let mut v = 0.0
        #|  let mut w = 0.0
        #|  let mut s = 0.0
        #|  let t = [
        #|    3.33333333333334091986e-01, // 3FD55555, 55555563 */
        #|     1.33333333333201242699e-01, // 3FC11111, 1110FE7A */
        #|     5.39682539762260521377e-02, // 3FABA1BA, 1BB341FE */
        #|     2.18694882948595424599e-02, // 3F9664F4, 8406D637 */
        #|     8.86323982359930005737e-03, // 3F8226E3, E96E8493 */
        #|     3.59207910759131235356e-03, // 3F6D6D22, C9560328 */
        #|     1.45620945432529025516e-03, // 3F57DBC8, FEE08315 */
        #|     5.88041240820264096874e-04, // 3F4344D8, F2F26501 */
        #|     2.46463134818469906812e-04, // 3F3026F7, 1A8D1068 */
        #|     7.81794442939557092300e-05, // 3F147E88, A03792A6 */
        #|     7.14072491382608190305e-05, // 3F12B80F, 32F0A7E9 */
        #|     -1.85586374855275456654e-05, // BEF375CB, DB605373 */
        #|     2.59073051863633712884e-05, // 3EFB2A70, 74BF7AD4 */
        #|     1.00000000000000000000e+00, // 3FF00000, 00000000 (one) */
        #|     7.85398163397448278999e-01, // 3FE921FB, 54442D18 (pio4) */
        #|     3.06161699786838301793e-17, // 3C81A626, 33145C07 (pio4lo) */
        #|  ]
        #|  let hx = get_high_word(x).reinterpret_as_int()
        #|  let ix = hx & 0x7fffffff
        #|  if ix < 0x3e300000 {
        #|    if x.to_int() == 0 {
        #|      if (ix | get_low_word(x).reinterpret_as_int() | (iy + 1)) == 0 {
        #|        return one / x.abs()
        #|      } else if iy == 1 {
        #|        return x
        #|      } else {
        #|        w = x + y
        #|        z = w
        #|        z = set_low_word(z, 0)
        #|        v = y - (z - x)
        #|        let a = -one / w
        #|        let mut t = a
        #|        t = set_low_word(t, 0)
        #|        s = one + t * z
        #|        return t + a * (s + t * v)
        #|      }
        #|    }
        #|  }
        #|  if ix >= 0x3fe59428 {
        #|    if hx < 0 {
        #|      x = -x
        #|      y = -y
        #|    }
        #|    z = pio4 - x
        #|    w = pio4lo - y
        #|    x = z + w
        #|    y = 0.0
        #|  }
        #|  z = x * x
        #|  w = z * z
        #|  r = t[1] + w * (t[3] + w * (t[5] + w * (t[7] + w * (t[9] + w * t[11]))))
        #|  v = z *
        #|    (t[2] + w * (t[4] + w * (t[6] + w * (t[8] + w * (t[10] + w * t[12])))))
        #|  s = z * x
        #|  r = y + z * (s * (r + v) + y)
        #|  r += t[0] * s
        #|  w = x + r
        #|  if ix >= 0x3fe59428 {
        #|    v = iy.to_double()
        #|    return (1 - ((hx >> 30) & 2)).to_double() *
        #|      (v - 2.0 * (x - (w * w / (w + v) - r)))
        #|  }
        #|  if iy == 1 {
        #|    w
        #|  } else {
        #|    z = w
        #|    z = set_low_word(z, 0)
        #|    v = r - (z - x)
        #|    let a = -1.0 / w
        #|    let mut t = a
        #|    t = set_low_word(t, 0)
        #|    s = 1.0 + t * z
        #|    t + a * (s + t * v)
        #|  } }
      ),
    ),
    "probable_prime": build(
      (
        #|pub fn probable_prime(bits : Int, rand : @random.Rand) -> @bigint.BigInt { for {
        #|    let b = rand.bigint(bits)
        #|    if is_probable_prime(b, rand) {
        #|      break b
        #|    }
        #|  } }
      ),
    ),
    "trial_divisions": build(
      (
        #|fn trial_divisions(n : @bigint.BigInt) -> Bool { // calculate the number of trial divisions based on the bit length of the candidate
        #|  let td = match n.bit_length() {
        #|    _..=512 => 64
        #|    512..=1024 => 128
        #|    1024..=2048 => 384
        #|    2048..=4096 => 1024
        #|    _ => 2048
        #|  }
        #|  for i in 1..<td {
        #|    if n % small_primes[i] == 0 {
        #|      return n == small_primes[i]
        #|    }
        #|  }
        #|  true }
      ),
    ),
    "w1": build("w - 1N"),
    "w3": build("w - 3N"),
    "a": build("w1.ctz()"),
    "m": build("w1 >> a"),
    "w3_len": build("w3.bit_length()"),
    "rand_b": build("for {"),
    "x": build("rand.bigint(w3_len)"),
    "b": build("rand_b + 2N"),
    "sinh": build(
      (
        #|pub fn sinh(x : Double) -> Double { if x.is_nan() || x.is_inf() {
        #|    return x
        #|  }
        #|  let ix = get_high_word(x).reinterpret_as_int() & 0x7fffffff
        #|  let abs_x = x.abs()
        #|  let shuge = 1.0e307
        #|  let h = if x < 0.0 { -0.5 } else { 0.5 }
        #|  if ix < 0x40360000 {
        #|    if ix < 0x3e300000 {
        #|      if shuge + x > 1.0 {
        #|        return x
        #|      }
        #|    }
        #|    let t = expm1(abs_x)
        #|    if ix < 0x3ff00000 {
        #|      return h * (2.0 * t - t * t / (t + 1.0))
        #|    }
        #|    return h * (t + t / (t + 1.0))
        #|  }
        #|  if ix < 0x40862E42 {
        #|    return h * exp(abs_x)
        #|  }
        #|  if abs_x.reinterpret_as_uint64() < 0x408633ce8fb9f87d {
        #|    let w = exp(0.5 * abs_x)
        #|    let t = h * w
        #|    return t * w
        #|  }
        #|  x * shuge }
      ),
    ),
    "cosh": build(
      (
        #|pub fn cosh(x : Double) -> Double { if x.is_nan() {
        #|    return x
        #|  }
        #|  if x.is_inf() {
        #|    return @double.infinity
        #|  }
        #|  let ix = get_high_word(x).reinterpret_as_int() & 0x7fffffff
        #|  if ix < 0x3fd62e43 {
        #|    let t = expm1(x.abs())
        #|    let w = 1.0 + t
        #|    if ix < 0x3c800000 {
        #|      return w
        #|    }
        #|    return 1.0 + t * t / (w + w)
        #|  }
        #|  if ix < 0x40360000 {
        #|    let t = exp(x.abs())
        #|    return 0.5 * t + 0.5 / t
        #|  }
        #|  if ix < 0x40862E42 {
        #|    return (0.5 * x.abs()) |> exp
        #|  }
        #|  let lx = get_low_word(x).reinterpret_as_int()
        #|  if ix < 0x408633ce || (ix == 0x408633ce && lx <= 0x8fb9f87d) {
        #|    let w = exp(0.5 * x.abs())
        #|    let t = 0.5 * w
        #|    return t * w
        #|  }
        #|  @double.infinity }
      ),
    ),
    "tanh": build(
      (
        #|pub fn tanh(x : Double) -> Double { if x.is_nan() {
        #|    return x
        #|  }
        #|  if x.is_pos_inf() {
        #|    return 1.0
        #|  }
        #|  if x.is_neg_inf() {
        #|    return -1.0
        #|  }
        #|  let ix = get_high_word(x).reinterpret_as_int() & 0x7fffffff
        #|  let tiny = 1.0e-300
        #|  let z = if ix < 0x40360000 {
        #|    if ix < 0x3c800000 {
        #|      x * (1.0 + x)
        #|    } else if ix >= 0x3ff00000 {
        #|      let t = (2.0 * x.abs()) |> expm1
        #|      1.0 - 2.0 / (t + 2.0)
        #|    } else {
        #|      let t = (-2.0 * x.abs()) |> expm1
        #|      -t / (t + 2.0)
        #|    }
        #|  } else {
        #|    1.0 - tiny
        #|  }
        #|  if x >= 0.0 {
        #|    z
        #|  } else {
        #|    -z
        #|  } }
      ),
    ),
    "asinh": build(
      (
        #|pub fn asinh(x : Double) -> Double { if x.is_nan() || x.is_inf() {
        #|    return x
        #|  }
        #|  let one : Double = 1.0
        #|  let ln2 : Double = 6.93147180559945286227e-01
        #|  let huge : Double = 1.0e300
        #|  let hx = get_high_word(x).reinterpret_as_int()
        #|  let ix = hx & 0x7fffffff
        #|  if ix < 0x3e300000 {
        #|    if huge + x > one {
        #|      return x
        #|    }
        #|  }
        #|  let w : Double = if ix > 0x41b00000 {
        #|    ln(x.abs()) + ln2
        #|  } else if ix > 0x40000000 {
        #|    let t = x.abs()
        #|    (2.0 * t + one / ((x * x + one).sqrt() + t)) |> ln
        #|  } else {
        #|    let t = x * x
        #|    (x.abs() + t / (one + (one + t).sqrt())) |> ln_1p
        #|  }
        #|  if hx > 0 {
        #|    w
        #|  } else {
        #|    -w
        #|  } }
      ),
    ),
    "acosh": build(
      (
        #|pub fn acosh(x : Double) -> Double { let one = 1.0
        #|  let hx = get_high_word(x).reinterpret_as_int()
        #|  if x < 1.0 || x.is_nan() {
        #|    return @double.not_a_number
        #|  } else if x == 1.0 {
        #|    return 0.0
        #|  } else if x.is_pos_inf() {
        #|    return @double.infinity
        #|  } else if hx >= 0x41b00000 {
        #|    return ln(x) + LN2
        #|  } else if hx > 0x40000000 {
        #|    let t = x * x
        #|    return (2.0 * x - one / (x + (t - one).sqrt())) |> ln
        #|  } else {
        #|    let t = x - one
        #|    return (t + (2.0 * t + t * t).sqrt()) |> ln_1p
        #|  } }
      ),
    ),
    "atanh": build(
      (
        #|pub fn atanh(x : Double) -> Double { let hx : Int = get_high_word(x).reinterpret_as_int()
        #|  let ix = hx & 0x7fffffff
        #|  if x.abs() > 1.0 {
        #|    return @double.not_a_number
        #|  }
        #|  if x == 1.0 {
        #|    return @double.infinity
        #|  }
        #|  if x == -1.0 {
        #|    return @double.neg_infinity
        #|  }
        #|  if ix < 0x3e300000 && 1.0e300 + x > 0.0 {
        #|    return x
        #|  }
        #|  let x = x.abs()
        #|  let t = if x <= 0.5 {
        #|    let t = x + x
        #|    0.5 * ln_1p(t + t * x / (1.0 - x))
        #|  } else {
        #|    0.5 * ln_1p((x + x) / (1.0 - x))
        #|  }
        #|  if hx >= 0 {
        #|    t
        #|  } else {
        #|    -t
        #|  } }
      ),
    ),
    "cbrt": build(
      (
        #|pub fn cbrt(x : Double) -> Double { if x.is_inf() || x.is_nan() || x == 0.0 {
        #|    return x
        #|  }
        #|  let b1 : UInt = 715094163 // B1 = (682-0.03306235651)*2**20
        #|  let b2 : UInt = 696219795 // B2 = (664-0.03306235651)*2**20
        #|  let c = 5.42857142857142815906e-01 // 19/35     = 0x3FE15F15, 0xF15F15F1
        #|  let d = -7.05306122448979611050e-01 // -864/1225 = 0xBFE691DE, 0x2532C834
        #|  let e = 1.41428571428571436819e+00 // 99/70     = 0x3FF6A0EA, 0x0EA0EA0F
        #|  let f = 1.60714285714285720630e+00 // 45/28     = 0x3FF9B6DB, 0x6DB6DB6E
        #|  let g = 3.57142857142857150787e-01 // 5/14      = 0x3FD6DB6D, 0xB6DB6DB7
        #|  let hx = get_high_word(x).reinterpret_as_int()
        #|  let sign = if x < 0.0 { true } else { false }
        #|  let x = abs(x)
        #|  let t = if hx < 0x00100000 {
        #|    let t : UInt64 = 0x43500000_00000000
        #|    let t : Double = t.reinterpret_as_double()
        #|    let t = t * x
        #|    set_high_word(0, get_high_word(t) / 3 + b2)
        #|  } else {
        #|    set_high_word(0, hx.reinterpret_as_uint() / 3 + b1)
        #|  }
        #|  let r = t * t / x
        #|  let s = c + r * t
        #|  let t = t * (g + f / (s + e + d / s))
        #|  let t = set_high_word(0, get_high_word(t) + 0x00000001)
        #|  let s = t * t
        #|  let r = x / s
        #|  let w = t + t
        #|  let r = (r - t) / (w + r)
        #|  let t = t + t * r
        #|  if sign {
        #|    -t
        #|  } else {
        #|    t
        #|  } }
      ),
    ),
    "hypot": build(
      (
        #|pub fn hypot(x : Double, y : Double) -> Double { if x.is_nan() || y.is_nan() {
        #|    return @double.not_a_number
        #|  }
        #|  if x.is_inf() || y.is_inf() {
        #|    return @double.infinity
        #|  }
        #|  let x = x.abs()
        #|  let y = y.abs()
        #|  let double_epsilon : Double = 0x0.0000000000001P-1022
        #|  let (x, y) = if y > x { (y, x) } else { (x, y) }
        #|  if x * double_epsilon >= y {
        #|    return x
        #|  }
        #|  let r = y / x
        #|  x * (1.0 + r * r).sqrt() }
      ),
    ),
    "pow": build(
      (
        #|pub fn pow(x : Double, y : Double) -> Double { fn set_low_word(d : Double, v : UInt) -> Double {
        #|    let bits : UInt64 = d.reinterpret_as_uint64()
        #|    let bits = bits & 0xFFFF_FFFF_0000_0000
        #|    let bits = bits | v.to_uint64()
        #|    bits.reinterpret_as_double()
        #|  }
        #|  fn set_high_word(d : Double, v : UInt) -> Double {
        #|    let bits : UInt64 = d.reinterpret_as_uint64()
        #|    let bits = bits & 0x0000_0000_FFFF_FFFF
        #|    let bits = bits | (v.to_uint64() << 32)
        #|    bits.reinterpret_as_double()
        #|  }
        #|  fn get_high_word(x : Double) -> UInt {
        #|    (x.reinterpret_as_uint64() >> 32).to_uint()
        #|  }
        #|  fn get_low_word(x : Double) -> UInt {
        #|    x.reinterpret_as_uint64().to_uint()
        #|  }
        #|  // double z, ax, z_h, z_l, p_h, p_l;
        #|  let mut z : Double = 0.0
        #|  let mut ax : Double = 0.0
        #|  let mut z_h : Double = 0.0
        #|  let mut z_l : Double = 0.0
        #|  let mut p_h : Double = 0.0
        #|  let mut p_l : Double = 0.0
        #|  // double y1, t1, t2, r, s, t, u, v, w
        #|  let mut y1 : Double = 0.0
        #|  let mut t1 : Double = 0.0
        #|  let mut t2 : Double = 0.0
        #|  let mut r : Double = 0.0
        #|  let mut s : Double = 0.0
        #|  let mut t : Double = 0.0
        #|  let mut u : Double = 0.0
        #|  let mut v : Double = 0.0
        #|  let mut w : Double = 0.0
        #|  // int i, j, k, yisint, n
        #|  let mut i : Int = 0
        #|  let mut j : Int = 0
        #|  let mut k : Int = 0
        #|  let mut yisint : Int = 0
        #|  let mut n : Int = 0
        #|  // int hx, hy, ix, iy;
        #|  // unsigned lx, ly;
        #|  //
        #|  // EXTRACT_WORDS(hx, lx, x);
        #|  // EXTRACT_WORDS(hy, ly, y);
        #|  // ix = hx & 0x7fffffff;
        #|  // iy = hy & 0x7fffffff;
        #|  let hx : Int = (x.reinterpret_as_uint64() >> 32).to_int()
        #|  let lx : UInt = (x.reinterpret_as_uint64() & 0xFFFFFFFF).to_uint()
        #|  let hy : Int = (y.reinterpret_as_uint64() >> 32).to_int()
        #|  let ly : UInt = (y.reinterpret_as_uint64() & 0xFFFFFFFF).to_uint()
        #|  let mut ix : Int = hx & 0x7FFFFFFF
        #|  let iy : Int = hy & 0x7FFFFFFF
        #|  // y==zero: x**0 = 1
        #|  if (iy.reinterpret_as_uint() | ly) == 0 {
        #|    return ONE
        #|  }
        #|  // +-NaN return x+y
        #|  if ix > 0x7FF00000 ||
        #|    (ix == 0x7FF00000 && lx != 0) ||
        #|    iy > 0x7FF00000 ||
        #|    (iy == 0x7FF00000 && ly != 0) {
        #|    return x + y
        #|  }
        #|  // determine if y is an odd int when x < 0
        #|  // yisint = 0 ... y is not an integer
        #|  // yisint = 1 ... y is an odd int
        #|  // yisint = 2 ... y is an even int
        #|  if hx < 0 {
        #|    if iy >= 0x43400000 {
        #|      yisint = 2 // even integer y
        #|    } else if iy >= 0x3ff00000 {
        #|      k = (iy >> 20) - 0x3ff // exponent
        #|      if k > 20 {
        #|        j = (ly >> (52 - k)).reinterpret_as_int()
        #|        if j << (52 - k) == ly.reinterpret_as_int() {
        #|          yisint = 2 - (j & 1)
        #|        }
        #|      } else if ly == 0 {
        #|        j = iy >> (20 - k)
        #|        if j << (20 - k) == iy {
        #|          yisint = 2 - (j & 1)
        #|        }
        #|      }
        #|    }
        #|  }
        #|  // special value of y
        #|  if ly == 0 {
        #|    if iy == 0x7ff00000 { // y is +-inf
        #|      if ((ix.reinterpret_as_uint() - 0x3ff00000) | lx) == 0 {
        #|        return y - y // inf**+-1 is NaN
        #|      } else if ix >= 0x3ff00000 { // (|x|>1)**+-inf = inf,0
        #|        return if hy >= 0 { y } else { ZERO }
        #|      } else { // (|x|<1)**-,+inf = inf,0
        #|        return if hy < 0 { -y } else { ZERO }
        #|      }
        #|    }
        #|    if iy == 0x3ff00000 { // y is  +-1
        #|      if hy < 0 {
        #|        return ONE / x
        #|      } else {
        #|        return x
        #|      }
        #|    }
        #|    if hy == 0x40000000 { // y is 2
        #|      return x * x
        #|    }
        #|    if hy == 0x3fe00000 { // y is 0.5
        #|      if hx >= 0 { // x >= +0
        #|        return x.sqrt()
        #|      }
        #|    }
        #|  }
        #|  ax = x.abs()
        #|  // special value of x
        #|  if lx == 0 {
        #|    if ix == 0x7ff00000 || ix == 0 || ix == 0x3ff00000 {
        #|      z = ax // x is +-0,+-inf,+-1 */
        #|      if hy < 0 {
        #|        z = ONE / z // z = (1/|x|)
        #|      }
        #|      if hx < 0 {
        #|        if ((ix - 0x3ff00000) | yisint) == 0 {
        #|          // (-1)**non-int is NaN
        #|          z = @double.not_a_number
        #|        } else if yisint == 1 {
        #|          z = -z // (x<0)**odd = -(|x|**odd)
        #|        }
        #|      }
        #|      return z
        #|    }
        #|  }
        #|  n = (hx >> 31) + 1
        #|  // (x<0)**(non-int) is NaN
        #|  if (n | yisint) == 0 {
        #|    return @double.not_a_number
        #|  }
        #|  s = ONE // s (sign of result -ve**odd) = -1 else = 1
        #|  if (n | (yisint - 1)) == 0 {
        #|    s = -ONE // (-ve)**(odd int)
        #|  }
        #|  // |y| is huge
        #|  if iy > 0x41e00000 { // if |y| > 2**31 */
        #|    if iy > 0x43f00000 { // if |y| > 2**64, must o/uflow */
        #|      if ix <= 0x3fefffff {
        #|        return if hy < 0 { POW_huge * POW_huge } else { POW_tiny * POW_tiny }
        #|      }
        #|      if ix >= 0x3ff00000 {
        #|        return if hy > 0 { POW_huge * POW_huge } else { POW_tiny * POW_tiny }
        #|      }
        #|    }
        #|    // over/underflow if x is not close to one */
        #|    if ix < 0x3fefffff {
        #|      return if hy < 0 {
        #|        s * POW_huge * POW_huge
        #|      } else {
        #|        s * POW_tiny * POW_tiny
        #|      }
        #|    }
        #|    if ix > 0x3ff00000 {
        #|      return if hy > 0 {
        #|        s * POW_huge * POW_huge
        #|      } else {
        #|        s * POW_tiny * POW_tiny
        #|      }
        #|    }
        #|    // now |1-x| is tiny <= 2**-20, suffice to compute
        #|    // log(x) by x-x^2/2+x^3/3-x^4/4 */
        #|    t = ax - ONE // t has 20 trailing zeros */
        #|    w = t * t * (0.5 - t * (0.3333333333333333333333 - t * 0.25))
        #|    u = POW_ivln2_h * t // POW_ivln2_h has 21 sig. bits */
        #|    v = t * POW_ivln2_l - w * POW_ivln2
        #|    t1 = u + v
        #|    t1 = set_low_word(t1, 0)
        #|    t2 = v - (t1 - u)
        #|  } else {
        #|    n = 0
        #|    // take care subnormal number
        #|    if ix < 0x00100000 {
        #|      ax *= POW_two53
        #|      n -= 53
        #|      ix = get_high_word(ax).reinterpret_as_int()
        #|    }
        #|    n += (ix >> 20) - 0x3ff
        #|    j = ix & 0x000fffff
        #|    // determine interval
        #|    ix = j | 0x3ff00000 // normalize ix
        #|    if j <= 0x3988E {
        #|      k = 0 // |x|<sqrt(3/2)
        #|    } else if j < 0xBB67A {
        #|      k = 1 // |x|<sqrt(3)
        #|    } else {
        #|      k = 0
        #|      n += 1
        #|      ix -= 0x00100000
        #|    }
        #|    ax = set_high_word(ax, ix.reinterpret_as_uint())
        #|    // compute ss = s_h+s_l = (x-1)/(x+1) or (x-1.5)/(x+1.5)
        #|    u = ax - pow_bp[k] // bp[0]=1.0, bp[1]=1.5
        #|    v = ONE / (ax + pow_bp[k])
        #|    let ss : Double = u * v
        #|    let mut s_h : Double = ss
        #|    s_h = set_low_word(s_h, 0)
        #|    // t_h=ax+bp[k] High
        #|    let mut t_h : Double = ZERO
        #|    t_h = set_high_word(
        #|      t_h,
        #|      ((ix.reinterpret_as_uint() >> 1) | 0x20000000) +
        #|      0x00080000 +
        #|      (k.reinterpret_as_uint() << 18),
        #|    )
        #|    let mut t_l : Double = ax - (t_h - pow_bp[k])
        #|    let s_l : Double = v * (u - s_h * t_h - s_h * t_l)
        #|    // compute log(ax)
        #|    let mut s2 : Double = ss * ss
        #|    r = s2 *
        #|      s2 *
        #|      (
        #|        POW_L1 +
        #|        s2 *
        #|        (POW_L2 + s2 * (POW_L3 + s2 * (POW_L4 + s2 * (POW_L5 + s2 * POW_L6))))
        #|      )
        #|    r += s_l * (s_h + ss)
        #|    s2 = s_h * s_h
        #|    t_h = 3.0 + s2 + r
        #|    t_h = set_low_word(t_h, 0)
        #|    t_l = r - (t_h - 3.0 - s2)
        #|    // u+v = ss*(1+...)
        #|    u = s_h * t_h
        #|    v = s_l * t_h + t_l * ss
        #|    // 2/(3log2)*(ss+...)
        #|    p_h = u + v
        #|    p_h = set_low_word(p_h, 0)
        #|    p_l = v - (p_h - u)
        #|    z_h = POW_cp_h * p_h // cp_h+cp_l = 2/(3*log2)
        #|    z_l = POW_cp_l * p_h + p_l * POW_cp + pow_dp_l[k]
        #|    // log2(ax) = (ss+..)*2/(3*log2) = n + dp_h + z_h + z_l
        #|    t = n.to_double()
        #|    t1 = z_h + z_l + pow_dp_h[k] + t
        #|    t1 = set_low_word(t1, 0)
        #|    t2 = z_l - (t1 - t - pow_dp_h[k] - z_h)
        #|  }
        #|  // split up y into y1+y2 and compute (y1+y2)*(t1+t2)
        #|  y1 = y
        #|  y1 = set_low_word(y1, 0)
        #|  p_l = (y - y1) * t1 + y * t2
        #|  p_h = y1 * t1
        #|  z = p_l + p_h
        #|  j = get_high_word(z).reinterpret_as_int()
        #|  i = get_low_word(z).reinterpret_as_int()
        #|  if j >= 0x40900000 { // z >= 1024
        #|    if ((j - 0x40900000) | i) != 0 { // if z > 1024
        #|      return s * POW_huge * POW_huge // overflow
        #|    } else if p_l + POW_ovt > z - p_h {
        #|      return s * POW_huge * POW_huge // overflow
        #|    }
        #|  } else if (j & 0x7fffffff) >= 0x4090cc00 { // z <= -1075
        #|    if ((j - 0xc090cc00) | i) != 0 { // z < -1075
        #|      return s * POW_tiny * POW_tiny // underflow
        #|    } else if p_l <= z - p_h {
        #|      return s * POW_tiny * POW_tiny // underflow
        #|    }
        #|  }
        #|  //
        #|  // compute 2**(p_h+p_l)
        #|  //
        #|  i = j & 0x7fffffff
        #|  k = (i >> 20) - 0x3ff
        #|  n = 0
        #|  if i > 0x3fe00000 { // if |z| > 0.5, set n = [z+0.5]
        #|    n = j + (0x00100000 >> (k + 1))
        #|    k = ((n & 0x7fffffff) >> 20) - 0x3ff // new k for n
        #|    t = ZERO
        #|    t = set_high_word(t, (n & (0x000fffff >> k).lnot()).reinterpret_as_uint())
        #|    n = ((n & 0x000fffff) | 0x00100000) >> (20 - k)
        #|    if j < 0 {
        #|      n = -n
        #|    }
        #|    p_h -= t
        #|  }
        #|  t = p_l + p_h
        #|  t = set_low_word(t, 0)
        #|  u = t * POW_lg2_h
        #|  v = (p_l - (t - p_h)) * POW_lg2 + t * POW_lg2_l
        #|  z = u + v
        #|  w = v - (z - u)
        #|  t = z * z
        #|  t1 = z -
        #|    t * (POW_P1 + t * (POW_P2 + t * (POW_P3 + t * (POW_P4 + t * POW_P5))))
        #|  r = z * t1 / (t1 - TWO - (w + z * w))
        #|  z = ONE - (r - z)
        #|  j = get_high_word(z).reinterpret_as_int()
        #|  j += (n.reinterpret_as_uint() << 20).reinterpret_as_int()
        #|  if j >> 20 <= 0 {
        #|    z = scalbn(z, n)
        #|  } else { // subnormal output */
        #|    let tmp = get_high_word(z).reinterpret_as_int()
        #|    z = set_high_word(
        #|      z,
        #|      (tmp + (n.reinterpret_as_uint() << 20).reinterpret_as_int()).reinterpret_as_uint(),
        #|    )
        #|  }
        #|  return s * z }
      ),
    ),
    "cbrtf": build(
      (
        #|pub fn cbrtf(x : Float) -> Float { let b1 : UInt = 709958130 // B1 = (127-127.0/3-0.03306235651)*2**23 */
        #|  let b2 : UInt = 642849266 // B2 = (127-127.0/3-24/3-0.03306235651)*2**23 */
        #|  let mut ui : UInt = x.reinterpret_as_uint()
        #|  let mut hx : UInt = ui & 0x7fffffff
        #|  if hx >= 0x7f800000 {
        #|    // cbrt(NaN,INF) is itx
        #|    return x + x
        #|  }
        #|  // rough cbrt to 5 bits
        #|  if hx < 0x00800000 {
        #|    // zero or subnormal?
        #|    if hx == 0 {
        #|      return x
        #|    } // cbrt(+-0) is itx
        #|    ui = (x * (0x1.0p24 : Float)).reinterpret_as_uint()
        #|    hx = ui & 0x7fffffff
        #|    hx = hx / 3 + b2
        #|  } else {
        #|    hx = hx / 3 + b1
        #|  }
        #|  ui = ui & 0x80000000
        #|  ui = ui | hx
        #|  //
        #|  // First step Newton iteration (solving t*t-x/t == 0) to 16 bits.  In
        #|  // double precision so that its terms can be arranged for efficiency
        #|  // without causing overflow or underflow.
        #|  //
        #|  let dx = x.to_double()
        #|  let t = ui.reinterpret_as_float().to_double()
        #|  let r = t * t * t
        #|  let t = t * (dx + dx + r) / (dx + r + r)
        #|  //
        #|  // Second step Newton iteration to 47 bits.  In double precision for
        #|  // efficiency and accuracy.
        #|  //
        #|  let r = t * t * t
        #|  let t = t * (dx + dx + r) / (dx + r + r)
        #|  // rounding to 24 bits is perfect in round-to-nearest mode
        #|  t.to_float() }
      ),
    ),
    "hypotf": build(
      (
        #|pub fn hypotf(x : Float, y : Float) -> Float { let epsilon : Float = 1.1920928955078125e-7
        #|  let x = x.abs()
        #|  let y = y.abs()
        #|  if x.is_inf() || y.is_inf() {
        #|    return @float.infinity
        #|  }
        #|  let (x, y) = if y > x { (y, x) } else { (x, y) }
        #|  if x * epsilon >= y {
        #|    return x
        #|  }
        #|  let rat = y / x
        #|  x * (rat * rat + 1.0).sqrt() }
      ),
    ),
    "pi": build("0x3.243F6A8885A308CA8A54"),
    "exp": build(
      (
        #|pub fn exp(x : Double) -> Double { fn get_high_word(x : Double) -> UInt {
        #|    (x.reinterpret_as_uint64() >> 32).to_uint()
        #|  }
        #|  fn get_low_word(x : Double) -> UInt {
        #|    x.reinterpret_as_uint64().to_uint()
        #|  }
        #|  fn insert_words(ix0 : UInt64, ix1 : UInt64) -> Double {
        #|    let mut bits : UInt64 = 0
        #|    bits = bits | (ix0 << 32)
        #|    bits = bits | ix1
        #|    bits.reinterpret_as_double()
        #|  }
        #|  let ori_x = x
        #|  let mut x = x
        #|  let one = 1.0
        #|  let halF = [0.5, -0.5]
        #|  let o_threshold = 7.09782712893383973096e+02
        #|  let u_threshold = -7.45133219101941108420e+02
        #|  let ln2HI = [6.93147180369123816490e-01, -6.93147180369123816490e-01]
        #|  let ln2LO = [1.90821492927058770002e-10, -1.90821492927058770002e-10]
        #|  let invln2 = 1.44269504088896338700e+00
        #|  let p1 = 1.66666666666666019037e-01
        #|  let p2 = -2.77777777770155933842e-03
        #|  let p3 = 6.61375632143793436117e-05
        #|  let p4 = -1.65339022054652515390e-06
        #|  let p5 = 4.13813679705723846039e-08
        #|  let e = 2.718281828459045
        #|  let mut hi = 0.0
        #|  let mut lo = 0.0
        #|  let huge = 1.0e+300
        #|  let twom1000 = 9.33263618503218878990e-302
        #|  let two1023 = 8.988465674311579539e307
        #|  let mut k : Int = 0
        #|  let mut hx : UInt = get_high_word(ori_x)
        #|  let xsb : Int = ((hx >> 31) & 1).reinterpret_as_int()
        #|  hx = hx & 0x7FFFFFFF
        #|  if hx >= 0x40862E42 {
        #|    if hx >= 0x7FF00000 {
        #|      let lx : UInt = get_low_word(ori_x)
        #|      if ((hx & 0xFFFFF) | lx) != 0 {
        #|        return ori_x + ori_x
        #|      } else if xsb == 0 {
        #|        return ori_x
        #|      } else {
        #|        return 0.0
        #|      }
        #|    }
        #|    if ori_x > o_threshold {
        #|      return huge * huge
        #|    }
        #|    if ori_x < u_threshold {
        #|      return twom1000 * twom1000
        #|    }
        #|  }
        #|  if hx > 0x3FD62E42 {
        #|    if hx < 0x3FF0A2B2 {
        #|      if ori_x == 1.0 {
        #|        return e
        #|      }
        #|      hi = ori_x - ln2HI[xsb]
        #|      lo = ln2LO[xsb]
        #|      k = 1 - xsb - xsb
        #|    } else {
        #|      k = (invln2 * ori_x + halF[xsb]).to_int()
        #|      let t = k.to_double()
        #|      hi = ori_x - t * ln2HI[0]
        #|      lo = t * ln2LO[0]
        #|    }
        #|    x = hi - lo
        #|  } else if hx < 0x3E300000 {
        #|    if huge + x > one {
        #|      return one + x
        #|    }
        #|  } else {
        #|    k = 0
        #|  }
        #|  let t = x * x
        #|  let twopk = if k >= -1021 {
        #|    insert_words(
        #|      (0x3FF00000 + (k.reinterpret_as_uint() << 20).reinterpret_as_int())
        #|      .to_int64()
        #|      .reinterpret_as_uint64(),
        #|      0,
        #|    )
        #|  } else {
        #|    insert_words(
        #|      0x3FF00000UL + ((k + 1000).reinterpret_as_uint() << 20).to_uint64(),
        #|      0,
        #|    )
        #|  }
        #|  let c = x - t * (p1 + t * (p2 + t * (p3 + t * (p4 + t * p5))))
        #|  if k == 0 {
        #|    return one - (x * c / (c - 2.0) - x)
        #|  }
        #|  let y = one - (lo - x * c / (2.0 - c) - hi)
        #|  if k >= -1021 {
        #|    if k == 1024 {
        #|      return y * 2.0 * two1023
        #|    } else {
        #|      return y * twopk
        #|    }
        #|  } else {
        #|    return y * twopk * twom1000
        #|  } }
      ),
    ),
    "expm1": build(
      (
        #|pub fn expm1(x : Double) -> Double { if x.is_nan() {
        #|    return @double.not_a_number
        #|  }
        #|  let o_threshold = 7.09782712893383973096e+02
        #|  if x > o_threshold {
        #|    return @double.infinity
        #|  }
        #|  if x.is_inf() {
        #|    return -1.0
        #|  }
        #|  let huge = 1.0e+300
        #|  let tiny = 1.0e-300
        #|  let ln2_hi = 6.93147180369123816490e-01
        #|  let ln2_lo = 1.90821492927058770002e-10
        #|  let invln2 = 1.44269504088896338700e+00
        #|  let q1 = -3.33333333333331316428e-02
        #|  let q2 = 1.58730158725481460165e-03
        #|  let q3 = -7.93650757867487942473e-05
        #|  let q4 = 4.00821782732936239552e-06
        #|  let q5 = -2.01099218183624371326e-07
        #|  let mut x = x
        #|  let mut hx = get_high_word(x)
        #|  let xsb : Int = (hx & 0x80000000).reinterpret_as_int()
        #|  let mut y : Double = if xsb == 0 { x } else { -x }
        #|  hx = hx & 0x7fffffff
        #|  if hx >= 0x4043687A {
        #|    if xsb != 0 {
        #|      if x + tiny < 0.0 {
        #|        return tiny - 1.0
        #|      }
        #|    }
        #|  }
        #|  let mut hi = 0.0
        #|  let mut lo = 0.0
        #|  let mut k = 0
        #|  let mut c = 0.0
        #|  let mut t = 0.0
        #|  if hx > 0x3fd62e42 {
        #|    if hx < 0x3FF0A2B2 {
        #|      hi = if xsb == 0 { x - ln2_hi } else { x + ln2_hi }
        #|      lo = if xsb == 0 { ln2_lo } else { -ln2_lo }
        #|      k = if xsb == 0 { 1 } else { -1 }
        #|    } else {
        #|      k = (invln2 * x + (if xsb == 0 { 0.5 } else { -0.5 })).to_int()
        #|      t = k.to_double()
        #|      hi = x - t * ln2_hi
        #|      lo = t * ln2_lo
        #|    }
        #|    x = hi - lo
        #|    c = hi - x - lo
        #|  } else if hx < 0x3c900000 {
        #|    t = huge + x
        #|    return x - (t - (huge + x))
        #|  } else {
        #|    k = 0
        #|  }
        #|  let hfx : Double = 0.5 * x
        #|  let hxs : Double = x * hfx
        #|  let r1 : Double = 1.0 +
        #|    hxs * (q1 + hxs * (q2 + hxs * (q3 + hxs * (q4 + hxs * q5))))
        #|  let t : Double = 3.0 - r1 * hfx
        #|  let e : Double = hxs * ((r1 - t) / (6.0 - x * t))
        #|  if k == 0 {
        #|    return x - (x * e - hxs)
        #|  } else {
        #|    let e : Double = x * (e - c) - c
        #|    let e : Double = e - hxs
        #|    if k == -1 {
        #|      return 0.5 * (x - e) - 0.5
        #|    }
        #|    if k == 1 {
        #|      return if x < -0.25 {
        #|        -2.0 * (e - (x + 0.5))
        #|      } else {
        #|        1.0 + 2.0 * (x - e)
        #|      }
        #|    }
        #|    if k <= -2 || k > 56 {
        #|      y = 1.0 - (e - x)
        #|      y = set_high_word(y, get_high_word(y) + (k << 20).reinterpret_as_uint())
        #|      return y - 1.0
        #|    }
        #|    let mut t : Double = 1.0
        #|    if k < 20 {
        #|      t = set_high_word(0, (0x3ff00000 - (0x200000 >> k)).reinterpret_as_uint())
        #|      y = t - (e - x)
        #|      y = set_high_word(y, get_high_word(y) + (k << 20).reinterpret_as_uint())
        #|    } else {
        #|      t = set_high_word(0, ((0x3ff - k) << 20).reinterpret_as_uint())
        #|      y = x - (e + t) + 1.0
        #|      y = set_high_word(y, get_high_word(y) + (k << 20).reinterpret_as_uint())
        #|    }
        #|  }
        #|  y }
      ),
    ),
    "abs": build(
      (
        #|fn abs(x : Double) -> Double { if x < 0.0 {
        #|    -x
        #|  } else {
        #|    x
        #|  } }
      ),
    ),
    "set_low_word": build(
      (
        #|fn set_low_word(d : Double, v : UInt) -> Double { let bits : UInt64 = d.reinterpret_as_uint64()
        #|  let bits = bits & 0xFFFF_FFFF_0000_0000
        #|  let bits = bits | v.to_uint64()
        #|  bits.reinterpret_as_double() }
      ),
    ),
    "set_high_word": build(
      (
        #|fn set_high_word(d : Double, v : UInt) -> Double { let bits : UInt64 = d.reinterpret_as_uint64()
        #|  let bits = bits & 0x0000_0000_FFFF_FFFF
        #|  let bits = bits | (v.to_uint64() << 32)
        #|  bits.reinterpret_as_double() }
      ),
    ),
    "get_high_word": build(
      (
        #|fn get_high_word(x : Double) -> UInt { (x.reinterpret_as_uint64() >> 32).to_uint() }
      ),
    ),
    "get_low_word": build(
      (
        #|fn get_low_word(x : Double) -> UInt { x.reinterpret_as_uint64().to_uint() }
      ),
    ),
    "normalize": build(
      (
        #|fn normalize(f : Double) -> (Double, Int) { if f.abs() < @double.min_positive {
        #|    return (f * (1L << 52).to_double(), -52)
        #|  }
        #|  (f, 0) }
      ),
    ),
    "frexp": build(
      (
        #|fn frexp(f : Double) -> (Double, Int) { if f == 0.0 || f.is_inf() || f.is_nan() {
        #|    return (f, 0)
        #|  }
        #|  let (norm_f, exp) = normalize(f)
        #|  let u = norm_f.reinterpret_as_uint64()
        #|  let exp = exp + ((u >> 52) & 0x7FF).to_int() - 1022
        #|  let frac = ((u & (0x7FFUL << 52).lnot()) | (1022UL << 52)).reinterpret_as_double()
        #|  return (frac, exp) }
      ),
    ),
    "logf_off": UInt(0x3f330000U),
    "logf_table_bits": Int(4),
    "lnf": build(
      (
        #|pub fn lnf(x : Float) -> Float { let mut ix : UInt = x.reinterpret_as_uint()
        #|  if ix == 0x3f800000U {
        #|    return 0.0
        #|  }
        #|  if ix - 0x00800000U >= 0x7f800000U - 0x00800000U {
        #|    if ix * 2 == 0 {
        #|      return @float.neg_infinity
        #|    }
        #|    if ix == 0x7f800000U {
        #|      return x
        #|    }
        #|    if (ix & 0x80000000U) != 0 || ix * 2 >= 0xff000000U {
        #|      return @float.not_a_number
        #|    }
        #|    ix = (x * 0x1.0p23).reinterpret_as_uint()
        #|    ix -= (23 << 23).reinterpret_as_uint()
        #|  }
        #|  let tmp = ix - logf_off
        #|  let i = ((tmp >> (23 - logf_table_bits)) % logf_n).reinterpret_as_int()
        #|  let k = tmp.reinterpret_as_int() >> 23
        #|  let iz = ix - (tmp & 0xff800000U)
        #|  let invc = logf_data.invc[i]
        #|  let logc = logf_data.logc[i]
        #|  let z = iz.reinterpret_as_float().to_double()
        #|  let r = z * invc - 1
        #|  let y0 = logc + k.to_double() * logf_data.ln2
        #|  let r2 = r * r
        #|  let y = logf_data.poly[1] * r + logf_data.poly[2]
        #|  let y = logf_data.poly[0] * r2 + y
        #|  let y = y * r2 + (y0 + r)
        #|  y.to_float() }
      ),
    ),
    "ln_1pf": build(
      (
        #|pub fn ln_1pf(x : Float) -> Float { let lg1_f : Float = 0.66666662693
        #|  let lg2_f : Float = 0.40000972152
        #|  let lg3_f : Float = 0.28498786688
        #|  let lg4_f : Float = 0.24279078841
        #|  let float_ln2_hi : Float = 6.9314575195e-01 // 0x3f317200
        #|  let float_ln2_lo : Float = 1.4286067653e-06 // 0x35bfbe8e
        #|  let mut ui : UInt = x.reinterpret_as_uint()
        #|  let mut f : Float = 0
        #|  let mut c : Float = 0
        #|  let mut iu : UInt = 0
        #|  let one : Float = 1.0
        #|  let mut k = 1
        #|  if ui < 0x3ed413d0 || ui >> 31 > 0 {
        #|    if ui >= 0xbf800000 {
        #|      if x == -1.0 {
        #|        return x / 0.0
        #|      }
        #|      return (x - x) / 0.0
        #|    }
        #|    if ui << 1 < 0x33800000U << 1 {
        #|      return x
        #|    }
        #|    if ui <= 0xbe95f619 {
        #|      k = 0
        #|      c = 0.0
        #|      f = x
        #|    }
        #|  } else if ui >= 0x7f800000 {
        #|    return x
        #|  }
        #|  if k > 0 {
        #|    ui = (one + x).reinterpret_as_uint()
        #|    iu = ui
        #|    iu += 0x3f800000U - 0x3f3504f3U
        #|    k = (iu >> 23).reinterpret_as_int() - 0x7f
        #|    if k < 25 {
        #|      let fui = ui.reinterpret_as_float()
        #|      c = if k >= 2 { one - (fui - x) } else { x - (fui - 1.0) }
        #|      c /= ui.reinterpret_as_float()
        #|    } else {
        #|      c = 0.0
        #|    }
        #|    iu = (iu & 0x007fffff) + 0x3f3504f3
        #|    ui = iu
        #|    f = ui.reinterpret_as_float() - 1.0
        #|  }
        #|  let s = f / (f + 2.0)
        #|  let z = s * s
        #|  let w = z * z
        #|  let t1 = w * (lg2_f + w * lg4_f)
        #|  let t2 = z * (lg1_f + w * lg3_f)
        #|  let r = t2 + t1
        #|  let hfsq = f * f * 0.5
        #|  let dk = k.to_float()
        #|  s * (hfsq + r) + (dk * float_ln2_lo + c) - hfsq + f + dk * float_ln2_hi }
      ),
    ),
    "k_expo2f": build(
      (
        #|fn k_expo2f(x : Float) -> Float { let k = 235
        #|  let k_ln2 = (0x4322e3bc).reinterpret_as_float()
        #|  // note that k is odd and scale*scale overflows */
        #|  let scale = ((0x7f + k / 2) << 23).reinterpret_as_float()
        #|  // exp(x - k ln2) * 2**(k-1) */
        #|  expf(x - k_ln2) * scale * scale }
      ),
    ),
    "sinhf": build(
      (
        #|pub fn sinhf(x : Float) -> Float { let mut h : Float = 0.5
        #|  let mut ix = x.reinterpret_as_uint()
        #|  if ix >> 31 != 0 {
        #|    h = -h
        #|  }
        #|  // |x|
        #|  ix = ix & 0x7fffffff
        #|  let absx = ix.reinterpret_as_float()
        #|  let w = ix
        #|  // |x| < log(FLT_MAX)
        #|  if w < 0x42b17217 {
        #|    let t = expm1f(absx)
        #|    if w < 0x3f800000 {
        #|      if w < 0x3f800000U - (12U << 23) {
        #|        return x
        #|      }
        #|      return h * ((2.0 : Float) * t - t * t / (t + 1.0))
        #|    }
        #|    return h * (t + t / (t + 1.0))
        #|  }
        #|  // |x| > logf(FLT_MAX) or nan
        #|  h * k_expo2f(absx) * 2.0 }
      ),
    ),
    "coshf": build(
      (
        #|pub fn coshf(x : Float) -> Float { let mut x = x
        #|  let mut ix = x.reinterpret_as_uint()
        #|  ix = ix & 0x7fffffff
        #|  x = ix.reinterpret_as_float()
        #|  let w = ix
        #|  // |x| < log(2)
        #|  if w < 0x3f317217 {
        #|    if w < 0x3f800000U - (12U << 23) {
        #|      return 1.0
        #|    }
        #|    let t = expm1f(x)
        #|    return (1.0 : Float) + t * t / ((2.0 : Float) * (t + 1.0))
        #|  }
        #|  // |x| < log(FLT_MAX)
        #|  if w < 0x42b17217 {
        #|    let t = expf(x)
        #|    return (t + (1.0 : Float) / t) * 0.5
        #|  }
        #|  // |x| > log(FLT_MAX) or nan
        #|  k_expo2f(x) }
      ),
    ),
    "tanhf": build(
      (
        #|pub fn tanhf(x : Float) -> Float { let mut ix = x.reinterpret_as_uint()
        #|  let sign = ix >> 31 != 0
        #|  ix = ix & 0x7fffffff
        #|  let x = ix.reinterpret_as_float()
        #|  let w = ix
        #|  let tt = if w > 0x3f0c9f54 {
        #|    // |x| > log(3)/2 ~= 0.5493 or nan
        #|    if w > 0x41200000 {
        #|      // |x| > 10
        #|      (1.0 : Float) + (0.0 : Float) / x
        #|    } else {
        #|      let t = expm1f(x * 2.0)
        #|      (1.0 : Float) - (2.0 : Float) / (t + 2.0)
        #|    }
        #|  } else if w > 0x3e82c578 {
        #|    // |x| > log(5/3)/2 ~= 0.2554
        #|    let t = expm1f(x * 2.0)
        #|    t / (t + 2.0)
        #|  } else if w >= 0x00800000 {
        #|    // |x| >= 0x1p-126
        #|    let t = expm1f(x * -2.0)
        #|    -t / (t + 2.0)
        #|  } else {
        #|    // |x| is subnormal
        #|    x
        #|  }
        #|  if sign {
        #|    -tt
        #|  } else {
        #|    tt
        #|  } }
      ),
    ),
    "asinhf": build(
      (
        #|pub fn asinhf(x : Float) -> Float { let u = x.reinterpret_as_uint()
        #|  let i = u & 0x7fffffff
        #|  let sign = u >> 31 != 0
        #|  let ln2 : Float = 0.693147180559945309417232121458176568
        #|  let x = i.reinterpret_as_float()
        #|  let x = if i >= 0x3f800000U + (12U << 23) {
        #|    // |x| >= 0x1p12 or inf or nan
        #|    lnf(x) + ln2
        #|  } else if i >= 0x3f800000U + (1U << 23) {
        #|    // |x| >= 2
        #|    lnf(x * 2.0 + (1.0 : Float) / ((x * x + 1.0).sqrt() + x))
        #|  } else if i >= 0x3f800000U - (12U << 23) {
        #|    // |x| >= 0x1p-12, up to 1.6ulp error in [0.125,0.5]
        #|    ln_1pf(x + x * x / ((x * x + 1.0).sqrt() + 1.0))
        #|  } else {
        #|    // |x| < 0x1p-12, raise inexact if x!=0
        #|    // x + 0x1.0p120
        #|    x
        #|  }
        #|  if sign {
        #|    -x
        #|  } else {
        #|    x
        #|  } }
      ),
    ),
    "acoshf": build(
      (
        #|pub fn acoshf(x : Float) -> Float { let ln2 : Float = 693147180559945309417232121458176568
        #|  let u = x.reinterpret_as_uint()
        #|  let a = u & 0x7fffffffU
        #|  if a < 0x3f800000U + (1U << 23) {
        #|    // |x| < 2, invalid if x < 1 or nan
        #|    // up to 2ulp error in [1,1.125]
        #|    return ln_1pf(
        #|      x - 1.0 + ((x - 1.0) * (x - 1.0) + (2.0 : Float) * (x - 1.0)).sqrt(),
        #|    )
        #|  }
        #|  if a < 0x3f800000U + (12U << 23) {
        #|    // |x| < 0x1p12
        #|    return lnf(x * 2.0 - (1.0 : Float) / (x + (x * x - 1.0).sqrt()))
        #|  }
        #|  // x >= 0x1p12
        #|  return lnf(x) + ln2 }
      ),
    ),
    "atanhf": build(
      (
        #|pub fn atanhf(x : Float) -> Float { let u = x.reinterpret_as_uint()
        #|  let sign = u >> 31 != 0
        #|  let u = u & 0x7fffffff
        #|  let x = u.reinterpret_as_float()
        #|  let x = if u < 0x3f800000U - (1U << 23) {
        #|    if u < 0x3f800000U - (32U << 23) {
        #|      x
        #|    } else {
        #|      // |x| < 0.5, up to 1.7ulp error
        #|      ln_1pf(x * 2.0 + x * 2.0 * x / ((1.0 : Float) - x)) * 0.5
        #|    }
        #|  } else {
        #|    // avoid overflow
        #|    ln_1pf(x / ((1.0 : Float) - x) * 2.0) * 0.5
        #|  }
        #|  if sign {
        #|    -x
        #|  } else {
        #|    x
        #|  } }
      ),
    ),
    "mulh": build(
      (
        #|fn mulh(a : UInt, b : UInt) -> UInt { let a = a.to_uint64()
        #|  let b = b.to_uint64()
        #|  let res = a * b
        #|  (res >> 32).to_uint() }
      ),
    ),
    "mul": build(
      (
        #|fn mul(a : UInt, b : UInt) -> (UInt, UInt) { let a = a.to_uint64()
        #|  let b = b.to_uint64()
        #|  let res = a * b
        #|  ((res >> 32).to_uint(), res.to_uint()) }
      ),
    ),
    "trig_reduce": build(
      (
        #|fn trig_reduce(x : Float, switch_over : Float) -> (Float, Int) { if x.abs() <= switch_over {
        #|    let mut j : Float = 0.0
        #|    let mut r : Float = 0.0
        #|    j = x * (0x3f22f983).reinterpret_as_float() +
        #|      (0x4b40_0000).reinterpret_as_float()
        #|    j = (j.reinterpret_as_int() - 0x4b40_0000).to_float()
        #|    r = x - j * (0x3fc90f80).reinterpret_as_float()
        #|    r = r - j * (0x37354440).reinterpret_as_float()
        #|    r = r - j * (0x2c34611a).reinterpret_as_float()
        #|    return (r, j.to_int())
        #|  }
        #|  let xispos = x > 0.0
        #|  let mut exp : Int = ((x.reinterpret_as_int() >> 23) & 0xff) - 126
        #|  let ix = ((x.reinterpret_as_uint() & 0x007fffff) << 8) | 0x80000000
        #|  let ind = exp >> 5
        #|  exp = exp & 0x1f
        #|  let two_over_pi : Array[UInt] = [
        #|    0x00000000, 0x28be60db, 0x9391054a, 0x7f09d5f4, 0x7d4d3770, 0x36d8a566, 0x4f10e410,
        #|    0000000000,
        #|  ]
        #|  let mut hi = two_over_pi[ind]
        #|  let mut mi = two_over_pi[ind + 1]
        #|  let mut lo = two_over_pi[ind + 2]
        #|  let tp = two_over_pi[ind + 3]
        #|  if exp > 0 {
        #|    hi = (hi << exp) | (mi >> (32 - exp))
        #|    mi = (mi << exp) | (lo >> (32 - exp))
        #|    lo = (lo << exp) | (tp >> (32 - exp))
        #|  }
        #|  let phi = 0U
        #|  let (h, l) = mul(ix, lo)
        #|  let plo = phi + l
        #|  let phi = h + (if plo < l { 1 } else { 0 })
        #|  let (h, l) = mul(ix, mi)
        #|  let mut plo = phi + l
        #|  let phi = h + (if plo < l { 1 } else { 0 })
        #|  let l = ix * hi
        #|  let mut phi = phi + l
        #|  let mut q : Int = (phi >> 30).reinterpret_as_int()
        #|  phi = phi & 0x3fffffff
        #|  if (phi & 0x2000_0000) != 0 {
        #|    phi = phi - 0x4000_0000
        #|    q = q + 1
        #|  }
        #|  let s : UInt = phi & 0x8000_0000
        #|  if phi >= 0x8000_0000 {
        #|    phi = phi.lnot()
        #|    plo = 0U - plo
        #|    //phi += (plo == 0).to_uint()
        #|    phi += if plo == 0 { 1 } else { 0 }
        #|  }
        #|  exp = 0
        #|  while phi < 0x8000_0000 {
        #|    phi = (phi << 1) | (plo >> 31)
        #|    plo = plo << 1
        #|    exp = exp - 1
        #|  }
        #|  phi = mulh(phi, 0xc90f_daa2)
        #|  if phi < 0x8000_0000 {
        #|    phi = phi << 1
        #|    exp = exp - 1
        #|  }
        #|  let mut r = s +
        #|    ((exp + 128) << 23).reinterpret_as_uint() +
        #|    (phi >> 8) +
        #|    (if (phi & 0xff) > 0x7e { 1 } else { 0 })
        #|  if !xispos {
        #|    r = r ^ 0x8000_0000
        #|    q = -q
        #|  }
        #|  let r = r.reinterpret_as_float()
        #|  return (r, q) }
      ),
    ),
    "sinf_poly": build(
      (
        #|fn sinf_poly(x : Float) -> Float { let s = x * x
        #|  let mut r = (0x3640_5000).reinterpret_as_float()
        #|  r = r * s - (0x3950_3486).reinterpret_as_float()
        #|  r = r * s + (0x3c08_88c1).reinterpret_as_float()
        #|  r = r * s - (0x3e2a_aaab).reinterpret_as_float()
        #|  let t = x * s
        #|  r = r * t + x
        #|  r }
      ),
    ),
    "cosf_poly": build(
      (
        #|fn cosf_poly(x : Float) -> Float { let s = x * x
        #|  let mut r = (0x37cd_4000).reinterpret_as_float()
        #|  r = r * s - (0x3ab6_077d).reinterpret_as_float()
        #|  r = r * s + (0x3d2a_aaa8).reinterpret_as_float()
        #|  r = r * s - (0x3f00_0000).reinterpret_as_float()
        #|  r = r * s + (0x3f80_0000).reinterpret_as_float()
        #|  r }
      ),
    ),
    "sin_cos_core": build(
      (
        #|fn sin_cos_core(x : Float, q : Int) -> Float { let mut r = if (q & 1) != 0 { cosf_poly(x) } else { sinf_poly(x) }
        #|  if (q & 2) != 0 {
        #|    r = -r
        #|  }
        #|  r }
      ),
    ),
    "tanf_poly": build(
      (
        #|fn tanf_poly(x : Float, odd : Bool) -> Float { let x = x.to_double()
        #|  let coef : FixedArray[Double] = [
        #|    0.333331395030791399758, // 0x15554d3418c99f.0p-54 */
        #|     0.133392002712976742718, // 0x1112fd38999f72.0p-55 */
        #|     0.0533812378445670393523, // 0x1b54c91d865afe.0p-57 */
        #|     0.0245283181166547278873, // 0x191df3908c33ce.0p-58 */
        #|     0.00297435743359967304927, // 0x185dadfcecf44e.0p-61 */
        #|     0.00946564784943673166728, // 0x1362b9bf971bcd.0p-59 */
        #|  ]
        #|  let z = x * x
        #|  let mut r = coef[4] + z * coef[5]
        #|  let t = coef[2] + z * coef[3]
        #|  let w = z * z
        #|  let s = z * x
        #|  let u = coef[0] + z * coef[1]
        #|  r = x + s * u + s * w * (t + w * r)
        #|  (if odd { -1.0 / r } else { r }).to_float() }
      ),
    ),
    "sinf": build(
      (
        #|pub fn sinf(x : Float) -> Float { if x.is_nan() || x.is_inf() {
        #|    return @float.not_a_number
        #|  }
        #|  if x == 0.0 {
        #|    return x
        #|  }
        #|  let (x, q) = trig_reduce(x, SIN_SWITCHOVER)
        #|  sin_cos_core(x, q) }
      ),
    ),
    "cosf": build(
      (
        #|pub fn cosf(x : Float) -> Float { if x.is_nan() || x.is_inf() {
        #|    return @float.not_a_number
        #|  }
        #|  if x == 0.0 {
        #|    return 1.0
        #|  }
        #|  let (x, q) = trig_reduce(x, COS_SWITCHOVER)
        #|  sin_cos_core(x, q + 1) }
      ),
    ),
    "tanf": build(
      (
        #|pub fn tanf(x : Float) -> Float { if x.is_nan() || x.is_inf() {
        #|    return @float.not_a_number
        #|  }
        #|  if x == 0.0 {
        #|    return x
        #|  }
        #|  let (x, q) = trig_reduce(x, COS_SWITCHOVER)
        #|  tanf_poly(x, (q & 1) != 0) }
      ),
    ),
    "asinf": build(
      (
        #|pub fn asinf(x : Float) -> Float { let x1p120 = 0x3870000000000000UL.reinterpret_as_double()
        #|  let pio2 : Double = 1.570796326794896558e+00
        #|  // coefficients for R(x^2)
        #|  let ps0 : Float = 1.6666586697e-01
        #|  let ps1 : Float = -4.2743422091e-02
        #|  let ps2 : Float = -8.6563630030e-03
        #|  let qs2 : Float = -7.0662963390e-01
        #|  fn r(z : Float) -> Float {
        #|    let p = z * (ps0 + z * (ps1 + z * ps2))
        #|    let q = z * qs2 + 1.0
        #|    p / q
        #|  }
        #|  let hx = x.reinterpret_as_uint()
        #|  let ix = hx & 0x7fffffff
        #|  if ix >= 0x3f800000 {
        #|    if ix == 0x3f800000 {
        #|      return (x.to_double() * pio2 + x1p120).to_float()
        #|    }
        #|    return @float.not_a_number // asin(|x|>1) is NaN
        #|  }
        #|  if ix < 0x3f000000 {
        #|    if ix is (0x00800000..=0x39800000) {
        #|      return x
        #|    }
        #|    return x + x * r(x * x)
        #|  }
        #|  let z = ((1.0 : Float) - x.abs()) * 0.5
        #|  let s = z.to_double().sqrt()
        #|  let x = (pio2 - 2.0 * (s + s * r(z).to_double())).to_float()
        #|  if hx >> 31 != 0 {
        #|    -x
        #|  } else {
        #|    x
        #|  } }
      ),
    ),
    "acosf": build(
      (
        #|pub fn acosf(x : Float) -> Float { let pio2_hi : Float = 1.5707962513
        #|  let pio2_lo : Float = 7.5497894159e-08
        #|  let ps0 : Float = 1.6666586697e-01
        #|  let ps1 : Float = -4.2743422091e-02
        #|  let ps2 : Float = -8.6563630030e-03
        #|  let qs1 : Float = -7.0662963390e-01
        #|  let one : Float = 1.0
        #|  let two : Float = 2.0
        #|  fn r(z : Float) -> Float {
        #|    let p = z * (ps0 + z * (ps1 + z * ps2))
        #|    let q = z * qs1 + 1.0
        #|    p / q
        #|  }
        #|  let hx = x.reinterpret_as_int()
        #|  let ix = hx & 0x7fffffff
        #|  if ix >= 0x3f800000 {
        #|    if ix == 0x3f800000 {
        #|      if hx >> 31 != 0 {
        #|        return two * pio2_hi + 0x1.0p-120
        #|      }
        #|      return 0.0
        #|    }
        #|    return @float.not_a_number
        #|  }
        #|  if ix < 0x3f000000 {
        #|    if ix <= 0x32800000 {
        #|      return pio2_hi + 0x1.0p-120
        #|    }
        #|    return pio2_hi - (x - (pio2_lo - x * r(x * x)))
        #|  }
        #|  if hx >> 31 != 0 {
        #|    let z = (x + 1.0) * 0.5
        #|    let s = z.sqrt()
        #|    let w = r(z) * s - pio2_lo
        #|    return two * (pio2_hi - (s + w))
        #|  }
        #|  let z = (one - x) * 0.5
        #|  let s = z.sqrt()
        #|  let df = s
        #|  let c = (z - df * df) / (s + df)
        #|  let w = r(z) * s + c
        #|  two * (df + w) }
      ),
    ),
    "atanf": build(
      (
        #|pub fn atanf(x : Float) -> Float { let atanhi : Array[Float] = [
        #|    4.6364760399e-01, 7.8539812565e-01, 9.8279368877e-01, 1.5707962513e+00,
        #|  ]
        #|  let atanlo : Array[Float] = [
        #|    5.0121582440e-09, 3.7748947079e-08, 3.4473217170e-08, 7.5497894159e-08,
        #|  ]
        #|  let a_t : Array[Float] = [
        #|    3.3333328366e-01, -1.9999158382e-01, 1.4253635705e-01, -1.0648017377e-01, 6.1687607318e-02,
        #|  ]
        #|  let ix = x.reinterpret_as_int()
        #|  let sign = ix >> 31
        #|  let ix = ix & 0x7fffffff
        #|  let mut id = 0
        #|  let mut x = x
        #|  let one : Float = 1.0
        #|  let two : Float = 2.0
        #|  if ix >= 0x4c800000 {
        #|    if x.is_nan() {
        #|      return x
        #|    }
        #|    let z = atanhi[3] + 0x1.0p-120
        #|    let z = if sign != 0 { -z } else { z }
        #|    return z
        #|  }
        #|  if ix < 0x3ee00000 {
        #|    if ix < 0x39800000 {
        #|      return x
        #|    }
        #|    id = -1
        #|  } else {
        #|    x = x.abs()
        #|    if ix < 0x3f980000 {
        #|      if ix < 0x3f300000 {
        #|        id = 0
        #|        x = (two * x - one) / (two + x)
        #|      } else {
        #|        id = 1
        #|        x = (x - one) / (x + one)
        #|      }
        #|    } else if ix < 0x401c0000 {
        #|      id = 2
        #|      x = (x - 1.5) / (one + x * 1.5)
        #|    } else {
        #|      id = 3
        #|      x = -one / x
        #|    }
        #|  }
        #|  let z = x * x
        #|  let w = z * z
        #|  let s1 = z * (a_t[0] + w * (a_t[2] + w * a_t[4]))
        #|  let s2 = w * (a_t[1] + w * a_t[3])
        #|  if id < 0 {
        #|    return x - x * (s1 + s2)
        #|  }
        #|  let z = atanhi[id] - (x * (s1 + s2) - atanlo[id] - x)
        #|  if sign != 0 {
        #|    -z
        #|  } else {
        #|    z
        #|  } }
      ),
    ),
    "atan2f": build(
      (
        #|pub fn atan2f(y : Float, x : Float) -> Float { if x.is_nan() || y.is_nan() {
        #|    return @float.not_a_number
        #|  }
        #|  let pi : Float = 3.1415927410e+00
        #|  let pi_lo : Float = -8.7422776573e-08
        #|  let zero : Float = 0.0
        #|  let ix = x.reinterpret_as_uint()
        #|  let iy = y.reinterpret_as_uint()
        #|  if ix == 0x3f800000 {
        #|    return atanf(y)
        #|  }
        #|  let m = ((iy >> 31) & 1) | ((ix >> 30) & 2)
        #|  let ix = ix & 0x7fffffff
        #|  let iy = iy & 0x7fffffff
        #|  if iy == 0 {
        #|    match m {
        #|      0 | 1 => return y
        #|      2 => return pi
        #|      _ => return -pi
        #|    }
        #|  }
        #|  if ix == 0 {
        #|    let res = if (m & 1) != 0 { -pi / 2 } else { pi / 2 }
        #|    return res
        #|  }
        #|  if ix == 0x7f800000 {
        #|    if iy == 0x7f800000 {
        #|      match m {
        #|        0 => return pi / 4
        #|        1 => return -pi / 4
        #|        2 => return pi * 3.0 / 4
        #|        _ => return -pi * 3.0 / 4
        #|      }
        #|    } else {
        #|      match m {
        #|        0 => return 0.0
        #|        1 => return -0.0
        #|        2 => return pi
        #|        _ => return -pi
        #|      }
        #|    }
        #|  }
        #|  if ix + (26U << 23) < iy || iy == 0x7f800000 {
        #|    let res = if (m & 1) != 0 { -pi / 2 } else { pi / 2 }
        #|    return res
        #|  }
        #|  let z = if (m & 2) != 0 && iy + (26U << 23) < ix {
        #|    zero
        #|  } else {
        #|    atanf(y / x)
        #|  }
        #|  match m {
        #|    0 => z
        #|    1 => -z
        #|    2 => pi - (z - pi_lo)
        #|    _ => z - pi_lo - pi
        #|  } }
      ),
    ),
    "scalbn": build(
      (
        #|pub fn scalbn(x : Double, exp : Int) -> Double { let mut n = exp
        #|  let mut y : Double = x
        #|  if n > 1023 {
        #|    y *= 0x1.0p1023
        #|    n -= 1023
        #|    if n > 1023 {
        #|      y *= 0x1.0p1023
        #|      n -= 1023
        #|      if n > 1023 {
        #|        n = 1023
        #|      }
        #|    }
        #|  } else if n < -1022 {
        #|    // make sure final n < -53 to avoid double
        #|    // rounding in the subnormal range
        #|    y *= 0x1.0p-1022 * 0x1.0p53
        #|    n += 1022 - 53
        #|    if n < -1022 {
        #|      y *= 0x1.0p-1022 * 0x1.0p53
        #|      n += 1022 - 53
        #|      if n < -1022 {
        #|        n = -1022
        #|      }
        #|    }
        #|  }
        #|  let ui = (0x3ff + n).to_uint64() << 52
        #|  return y * ui.reinterpret_as_double() }
      ),
    ),
    "scalbnf": build(
      (
        #|pub fn scalbnf(y : Float, exp : Int) -> Float { let mut y = y
        #|  let mut n = exp
        #|  if n > 127 {
        #|    y *= (0x1.0p127 : Float)
        #|    n -= 127
        #|    if n > 127 {
        #|      y *= (0x1.0p127 : Float)
        #|      n -= 127
        #|      if n > 127 {
        #|        n = 127
        #|      }
        #|    }
        #|  } else if n < -126 {
        #|    y *= (0x1.0p-126 : Float) * 0x1.0p24
        #|    n += 126 - 24
        #|    if n < -126 {
        #|      y *= (0x1.0p-126 : Float) * 0x1.0p24
        #|      n += 126 - 24
        #|      if n < -126 {
        #|        n = -126
        #|      }
        #|    }
        #|  }
        #|  let u = (0x7f + n) << 23
        #|  return y * u.reinterpret_as_float() }
      ),
    ),
    "top12": build(
      (
        #|fn top12(x : Float) -> UInt { x.reinterpret_as_uint() >> 20 }
      ),
    ),
    "__math_xflowf": build(
      (
        #|fn __math_xflowf(sign : UInt, y : Float) -> Float { return (if sign != 0 { -y } else { y }) * y }
      ),
    ),
    "__math_oflowf": build(
      (
        #|fn __math_oflowf(sign : UInt) -> Float { return __math_xflowf(sign, 0x1.0p97) }
      ),
    ),
    "__math_uflowf": build(
      (
        #|fn __math_uflowf(sign : UInt) -> Float { return __math_xflowf(sign, 0x1.0p-95) }
      ),
    ),
    "exp2f_table_bits": Int(5),
    "expf": build(
      (
        #|pub fn expf(x : Float) -> Float { let xd = x.to_double()
        #|  let abstop = top12(x) & 0x7ff
        #|  if abstop >= top12(88.0) {
        #|    if x.reinterpret_as_uint() == @float.neg_infinity.reinterpret_as_uint() {
        #|      return 0.0
        #|    }
        #|    if abstop >= top12(@float.infinity) {
        #|      return x + x
        #|    }
        #|    if x > 0x1.62e42ep6 {
        #|      return __math_oflowf(0)
        #|    }
        #|    if x < -0x1.9fe368p6 {
        #|      return __math_uflowf(0)
        #|    }
        #|  }
        #|  let z = exp2f_data.invln2_scaled * xd
        #|  let kd = z + exp2f_data.shift
        #|  let ki = kd.reinterpret_as_uint64()
        #|  let kd = kd - exp2f_data.shift
        #|  let r = z - kd
        #|  let t = exp2f_data.tab[(ki % expf_n).to_int()]
        #|  let t = t + (ki << (52 - exp2f_table_bits))
        #|  let s = t.reinterpret_as_double()
        #|  let z = exp2f_data.poly_scaled[0] * r + exp2f_data.poly_scaled[1]
        #|  let r2 = r * r
        #|  let y = exp2f_data.poly_scaled[2] * r + 1
        #|  let y = z * r2 + y
        #|  let y = y * s
        #|  y.to_float() }
      ),
    ),
    "expm1f": build(
      (
        #|pub fn expm1f(x : Float) -> Float { let float_ln2_hi : Float = 6.9314575195e-01 // 0x3f317200
        #|  let float_ln2_lo : Float = 1.4286067653e-06 // 0x35bfbe8e
        #|  let inv_ln2 : Float = 1.4426950216e+00 // 0x3fb8aa3b
        #|  let mut x = x
        #|  let q1 : Float = -3.3333212137e-2 // -0x888868.0p-28
        #|  let q2 : Float = 1.5807170421e-3 //  0xcf3010.0p-33
        #|  let mut hx = x.reinterpret_as_uint()
        #|  let sign = hx >> 31 != 0
        #|  hx = hx & 0x7fffffff
        #|  // filter out huge and non-finite argument
        #|  if hx >= 0x4195b844 {
        #|    // if |x|>=27*ln2
        #|    if hx > 0x7f800000 {
        #|      // NaN
        #|      return x
        #|    }
        #|    if sign {
        #|      return -1.0
        #|    }
        #|    if hx > 0x42b17217 {
        #|      x *= (0x1.0p127 : Float)
        #|      return x
        #|    }
        #|  }
        #|  let mut k : Int = 0
        #|  let mut hi : Float = 0
        #|  let mut lo : Float = 0
        #|  let mut c : Float = 0
        #|  // argument reduction
        #|  if hx > 0x3eb17218 {
        #|    // if  |x| > 0.5 ln2
        #|    if hx < 0x3F851592 {
        #|      // and |x| < 1.5 ln2
        #|      if !sign {
        #|        hi = x - float_ln2_hi
        #|        lo = float_ln2_lo
        #|        k = 1
        #|      } else {
        #|        hi = x + float_ln2_hi
        #|        lo = -float_ln2_lo
        #|        k = -1
        #|      }
        #|    } else {
        #|      k = (inv_ln2 * x + (if sign { -0.5 } else { 0.5 })).to_int()
        #|      let t = k.to_float()
        #|      hi = x - t * float_ln2_hi // t*ln2_hi is exact here
        #|      lo = t * float_ln2_lo
        #|    }
        #|    x = hi - lo
        #|    c = hi - x - lo
        #|  } else if hx < 0x33000000 {
        #|    // when |x|<2**-25, return x
        #|    //if hx < 0x00800000 {
        #|    //    force_eval(x * x);
        #|    //}
        #|    return x
        #|  } else {
        #|    k = 0
        #|  }
        #|  // x is now in primary range
        #|  let hfx = (0.5 : Float) * x
        #|  let hxs = x * hfx
        #|  let r1 = (1.0 : Float) + hxs * (q1 + hxs * q2)
        #|  let t = (3.0 : Float) - r1 * hfx
        #|  let mut e = hxs * ((r1 - t) / ((6.0 : Float) - x * t))
        #|  if k == 0 {
        #|    // c is 0
        #|    return x - (x * e - hxs)
        #|  }
        #|  e = x * (e - c) - c
        #|  e -= hxs
        #|  // exp(x) ~ 2^k (x_reduced - e + 1)
        #|  if k == -1 {
        #|    return (0.5 : Float) * (x - e) - 0.5
        #|  }
        #|  if k == 1 {
        #|    if x < -0.25 {
        #|      return -(2.0 : Float) * (e - (x + 0.5))
        #|    }
        #|    return (1.0 : Float) + (2.0 : Float) * (x - e)
        #|  }
        #|  let twopk = ((0x7f + k) << 23).reinterpret_as_float() // 2^k
        #|  if !(k is (0..=56)) {
        #|    // suffice to return exp(x)-1
        #|    let mut y = x - e + 1.0
        #|    if k == 128 {
        #|      y = y * 2.0 * (0x1.0p127 : Float)
        #|    } else {
        #|      y = y * twopk
        #|    }
        #|    return y - 1.0
        #|  }
        #|  let uf = ((0x7f - k) << 23).reinterpret_as_float() // 2^-k
        #|  if k < 23 {
        #|    (x - e + ((1.0 : Float) - uf)) * twopk
        #|  } else {
        #|    (x - (e + uf) + 1.0) * twopk
        #|  } }
      ),
    ),
    "powf": build(
      (
        #|pub fn powf(base : Float, exponent : Float) -> Float { let huge : Float = 1.0e30
        #|  let tiny : Float = 1.0e-30
        #|  let cp : Float = 9.6179670095e-01 // 0x3f76384f =2/(3ln2) */
        #|  let cp_h : Float = 9.6191406250e-01 // 0x3f764000 =12b cp */
        #|  let cp_l : Float = -1.1736857402e-04 // 0xb8f623c6 =tail of cp_h */
        #|  let lg2 : Float = 6.9314718246e-01 // 0x3f317218 */
        #|  let lg2_h : Float = 6.93145752e-01 // 0x3f317200 */
        #|  let lg2_l : Float = 1.4286067653e-06 // 0x35bfbe8c */
        #|  let ovt : Float = 8.0085662595e-08 // -(2**-28)/(log(2)**2) */
        #|  let ivln2 : Float = 1.4426950216e+00 // 0x3f317218 */
        #|  let ivln2_h : Float = 1.4426879883e+00 // 0x3f317218 */
        #|  let ivln2_l : Float = 7.0526075433e-06 // 0x35bfbe8c */
        #|  let l1 : Float = 6.0000002384e-01 // 0x3f19999a */
        #|  let l2 : Float = 4.2857143283e-01 // 0x3edb6db7 */
        #|  let l3 : Float = 3.3333334327e-01 // 0x3eaaaaab */
        #|  let l4 : Float = 2.7272811532e-01 // 0x3e8ba305 */
        #|  let l5 : Float = 2.3066075146e-01 // 0x3e6c3255 */
        #|  let l6 : Float = 2.0697501302e-01 // 0x3e53f142 */
        #|  let p1 : Float = 1.6666667163e-01 // 0x3e2aaaab */
        #|  let p2 : Float = -2.7777778450e-03 // 0xbb360b61 */
        #|  let p3 : Float = 6.6137559770e-05 // 0x388ab355 */
        #|  let p4 : Float = -1.6533901999e-06 // 0xb5ddea0e */
        #|  let p5 : Float = 4.1381369442e-08 // 0x3331bb4c */
        #|  let mut z : Float = 0
        #|  let mut ax : Float = 0
        #|  let mut z_h : Float = 0
        #|  let mut z_l : Float = 0
        #|  let mut p_h : Float = 0
        #|  let mut p_l : Float = 0
        #|  let mut y1 : Float = 0
        #|  let mut t1 : Float = 0
        #|  let mut t2 : Float = 0
        #|  let mut r : Float = 0
        #|  let mut s : Float = 0
        #|  let mut sn : Float = 0
        #|  let mut t : Float = 0
        #|  let mut u : Float = 0
        #|  let mut v : Float = 0
        #|  let mut w : Float = 0
        #|  let mut i : Int = 0
        #|  let mut j : Int = 0
        #|  let mut k : Int = 0
        #|  let mut yisint : Int = 0
        #|  let mut n : Int = 0
        #|  let mut hx : Int = 0
        #|  let mut hy : Int = 0
        #|  let mut ix : Int = 0
        #|  let mut iy : Int = 0
        #|  let mut i_s : Int = 0
        #|  let (x, y) = (base, exponent)
        #|  let bp : Array[Float] = [1.0, 1.5]
        #|  let dp_h : Array[Float] = [0.0, 5.84960938e-01] // 0x3f15c000 */
        #|  let dp_l : Array[Float] = [0.0, 1.56322085e-06] // 0x35d1cfdc */
        #|  let two24 : Float = 16777216.0
        #|  hx = x.reinterpret_as_int()
        #|  hy = y.reinterpret_as_int()
        #|  ix = hx & 0x7fffffff
        #|  iy = hy & 0x7fffffff
        #|  // x**0 = 1, even if x is NaN
        #|  if iy == 0 {
        #|    return 1.0
        #|  }
        #|  // 1**y = 1, even if y is NaN
        #|  if hx == 0x3f800000 {
        #|    return 1.0
        #|  }
        #|  // NaN if either arg is NaN
        #|  if ix > 0x7f800000 || iy > 0x7f800000 {
        #|    return x + y
        #|  }
        #|  // determine if y is an odd int when x < 0
        #|  // yisint = 0       ... y is not an integer
        #|  // yisint = 1       ... y is an odd int
        #|  // yisint = 2       ... y is an even int
        #|  //
        #|  yisint = 0
        #|  if hx < 0 {
        #|    if iy >= 0x4b800000 {
        #|      yisint = 2 // even integer y
        #|    } else if iy >= 0x3f800000 {
        #|      k = (iy >> 23) - 0x7f // exponent
        #|      j = iy >> (23 - k)
        #|      if j << (23 - k) == iy {
        #|        yisint = 2 - (j & 1)
        #|      }
        #|    }
        #|  }
        #|  // special value of y
        #|  if iy == 0x7f800000 {
        #|    if ix == 0x3f800000 {
        #|      // (-1)**+-inf is 1
        #|      return 1.0
        #|    } else if ix > 0x3f800000 {
        #|      // (|x|>1)**+-inf = inf,0
        #|      return if hy >= 0 { y } else { 0.0 }
        #|    } else {
        #|      // (|x|<1)**+-inf = 0,inf
        #|      return if hy >= 0 { 0.0 } else { -y }
        #|    }
        #|  }
        #|  if iy == 0x3f800000 {
        #|    // y is +-1
        #|    return if hy >= 0 { x } else { (1.0 : Float) / x }
        #|  }
        #|  if hy == 0x40000000 {
        #|    // y is 2
        #|    return x * x
        #|  }
        #|  // y is  0.5
        #|  if hy == 0x3f000000 && hx >= 0 {
        #|    // x >= +0
        #|    return x.sqrt()
        #|  }
        #|  ax = x.abs()
        #|  // special value of x
        #|  if ix == 0x7f800000 || ix == 0 || ix == 0x3f800000 {
        #|    // x is +-0,+-inf,+-1
        #|    z = ax
        #|    if hy < 0 {
        #|      // z = (1/|x|)
        #|      z = (1.0 : Float) / z
        #|    }
        #|    if hx < 0 {
        #|      if ((ix - 0x3f800000) | yisint) == 0 {
        #|        z = (z - z) / (z - z) // (-1)**non-int is NaN
        #|      } else if yisint == 1 {
        #|        z = -z
        #|      }
        #|    } // (x<0)**odd = -(|x|**odd)
        #|    return z
        #|  }
        #|  sn = 1.0 // sign of result
        #|  if hx < 0 {
        #|    if yisint == 0 {
        #|      // (x<0)**(non-int) is NaN
        #|      return @float.not_a_number
        #|    }
        #|    if yisint == 1 {
        #|      // (x<0)**(odd int)
        #|      sn = -1.0
        #|    }
        #|  }
        #|  // |y| is huge
        #|  if iy > 0x4d000000 {
        #|    // if |y| > 2**27
        #|    // over/underflow if x is not close to one
        #|    if ix < 0x3f7ffff8 {
        #|      return if hy < 0 { sn * huge * huge } else { sn * tiny * tiny }
        #|    }
        #|    if ix > 0x3f800007 {
        #|      return if hy > 0 { sn * huge * huge } else { sn * tiny * tiny }
        #|    }
        #|    // now |1-x| is tiny <= 2**-20, suffice to compute
        #|    // log(x) by x-x^2/2+x^3/3-x^4/4
        #|    t = ax - 1.0 // t has 20 trailing zeros
        #|    w = t * t * ((0.5 : Float) - t * ((0.333333333333 : Float) - t * 0.25))
        #|    u = ivln2_h * t // IVLN2_H has 16 sig. bits
        #|    v = t * ivln2_l - w * ivln2
        #|    t1 = u + v
        #|    i_s = t1.reinterpret_as_int()
        #|    t1 = (i_s & 0xfffff000).reinterpret_as_float()
        #|    t2 = v - (t1 - u)
        #|  } else {
        #|    let mut s2 : Float = 0
        #|    let mut s_h : Float = 0
        #|    let mut s_l : Float = 0
        #|    let mut t_h : Float = 0
        #|    let mut t_l : Float = 0
        #|    n = 0
        #|    // take care subnormal number
        #|    if ix < 0x00800000 {
        #|      ax *= two24
        #|      n -= 24
        #|      ix = ax.reinterpret_as_int()
        #|    }
        #|    n += (ix >> 23) - 0x7f
        #|    j = ix & 0x007fffff
        #|    // determine interval
        #|    ix = j | 0x3f800000 // normalize ix
        #|    if j <= 0x1cc471 {
        #|      // |x|<sqrt(3/2)
        #|      k = 0
        #|    } else if j < 0x5db3d7 {
        #|      // |x|<sqrt(3)
        #|      k = 1
        #|    } else {
        #|      k = 0
        #|      n += 1
        #|      ix -= 0x00800000
        #|    }
        #|    ax = ix.reinterpret_as_float()
        #|    // compute s = s_h+s_l = (x-1)/(x+1) or (x-1.5)/(x+1.5)
        #|    u = ax - bp[k]
        #|    v = (1.0 : Float) / (ax + bp[k])
        #|    s = u * v
        #|    s_h = s
        #|    i_s = s_h.reinterpret_as_int()
        #|    s_h = (i_s & 0xfffff000).reinterpret_as_float()
        #|    // t_h=ax+bp[k] High
        #|    i_s = (((ix.reinterpret_as_uint() >> 1) & 0xfffff000) | 0x20000000).reinterpret_as_int()
        #|    t_h = (i_s.reinterpret_as_uint() +
        #|    0x00400000 +
        #|    (k.reinterpret_as_uint() << 21)).reinterpret_as_float()
        #|    t_l = ax - (t_h - bp[k])
        #|    s_l = v * (u - s_h * t_h - s_h * t_l)
        #|    // compute log(ax) */
        #|    s2 = s * s
        #|    r = s2 * s2 * (l1 + s2 * (l2 + s2 * (l3 + s2 * (l4 + s2 * (l5 + s2 * l6)))))
        #|    r += s_l * (s_h + s)
        #|    s2 = s_h * s_h
        #|    t_h = (3.0 : Float) + s2 + r
        #|    i_s = t_h.reinterpret_as_int()
        #|    t_h = (i_s & 0xfffff000).reinterpret_as_float()
        #|    t_l = r - (t_h - 3.0 - s2)
        #|    // u+v = s*(1+...)
        #|    u = s_h * t_h
        #|    v = s_l * t_h + t_l * s
        #|    // 2/(3log2)*(s+...)
        #|    p_h = u + v
        #|    i_s = p_h.reinterpret_as_int()
        #|    p_h = (i_s & 0xfffff000).reinterpret_as_float()
        #|    p_l = v - (p_h - u)
        #|    z_h = cp_h * p_h // cp_h+cp_l = 2/(3*log2)
        #|    z_l = cp_l * p_h + p_l * cp + dp_l[k]
        #|    // log2(ax) = (s+..)*2/(3*log2) = n + dp_h + z_h + z_l
        #|    t = n.to_float()
        #|    t1 = z_h + z_l + dp_h[k] + t
        #|    i_s = t1.reinterpret_as_int()
        #|    t1 = (i_s & 0xfffff000).reinterpret_as_float()
        #|    t2 = z_l - (t1 - t - dp_h[k] - z_h)
        #|  }
        #|  // split up y into y1+y2 and compute (y1+y2)*(t1+t2)
        #|  i_s = y.reinterpret_as_int()
        #|  y1 = (i_s & 0xfffff000).reinterpret_as_float()
        #|  p_l = (y - y1) * t1 + y * t2
        #|  p_h = y1 * t1
        #|  z = p_l + p_h
        #|  j = z.reinterpret_as_int()
        #|  if j > 0x43000000 {
        #|    // if z > 128
        #|    return sn * huge * huge // overflow
        #|  } else if j == 0x43000000 {
        #|    // if z == 128
        #|    if p_l + ovt > z - p_h {
        #|      return sn * huge * huge
        #|    }
        #|  } else if ( // overflow
        #|      j & 0x7fffffff
        #|    ) >
        #|    0x43160000 {
        #|    // z < -150
        #|    return sn * tiny * tiny // underflow
        #|    // z == -150
        #|  } else if j.reinterpret_as_uint() == 0xc3160000 && p_l <= z - p_h {
        #|    return sn * tiny * tiny
        #|  } // underflow
        #|  //
        #|  // compute 2**(p_h+p_l)
        #|  //
        #|  i = j & 0x7fffffff
        #|  k = (i >> 23) - 0x7f
        #|  n = 0
        #|  if i > 0x3f000000 {
        #|    // if |z| > 0.5, set n = [z+0.5]
        #|    n = j + (0x00800000 >> (k + 1))
        #|    k = ((n & 0x7fffffff) >> 23) - 0x7f // new k for n
        #|    t = (n & (0x007fffff >> k).lnot()).reinterpret_as_float()
        #|    n = ((n & 0x007fffff) | 0x00800000) >> (23 - k)
        #|    if j < 0 {
        #|      n = -n
        #|    }
        #|    p_h -= t
        #|  }
        #|  t = p_l + p_h
        #|  i_s = t.reinterpret_as_int()
        #|  t = (i_s & 0xffff8000).reinterpret_as_float()
        #|  u = t * lg2_h
        #|  v = (p_l - (t - p_h)) * lg2 + t * lg2_l
        #|  z = u + v
        #|  w = v - (z - u)
        #|  t = z * z
        #|  t1 = z - t * (p1 + t * (p2 + t * (p3 + t * (p4 + t * p5))))
        #|  r = z * t1 / (t1 - 2.0) - (w + z * w)
        #|  z = (1.0 : Float) - (r - z)
        #|  j = z.reinterpret_as_int()
        #|  j += n << 23
        #|  if j >> 23 <= 0 {
        #|    // subnormal output
        #|    z = scalbnf(z, n)
        #|  } else {
        #|    z = j.reinterpret_as_float()
        #|  }
        #|  sn * z }
      ),
    ),
  }
})

///|
let option_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/option",
  fn(_env, build) {
    {
      "a": build("Some(5)"),
      "a": build("Option::Some(\"foo\")"),
      "k": Int(21),
      "a": build("Option::Some(\"foo\")"),
      "a": build("Option::Some(5)"),
      "x": build("Option::Some(3)"),
      "x": build("Option::Some(3)"),
      "x": build("Option::Some(3)"),
      "x": build("Option::Some(3)"),
      "x": build("Option::Some(3)"),
      "some1": build("Option::Some(1)"),
      "some2": build("Option::Some(2)"),
      "none": build("Option::None"),
      "x": build("Option::Some(42)"),
      "exb": build("StringBuilder::new(size_hint=0)"),
    }
  },
)

///|
let priority_queue_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/priority_queue",
  fn(_env, build) {
    {
      "len": build("arr.length()"),
      "arr": build("Array::new(capacity=self.len)"),
      "go": build(
        (
          #|fn go(x : Node[A]) { match x {
          #|      Cons(_) as x => {
          #|        arr.push(x.content)
          #|        go(x.sibling)
          #|        go(x.child)
          #|      }
          #|      Nil => ()
          #|    } }
        ),
      ),
      "arr": build("self.to_array()"),
      "arr": build("[]"),
      "s": build("new()"),
      "result": build("self.peek()"),
      "len": build("arr.length()"),
    }
  },
)

///|
let queue_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/queue",
  fn(_env, build) {
    {
      "length": build("arr.length()"),
      "last": build("{ content: arr[length - 1], next: None }"),
      "first": build("for i = length - 2, x = last; i >= 0; {"),
      "cell": build("Some({ content: x, next: None })"),
      "first": build("{ content, next: None }"),
      "last": build("loop (first, next) {"),
      "curr": build("{ content, next: None }"),
      "q": build("new()"),
      "length": build("arr.length()"),
      "last": build("{ content: arr[length - 1], next: None }"),
      "first": build("for i = length - 2, x = last; i >= 0; {"),
      "q": build("of([1, 2, 3, 4])"),
      "q": build("of([1, 2, 3, 4])"),
      "queue": build("of([1, 2, 3, 4])"),
      "queue2": build("of([1, 2, 3, 4])"),
      "queue3": build("of([1, 2, 3, 5])"),
    }
  },
)

///|
let quickcheck_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/quickcheck",
  fn(_env, build) {
    {
      "sz": build("rs.next_positive_int() % size"),
      "len": build("if size == 0 { 0 } else { rs.next_positive_int() % size }"),
      "len": build("if size == 0 { 0 } else { rs.next_positive_int() % size }"),
      "size": build("match size {"),
      "state": build("match state {"),
      "rs": build("@splitmix.new()"),
      "array": build("Array::make(x, X::arbitrary(0, rs))"),
    }
  },
)

///|
let random_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/random",
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn new(seed~ : Bytes = b\"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456\") -> Rand { if seed.length() != 32 {
          #|    abort(\"seed must be 32 bytes long\")
          #|  }
          #|  @random_source.ChaCha8::new(seed) as &Source }
        ),
      ),
      "chacha8": build(
        (
          #|pub fn chacha8(seed~ : Bytes = b\"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456\") -> &Source { @random_source.ChaCha8::new(seed) }
        ),
      ),
      "new": build(
        (
          #|pub fn Rand::new(generator? : &Source) -> Rand { match generator {
          #|    None => chacha8()
          #|    Some(gen) => Rand(gen)
          #|  } }
        ),
      ),
      "next": build(
        (
          #|let Rand(s) = self
          #|  s.next()
        ),
      ),
      "r": build("new()"),
      "n": build("r.next()"),
      "exp": UInt64(13219109469176600229UL),
      "int": build(
        (
          #|pub fn int(self : Rand, limit~ : Int = 0) -> Int { if limit == 0 {
          #|    // Range [0, 2^31)
          #|    (self.next() >> 33).to_int()
          #|  } else {
          #|    self.uint(limit=limit.reinterpret_as_uint()).reinterpret_as_int()
          #|  } }
        ),
      ),
      "int64": build(
        (
          #|pub fn int64(self : Rand, limit~ : Int64 = 0) -> Int64 { if limit == 0 {
          #|    // range [0, 2^63)
          #|    // Create a mask that keeps the lower 63 bits
          #|    let mask : UInt64 = (1UL << 63) - 1UL
          #|    return (self.next() & mask).reinterpret_as_int64()
          #|  } else {
          #|    self.uint64(limit=limit.reinterpret_as_uint64()).reinterpret_as_int64()
          #|  } }
        ),
      ),
      "uint": build(
        (
          #|pub fn uint(self : Rand, limit~ : UInt = 0) -> UInt { if limit == 0 {
          #|    // Range: [0, 2^32)
          #|    return self.next().to_uint()
          #|  }
          #|  self.uint64(limit=limit.to_uint64()).to_uint() }
        ),
      ),
      "r": build("new()"),
      "n": build("r.uint(limit=10U)"),
      "n": build("r.uint(limit=10U)"),
      "n": build("r.uint(limit=10U)"),
      "uint64": build(
        (
          #|pub fn uint64(self : Rand, limit~ : UInt64 = 0) -> UInt64 { if limit == 0 {
          #|    // Range: [0, 2^64)
          #|    return self.next()
          #|  } else if (limit & (limit - 1)) == 0 {
          #|    // limit is a power of 2, mask to get the unbiased result.
          #|    return self.next() & (limit - 1)
          #|  }
          #|  let mut r = umul128(self.next(), limit)
          #|  if r.lo < limit {
          #|    let thresh = limit.lnot() % limit
          #|    while r.lo < thresh {
          #|      r = umul128(self.next(), limit)
          #|    }
          #|  }
          #|  r.hi }
        ),
      ),
      "r": build("new()"),
      "n": build("r.uint64()"),
      "exp": UInt64(13219109469176600229UL),
      "r": build("new()"),
      "n": build("r.uint64(limit=10UL)"),
      "n": build("r.uint64(limit=10UL)"),
      "n": build("r.uint64(limit=10UL)"),
      "double": build(
        (
          #|Double::convert_uint64(self.next() << 11 >> 11) /
          #|  Double::convert_uint64(1UL << 53)
        ),
      ),
      "r": build("new()"),
      "n": build("r.double()"),
      "float": build(
        (
          #|(self.uint() << 8 >> 8).to_float() / (1U << 24).to_float()
        ),
      ),
      "bigint": build(
        (
          #|pub fn bigint(self : Rand, bits : Int) -> @bigint.BigInt { let mod = bits % 8
          #|  let len = if mod == 0 { bits / 8 } else { bits / 8 + 1 }
          #|  let bytes = Bytes::makei(len, i => if i == 0 && mod != 0 {
          #|    let mask = (1U << mod) - 1U
          #|    (self.uint(limit=256) & mask).to_byte()
          #|  } else {
          #|    self.uint(limit=256).to_byte()
          #|  })
          #|  @bigint.BigInt::from_octets(bytes) }
        ),
      ),
      "r": build("new()"),
      "umul128": build(
        (
          #|fn umul128(a : UInt64, b : UInt64) -> UInt128 { let aLo = a & 0xffffffff
          #|  let aHi = a >> 32
          #|  let bLo = b & 0xffffffff
          #|  let bHi = b >> 32
          #|  let x = aLo * bLo
          #|  let y = aHi * bLo + (x >> 32)
          #|  let z = aLo * bHi + (y & 0xffffffff)
          #|  let w = aHi * bHi + (y >> 32) + (z >> 32)
          #|  { hi: w, lo: a * b } }
        ),
      ),
      "r": build("umul128(0x123456789ABCDEF0, 0xFEDCBA9876543210)"),
      "r": build("umul128(1UL, 1UL)"),
      "r": build("umul128(1UL, 0xFFFFFFFFFFFFFFFFUL)"),
      "r": build("umul128(0UL, 0UL)"),
      "shuffle": build(
        (
          #|pub fn shuffle(self : Rand, limit : Int, swap : (Int, Int) -> Unit) -> Unit { if limit < 0 {
          #|    abort(\"Rand::shuffle: invalid argument limit\")
          #|  }
          #|  for i = limit - 1; i > 0; i = i - 1 {
          #|    let j = self.int(limit=i + 1)
          #|    swap(i, j)
          #|  } }
        ),
      ),
      "r": build("new()"),
      "a": build("[1, 2, 3, 4, 5]"),
      "t": build("a[i]"),
    }
  },
)

///|
let rational_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/rational",
  fn(_env, build) {
    {
      "gcd": build(
        (
          #|fn gcd(a : Int64, b : Int64) -> Int64 { for a = a, b = b {
          #|    if b == 0L {
          #|      break a
          #|    }
          #|    continue b, a % b
          #|  } }
        ),
      ),
      "new": build(
        (
          #|pub fn new(numerator : Int64, denominator : Int64) -> T? { if denominator == 0L {
          #|    None
          #|  } else {
          #|    let sign = if (numerator < 0L && denominator < 0L) ||
          #|      (numerator > 0L && denominator > 0L) {
          #|      1L
          #|    } else {
          #|      -1L
          #|    }
          #|    let numerator = numerator.abs()
          #|    let denominator = denominator.abs()
          #|    let gcd = gcd(numerator, denominator)
          #|    Some({ numerator: sign * numerator / gcd, denominator: denominator / gcd })
          #|  } }
        ),
      ),
      "new_unchecked": build(
        (
          #|fn new_unchecked(numerator : Int64, denominator : Int64) -> T { let gcd = gcd(numerator.abs(), denominator)
          #|  { numerator: numerator / gcd, denominator: denominator / gcd } }
        ),
      ),
      "reciprocal": build(
        (
          #|if self.numerator < 0L {
          #|    new_unchecked(-self.denominator, -self.numerator)
          #|  } else {
          #|    new_unchecked(self.denominator, self.numerator)
          #|  }
        ),
      ),
      "neg": build(
        (
          #|new_unchecked(-self.numerator, self.denominator)
        ),
      ),
      "abs": build(
        (
          #|new_unchecked(self.numerator.abs(), self.denominator)
        ),
      ),
      "left": build("self.numerator * other.denominator"),
      "right": build("other.numerator * self.denominator"),
      "to_double": build(
        (
          #|// TODO: complete algorithm
          #|  self.numerator.to_double() / self.denominator.to_double()
        ),
      ),
      "from_double": build(
        (
          #|pub fn from_double(value : Double) -> T raise RationalError { // continued fraction algorithm
          #|  // Ported from https://github.com/rust-num/num
          #|  if value.is_nan() {
          #|    nan_error()
          #|  }
          #|  let sign = if value < 0.0 { -1L } else { 1L }
          #|  let value = value.abs()
          #|  let mut q = value
          #|  let mut n0 = 0L
          #|  let mut d0 = 1L
          #|  let mut n1 = 1L
          #|  let mut d1 = 0L
          #|  let t_max = @int64.max_value
          #|  let t_max_f = t_max.to_double()
          #|  let epsilon = 1.0 / t_max_f
          #|  let max_iteration = 30
          #|  let max_error = 10.0e-20
          #|  // Overflow
          #|  if q > t_max_f {
          #|    overflow_error()
          #|  }
          #|  for i in 0..<max_iteration {
          #|    if !(q >= -9223372036854775808.0 && q < 9223372036854775808.0) {
          #|      break // overflow
          #|    }
          #|    let a = q.to_int64()
          #|    let a_f = a.to_double()
          #|    let f = q - a_f
          #|    // Prevent overflow
          #|    if !(a == 0L) &&
          #|      (
          #|        n1 > t_max / a ||
          #|        d1 > t_max / a ||
          #|        a * n1 > t_max - n0 ||
          #|        a * d1 > t_max - d0
          #|      ) {
          #|      break
          #|    }
          #|    let n = a * n1 + n0
          #|    let d = a * d1 + d0
          #|    n0 = n1
          #|    d0 = d1
          #|    n1 = n
          #|    d1 = d
          #|    let g = gcd(n1, d1)
          #|    if !(g == 0L) {
          #|      n1 = n1 / g
          #|      d1 = d1 / g
          #|    }
          #|    // Close enough?
          #|    let (n_f, d_f) = (n.to_double(), d.to_double())
          #|    if (n_f / d_f - value).abs() < max_error {
          #|      break
          #|    }
          #|    // Prevent division by ~0
          #|    if f < epsilon {
          #|      break
          #|    }
          #|    q = 1.0 / f
          #|  }
          #|  // Overflow
          #|  if d1 == 0L {
          #|    overflow_error()
          #|  }
          #|  match new(sign * n1, d1) {
          #|    Some(r) => r
          #|    None => abort(\"Impossible to reach\")
          #|  } }
        ),
      ),
      "ceil": build(
        (
          #|let sign = if self.numerator < 0L { -1L } else { 1L }
          #|  let quotient = self.numerator / self.denominator
          #|  if self.numerator % self.denominator == 0L {
          #|    quotient
          #|  } else {
          #|    quotient + (1L + sign) / 2L
          #|  }
        ),
      ),
      "floor": build(
        (
          #|let sign = if self.numerator < 0L { -1L } else { 1L }
          #|  let quotient = self.numerator / self.denominator
          #|  if self.numerator % self.denominator == 0L {
          #|    quotient
          #|  } else {
          #|    quotient + (-1L + sign) / 2L
          #|  }
        ),
      ),
      "trunc": build(
        (
          #|if self.numerator < 0L {
          #|    -(-self.numerator / self.denominator)
          #|  } else {
          #|    self.numerator / self.denominator
          #|  }
        ),
      ),
      "fract": build(
        (
          #|new_unchecked(self.numerator % self.denominator, self.denominator)
        ),
      ),
      "is_integer": build(
        (
          #|self.denominator == 1L
        ),
      ),
    }
  },
)

///|
let ref_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/ref", fn(
  _env,
  build,
) {
  {
    "old": build("self.val"),
    "tmp": build("self.val"),
    "x": build("new(1)"),
    "y": build("new(2)"),
    "a": build("new(1)"),
    "a": build("new(1)"),
  }
})

///|
let result_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/result",
  fn(_env, build) {
    {
      "y": build("x.map((v : Int) => v * 7)"),
      "w": build("z.map((v : Int) => v * 7)"),
      "y": build("x.map_err((v : String) => v + \"!\")"),
      "w": build("z.map_err((v : Int) => v + 6)"),
      "z": build("x.or(0)"),
      "w": build("y.or(0)"),
      "z": build("x.or_else(() => 0)"),
      "w": build("y.or_else(() => 0)"),
      "y": build("x.flatten()"),
      "w": build("z.flatten()"),
      "y": build("x.bind((v : Int) => Ok(v * 7))"),
      "y": build("x.fold((v : Int) => v * 7, (_e : String) => 0)"),
      "w": build("z.fold((v : Int) => v * 7, (_e : String) => 0)"),
      "z": build("x.to_option()"),
      "w": build("y.to_option()"),
      "ok1": build("Result::Ok(1)"),
      "ok2": build("Result::Ok(2)"),
      "err1": build("Result::Err(1)"),
      "err2": build("Result::Err(2)"),
    }
  },
)

///|
let set_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/set", fn(
  _env,
  build,
) {
  {
    "calc_grow_threshold": build(
      (
        #|fn calc_grow_threshold(capacity : Int) -> Int { capacity * 13 / 16 }
      ),
    ),
    "capacity": build("capacity.next_power_of_two()"),
    "m": build("Set::new(capacity=arr.length())"),
    "hash": build("key.hash()"),
    "insert_entry": build("{ idx: -1, psl: 0, hash, key }"),
    "curr_node": build("self.list[curr_entry.idx]"),
    "hash": build("key.hash()"),
    "insert_entry": build("{ idx: -1, psl: 0, hash, key }"),
    "curr_node": build("self.list[curr_entry.idx]"),
    "hash": build("key.hash()"),
    "hash": build("key.hash()"),
    "hash": build("key.hash()"),
    "node": build("self.list[entry.idx]"),
    "old_head": build("self.head"),
    "old_list": build("self.list"),
    "new_capacity": build("self.capacity << 1"),
    "res": build("Array::new(capacity=self.size)"),
    "length": build("arr.length()"),
    "m": build("Set::new(capacity=length)"),
    "e": build("arr[i]"),
    "m": build("Set::new()"),
    "m": build("Set::new()"),
    "m": build("Set::new()"),
    "m": build("Set::new()"),
    "m": build("Set::new()"),
    "res": build("Array::new(capacity=self.size)"),
  }
})

///|
let sorted_map_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/sorted_map",
  fn(_env, build) {
    {
      "map": build("{ root: None, size: 0 }"),
      "cmp": build("key.compare(node.key)"),
      "dfs": build(
        (
          #|fn dfs(root : Node[K, V]?) -> Unit raise? { if root is Some(root) {
          #|      dfs(root.left)
          #|      f(root.key, root.value)
          #|      dfs(root.right)
          #|    } }
        ),
      ),
      "keys": build("Array::new(capacity=self.size)"),
      "values": build("Array::new(capacity=self.size)"),
      "arr": build("Array::new(capacity=self.size)"),
      "go": build(
        (
          #|fn go(x : Node[K, V]?) { match x {
          #|        None => IterContinue
          #|        Some({ left, right, key, value, .. }) =>
          #|          if go(left) is IterEnd {
          #|            IterEnd
          #|          } else if yield_((key, value)) is IterEnd {
          #|            IterEnd
          #|          } else {
          #|            go(right)
          #|          }
          #|      } }
        ),
      ),
      "go": build(
        (
          #|fn go(x : Node[K, V]?) { match x {
          #|        None => IterContinue
          #|        Some({ left, right, key, value, .. }) =>
          #|          if go(left) is IterEnd {
          #|            IterEnd
          #|          } else if yield_(key, value) is IterEnd {
          #|            IterEnd
          #|          } else {
          #|            go(right)
          #|          }
          #|      } }
        ),
      ),
      "m": build("new()"),
      "go": build(
        (
          #|fn go(x : Node[K, V]?) { match x {
          #|        None => IterContinue
          #|        Some({ left, right, key, value, .. }) => {
          #|          let cmp_key_low = key.compare(low)
          #|          let cmp_key_high = key.compare(high)
          #|          if cmp_key_low > 0 && go(left) is IterEnd {
          #|            IterEnd
          #|          } else if cmp_key_low >= 0 &&
          #|            cmp_key_high <= 0 &&
          #|            yield_(key, value) is IterEnd {
          #|            IterEnd
          #|          } else if cmp_key_high < 0 {
          #|            go(right)
          #|          } else {
          #|            IterContinue
          #|          }
          #|        }
          #|      } }
        ),
      ),
      "new_root": build("if hl > hr + 1 {"),
      "r": build("n.right.unwrap()"),
      "l": build("n.left.unwrap()"),
      "l": build("n.left.unwrap()"),
      "v": build("rotate_l(l)"),
      "r": build("n.right.unwrap()"),
      "v": build("rotate_r(r)"),
      "n": build("match (l, r) {"),
      "map": build("from_array([(3, \"c\"), (2, \"b\"), (1, \"a\")])"),
      "map": build("new()"),
      "map": build("new()"),
      "map": build("new()"),
      "map": build("new()"),
      "map": build("from_array([(3, \"c\"), (2, \"b\"), (1, \"a\")])"),
      "map": build("from_array(["),
      "map": build("new()"),
      "map": build("from_array([(3, \"c\"), (2, \"b\"), (1, \"a\")])"),
      "map": build("{ root: None, size: 0 }"),
      "max": build(
        (
          #|fn max(x : Int, y : Int) -> Int { if x > y {
          #|    x
          #|  } else {
          #|    y
          #|  } }
        ),
      ),
      "l": build("match self.left {"),
      "r": build("match self.right {"),
    }
  },
)

///|
let sorted_set_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/sorted_set",
  fn(_env, build) {
    {
      "set": build("new()"),
      "ret": build("new()"),
      "max": build(
        (
          #|fn max(x : Int, y : Int) -> Int { if x > y {
          #|    x
          #|  } else {
          #|    y
          #|  } }
        ),
      ),
      "l": build("match self.left {"),
      "r": build("match self.right {"),
      "value": build("self.value"),
      "height": build("self.height"),
      "set": build("new()"),
      "left": build("copy_tree(node.left)"),
      "right": build("copy_tree(node.right)"),
      "new_node": build(
        "new_node(node.value, left~, right~, height=node.height)",
      ),
      "compare_result": build("value.compare(node.value)"),
      "aux": build(
        (
          #|fn aux(a : Node[V]?, b : Node[V]?) -> Node[V]? { match (a, b) {
          #|      (Some(_), None) => a
          #|      (None, Some(_)) => b
          #|      (Some({ value: va, left: la, right: ra, .. }), Some(_)) => {
          #|        let (l, r) = split(b, va)
          #|        Some(join(aux(la, l), va, aux(ra, r)))
          #|      }
          #|      (None, None) => None
          #|    } }
        ),
      ),
      "t1": build("copy_tree(self.root)"),
      "t2": build("copy_tree(src.root)"),
      "t": build("aux(t1, t2)"),
      "ret": build("{ root: t, size: 0 }"),
      "comp": build("value.compare(node.value)"),
      "node": build("if height(rl) <= height(l) + 1 {"),
      "new_l": build("new_node_update_height(left=l, v, right=rl)"),
      "new_l": build("rotate_l(new_l)"),
      "new": build("new_node_update_height(left=Some(new_l), rv, right=rr)"),
      "new_l": build("join_left(l, v, rl)"),
      "new": build("new_node_update_height(left=Some(new_l), rv, right=rr)"),
      "node": build("if height(lr) <= height(r) + 1 {"),
      "new_r": build("new_node_update_height(left=lr, v, right=r)"),
      "new_r": build("rotate_r(new_r)"),
      "new": build("new_node_update_height(left=ll, lv, right=Some(new_r))"),
      "new_r": build("join_right(lr, v, r)"),
      "new": build("new_node_update_height(left=ll, lv, right=Some(new_r))"),
      "ret": build("new()"),
      "set1": build("self.difference(other)"),
      "set2": build("other.difference(self)"),
      "ret": build("new()"),
      "dfs": build(
        (
          #|fn dfs(root : Node[V]?) -> Unit raise? { if root is Some(root) {
          #|      dfs(root.left)
          #|      f(root.value)
          #|      dfs(root.right)
          #|    } }
        ),
      ),
      "padding": build("self.root.unwrap().value"),
      "arr": build("Array::make(self.size, padding)"),
      "dfs": build(
        (
          #|fn dfs(root : Node[V]?) -> Unit { if root is Some(root) {
          #|        dfs(root.left)
          #|        arr[i] = root.value
          #|        i = i + 1
          #|        dfs(root.right)
          #|      } }
        ),
      ),
      "go": build(
        (
          #|fn go(x : Node[V]?) { match x {
          #|        None => IterContinue
          #|        Some({ left, right, value, .. }) =>
          #|          if go(left) is IterEnd {
          #|            IterEnd
          #|          } else if yield_(value) is IterEnd {
          #|            IterEnd
          #|          } else {
          #|            go(right)
          #|          }
          #|      } }
        ),
      ),
      "s": build("new()"),
      "x": build("{ root: Some(self), size: 0 } // Hack for test"),
      "go": build(
        (
          #|fn go(x : Node[V]?) { match x {
          #|        None => IterContinue
          #|        Some({ left, right, value, .. }) => {
          #|          let cmp_key_low = value.compare(low)
          #|          let cmp_key_high = value.compare(high)
          #|          if cmp_key_low > 0 && go(left) is IterEnd {
          #|            IterEnd
          #|          } else if cmp_key_low >= 0 &&
          #|            cmp_key_high <= 0 &&
          #|            yield_(value) is IterEnd {
          #|            IterEnd
          #|          } else if cmp_key_high < 0 {
          #|            go(right)
          #|          } else {
          #|            IterContinue
          #|          }
          #|        }
          #|      } }
        ),
      ),
      "new_root": build("if hl > hr + 1 {"),
      "r": build("n.right.unwrap()"),
      "l": build("n.left.unwrap()"),
      "l": build("n.left.unwrap()"),
      "v": build("rotate_l(l)"),
      "r": build("n.right.unwrap()"),
      "v": build("rotate_r(r)"),
      "comp": build("value.compare(n.value)"),
      "comp": build("value.compare(root.value)"),
      "n": build("match (l, r) {"),
      "set": build("from_array([1, 2, 3, 4, 5])"),
      "copied_set": build("set.copy()"),
      "copied_set": build("set.copy()"),
      "set1": build("from_array([1, 2, 3])"),
      "set2": build("from_array([4, 5, 6])"),
      "set3": build("set1.union(set2)"),
      "set1": build("from_array([1, 2, 3])"),
      "set2": build("from_array([2, 3, 4])"),
      "set3": build("set1.union(set2)"),
      "set1": build("from_array([1, 2, 3])"),
      "set2": build("from_array([2, 3])"),
      "set3": build("set1.union(set2)"),
      "set2": build("new()"),
      "set3": build("set1.union(set2)"),
      "set1": build("from_array([1, 2, 3])"),
      "set2": build("from_array([])"),
      "set3": build("set1.union(set2)"),
      "set1": build("from_array([])"),
      "set2": build("from_array([1, 2, 3])"),
      "set3": build("set1.union(set2)"),
      "set1": build("from_array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])"),
      "set2": build("from_array([11, 12, 13, 14, 15, 16, 17, 18, 19, 20])"),
      "set3": build("set1.union(set2)"),
      "set1": build("from_array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])"),
      "set2": build("from_array([6, 7, 8, 9, 10, 11, 12, 13, 14, 15])"),
      "set3": build("set1.union(set2)"),
      "set1": build("from_array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])"),
      "set2": build("from_array([6, 7, 8, 9, 10])"),
      "set3": build("set1.union(set2)"),
      "l": build("from_array([13, 8, 17, 1, 11, 15, 25, 6])"),
      "r": build("from_array([27, 28, 40, 35, 33])"),
      "l": build("from_array([3, 2, 5, 1, 4])"),
      "r": build("from_array([7])"),
      "l": build("from_array([3, 2, 5, 1, 4])"),
      "r": build("from_array([])"),
      "l": build("from_array([])"),
      "r": build("from_array([])"),
      "l": build("from_array([])"),
      "r": build("from_array([7, 8, 9, 10, 11, 12])"),
      "set": build("new()"),
      "set": build("new()"),
      "set": build("new()"),
      "set": build("new()"),
      "set": build("from_array([7, 2, 9, 4, 5, 6, 3, 8, 1])"),
      "set": build("from_array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])"),
      "set": build("from_array([7, 2, 9, 4, 5, 6, 3, 1])"),
    }
  },
)

///|
let strconv_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/strconv",
  fn(_env, build) {
    {
      "overflow_threshold": build("match num_base {"),
      "has_digit": build("rest"),
      "c": build("c.to_int()"),
      "d": build("match c {"),
      "next_acc": build("acc * num_base.to_uint64() + d.to_uint64()"),
      "n": build("parse_uint64(str, base~)"),
      "t": build("tests[i]"),
      "t": build("tests[i]"),
      "t": build("tests[i]"),
      "parse_bool": build(
        (
          #|pub fn parse_bool(str : @string.View) -> Bool raise StrConvError { match str {
          #|    \"1\" | \"t\" | \"T\" | \"true\" | \"TRUE\" | \"True\" => true
          #|    \"0\" | \"f\" | \"F\" | \"false\" | \"FALSE\" | \"False\" => false
          #|    _ => syntax_err()
          #|  } }
        ),
      ),
      "t": build("tests[i]"),
      "mantissa_explicit_bits": Int(52),
      "parse_double": build(
        (
          #|pub fn parse_double(str : @string.View) -> Double raise StrConvError { if str.length() == 0 {
          #|    syntax_err()
          #|  }
          #|  if !check_underscore(str) {
          #|    syntax_err()
          #|  }
          #|  // validate its a number
          #|  let (num, consumed) = match parse_number(str) {
          #|    Some(r) => r
          #|    None =>
          #|      match parse_inf_nan(str) {
          #|        Some((num, consumed)) =>
          #|          if str.length() != consumed {
          #|            syntax_err()
          #|          } else {
          #|            return num
          #|          }
          #|        None => syntax_err()
          #|      }
          #|  }
          #|  if str.length() != consumed {
          #|    syntax_err()
          #|  }
          #|  // Clinger's fast path (How to read floating point numbers accurately)[https://doi.org/10.1145/989393.989430]
          #|  match num.try_fast_path() {
          #|    Some(value) => value
          #|    None => {
          #|      // fallback to slow path
          #|      let ret = parse_decimal_priv(str)
          #|      ret.to_double_priv()
          #|    }
          #|  } }
        ),
      ),
      "is_fast_path": build(
        (
          #|min_exponent_fast_path <= self.exponent &&
          #|  self.exponent <= max_exponent_disguised_fast_path &&
          #|  self.mantissa <= max_mantissa_fast_path &&
          #|  !self.many_digits
        ),
      ),
      "pow10_fast_path": build(
        (
          #|fn pow10_fast_path(exponent : Int) -> Double { table[exponent & 31] }
        ),
      ),
      "try_fast_path": build(
        (
          #|if self.is_fast_path() {
          #|    let mut value = if self.exponent <= max_exponent_fast_path {
          #|      // normal fast path
          #|      let value = Double::convert_uint64(self.mantissa)
          #|      if self.exponent < 0L {
          #|        value / pow10_fast_path(-self.exponent.to_int())
          #|      } else {
          #|        value * pow10_fast_path(self.exponent.to_int())
          #|      }
          #|    } else {
          #|      // disguised fast path
          #|      let shift = self.exponent - max_exponent_fast_path
          #|      let mantissa = match
          #|        checked_mul(self.mantissa, int_pow10[shift.to_int()]) {
          #|        Some(m) => m
          #|        None => return None
          #|      }
          #|      if mantissa > max_mantissa_fast_path {
          #|        return None
          #|      }
          #|      Double::convert_uint64(mantissa) *
          #|      pow10_fast_path(max_exponent_fast_path.to_int())
          #|    }
          #|    if self.negative {
          #|      value = -value
          #|    }
          #|    Some(value)
          #|  } else {
          #|    None
          #|  }
        ),
      ),
      "t": build("tests[i]"),
      "parse_digits": build(
        (
          #|fn parse_digits(s : @string.View, x : UInt64) -> (@string.View, UInt64, Int) { s.fold_digits(x, (digit, acc : UInt64) => acc * 10UL +
          #|    UInt64::extend_uint(digit.reinterpret_as_uint())) }
        ),
      ),
      "parse_scientific": build(
        (
          #|fn parse_scientific(s : @string.View) -> (@string.View, Int64)? { // the first character is 'e'/'E' and scientific mode is enabled
          #|  let mut s = match s.step(1) {
          #|    Some(s) => s
          #|    None => return None
          #|  }
          #|  let exp_num = 0L
          #|  let mut neg_exp = false
          #|  if s is ['+' | '-' as ch, .. rest] {
          #|    neg_exp = ch == '-'
          #|    s = rest
          #|  }
          #|  if s is ['0'..='9', ..] {
          #|    let (s, exp_num, _) = s.fold_digits(exp_num, (digit, exp_num : Int64) => if exp_num <
          #|      0x10000L {
          #|      10L * exp_num + digit.to_int64() // no overflows here
          #|    } else {
          #|      exp_num
          #|    })
          #|    if neg_exp {
          #|      Some((s, -exp_num))
          #|    } else {
          #|      Some((s, exp_num))
          #|    }
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "parse_number": build(
        (
          #|fn parse_number(s : @string.View) -> (Number, Int)? { let mut s = s
          #|  let start = s
          #|  // handle optional +/- sign
          #|  let mut negative = false
          #|  if s is ['-', .. rest] {
          #|    negative = true
          #|    s = rest
          #|  } else if s is ['+', .. rest] {
          #|    s = rest
          #|  }
          #|  if s.is_empty() {
          #|    return None
          #|  }
          #|  // parse initial digits before dot
          #|  let (s, mantissa, consumed) = parse_digits(s, 0UL)
          #|  let mut mantissa = mantissa
          #|  let mut s = s
          #|  let mut n_digits = consumed
          #|  // handle dot with the following digits
          #|  let mut n_after_dot = 0
          #|  let mut exponent = 0L
          #|  if s is ['.', .. rest] {
          #|    s = rest
          #|    // TODO: optimization chance. In the original Rust implementation,
          #|    // the the digits are stored as consecutive bytes in the string.
          #|    // It directly reads 8 bytes to `u64`.
          #|    let (new_s, new_mantissa, consumed_digit) = parse_digits(s, mantissa)
          #|    s = new_s
          #|    mantissa = new_mantissa
          #|    n_after_dot = consumed_digit
          #|    exponent = -n_after_dot.to_int64()
          #|  }
          #|  n_digits += n_after_dot
          #|  if n_digits == 0 {
          #|    return None
          #|  }
          #|  // handle scientific format
          #|  let exp_number = 0L
          #|  if s is ['e' | 'E', ..] {
          #|    let (new_s, exp_number) = match parse_scientific(s) {
          #|      Some(res) => res
          #|      None => return None
          #|    }
          #|    s = new_s
          #|    exponent += exp_number
          #|  }
          #|  let len = start.length() - s.length()
          #|  // handle uncommon case with many digits
          #|  if n_digits <= 19 {
          #|    return Some(({ exponent, mantissa, negative, many_digits: false }, len))
          #|  }
          #|  n_digits -= 19
          #|  let mut many_digits = false
          #|  let mut p = start
          #|  while p is ['0' | '.' as ch, .. rest] {
          #|    n_digits -= (ch.to_int() - 46) / 2 // '0' = b'.' + 2
          #|    p = rest
          #|  }
          #|  let mut mantissa = mantissa
          #|  if n_digits > 0 {
          #|    // at this point we have more than 19 significant digits, let's try again
          #|    many_digits = true
          #|    mantissa = 0UL
          #|    let s = start
          #|    let (s, new_mantissa, consumed_digit) = try_parse_19digits(s, mantissa)
          #|    mantissa = new_mantissa
          #|    exponent = (if mantissa >= min_19digit_int {
          #|      consumed_digit // big int
          #|    } else {
          #|      let s = match s.step(1) {
          #|        Some(s) => s
          #|        None => return None
          #|      } // fractional component, skip the '.'
          #|      let (_, new_mantissa, consumed_digit) = try_parse_19digits(s, mantissa)
          #|      mantissa = new_mantissa
          #|      consumed_digit
          #|    }).to_int64()
          #|    exponent += exp_number
          #|  } // add back the explicit part
          #|  Some(({ exponent, mantissa, negative, many_digits }, len)) }
        ),
      ),
      "parse_inf_nan": build(
        (
          #|fn parse_inf_nan(s : @string.View) -> (Double, Int)? { let mut s = s
          #|  let mut pos = true
          #|  let mut len = 0
          #|  if s is ['-' | '+' as ch, .. rest] {
          #|    pos = ch == '+'
          #|    s = rest
          #|    len += 1
          #|  }
          #|  if s is ['n' | 'N', 'a' | 'A', 'n' | 'N', ..] {
          #|    Some((@double.not_a_number, len + 3))
          #|  } else if s is ['i' | 'I', 'n' | 'N', 'f' | 'F', .. rest] {
          #|    len += 3
          #|    if rest is ['i' | 'I', 'n' | 'N', 'i' | 'I', 't' | 'T', 'y' | 'Y', ..] {
          #|      len += 5
          #|    }
          #|    if pos {
          #|      Some((@double.infinity, len))
          #|    } else {
          #|      Some((@double.neg_infinity, len))
          #|    }
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "checked_mul": build(
        (
          #|fn checked_mul(a : UInt64, b : UInt64) -> UInt64? { if a == 0UL || b == 0UL {
          #|    return Some(0UL)
          #|  }
          #|  if a == 1UL {
          #|    return Some(b)
          #|  }
          #|  if b == 1UL {
          #|    return Some(a)
          #|  }
          #|  // Can only multiply by 1 or 0, which is handled above.
          #|  if b.clz() == 0 || a.clz() == 0 {
          #|    return None
          #|  }
          #|  let quotient : UInt64 = @uint64.max_value / b
          #|  if a > quotient {
          #|    return None
          #|  }
          #|  Some(a * b) }
        ),
      ),
      "range_err_str": String("value out of range"),
      "syntax_err_str": String("invalid syntax"),
      "base_err_str": String("invalid base"),
      "max_shift": Int(59),
      "powtab": build("["),
      "new_priv": build(
        (
          #|{
          #|    digits: FixedArray::make(800, Byte::default()),
          #|    digits_num: 0,
          #|    decimal_point: 0,
          #|    negative: false,
          #|    truncated: false,
          #|  }
        ),
      ),
      "from_int64_priv": build(
        (
          #|fn Decimal::from_int64_priv(v : Int64) -> Decimal { let d = Decimal::new_priv()
          #|  d.assign(v)
          #|  d }
        ),
      ),
      "parse_decimal_priv": build(
        (
          #|fn parse_decimal_priv(str : @string.View) -> Decimal raise StrConvError { parse_decimal_from_view(str) }
        ),
      ),
      "parse_decimal_from_view": build(
        (
          #|fn parse_decimal_from_view(str : @string.View) -> Decimal raise StrConvError { let d = Decimal::new_priv()
          #|  let mut has_dp = false
          #|  let mut has_digits = false
          #|  // read sign
          #|  let rest = match str {
          #|    ['-', .. rest] => {
          #|      d.negative = true
          #|      rest
          #|    }
          #|    ['+', .. rest] => rest
          #|    _ => str
          #|  }
          #|  // read digits
          #|  let rest = loop rest {
          #|    ['_', .. rest] => continue rest
          #|    ['.', .. rest] => {
          #|      guard !has_dp else { syntax_err() }
          #|      has_dp = true
          #|      d.decimal_point = d.digits_num
          #|      continue rest
          #|    }
          #|    ['0'..='9' as digit, .. rest] => {
          #|      has_digits = true
          #|      if digit == '0' && d.digits_num == 0 {
          #|        // ignore leading zeros
          #|        d.decimal_point -= 1
          #|        continue rest
          #|      }
          #|      if d.digits_num < d.digits.length() {
          #|        d.digits[d.digits_num] = (digit.to_int() - '0').to_byte()
          #|        d.digits_num += 1
          #|      } else if digit != '0' {
          #|        d.truncated = true
          #|      }
          #|      continue rest
          #|    }
          #|    rest => rest
          #|  }
          #|  guard has_digits else { syntax_err() }
          #|  if !has_dp {
          #|    d.decimal_point = d.digits_num
          #|  }
          #|  // read exponent part
          #|  let rest = match rest {
          #|    ['e' | 'E', .. rest] => {
          #|      let mut exp_sign = 1
          #|      let rest = match rest {
          #|        ['+', .. rest] => rest
          #|        ['-', .. rest] => {
          #|          exp_sign = -1
          #|          rest
          #|        }
          #|        rest => rest
          #|      }
          #|      guard rest is ['0'..='9', ..] else { syntax_err() }
          #|      let mut exp = 0
          #|      let rest = loop rest {
          #|        ['_', .. rest] => continue rest
          #|        ['0'..='9' as digit, .. rest] => {
          #|          exp = exp * 10 + (digit.to_int() - '0')
          #|          continue rest
          #|        }
          #|        rest => rest
          #|      }
          #|      d.decimal_point += exp_sign * exp
          #|      rest
          #|    }
          #|    rest => rest
          #|  }
          #|  // finish
          #|  guard rest is [] else { syntax_err() }
          #|  d.trim()
          #|  d }
        ),
      ),
      "to_double_priv": build(
        (
          #|let mut exponent = 0
          #|  let mut mantissa = 0L
          #|  // check the underflow and overflow
          #|  // Double: 1.79769e+308 (10^308) - 2.22507e-308 (10^-308)
          #|  if self.digits_num == 0 || self.decimal_point < -330 {
          #|    // zero
          #|    mantissa = 0
          #|    exponent = double_info.bias
          #|    let bits = assemble_bits(mantissa, exponent, self.negative)
          #|    return bits.reinterpret_as_double()
          #|  }
          #|  if self.decimal_point > 310 {
          #|    // overflow
          #|    range_err()
          #|  }
          #|  // scale by powers of 2 until in range [0.5 .. 1]
          #|  // right shift
          #|  while self.decimal_point > 0 {
          #|    let mut n = 0
          #|    if self.decimal_point >= powtab.length() {
          #|      n = 60
          #|    } else {
          #|      n = powtab[self.decimal_point]
          #|    }
          #|    self.shift_priv(-n)
          #|    exponent += n
          #|  }
          #|  // left shift
          #|  while self.decimal_point < 0 ||
          #|        (self.decimal_point == 0 && self.digits[0].to_int() < 5) {
          #|    let mut n = 0
          #|    if -self.decimal_point >= powtab.length() {
          #|      n = 60
          #|    } else {
          #|      n = powtab[-self.decimal_point]
          #|    }
          #|    self.shift_priv(n)
          #|    exponent -= n
          #|  }
          #|  // normalized floating point range is [1, 2), current [0.5, 1)
          #|  // should decrease the exponent by 1
          #|  exponent -= 1
          #|  // minimum representable exponent is bias + 1
          #|  // if the exponent is smaller, move it up and shift decimal accordingly
          #|  if exponent < double_info.bias + 1 {
          #|    let n = double_info.bias + 1 - exponent
          #|    self.shift_priv(-n)
          #|    exponent += n
          #|  }
          #|  if exponent - double_info.bias >= (1 << double_info.exponent_bits) - 1 {
          #|    // overflow
          #|    range_err()
          #|  }
          #|  // multiply by (2 ** precision) and round to get mantissa
          #|  // extract mantissa_bits + 1 bits
          #|  self.shift_priv(double_info.mantissa_bits + 1)
          #|  mantissa = self.rounded_integer()
          #|  // rounding might have added a bit, shift down.
          #|  if mantissa == 2L << double_info.mantissa_bits {
          #|    mantissa = mantissa << 1
          #|    exponent += 1
          #|    if exponent - double_info.bias >= (1 << double_info.exponent_bits) - 1 {
          #|      // overflow
          #|      range_err()
          #|    }
          #|  }
          #|  // denormalized
          #|  if (mantissa & (1L << double_info.mantissa_bits)) == 0L {
          #|    exponent = double_info.bias
          #|  }
          #|  // combining the 52 mantissa bits with the 11 exponent bits and 1 sign bit
          #|  let bits = assemble_bits(mantissa, exponent, self.negative)
          #|  bits.reinterpret_as_double()
        ),
      ),
      "shift_priv": build(
        (
          #|fn shift_priv(self : Decimal, s : Int) -> Unit { if self.digits_num == 0 {
          #|    return
          #|  }
          #|  let mut s = s
          #|  if s > 0 {
          #|    while s > max_shift {
          #|      self.left_shift(max_shift)
          #|      s -= max_shift
          #|    }
          #|    self.left_shift(s)
          #|  }
          #|  if s < 0 {
          #|    while s < -max_shift {
          #|      self.right_shift(max_shift)
          #|      s += max_shift
          #|    }
          #|    self.right_shift(-s)
          #|  } }
        ),
      ),
      "assemble_bits": build(
        (
          #|fn assemble_bits(mantissa : Int64, exponent : Int, negative : Bool) -> Int64 { let biased_exp = exponent - double_info.bias
          #|  // set the mantissa bits
          #|  let mut bits = mantissa & ((1L << double_info.mantissa_bits) - 1L)
          #|  // set the exponent bits
          #|  let exp_bits = (biased_exp & ((1 << double_info.exponent_bits) - 1)).to_int64()
          #|  bits = bits | (exp_bits << double_info.mantissa_bits)
          #|  // set the sign bit
          #|  if negative {
          #|    bits = bits | (1L << double_info.mantissa_bits << double_info.exponent_bits)
          #|  }
          #|  bits }
        ),
      ),
      "rounded_integer": build(
        (
          #|if self.decimal_point > 20 {
          #|    return 0xFFFFFFFFFFFFFFFFL
          #|  }
          #|  let mut n = 0L
          #|  let mut i = 0
          #|  while i < self.decimal_point && i < self.digits_num {
          #|    n = n * 10L + self.digits[i].to_int64()
          #|    i += 1
          #|  }
          #|  while i < self.decimal_point {
          #|    n *= 10L
          #|    i += 1
          #|  }
          #|  if self.should_round_up(self.decimal_point) {
          #|    n += 1L
          #|  }
          #|  n
        ),
      ),
      "should_round_up": build(
        (
          #|fn should_round_up(self : Decimal, d : Int) -> Bool { if d < 0 || d >= self.digits_num {
          #|    return false
          #|  }
          #|  if self.digits[d].to_int() == 5 && d + 1 == self.digits_num {
          #|    // half-way between two integers
          #|    // if truncated, the real value is higher than stored value, round up.
          #|    if self.truncated {
          #|      return true
          #|    }
          #|    // round to even
          #|    return d > 0 && self.digits[d - 1].to_int() % 2 != 0
          #|  }
          #|  // normal case
          #|  self.digits[d].to_int() >= 5 }
        ),
      ),
      "assign": build(
        (
          #|fn assign(self : Decimal, v : Int64) -> Unit { let buf = FixedArray::make(24, Byte::default())
          #|  // write value to buf
          #|  let mut n = 0
          #|  let mut v = v
          #|  while v > 0 {
          #|    let v1 = v / 10
          #|    buf[n] = (v - v1 * 10).to_byte()
          #|    n += 1
          #|    v = v1
          #|  }
          #|  // reverse the buf
          #|  self.digits_num = 0
          #|  for i = n - 1; i >= 0; i = i - 1 {
          #|    self.digits[self.digits_num] = buf[i]
          #|    self.digits_num += 1
          #|  }
          #|  self.decimal_point = self.digits_num
          #|  self.trim() }
        ),
      ),
      "right_shift": build(
        (
          #|fn right_shift(self : Decimal, s : Int) -> Unit { let mut read_index = 0
          #|  let mut write_index = 0
          #|  // read enough leading digits to start a shift
          #|  let mut acc = 0UL
          #|  while acc >> s == 0 {
          #|    if read_index >= self.digits_num {
          #|      while acc >> s == 0 {
          #|        acc *= 10
          #|        read_index += 1
          #|      }
          #|      break
          #|    }
          #|    let d = self.digits[read_index]
          #|    acc = acc * 10 + d.to_int64().reinterpret_as_uint64()
          #|    read_index += 1
          #|  }
          #|  self.decimal_point -= read_index - 1
          #|  // read a digit and output a shifted digit
          #|  let mask = (1UL << s) - 1
          #|  while read_index < self.digits_num {
          #|    // output (acc >> s)
          #|    let out = acc >> s
          #|    self.digits[write_index] = out.to_byte()
          #|    write_index += 1
          #|    // contract
          #|    acc = acc & mask
          #|    // expand
          #|    let d = self.digits[read_index]
          #|    acc = acc * 10 + d.to_int64().reinterpret_as_uint64()
          #|    read_index += 1
          #|  }
          #|  // output extra digits
          #|  while acc > 0 {
          #|    let out = acc >> s
          #|    if write_index < self.digits.length() {
          #|      self.digits[write_index] = out.to_byte()
          #|      write_index += 1
          #|    } else if out > 0 {
          #|      self.truncated = true
          #|    }
          #|    acc = acc & mask
          #|    acc = acc * 10
          #|  }
          #|  // update and trim
          #|  self.digits_num = write_index
          #|  self.trim() }
        ),
      ),
      "left_shift_cheats": build("["),
      "new_digits": build(
        (
          #|fn new_digits(self : Decimal, s : Int) -> Int { let new_digits = left_shift_cheats[s].0
          #|  let cheat_num = left_shift_cheats[s].1
          #|  // check if the leading digits lexicographically less than cheats num.
          #|  let mut less = false
          #|  for i in 0..<cheat_num.length() {
          #|    if i >= self.digits_num {
          #|      less = true
          #|      break
          #|    }
          #|    let d = cheat_num.unsafe_charcode_at(i) - '0'
          #|    if self.digits[i].to_int() != d {
          #|      less = self.digits[i].to_int() < d
          #|      break
          #|    }
          #|  }
          #|  if less {
          #|    new_digits - 1
          #|  } else {
          #|    new_digits
          #|  } }
        ),
      ),
      "left_shift": build(
        (
          #|fn left_shift(self : Decimal, s : Int) -> Unit { let new_digits = self.new_digits(s)
          #|  // from right to left
          #|  let mut read_index = self.digits_num
          #|  let mut write_index = self.digits_num + new_digits
          #|  // read a digit and output a shifted digit
          #|  let mut acc = 0L
          #|  read_index -= 1
          #|  while read_index >= 0 {
          #|    let d = self.digits[read_index].to_int64()
          #|    acc += d << s
          #|    let quo = acc / 10L
          #|    let rem = (acc - quo * 10L).to_int()
          #|    write_index -= 1
          #|    if write_index < self.digits.length() {
          #|      self.digits[write_index] = rem.to_byte()
          #|    } else if rem != 0 {
          #|      self.truncated = true
          #|    }
          #|    acc = quo
          #|    read_index -= 1
          #|  }
          #|  // output extra digits
          #|  while acc > 0L {
          #|    let quo = acc / 10L
          #|    let rem = (acc - 10L * quo).to_int()
          #|    write_index -= 1
          #|    if write_index < self.digits.length() {
          #|      self.digits[write_index] = rem.to_byte()
          #|    } else if rem != 0 {
          #|      self.truncated = true
          #|    }
          #|    acc = quo
          #|  }
          #|  // update and trim
          #|  self.digits_num += new_digits
          #|  if self.digits_num > self.digits.length() {
          #|    self.digits_num = self.digits.length()
          #|  }
          #|  self.decimal_point += new_digits
          #|  self.trim() }
        ),
      ),
      "trim": build(
        (
          #|while self.digits_num > 0 && self.digits[self.digits_num - 1] == 0 {
          #|    self.digits_num -= 1
          #|  }
          #|  if self.digits_num == 0 {
          #|    self.decimal_point = 0
          #|  }
        ),
      ),
      "to_string": build(
        (
          #|Show::to_string(self)
        ),
      ),
      "hpd": build("Decimal::from_int64_priv(1L)"),
      "hpd": build("Decimal::from_int64_priv(123456789L)"),
      "s": String(
        "0.0000000000000000000000000000007888609052210118054117285652827862296732064351090230047702789306640625",
      ),
      "hpd": build("Decimal::from_int64_priv(123456789L)"),
      "t": build("tests[i]"),
      "d": build("Decimal::from_int64_priv(t.0)"),
      "s": build("String::make(100, '9')"),
      "decimal": build("parse_decimal_priv(\"12.50\")"),
      "s": build("String::make(1000, '9')"),
      "new": build(
        (
          #|Decimal::new_priv()
        ),
      ),
      "from_int64": build(
        (
          #|pub fn Decimal::from_int64(v : Int64) -> Decimal { Decimal::from_int64_priv(v) }
        ),
      ),
      "parse_decimal": build(
        (
          #|pub fn parse_decimal(str : @string.View) -> Decimal raise StrConvError { parse_decimal_from_view(str) }
        ),
      ),
      "parse_decimal": build(
        (
          #|pub fn Decimal::parse_decimal(str : @string.View) -> Decimal raise StrConvError { parse_decimal_from_view(str) }
        ),
      ),
      "to_double": build(
        (
          #|self.to_double_priv()
        ),
      ),
      "shift": build(
        (
          #|pub fn shift(self : Decimal, s : Int) -> Unit { self.shift_priv(s) }
        ),
      ),
      "overflow_threshold": build("overflow_threshold(num_base, neg)"),
      "has_digit": build("rest"),
      "c": build("c.to_int()"),
      "d": build("match c {"),
      "next_acc": build("acc * num_base.to_int64() - d.to_int64()"),
      "next_acc": build("acc * num_base.to_int64() + d.to_int64()"),
      "parse_int": build(
        (
          #|pub fn parse_int(str : @string.View, base~ : Int = 0) -> Int raise StrConvError { let n = parse_int64(str, base~)
          #|  if n < INT_MIN.to_int64() || n > INT_MAX.to_int64() {
          #|    range_err()
          #|  }
          #|  n.to_int() }
        ),
      ),
      "check_underscore": build(
        (
          #|fn check_underscore(str : @string.View) -> Bool { // skip the sign
          #|  let rest = match str {
          #|    ['+' | '-', .. rest] => rest
          #|    rest => rest
          #|    // CR: the type maybe a bit confusing?
          #|  }
          #|  // base prefix
          #|  let (rest, allow_underscore, hex) = match rest {
          #|    ['0', 'x' | 'X', .. rest] => (rest, true, true)
          #|    ['0', 'o' | 'O', .. rest] => (rest, true, false)
          #|    ['0', 'b' | 'B', .. rest] => (rest, true, false)
          #|    rest => (rest, false, false)
          #|  }
          #|  // 'e' and 'E' are valid hex digits
          #|  // but are not treated as digits in decimal strings since they're used for scientific notation
          #|  fn is_digit(c : Char) -> Bool {
          #|    c is ('0'..='9') || (hex && c is ('a'..='f' | 'A'..='F'))
          #|  }
          #|  // Track whether the previous character was an underscore
          #|  let follow_underscore = false
          #|  loop (rest, allow_underscore, follow_underscore) {
          #|    // Empty string is valid
          #|    ([], _, _) => true
          #|    // String ending with underscore is invalid
          #|    (['_'], _, _) => false
          #|    // Underscore not allowed in current position (e.g., between non-digits)
          #|    (['_', ..], false, _) => false
          #|    // Valid underscore - continue but mark that next char must be a digit
          #|    (['_', .. rest], true, _) => continue (rest, false, true)
          #|    // Handle non-underscore character
          #|    ([c, .. rest], _, follow_underscore) =>
          #|      if is_digit(c) {
          #|        // Digit found - allow underscore in next position
          #|        continue (rest, true, false)
          #|      } else if follow_underscore {
          #|        // Non-digit found after underscore - invalid
          #|        false
          #|      } else {
          #|        // Non-digit found (not after underscore) - continue but don't allow underscores
          #|        continue (rest, false, false)
          #|      }
          #|  } }
        ),
      ),
      "determine_base": build(
        (
          #|fn determine_base(s : String) -> Int { match s {
          #|    ['0', 'x' | 'X', ..] => 16
          #|    ['0', 'o' | 'O', ..] => 8
          #|    ['0', 'b' | 'B', ..] => 2
          #|    _ => 10
          #|  } }
        ),
      ),
      "overflow_threshold": build(
        (
          #|fn overflow_threshold(base : Int, neg : Bool) -> Int64 { if !neg {
          #|    if base == 10 {
          #|      INT64_MAX / 10L + 1L
          #|    } else if base == 16 {
          #|      INT64_MAX / 16L + 1L
          #|    } else {
          #|      INT64_MAX / base.to_int64() + 1L
          #|    }
          #|  } else if base == 10 {
          #|    INT64_MIN / 10L
          #|  } else if base == 16 {
          #|    INT64_MIN / 16L
          #|  } else {
          #|    INT64_MIN / base.to_int64()
          #|  } }
        ),
      ),
      "t": build("tests[i]"),
      "t": build("tests[i]"),
      "t": build("tests[i]"),
    }
  },
)

///|
let string_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/string",
  fn(_env, build) {
    {
      "concat": build(
        (
          #|pub fn String::concat(self : Array[String], separator~ : String = \"\") -> String { concat(self, separator~) }
        ),
      ),
      "concat": build(
        (
          #|pub fn concat(strings : Array[String], separator~ : String = \"\") -> String { match strings {
          #|    [] => \"\"
          #|    [hd, .. tl] => {
          #|      let mut size_hint = hd.length()
          #|      for s in tl {
          #|        size_hint += s.length() + separator.length()
          #|      }
          #|      size_hint = size_hint << 1
          #|      let buf = StringBuilder::new(size_hint~)
          #|      buf.write_string(hd)
          #|      if separator == \"\" {
          #|        for s in tl {
          #|          buf.write_string(s)
          #|        }
          #|      } else {
          #|        for s in tl {
          #|          buf.write_string(separator)
          #|          buf.write_string(s)
          #|        }
          #|      }
          #|      buf.to_string()
          #|    }
          #|  } }
        ),
      ),
      "index_of": build(
        (
          #|pub fn index_of(self : String, str : String, from~ : Int = 0) -> Int { if from <= 0 {
          #|    if self.find(str.view()) is Some(idx) {
          #|      idx
          #|    } else {
          #|      -1
          #|    }
          #|  } else if from > self.length() {
          #|    if str.length() == 0 {
          #|      self.length()
          #|    } else {
          #|      -1
          #|    }
          #|  } else if self.view(start_offset=from).find(str.view()) is Some(idx) {
          #|    idx + from
          #|  } else {
          #|    -1
          #|  } }
        ),
      ),
      "last_index_of": build(
        (
          #|pub fn last_index_of(self : String, str : String, from? : Int) -> Int { let from = if from is Some(f) { f } else { self.length() }
          #|  if from >= self.length() {
          #|    if self.rev_find(str.view()) is Some(idx) {
          #|      idx
          #|    } else {
          #|      -1
          #|    }
          #|  } else if from < 0 {
          #|    if str.length() == 0 {
          #|      self.length()
          #|    } else {
          #|      -1
          #|    }
          #|  } else if self.view(end_offset=from).rev_find(str.view()) is Some(idx) {
          #|    idx
          #|  } else {
          #|    -1
          #|  } }
        ),
      ),
      "charcode_at": build(
        (
          #|pub fn View::charcode_at(self : View, index : Int) -> Int { guard index >= 0 && index < self.length() else {
          #|    abort(\"Index out of bounds\")
          #|  }
          #|  self.str().unsafe_charcode_at(self.start() + index) }
        ),
      ),
      "char_at": build(
        (
          #|pub fn View::char_at(self : View, index : Int) -> Char { self.get_char(index).unwrap() }
        ),
      ),
      "char_at": build(
        (
          #|pub fn String::char_at(self : String, offset : Int) -> Char { match self.get_char(offset) {
          #|    Some(c) => c
          #|    None => '�'
          #|  } }
        ),
      ),
      "code_point_of_surrogate_pair": build(
        (
          #|fn code_point_of_surrogate_pair(leading : Int, trailing : Int) -> Char { ((leading - 0xD800) * 0x400 + trailing - 0xDC00 + 0x10000).unsafe_to_char() }
        ),
      ),
      "s": String("😀"),
      "leading": build("s.charcode_at(0)"),
      "trailing": build("s.charcode_at(1)"),
      "find": build(
        (
          #|pub fn View::find(self : View, str : View) -> Int? { if str.length() <= 4 {
          #|    brute_force_find(self, str)
          #|  } else {
          #|    boyer_moore_horspool_find(self, str)
          #|  }
          #|  // TODO: When the pattern string is long (>= 256),
          #|  // consider using Two-Way algorithm to ensure linear time complexity. }
        ),
      ),
      "brute_force_find": build(
        (
          #|fn brute_force_find(haystack : View, needle : View) -> Int? { let haystack_len = haystack.length()
          #|  let needle_len = needle.length()
          #|  guard needle_len > 0 else { return Some(0) }
          #|  guard haystack_len >= needle_len else { return None }
          #|  let needle_first = needle.unsafe_charcode_at(0)
          #|  let forward_len = haystack_len - needle_len
          #|  let mut i = 0
          #|  while i <= forward_len {
          #|    // Skip positions where first charcode doesn't match
          #|    while i <= forward_len && haystack.unsafe_charcode_at(i) != needle_first {
          #|      i += 1
          #|    }
          #|    if i <= forward_len {
          #|      // Check remaining charcodes for full match
          #|      for j in 1..<needle_len {
          #|        if haystack.unsafe_charcode_at(i + j) != needle.unsafe_charcode_at(j) {
          #|          break
          #|        }
          #|      } else {
          #|        return Some(i)
          #|      }
          #|      i += 1
          #|    }
          #|  }
          #|  None }
        ),
      ),
      "boyer_moore_horspool_find": build(
        (
          #|fn boyer_moore_horspool_find(haystack : View, needle : View) -> Int? { let haystack_len = haystack.length()
          #|  let needle_len = needle.length()
          #|  guard needle_len > 0 else { return Some(0) }
          #|  guard haystack_len >= needle_len else { return None }
          #|  // Build skip table
          #|  let skip_table = FixedArray::make(1 << 8, needle_len)
          #|  for i in 0..<(needle_len - 1) {
          #|    skip_table[needle.unsafe_charcode_at(i) & 0xFF] = needle_len - 1 - i
          #|  }
          #|  for i = 0
          #|      i <= haystack_len - needle_len
          #|      i = i + skip_table[haystack.unsafe_charcode_at(i + needle_len - 1) & 0xFF] {
          #|    // Check all charcodes for match at current position
          #|    for j in 0..=(needle_len - 1) {
          #|      if haystack.unsafe_charcode_at(i + j) != needle.unsafe_charcode_at(j) {
          #|        break
          #|      }
          #|    } else {
          #|      return Some(i)
          #|    }
          #|  }
          #|  None }
        ),
      ),
      "find": build(
        (
          #|pub fn String::find(self : String, str : View) -> Int? { self[:].find(str) }
        ),
      ),
      "find_by": build(
        (
          #|pub fn View::find_by(self : View, pred : (Char) -> Bool) -> Int? { for i, c in self {
          #|    if pred(c) {
          #|      return Some(i)
          #|    }
          #|  }
          #|  None }
        ),
      ),
      "find_by": build(
        (
          #|pub fn String::find_by(self : String, pred : (Char) -> Bool) -> Int? { self[:].find_by(pred) }
        ),
      ),
      "rev_find": build(
        (
          #|pub fn View::rev_find(self : View, str : View) -> Int? { if str.length() <= 4 {
          #|    brute_force_rev_find(self, str)
          #|  } else {
          #|    boyer_moore_horspool_rev_find(self, str)
          #|  }
          #|  // TODO: When the pattern string is long (>= 256),
          #|  // consider using Two-Way algorithm to ensure linear time complexity. }
        ),
      ),
      "brute_force_rev_find": build(
        (
          #|fn brute_force_rev_find(haystack : View, needle : View) -> Int? { let haystack_len = haystack.length()
          #|  let needle_len = needle.length()
          #|  guard needle_len > 0 else { return Some(haystack_len) }
          #|  guard haystack_len >= needle_len else { return None }
          #|  let needle_first = needle.unsafe_charcode_at(0)
          #|  let mut i = haystack_len - needle_len
          #|  while i >= 0 {
          #|    // Skip positions where first charcode doesn't match
          #|    while i >= 0 && haystack.unsafe_charcode_at(i) != needle_first {
          #|      i -= 1
          #|    }
          #|    if i >= 0 {
          #|      // Check remaining charcodes for full match
          #|      for j in 1..<needle_len {
          #|        if haystack.unsafe_charcode_at(i + j) != needle.unsafe_charcode_at(j) {
          #|          break
          #|        }
          #|      } else {
          #|        return Some(i)
          #|      }
          #|      i -= 1
          #|    }
          #|  }
          #|  None }
        ),
      ),
      "boyer_moore_horspool_rev_find": build(
        (
          #|fn boyer_moore_horspool_rev_find(haystack : View, needle : View) -> Int? { let haystack_len = haystack.length()
          #|  let needle_len = needle.length()
          #|  guard needle_len > 0 else { return Some(haystack_len) }
          #|  guard haystack_len >= needle_len else { return None }
          #|  let skip_table = FixedArray::make(1 << 8, needle_len)
          #|  for i = needle_len - 1; i > 0; i = i - 1 {
          #|    skip_table[needle.unsafe_charcode_at(i) & 0xFF] = i
          #|  }
          #|  for i = haystack_len - needle_len
          #|      i >= 0
          #|      i = i - skip_table[haystack.unsafe_charcode_at(i) & 0xFF] {
          #|    // Check all charcodes for match at current position
          #|    for j in 0..<needle_len {
          #|      if haystack.unsafe_charcode_at(i + j) != needle.unsafe_charcode_at(j) {
          #|        break
          #|      }
          #|    } else {
          #|      return Some(i)
          #|    }
          #|  }
          #|  None }
        ),
      ),
      "rev_find": build(
        (
          #|pub fn String::rev_find(self : String, str : View) -> Int? { self[:].rev_find(str) }
        ),
      ),
      "has_suffix": build(
        (
          #|pub fn View::has_suffix(self : View, str : View) -> Bool { self.rev_find(str) is Some(i) && i == self.length() - str.length() }
        ),
      ),
      "has_suffix": build(
        (
          #|pub fn String::has_suffix(self : String, str : View) -> Bool { self[:].has_suffix(str) }
        ),
      ),
      "has_prefix": build(
        (
          #|pub fn View::has_prefix(self : View, str : View) -> Bool { self.find(str) is Some(i) && i == 0 }
        ),
      ),
      "has_prefix": build(
        (
          #|pub fn String::has_prefix(self : String, str : View) -> Bool { self[:].has_prefix(str) }
        ),
      ),
      "strip_suffix": build(
        (
          #|pub fn strip_suffix(self : String, suffix : View) -> View? { if self.has_suffix(suffix) {
          #|    Some(self.charcodes(end=self.length() - suffix.length()))
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "strip_prefix": build(
        (
          #|pub fn strip_prefix(self : String, prefix : View) -> View? { if self.has_prefix(prefix) {
          #|    Some(self.charcodes(start=prefix.length()))
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "strip_prefix": build(
        (
          #|pub fn View::strip_prefix(self : View, prefix : View) -> View? { if self.has_prefix(prefix) {
          #|    Some(self.view(start_offset=prefix.length()))
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "strip_suffix": build(
        (
          #|pub fn View::strip_suffix(self : View, suffix : View) -> View? { if self.has_suffix(suffix) {
          #|    Some(self.view(end_offset=self.length() - suffix.length()))
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "to_array": build(
        (
          #|self
          #|  .iter()
          #|  .fold(init=Array::new(capacity=self.length()), (rv, c) => {
          #|    rv.push(c)
          #|    rv
          #|  })
        ),
      ),
      "to_bytes": build(
        (
          #|let array = FixedArray::make(self.length() * 2, Byte::default())
          #|  array.blit_from_string(0, self.data(), self.start_offset(), self.length())
          #|  array |> unsafe_to_bytes
        ),
      ),
      "view": build("\"hello world\"[:]"),
      "empty_view": build("\"\"[:]"),
      "unicode_view": build("\"😀hello😃\"[:]"),
      "view": build("\"hello world\"[:]"),
      "empty_view": build("\"\"[:]"),
      "unicode_view": build("\"😀hello😃\"[:]"),
      "view": build("\"Hello🤣\"[:]"),
      "chars": build("view.to_array()"),
      "empty_view": build("\"\"[:]"),
      "empty_chars": build("empty_view.to_array()"),
      "sub_view": build("\"Hello World\"[6:11] // \"World\""),
      "sub_chars": build("sub_view.to_array()"),
      "view": build("\"Hello\"[:]"),
      "bytes": build("view.to_bytes()"),
      "unicode_view": build("\"🤣🤔\"[:]"),
      "unicode_bytes": build("unicode_view.to_bytes()"),
      "sub_view": build("\"Hello World\"[0:5] // \"Hello\""),
      "sub_bytes": build("sub_view.to_bytes()"),
      "contains": build(
        (
          #|pub fn View::contains(self : View, str : View) -> Bool { self.find(str) is Some(_) }
        ),
      ),
      "contains": build(
        (
          #|pub fn contains(self : String, str : View) -> Bool { self[:].contains(str) }
        ),
      ),
      "contains_char": build(
        (
          #|pub fn View::contains_char(self : View, c : Char) -> Bool { let len = self.length()
          #|  // Check empty
          #|  guard len > 0 else { return false }
          #|  let c = c.to_int()
          #|  if c <= 0xFFFF {
          #|    // Search BMP
          #|    for i in 0..<len {
          #|      if self.unsafe_charcode_at(i) == c {
          #|        return true
          #|      }
          #|    }
          #|  } else {
          #|    // Check insufficient
          #|    guard len >= 2 else { return false }
          #|    // Calc surrogate pair
          #|    let adj = c - 0x10000
          #|    let high = 0xD800 + (adj >> 10)
          #|    let low = 0xDC00 + (adj & 0x3FF)
          #|    // Search surrogate pair
          #|    let mut i = 0
          #|    while i < len - 1 {
          #|      if self.unsafe_charcode_at(i) == high {
          #|        i += 1
          #|        if self.unsafe_charcode_at(i) == low {
          #|          return true
          #|        }
          #|      }
          #|      i += 1
          #|    }
          #|  }
          #|  false }
        ),
      ),
      "contains_char": build(
        (
          #|pub fn contains_char(self : String, c : Char) -> Bool { self[:].contains_char(c) }
        ),
      ),
      "trim_start": build(
        (
          #|pub fn View::trim_start(self : View, char_set : View) -> View { loop self {
          #|    [] as v => v
          #|    [c, .. rest] as v =>
          #|      if char_set.contains_char(c) {
          #|        continue rest
          #|      } else {
          #|        v
          #|      }
          #|  } }
        ),
      ),
      "trim_start": build(
        (
          #|pub fn trim_start(self : String, char_set : View) -> View { self[:].trim_start(char_set) }
        ),
      ),
      "trim_end": build(
        (
          #|pub fn View::trim_end(self : View, char_set : View) -> View { loop self {
          #|    [] as v => v
          #|    [.. rest, c] as v =>
          #|      if char_set.contains_char(c) {
          #|        continue rest
          #|      } else {
          #|        v
          #|      }
          #|  } }
        ),
      ),
      "trim_end": build(
        (
          #|pub fn trim_end(self : String, char_set : View) -> View { self[:].trim_end(char_set) }
        ),
      ),
      "trim": build(
        (
          #|pub fn View::trim(self : View, char_set : View) -> View { self.trim_start(char_set).trim_end(char_set) }
        ),
      ),
      "trim": build(
        (
          #|pub fn trim(self : String, char_set : View) -> View { self[:].trim(char_set) }
        ),
      ),
      "trim_space": build(
        (
          #|self.trim(\" \\n\\r\\t\")
        ),
      ),
      "trim_space": build(
        (
          #|self[:].trim_space()
        ),
      ),
      "is_empty": build(
        (
          #|self.length() == 0
        ),
      ),
      "is_empty": build(
        (
          #|self == \"\"
        ),
      ),
      "s": String("hello"),
      "empty_view": build("s[0:0]"),
      "non_empty_view": build("s[0:3]"),
      "is_blank": build(
        (
          #|self.trim_space().is_empty()
        ),
      ),
      "is_blank": build(
        (
          #|self[:].is_blank()
        ),
      ),
      "s": String("   hello  "),
      "blank_view": build("s[0:3] // \"   \""),
      "non_blank_view": build("s[3:8] // \"hello\""),
      "len": build("self.length()"),
      "padding": build("String::make(total_width - len, padding_char)"),
      "len": build("self.length()"),
      "padding": build("String::make(total_width - len, padding_char)"),
      "s": String("hello"),
      "view": build("s[2:5] // \"llo\""),
      "len": build("self.length()"),
      "padding": build("String::make(total_width - len, padding_char)"),
      "len": build("self.length()"),
      "padding": build("String::make(total_width - len, padding_char)"),
      "s": String("hello"),
      "view": build("s[2:5] // \"llo\""),
      "repeat": build(
        (
          #|pub fn View::repeat(self : View, n : Int) -> View { match n {
          #|    _..=0 => \"\"
          #|    1 => self
          #|    _ => {
          #|      let len = self.length()
          #|      let buf = StringBuilder::new(size_hint=len * n)
          #|      let str = self.to_string()
          #|      for _ in 0..<n {
          #|        buf.write_string(str)
          #|      }
          #|      buf.to_string()
          #|    }
          #|  } }
        ),
      ),
      "repeat": build(
        (
          #|pub fn repeat(self : String, n : Int) -> String { match n {
          #|    _..=0 => \"\"
          #|    1 => self
          #|    _ => {
          #|      let len = self.length()
          #|      let buf = StringBuilder::new(size_hint=len * n)
          #|      let str = self.to_string()
          #|      for _ in 0..<n {
          #|        buf.write_string(str)
          #|      }
          #|      buf.to_string()
          #|    }
          #|  } }
        ),
      ),
      "s": String("hello world"),
      "view": build("s[6:11] // \"world\""),
      "rev": build(
        (
          #|let buf = StringBuilder::new(size_hint=self.length())
          #|  for c in self.rev_iter() {
          #|    buf.write_char(c)
          #|  }
          #|  buf.to_string()
        ),
      ),
      "rev": build(
        (
          #|self[:].rev()
        ),
      ),
      "split": build(
        (
          #|pub fn View::split(self : View, sep : View) -> Iter[View] { let sep_len = sep.length()
          #|  if sep_len == 0 {
          #|    return self.iter().map(c => c.to_string().view())
          #|  }
          #|  Iter::new(yield_ => {
          #|    let mut view = self
          #|    while view.find(sep) is Some(end) {
          #|      guard yield_(view.view(end_offset=end)) is IterContinue else {
          #|        break IterEnd
          #|      }
          #|      view = view.view(start_offset=end + sep_len)
          #|    } else {
          #|      yield_(view)
          #|    }
          #|  }) }
        ),
      ),
      "split": build(
        (
          #|pub fn split(self : String, sep : View) -> Iter[View] { self[:].split(sep) }
        ),
      ),
      "replace": build(
        (
          #|pub fn View::replace(self : View, old~ : View, new~ : View) -> View { match self.find(old) {
          #|    Some(end) =>
          #|      [
          #|        ..self.view(end_offset=end),
          #|        ..new,
          #|        ..self.view(start_offset=end + old.length()),
          #|      ]
          #|    None => self
          #|  } }
        ),
      ),
      "replace": build(
        (
          #|pub fn replace(self : String, old~ : View, new~ : View) -> String { match self.find(old) {
          #|    Some(end) =>
          #|      [
          #|        ..self.view(end_offset=end),
          #|        ..new,
          #|        ..self.view(start_offset=end + old.length()),
          #|      ]
          #|    None => self
          #|  } }
        ),
      ),
      "replace_all": build(
        (
          #|pub fn View::replace_all(self : View, old~ : View, new~ : View) -> View { let len = self.length()
          #|  let buf = StringBuilder::new(size_hint=len)
          #|  let old_len = old.length()
          #|  let new = new.to_string()
          #|  // use write_substring to avoid intermediate allocations
          #|  if old_len == 0 {
          #|    buf.write_string(new)
          #|    for c in self {
          #|      buf.write_char(c)
          #|      buf.write_string(new)
          #|    }
          #|    buf.to_string()
          #|  } else {
          #|    let first_end = self.find(old)
          #|    if first_end is Some(end) {
          #|      for view = self, end = end {
          #|        let seg = view.view(end_offset=end)
          #|        buf.write_substring(seg.data(), seg.start_offset(), seg.length())
          #|        buf.write_string(new)
          #|        // check if there is no more characters after the last occurrence of `old`
          #|        guard end + old_len <= len else { break }
          #|        let next_view = view.view(start_offset=end + old_len)
          #|        guard next_view.find(old) is Some(next_end) else {
          #|          buf.write_substring(
          #|            next_view.data(),
          #|            next_view.start_offset(),
          #|            next_view.length(),
          #|          )
          #|          break
          #|        }
          #|        continue next_view, next_end
          #|      }
          #|      buf.to_string()
          #|    } else {
          #|      self
          #|    }
          #|  } }
        ),
      ),
      "replace_all": build(
        (
          #|pub fn replace_all(self : String, old~ : View, new~ : View) -> String { let len = self.length()
          #|  let buf = StringBuilder::new(size_hint=len)
          #|  let old_len = old.length()
          #|  let new = new.to_string()
          #|  // use write_substring to avoid intermediate allocations
          #|  if old_len == 0 {
          #|    buf.write_string(new)
          #|    for c in self {
          #|      buf.write_char(c)
          #|      buf.write_string(new)
          #|    }
          #|    buf.to_string()
          #|  } else {
          #|    let first_end = self.find(old)
          #|    if first_end is Some(end) {
          #|      for view = self[:], end = end {
          #|        let seg = view.view(end_offset=end)
          #|        buf.write_substring(seg.data(), seg.start_offset(), seg.length())
          #|        buf.write_string(new)
          #|        // check if there is no more characters after the last occurrence of `old`
          #|        guard end + old_len <= len else { break }
          #|        let next_view = view.view(start_offset=end + old_len)
          #|        guard next_view.find(old) is Some(next_end) else {
          #|          buf.write_substring(
          #|            next_view.data(),
          #|            next_view.start_offset(),
          #|            next_view.length(),
          #|          )
          #|          break
          #|        }
          #|        continue next_view, next_end
          #|      }
          #|      buf.to_string()
          #|    } else {
          #|      self
          #|    }
          #|  } }
        ),
      ),
      "to_lower": build(
        (
          #|// TODO: deal with non-ascii characters
          #|  guard self.find_by(x => x.is_ascii_uppercase()) is Some(idx) else {
          #|    return self
          #|  }
          #|  let buf = StringBuilder::new(size_hint=self.length())
          #|  let head = self.view(end_offset=idx)
          #|  buf.write_substring(head.data(), head.start_offset(), head.length())
          #|  for c in self.view(start_offset=idx) {
          #|    if c.is_ascii_uppercase() {
          #|      // 'A' is 65 in ASCII, 'a' is 97, the difference is 32
          #|      buf.write_char((c.to_int() + 32).unsafe_to_char())
          #|    } else {
          #|      buf.write_char(c)
          #|    }
          #|  }
          #|  buf.to_string()
        ),
      ),
      "to_lower": build(
        (
          #|// TODO: deal with non-ascii characters
          #|  guard self.find_by(x => x.is_ascii_uppercase()) is Some(idx) else {
          #|    return self
          #|  }
          #|  let buf = StringBuilder::new(size_hint=self.length())
          #|  let head = self.view(end_offset=idx)
          #|  buf.write_substring(head.data(), head.start_offset(), head.length())
          #|  for c in self.view(start_offset=idx) {
          #|    if c.is_ascii_uppercase() {
          #|      // 'A' is 65 in ASCII, 'a' is 97, the difference is 32
          #|      buf.write_char((c.to_int() + 32).unsafe_to_char())
          #|    } else {
          #|      buf.write_char(c)
          #|    }
          #|  }
          #|  buf.to_string()
        ),
      ),
      "to_upper": build(
        (
          #|// TODO: deal with non-ascii characters
          #|  guard self.find_by(_.is_ascii_lowercase()) is Some(idx) else { return self }
          #|  let buf = StringBuilder::new(size_hint=self.length())
          #|  let head = self.view(end_offset=idx)
          #|  buf.write_substring(head.data(), head.start_offset(), head.length())
          #|  for c in self.view(start_offset=idx) {
          #|    if c.is_ascii_lowercase() {
          #|      buf.write_char((c.to_int() - 32).unsafe_to_char())
          #|    } else {
          #|      buf.write_char(c)
          #|    }
          #|  }
          #|  buf.to_string()
        ),
      ),
      "to_upper": build(
        (
          #|// TODO: deal with non-ascii characters
          #|  guard self.find_by(_.is_ascii_lowercase()) is Some(idx) else { return self }
          #|  let buf = StringBuilder::new(size_hint=self.length())
          #|  let head = self.view(end_offset=idx)
          #|  buf.write_substring(head.data(), head.start_offset(), head.length())
          #|  for c in self.view(start_offset=idx) {
          #|    if c.is_ascii_lowercase() {
          #|      buf.write_char((c.to_int() - 32).unsafe_to_char())
          #|    } else {
          #|      buf.write_char(c)
          #|    }
          #|  }
          #|  buf.to_string()
        ),
      ),
      "get": build(
        (
          #|pub fn String::get(self : String, idx : Int) -> Int? { guard idx >= 0 && idx < self.length() else { return None }
          #|  Some(self.unsafe_charcode_at(idx)) }
        ),
      ),
      "get": build(
        (
          #|pub fn View::get(self : View, idx : Int) -> Int? { guard idx >= 0 && idx < self.length() else { return None }
          #|  Some(self.unsafe_charcode_at(idx)) }
        ),
      ),
      "s": String("hello"),
      "s": String("a🤣b"),
      "v": build("\"hello\"[1:-1]"),
      "v": build("\"ab🤣cd\"[1:-1]"),
      "get_char": build(
        (
          #|pub fn String::get_char(self : String, idx : Int) -> Char? { guard idx >= 0 && idx < self.length() else { return None }
          #|  let c = self.unsafe_charcode_at(idx)
          #|  if c.is_leading_surrogate() {
          #|    guard idx + 1 < self.length() else { return None }
          #|    let next = self.unsafe_charcode_at(idx + 1)
          #|    if next.is_trailing_surrogate() {
          #|      Some(code_point_of_surrogate_pair(c, next))
          #|    } else {
          #|      None
          #|    }
          #|  } else if c.is_trailing_surrogate() {
          #|    None
          #|  } else {
          #|    Some(c.unsafe_to_char())
          #|  } }
        ),
      ),
      "get_char": build(
        (
          #|pub fn View::get_char(self : View, idx : Int) -> Char? { guard idx >= 0 && idx < self.length() else { return None }
          #|  let c = self.unsafe_charcode_at(idx)
          #|  if c.is_leading_surrogate() {
          #|    guard idx + 1 < self.length() else { return None }
          #|    let next = self.unsafe_charcode_at(idx + 1)
          #|    if next.is_trailing_surrogate() {
          #|      Some(code_point_of_surrogate_pair(c, next))
          #|    } else {
          #|      None
          #|    }
          #|  } else if c.is_trailing_surrogate() {
          #|    None
          #|  } else {
          #|    Some(c.unsafe_to_char())
          #|  } }
        ),
      ),
      "s": String("hello"),
      "s": String("a🤣b"),
      "s": String("a🤣b"),
      "v": build("s[0:-1]"),
      "v2": build("s[1:3] // Only contains the emoji surrogate pair"),
      "from_array": build(
        (
          #|pub fn String::from_array(chars : Array[Char]) -> String { let buf = StringBuilder::new(size_hint=chars.length() * 4)
          #|  for c in chars {
          #|    buf.write_char(c)
          #|  }
          #|  buf.to_string() }
        ),
      ),
      "from_array": build(
        (
          #|pub fn from_array(chars : Array[Char]) -> String { String::from_array(chars) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn String::from_iter(iter : Iter[Char]) -> String { let chars = iter.collect()
          #|  String::from_array(chars) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn from_iter(iter : Iter[Char]) -> String { let chars = iter.collect()
          #|  String::from_array(chars) }
        ),
      ),
      "len": build("self.length()"),
      "order": build("self"),
      "default": build(
        (
          #|\"\"
        ),
      ),
      "to_bytes": build(
        (
          #|let array = FixedArray::make(self.length() * 2, Byte::default())
          #|  array.blit_from_string(0, self, 0, self.length())
          #|  array |> unsafe_to_bytes
        ),
      ),
      "to_array": build(
        (
          #|self
          #|  .iter()
          #|  .fold(init=Array::new(capacity=self.length()), (rv, c) => {
          #|    rv.push(c)
          #|    rv
          #|  })
        ),
      ),
      "iter": build(
        (
          #|Iter::new(yield_ => {
          #|    let len = self.length()
          #|    for index in 0..<len {
          #|      let c1 = self.unsafe_charcode_at(index)
          #|      if c1.is_leading_surrogate() && index + 1 < len {
          #|        let c2 = self.unsafe_charcode_at(index + 1)
          #|        if c2.is_trailing_surrogate() {
          #|          let c = code_point_of_surrogate_pair(c1, c2)
          #|          guard yield_(c) is IterContinue else { break IterEnd }
          #|          continue index + 2
          #|        }
          #|      }
          #|      //TODO: handle garbage input
          #|      guard yield_(c1.unsafe_to_char()) is IterContinue else { break IterEnd }
          #|    } else {
          #|      IterContinue
          #|    }
          #|  })
        ),
      ),
      "iter2": build(
        (
          #|Iter2::new(yield_ => {
          #|    let len = self.length()
          #|    for index = 0, n = 0; index < len; index = index + 1, n = n + 1 {
          #|      let c1 = self.unsafe_charcode_at(index)
          #|      if c1.is_leading_surrogate() && index + 1 < len {
          #|        let c2 = self.unsafe_charcode_at(index + 1)
          #|        if c2.is_trailing_surrogate() {
          #|          let c = code_point_of_surrogate_pair(c1, c2)
          #|          guard yield_(n, c) is IterContinue else { break IterEnd }
          #|          continue index + 2, n + 1
          #|        }
          #|      }
          #|      //TODO: handle garbage input
          #|      guard yield_(n, c1.unsafe_to_char()) is IterContinue else {
          #|        break IterEnd
          #|      }
          #|    } else {
          #|      IterContinue
          #|    }
          #|  })
        ),
      ),
      "rev_iter": build(
        (
          #|Iter::new(yield_ => {
          #|    let len = self.length()
          #|    for index = len - 1; index >= 0; index = index - 1 {
          #|      let c1 = self.unsafe_charcode_at(index)
          #|      if c1.is_trailing_surrogate() && index - 1 >= 0 {
          #|        let c2 = self.unsafe_charcode_at(index - 1)
          #|        if c2.is_leading_surrogate() {
          #|          let c = code_point_of_surrogate_pair(c2, c1)
          #|          guard yield_(c) is IterContinue else { break IterEnd }
          #|          continue index - 2
          #|        }
          #|      }
          #|      // TODO: handle garbage input
          #|      guard yield_(c1.unsafe_to_char()) is IterContinue else { break IterEnd }
          #|    } else {
          #|      IterContinue
          #|    }
          #|  })
        ),
      ),
      "c": build("self.unsafe_charcode_at(utf16_offset)"),
      "c": build("self.unsafe_charcode_at(utf16_offset - 1)"),
      "end_offset": build(
        "if end_offset is Some(o) { o } else { self.length() }",
      ),
      "end_offset": build(
        "if end_offset is Some(o) { o } else { self.length() }",
      ),
      "c1": build("self.unsafe_charcode_at(index)"),
      "c2": build("self.unsafe_charcode_at(index + 1)"),
      "end_offset": build(
        "if end_offset is Some(o) { o } else { self.length() }",
      ),
      "c1": build("self.unsafe_charcode_at(index)"),
      "c2": build("self.unsafe_charcode_at(index + 1)"),
      "op_get": build(
        (
          #|pub fn View::op_get(self : View, index : Int) -> Int { guard index >= 0 && index < self.length() else {
          #|    abort(\"Index out of bounds\")
          #|  }
          #|  self.str().unsafe_charcode_at(self.start() + index) }
        ),
      ),
      "data": build(
        (
          #|self.str()
        ),
      ),
      "start_offset": build(
        (
          #|self.start()
        ),
      ),
      "length": build(
        (
          #|self.end() - self.start()
        ),
      ),
      "end_offset": build(
        "if end_offset is Some(o) { o } else { self.length() }",
      ),
      "end_offset": build(
        "if end_offset is Some(o) { o } else { self.length() }",
      ),
      "charcodes": build(
        (
          #|pub fn String::charcodes(self : String, start~ : Int = 0, end? : Int) -> View { self.view(start_offset=start, end_offset?=end) }
        ),
      ),
      "charcodes": build(
        (
          #|pub fn View::charcodes(self : View, start~ : Int = 0, end? : Int) -> View { self.view(start_offset=start, end_offset?=end) }
        ),
      ),
      "offset_of_nth_char": build(
        (
          #|pub fn View::offset_of_nth_char(self : View, i : Int) -> Int? { if self
          #|    .str()
          #|    .offset_of_nth_char(i, start_offset=self.start(), end_offset=self.end())
          #|    is Some(index) {
          #|    Some(index - self.start())
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "unsafe_charcode_at": build(
        (
          #|pub fn View::unsafe_charcode_at(self : View, index : Int) -> Int { self.str().unsafe_charcode_at(self.start() + index) }
        ),
      ),
      "char_length": build(
        (
          #|self.str().char_length(start_offset=self.start(), end_offset=self.end())
        ),
      ),
      "char_length_eq": build(
        (
          #|pub fn View::char_length_eq(self : View, len : Int) -> Bool { self
          #|  .str()
          #|  .char_length_eq(len, start_offset=self.start(), end_offset=self.end()) }
        ),
      ),
      "char_length_ge": build(
        (
          #|pub fn View::char_length_ge(self : View, len : Int) -> Bool { self
          #|  .str()
          #|  .char_length_ge(len, start_offset=self.start(), end_offset=self.end()) }
        ),
      ),
      "substr": build(
        "self.str().substring(start=self.start(), end=self.end())",
      ),
      "iter": build(
        (
          #|Iter::new(yield_ => for index in self.start()..<self.end() {
          #|    let c1 = self.str().unsafe_charcode_at(index)
          #|    if c1.is_leading_surrogate() && index + 1 < self.end() {
          #|      let c2 = self.str().unsafe_charcode_at(index + 1)
          #|      if c2.is_trailing_surrogate() {
          #|        let c = code_point_of_surrogate_pair(c1, c2)
          #|        guard yield_(c) is IterContinue else { break IterEnd }
          #|        continue index + 2
          #|      }
          #|    }
          #|    guard yield_(c1.unsafe_to_char()) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  })
        ),
      ),
      "iter2": build(
        (
          #|Iter2::new(yield_ => {
          #|    let len = self.length()
          #|    for index = 0, n = 0; index < len; index = index + 1, n = n + 1 {
          #|      let c1 = self.str().unsafe_charcode_at(self.start() + index)
          #|      if c1.is_leading_surrogate() && index + 1 < len {
          #|        let c2 = self.str().unsafe_charcode_at(self.start() + index + 1)
          #|        if c2.is_trailing_surrogate() {
          #|          let c = code_point_of_surrogate_pair(c1, c2)
          #|          guard yield_(n, c) is IterContinue else { break IterEnd }
          #|          continue index + 2, n + 1
          #|        }
          #|      }
          #|      guard yield_(n, c1.unsafe_to_char()) is IterContinue else {
          #|        break IterEnd
          #|      }
          #|    } else {
          #|      IterContinue
          #|    }
          #|  })
        ),
      ),
      "rev_iter": build(
        (
          #|Iter::new(yield_ => for index = self.end() - 1
          #|                          index >= self.start()
          #|                          index = index - 1 {
          #|    let c1 = self.str().unsafe_charcode_at(index)
          #|    if c1.is_trailing_surrogate() && index - 1 >= 0 {
          #|      let c2 = self.str().unsafe_charcode_at(index - 1)
          #|      if c2.is_leading_surrogate() {
          #|        let c = code_point_of_surrogate_pair(c2, c1)
          #|        guard yield_(c) is IterContinue else { break IterEnd }
          #|        continue index - 2
          #|      }
          #|    }
          #|    guard yield_(c1.unsafe_to_char()) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  })
        ),
      ),
      "len": build("self.length()"),
      "self_len": build("self.length()"),
      "other_len": build("other.length()"),
      "cmp": build("self_len.compare(other_len)"),
      "cmp": build("self"),
      "from_array": build(
        (
          #|pub fn View::from_array(chars : Array[Char]) -> View { // todo: remove .view() in new version
          #|  String::from_array(chars).view() }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn View::from_iter(iter : Iter[Char]) -> View { // todo: remove .view() in new version
          #|  String::from_iter(iter).view() }
        ),
      ),
      "make": build(
        (
          #|pub fn View::make(length : Int, value : Char) -> View { // todo: remove .view() in new version
          #|  String::make(length, value).view() }
        ),
      ),
      "len": build("self.length()"),
      "end": build("match end {"),
      "start": build("if start < 0 { len + start } else { start }"),
      "str_len": build("self.str().length()"),
      "abs_end": build("match end {"),
      "abs_start": build("if start < 0 {"),
    }
  },
)

///|
let test_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/test", fn(
  _env,
  build,
) {
  {
    "a": build("debug_string(a)"),
    "b": build("debug_string(b)"),
    "a": build("debug_string(a)"),
    "b": build("debug_string(b)"),
    "is_true": build(
      (
        #|pub fn is_true(x : Bool, loc~ : SourceLoc) -> Unit raise { if !x {
        #|    let x = debug_string(x)
        #|    fail(\"`\\{x}` is not true\", loc~)
        #|  } }
      ),
    ),
    "is_false": build(
      (
        #|pub fn is_false(x : Bool, loc~ : SourceLoc) -> Unit raise { if x {
        #|    let x = debug_string(x)
        #|    fail(\"`\\{x}` is not false\", loc~)
        #|  } }
      ),
    ),
    "summary": build("@bench.single_bench(f, count~)"),
    "new": build(
      (
        #|pub fn new(name : String) -> T { { name, buffer: StringBuilder::new() } }
      ),
    ),
    "buf": build("StringBuilder::new(size_hint=50)"),
    "a": build("debug_string(a)"),
    "b": build("debug_string(b)"),
    "a": build("debug_string(a)"),
    "b": build("debug_string(b)"),
    "write": build(
      (
        #|pub fn write(self : T, obj : &Show) -> Unit { self.buffer.write_string(obj.to_string()) }
      ),
    ),
    "writeln": build(
      (
        #|pub fn writeln(self : T, obj : &Show) -> Unit { self.write(obj)
        #|  self.buffer.write_char('\\n') }
      ),
    ),
    "loc": build("loc.to_string().escape()"),
    "args_loc": build("args_loc.to_json().escape()"),
    "actual": build("self.buffer.to_string().escape()"),
    "expect": build("filename.escape()"),
  }
})

///|
let tuple_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/tuple",
  fn(_env, build) {
    {
      "r1": build("r0.split()"),
      "r1": build("r0.split()"),
      "r1": build("r0.split()"),
      "r1": build("r0.split()"),
      "r1": build("r0.split()"),
      "r1": build("r0.split()"),
    }
  },
)

///|
let uint_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/uint", fn(
  _env,
  build,
) {
  {
    "to_int64": build(
      (
        #|self.to_uint64().reinterpret_as_int64()
      ),
    ),
    "default": build(
      (
        #|0
      ),
    ),
    "to_be_bytes": build(
      (
        #|[
        #|    (self >> 24).to_byte(),
        #|    (self >> 16).to_byte(),
        #|    (self >> 8).to_byte(),
        #|    self.to_byte(),
        #|  ]
      ),
    ),
    "to_le_bytes": build(
      (
        #|[
        #|    self.to_byte(),
        #|    (self >> 8).to_byte(),
        #|    (self >> 16).to_byte(),
        #|    (self >> 24).to_byte(),
        #|  ]
      ),
    ),
  }
})

///|
let uint16_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/uint16",
  fn(_env, build) {
    {
      "to_uint": build(
        (
          #|self.to_int().reinterpret_as_uint()
        ),
      ),
      "to_uint64": build(
        (
          #|self.to_int().to_uint64()
        ),
      ),
    }
  },
)

///|
let uint64_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/uint64",
  fn(_env, build) {
    {
      "to_be_bytes": build(
        (
          #|[
          #|    (self >> 56).to_byte(),
          #|    (self >> 48).to_byte(),
          #|    (self >> 40).to_byte(),
          #|    (self >> 32).to_byte(),
          #|    (self >> 24).to_byte(),
          #|    (self >> 16).to_byte(),
          #|    (self >> 8).to_byte(),
          #|    self.to_byte(),
          #|  ]
        ),
      ),
      "to_le_bytes": build(
        (
          #|[
          #|    self.to_byte(),
          #|    (self >> 8).to_byte(),
          #|    (self >> 16).to_byte(),
          #|    (self >> 24).to_byte(),
          #|    (self >> 32).to_byte(),
          #|    (self >> 40).to_byte(),
          #|    (self >> 48).to_byte(),
          #|    (self >> 56).to_byte(),
          #|  ]
        ),
      ),
    }
  },
)

///|
let unit_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/unit", fn(
  _env,
  build,
) {
  {
    "to_string": build(
      (
        #|let _ = self
        #|  \"()\"
      ),
    ),
    "_": build("self"),
    "_": build("self"),
    "default": build(
      (
        #|()
      ),
    ),
  }
})
