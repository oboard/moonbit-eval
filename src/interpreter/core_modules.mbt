///|
/// Auto-generated core modules for moonbit-eval interpreter
/// This file contains embedded RuntimeModule definitions for all moonbitlang/core modules

///|
let core_modules : Map[String, RuntimeModule] = {
  "moonbitlang/core/abort": moonbitlang_core_abort_module,
  "moonbitlang/core/array": moonbitlang_core_array_module,
  "moonbitlang/core/bench": moonbitlang_core_bench_module,
  "moonbitlang/core/bigint": moonbitlang_core_bigint_module,
  "moonbitlang/core/bool": moonbitlang_core_bool_module,
  "moonbitlang/core/buffer": moonbitlang_core_buffer_module,
  "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
  "moonbitlang/core/byte": moonbitlang_core_byte_module,
  "moonbitlang/core/bytes": moonbitlang_core_bytes_module,
  "moonbitlang/core/char": moonbitlang_core_char_module,
  "moonbitlang/core/cmp": moonbitlang_core_cmp_module,
  "moonbitlang/core/deque": moonbitlang_core_deque_module,
  "moonbitlang/core/double": moonbitlang_core_double_module,
  "moonbitlang/core/double/internal/ryu": moonbitlang_core_double_internal_ryu_module,
  "moonbitlang/core/env": moonbitlang_core_env_module,
  "moonbitlang/core/float": moonbitlang_core_float_module,
  "moonbitlang/core/hashmap": moonbitlang_core_hashmap_module,
  "moonbitlang/core/hashset": moonbitlang_core_hashset_module,
  "moonbitlang/core/immut/array": moonbitlang_core_immut_array_module,
  "moonbitlang/core/immut/hashmap": moonbitlang_core_immut_hashmap_module,
  "moonbitlang/core/immut/hashset": moonbitlang_core_immut_hashset_module,
  "moonbitlang/core/immut/internal/path": moonbitlang_core_immut_internal_path_module,
  "moonbitlang/core/immut/internal/sparse_array": moonbitlang_core_immut_internal_sparse_array_module,
  "moonbitlang/core/immut/list": moonbitlang_core_immut_list_module,
  "moonbitlang/core/immut/priority_queue": moonbitlang_core_immut_priority_queue_module,
  "moonbitlang/core/immut/sorted_map": moonbitlang_core_immut_sorted_map_module,
  "moonbitlang/core/immut/sorted_set": moonbitlang_core_immut_sorted_set_module,
  "moonbitlang/core/int": moonbitlang_core_int_module,
  "moonbitlang/core/int16": moonbitlang_core_int16_module,
  "moonbitlang/core/int64": moonbitlang_core_int64_module,
  "moonbitlang/core/json": moonbitlang_core_json_module,
  "moonbitlang/core/list": moonbitlang_core_list_module,
  "moonbitlang/core/math": moonbitlang_core_math_module,
  "moonbitlang/core/option": moonbitlang_core_option_module,
  "moonbitlang/core/prelude": moonbitlang_core_prelude_module,
  "moonbitlang/core/priority_queue": moonbitlang_core_priority_queue_module,
  "moonbitlang/core/queue": moonbitlang_core_queue_module,
  "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
  "moonbitlang/core/quickcheck/splitmix": moonbitlang_core_quickcheck_splitmix_module,
  "moonbitlang/core/random": moonbitlang_core_random_module,
  "moonbitlang/core/random/internal/random_source": moonbitlang_core_random_internal_random_source_module,
  "moonbitlang/core/rational": moonbitlang_core_rational_module,
  "moonbitlang/core/ref": moonbitlang_core_ref_module,
  "moonbitlang/core/result": moonbitlang_core_result_module,
  "moonbitlang/core/set": moonbitlang_core_set_module,
  "moonbitlang/core/sorted_map": moonbitlang_core_sorted_map_module,
  "moonbitlang/core/sorted_set": moonbitlang_core_sorted_set_module,
  "moonbitlang/core/strconv": moonbitlang_core_strconv_module,
  "moonbitlang/core/string": moonbitlang_core_string_module,
  "moonbitlang/core/test": moonbitlang_core_test_module,
  "moonbitlang/core/tuple": moonbitlang_core_tuple_module,
  "moonbitlang/core/uint": moonbitlang_core_uint_module,
  "moonbitlang/core/uint16": moonbitlang_core_uint16_module,
  "moonbitlang/core/uint64": moonbitlang_core_uint64_module,
  "moonbitlang/core/unit": moonbitlang_core_unit_module,
}

///|
fn dummy_loc() -> @basic.Location {
  {
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
}

///|
let moonbitlang_core_abort_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/abort",
  deps={},
  fn(_env, build) {
    {
      "abort": build(
        (
          #|pub fn[T] abort(msg : String) -> T { let _ = msg
          #|  panic_impl() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_array_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/array",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/bytes": moonbitlang_core_bytes_module,
    "moonbitlang/core/string": moonbitlang_core_string_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/quickcheck/splitmix": moonbitlang_core_quickcheck_splitmix_module,
  },
  fn(_env, build) {
    {
      "copy": build(
        (
          #|pub fn[T] FixedArray::copy(self : FixedArray[T]) -> FixedArray[T] { let len = self.length()
          #|  if len == 0 {
          #|    []
          #|  } else {
          #|    let arr = FixedArray::make(len, self[0])
          #|    FixedArray::unsafe_blit(arr, 0, self, 0, len)
          #|    arr
          #|  } }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[T] Array::from_iter(iter : Iter[T]) -> Array[T] { iter.collect() }
        ),
      ),
      "push_iter": build(
        (
          #|pub fn[T] Array::push_iter(self : Self[T], iter : Iter[T]) -> Unit { for x in iter {
          #|    self.push(x)
          #|  } }
        ),
      ),
      "shuffle_in_place": build(
        (
          #|pub fn[T] shuffle_in_place(self : Array[T], rand~ : (Int) -> Int) -> Unit { let n = self.length()
          #|  for i = n - 1; i > 0; i = i - 1 {
          #|    let j = rand(i + 1) % (i + 1)
          #|    // for safety, perf is not a concern here
          #|    // TODO: maybe return an error later
          #|    self.swap(i, j)
          #|  } }
        ),
      ),
      "shuffle": build(
        (
          #|pub fn[T] shuffle(self : Array[T], rand~ : (Int) -> Int) -> Array[T] { let new_arr = self.copy()
          #|  Array::shuffle_in_place(new_arr, rand~)
          #|  new_arr }
        ),
      ),
      "last": build(
        (
          #|pub fn[A] last(self : Array[A]) -> A? { match self {
          #|    [] => None
          #|    [.., last] => Some(last)
          #|  } }
        ),
      ),
      "zip": build(
        (
          #|pub fn[A, B] zip(self : Array[A], other : Array[B]) -> Array[(A, B)] { let length = if self.length() < other.length() {
          #|    self.length()
          #|  } else {
          #|    other.length()
          #|  }
          #|  let arr = Array::new(capacity=length)
          #|  for i in 0..<length {
          #|    arr.push((self[i], other[i]))
          #|  } else {
          #|    return arr
          #|  } }
        ),
      ),
      "unzip": build(
        (
          #|pub fn[T1, T2] unzip(self : Array[(T1, T2)]) -> (Array[T1], Array[T2]) { let arr1 : Array[T1] = Array::new(capacity=self.length())
          #|  let arr2 : Array[T2] = Array::new(capacity=self.length())
          #|  for pair in self {
          #|    let (x, y) = pair
          #|    arr1.push(x)
          #|    arr2.push(y)
          #|  }
          #|  (arr1, arr2) }
        ),
      ),
      "zip_to_iter2": build(
        (
          #|pub fn[A, B] zip_to_iter2(self : Array[A], other : Array[B]) -> Iter2[A, B] { Iter2::new(yield_ => {
          #|    let length = if self.length() < other.length() {
          #|      self.length()
          #|    } else {
          #|      other.length()
          #|    }
          #|    for i in 0..<length {
          #|      if yield_(self[i], other[i]) == IterEnd {
          #|        break IterEnd
          #|      }
          #|    } else {
          #|      IterContinue
          #|    }
          #|  }) }
        ),
      ),
      "join": build(
        (
          #|pub fn join(self : Array[String], separator : @string.View) -> String { self[:].join(separator) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[T] FixedArray::from_array(array : Array[T]) -> FixedArray[T] { FixedArray::makei(array.length(), i => array[i]) }
        ),
      ),
      "rev_inplace": build(
        (
          #|pub fn[T] FixedArray::rev_inplace(self : FixedArray[T]) -> Unit { let mid_len = self.length() / 2
          #|  for i in 0..<mid_len {
          #|    let j = self.length() - i - 1
          #|    let temp = self[i]
          #|    self[i] = self[j]
          #|    self[j] = temp
          #|  } }
        ),
      ),
      "rev": build(
        (
          #|pub fn[T] FixedArray::rev(self : FixedArray[T]) -> FixedArray[T] { match self {
          #|    [] => []
          #|    [.., first] => {
          #|      let res = FixedArray::make(self.length(), first)
          #|      let len = self.length()
          #|      for i in 1..<len {
          #|        res[i] = self[len - 1 - i]
          #|      }
          #|      res
          #|    }
          #|  } }
        ),
      ),
      "swap": build(
        (
          #|pub fn[T] FixedArray::swap(self : FixedArray[T], i : Int, j : Int) -> Unit { let temp = self[i]
          #|  self[i] = self[j]
          #|  self[j] = temp }
        ),
      ),
      "search": build(
        (
          #|pub fn[T : Eq] FixedArray::search(self : FixedArray[T], value : T) -> Int? { for i in 0..<self.length() {
          #|    if self[i] == value {
          #|      return Some(i)
          #|    }
          #|  }
          #|  None }
        ),
      ),
      "contains": build(
        (
          #|pub fn[T : Eq] FixedArray::contains(self : FixedArray[T], value : T) -> Bool { for i in 0..<self.length() {
          #|    if self[i] == value {
          #|      return true
          #|    }
          #|  }
          #|  false }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[T] FixedArray::from_iter(iter : Iter[T]) -> FixedArray[T] { FixedArray::from_array(iter.collect()) }
        ),
      ),
      "last": build(
        (
          #|pub fn[A] FixedArray::last(self : FixedArray[A]) -> A? { match self {
          #|    [] => None
          #|    [.., last] => Some(last)
          #|  } }
        ),
      ),
      "sort_by_key": build(
        (
          #|pub fn[T, K : Compare] sort_by_key(self : Array[T], map : (T) -> K) -> Unit { quick_sort_by(
          #|    self[:],
          #|    (a, b) => map(a).compare(map(b)),
          #|    None,
          #|    get_limit(self.length()),
          #|  ) }
        ),
      ),
      "sort_by": build(
        (
          #|pub fn[T] sort_by(self : Array[T], cmp : (T, T) -> Int) -> Unit { quick_sort_by(self[:], cmp, None, get_limit(self.length())) }
        ),
      ),
      "try_bubble_sort_by": build(
        (
          #|fn[T] try_bubble_sort_by(arr : ArrayView[T], cmp : (T, T) -> Int) -> Bool { let max_tries = 8
          #|  let mut tries = 0
          #|  for i in 1..<arr.length() {
          #|    let mut sorted = true
          #|    for j = i; j > 0 && cmp(arr[j - 1], arr[j]) > 0; j = j - 1 {
          #|      sorted = false
          #|      arr.swap(j, j - 1)
          #|    }
          #|    if !sorted {
          #|      tries += 1
          #|      if tries > max_tries {
          #|        return false
          #|      }
          #|    }
          #|  }
          #|  true }
        ),
      ),
      "bubble_sort_by": build(
        (
          #|fn[T] bubble_sort_by(arr : ArrayView[T], cmp : (T, T) -> Int) -> Unit { for i in 1..<arr.length() {
          #|    for j = i; j > 0 && cmp(arr[j - 1], arr[j]) > 0; j = j - 1 {
          #|      arr.swap(j, j - 1)
          #|    }
          #|  } }
        ),
      ),
      "choose_pivot_by": build(
        (
          #|fn[T] choose_pivot_by(arr : ArrayView[T], cmp : (T, T) -> Int) -> (Int, Bool) { let len = arr.length()
          #|  let use_median_of_medians = 50
          #|  let max_swaps = 4 * 3
          #|  let mut swaps = 0
          #|  let b = len / 4 * 2
          #|  if len >= 8 {
          #|    let a = len / 4 * 1
          #|    let c = len / 4 * 3
          #|    let sort_2 = (a : Int, b : Int) => if cmp(arr[a], arr[b]) > 0 {
          #|      arr.swap(a, b)
          #|      swaps += 1
          #|    }
          #|    let sort_3 = (a : Int, b : Int, c : Int) => {
          #|      sort_2(a, b)
          #|      sort_2(b, c)
          #|      sort_2(a, b)
          #|    }
          #|    if len > use_median_of_medians {
          #|      sort_3(a - 1, a, a + 1)
          #|      sort_3(b - 1, b, b + 1)
          #|      sort_3(c - 1, c, c + 1)
          #|    }
          #|    sort_3(a, b, c)
          #|  }
          #|  if swaps == max_swaps {
          #|    arr.rev_inplace()
          #|    (len - b - 1, true)
          #|  } else {
          #|    (b, swaps == 0)
          #|  } }
        ),
      ),
      "heap_sort_by": build(
        (
          #|fn[T] heap_sort_by(arr : ArrayView[T], cmp : (T, T) -> Int) -> Unit { let len = arr.length()
          #|  for i = len / 2 - 1; i >= 0; i = i - 1 {
          #|    sift_down_by(arr, i, cmp)
          #|  }
          #|  for i = len - 1; i > 0; i = i - 1 {
          #|    arr.swap(0, i)
          #|    sift_down_by(arr[0:i], 0, cmp)
          #|  } }
        ),
      ),
      "fixed_heap_sort_by": build(
        (
          #|fn[T] fixed_heap_sort_by(arr : FixedArraySlice[T], cmp : (T, T) -> Int) -> Unit { let len = arr.length()
          #|  for i = len / 2 - 1; i >= 0; i = i - 1 {
          #|    fixed_sift_down_by(arr, i, cmp)
          #|  }
          #|  for i = len - 1; i > 0; i = i - 1 {
          #|    arr.swap(0, i)
          #|    fixed_sift_down_by(arr.slice(0, i), 0, cmp)
          #|  } }
        ),
      ),
      "copy": build(
        (
          #|pub fn[T] copy(self : Array[T]) -> Array[T] { let len = self.length()
          #|  if len == 0 {
          #|    []
          #|  } else {
          #|    let arr = Array::make(len, self[0])
          #|    Array::unsafe_blit(arr, 0, self, 0, len)
          #|    arr
          #|  } }
        ),
      ),
      "copy": build(
        (
          #|pub fn[T] FixedArray::copy(self : FixedArray[T]) -> FixedArray[T] { JSArray::ofAnyFixedArray(self).copy().toAnyFixedArray() }
        ),
      ),
      "copy": build(
        (
          #|pub fn[T] copy(self : Array[T]) -> Array[T] { JSArray::ofAnyArray(self).copy().toAnyArray() }
        ),
      ),
      "stable_sort": build(
        (
          #|pub fn[T : Compare] FixedArray::stable_sort(self : FixedArray[T]) -> Unit { timsort({ array: self, start: 0, end: self.length() }) }
        ),
      ),
      "timsort": build(
        (
          #|fn[T : Compare] timsort(arr : FixedArraySlice[T]) -> Unit { // Slices of up to this length get sorted using insertion sort.
          #|  let max_insertion = 20
          #|  // Short arrays get sorted in-place via insertion sort to avoid allocations.
          #|  let len = arr.length()
          #|  if len <= max_insertion {
          #|    FixedArraySlice::insertion_sort(arr)
          #|  }
          #|  let mut end = 0
          #|  let mut start = 0
          #|  let runs : Array[TimSortRun] = []
          #|  while end < len {
          #|    let (streak_end, was_reversed) = find_streak(arr.slice(start, arr.end))
          #|    end += streak_end
          #|    if was_reversed {
          #|      arr.slice(start, end).rev_inplace()
          #|    }
          #|    // Insert some more elements into the run if it's too short. Insertion sort is faster than
          #|    // merge sort on short sequences, so this significantly improves performance.
          #|    end = provide_sorted_batch(arr, start, end)
          #|    runs.push({ start, len: end - start })
          #|    start = end
          #|    while true {
          #|      guard collapse(runs, len) is Some(r) else { break }
          #|      let left = runs[r]
          #|      let right = runs[r + 1]
          #|      merge(arr.slice(left.start, right.start + right.len), left.len)
          #|      runs[r + 1] = { start: left.start, len: left.len + right.len }
          #|      runs.remove(r) |> ignore
          #|    }
          #|  } }
        ),
      ),
      "merge": build(
        (
          #|fn[T : Compare] merge(arr : FixedArraySlice[T], mid : Int) -> Unit { let buf_len = arr.length() - mid
          #|  let buf : FixedArray[T] = FixedArray::make(buf_len, arr[mid])
          #|  for i in 0..<buf.length() {
          #|    buf[i] = arr[mid + i]
          #|  }
          #|  let buf = { array: buf, start: 0, end: buf_len }
          #|  let buf_remaining = for p1 = mid - 1, p2 = buf_len - 1, p = mid + buf_len - 1; p1 >=
          #|                         0 &&
          #|                         p2 >= 0; {
          #|    if arr[p1] > buf[p2] {
          #|      arr[p] = arr[p1]
          #|      continue p1 - 1, p2, p - 1
          #|    } else {
          #|      arr[p] = buf[p2]
          #|      continue p1, p2 - 1, p - 1
          #|    }
          #|  } else {
          #|    p2
          #|  }
          #|  for i = buf_remaining; i >= 0; i = i - 1 {
          #|    arr[i] = buf[i]
          #|  } }
        ),
      ),
      "find_streak": build(
        (
          #|fn[T : Compare] find_streak(arr : FixedArraySlice[T]) -> (Int, Bool) { let len = arr.length()
          #|  if len < 2 {
          #|    return (len, false)
          #|  }
          #|  let assume_reverse = arr[1] < arr[0]
          #|  if assume_reverse {
          #|    for end = 2 {
          #|      if end < len && arr[end] < arr[end - 1] {
          #|        continue end + 1
          #|      } else {
          #|        break (end, true)
          #|      }
          #|    }
          #|  } else {
          #|    for end = 2 {
          #|      if end < len && arr[end] >= arr[end - 1] {
          #|        continue end + 1
          #|      } else {
          #|        break (end, false)
          #|      }
          #|    }
          #|  } }
        ),
      ),
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
      "sort": build(
        (
          #|pub fn[T : Compare] FixedArray::sort(self : FixedArray[T]) -> Unit { fixed_quick_sort(
          #|    { array: self, start: 0, end: self.length() },
          #|    None,
          #|    fixed_get_limit(self.length()),
          #|  ) }
        ),
      ),
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
      "fixed_try_bubble_sort": build(
        (
          #|fn[T : Compare] fixed_try_bubble_sort(arr : FixedArraySlice[T]) -> Bool { let max_tries = 8
          #|  let mut tries = 0
          #|  for i in 1..<arr.length() {
          #|    let mut sorted = true
          #|    for j = i; j > 0 && arr[j - 1] > arr[j]; j = j - 1 {
          #|      sorted = false
          #|      arr.swap(j, j - 1)
          #|    }
          #|    if !sorted {
          #|      tries += 1
          #|      if tries > max_tries {
          #|        return false
          #|      }
          #|    }
          #|  }
          #|  true }
        ),
      ),
      "fixed_bubble_sort": build(
        (
          #|fn[T : Compare] fixed_bubble_sort(arr : FixedArraySlice[T]) -> Unit { for i in 1..<arr.length() {
          #|    for j = i; j > 0 && arr[j - 1] > arr[j]; j = j - 1 {
          #|      arr.swap(j, j - 1)
          #|    }
          #|  } }
        ),
      ),
      "fixed_choose_pivot": build(
        (
          #|fn[T : Compare] fixed_choose_pivot(arr : FixedArraySlice[T]) -> (Int, Bool) { let len = arr.length()
          #|  let use_median_of_medians = 50
          #|  let max_swaps = 4 * 3
          #|  let mut swaps = 0
          #|  let b = len / 4 * 2
          #|  if len >= 8 {
          #|    let a = len / 4 * 1
          #|    let c = len / 4 * 3
          #|    let sort_2 = (a : Int, b : Int) => if arr[a] > arr[b] {
          #|      arr.swap(a, b)
          #|      swaps += 1
          #|    }
          #|    let sort_3 = (a : Int, b : Int, c : Int) => {
          #|      sort_2(a, b)
          #|      sort_2(b, c)
          #|      sort_2(a, b)
          #|    }
          #|    if len > use_median_of_medians {
          #|      sort_3(a - 1, a, a + 1)
          #|      sort_3(b - 1, b, b + 1)
          #|      sort_3(c - 1, c, c + 1)
          #|    }
          #|    sort_3(a, b, c)
          #|  }
          #|  if swaps == max_swaps {
          #|    arr.rev_inplace()
          #|    (len - b - 1, true)
          #|  } else {
          #|    (b, swaps == 0)
          #|  } }
        ),
      ),
      "fixed_heap_sort": build(
        (
          #|fn[T : Compare] fixed_heap_sort(arr : FixedArraySlice[T]) -> Unit { let len = arr.length()
          #|  for i = len / 2 - 1; i >= 0; i = i - 1 {
          #|    fixed_sift_down(arr, i)
          #|  }
          #|  for i = len - 1; i > 0; i = i - 1 {
          #|    arr.swap(0, i)
          #|    fixed_sift_down(arr.slice(0, i), 0)
          #|  } }
        ),
      ),
      "fixed_sift_down": build(
        (
          #|fn[T : Compare] fixed_sift_down(arr : FixedArraySlice[T], index : Int) -> Unit { let mut index = index
          #|  let len = arr.length()
          #|  let mut child = index * 2 + 1
          #|  while child < len {
          #|    if child + 1 < len && arr[child] < arr[child + 1] {
          #|      child = child + 1
          #|    }
          #|    if arr[index] >= arr[child] {
          #|      return
          #|    }
          #|    arr.swap(index, child)
          #|    index = child
          #|    child = index * 2 + 1
          #|  } }
        ),
      ),
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
      "is_sorted": build(
        (
          #|pub fn[T : Compare] FixedArray::is_sorted(arr : FixedArray[T]) -> Bool { for i in 1..<arr.length() {
          #|    if arr[i] < arr[i - 1] {
          #|      break false
          #|    }
          #|  } else {
          #|    true
          #|  } }
        ),
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
      "rev_inplace": build(
        (
          #|pub fn[T] View::rev_inplace(self : View[T]) -> Unit { let mid_len = self.length() / 2
          #|  for i in 0..<mid_len {
          #|    let j = self.length() - i - 1
          #|    self.swap(i, j)
          #|  } }
        ),
      ),
      "each": build(
        (
          #|pub fn[T] View::each(self : View[T], f : (T) -> Unit raise?) -> Unit raise? { for v in self {
          #|    f(v)
          #|  } }
        ),
      ),
      "all": build(
        (
          #|pub fn[T] View::all(self : View[T], f : (T) -> Bool raise?) -> Bool raise? { for v in self {
          #|    if !f(v) {
          #|      return false
          #|    }
          #|  }
          #|  true }
        ),
      ),
      "any": build(
        (
          #|pub fn[T] View::any(self : View[T], f : (T) -> Bool raise?) -> Bool raise? { for v in self {
          #|    if f(v) {
          #|      return true
          #|    }
          #|  }
          #|  false }
        ),
      ),
      "contains": build(
        (
          #|pub fn[T : Eq] View::contains(self : View[T], value : T) -> Bool { for v in self {
          #|    if v == value {
          #|      break true
          #|    }
          #|  } else {
          #|    false
          #|  } }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A] View::iter(self : View[A]) -> Iter[A] { Iter::new(yield_ => for v in self {
          #|    guard yield_(v) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[A] View::iter2(self : View[A]) -> Iter2[Int, A] { Iter2::new(yield_ => for i, v in self {
          #|    guard yield_(i, v) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "map": build(
        (
          #|pub fn[T, U] View::map(self : View[T], f : (T) -> U raise?) -> Array[U] raise? { if self.length() == 0 {
          #|    return []
          #|  }
          #|  Array::makei(self.length(), i => f(self[i])) }
        ),
      ),
      "map_inplace": build(
        (
          #|pub fn[T] View::map_inplace(self : View[T], f : (T) -> T raise?) -> Unit raise? { for i, v in self {
          #|    self[i] = f(v)
          #|  } }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[T] View::to_array(self : View[T]) -> Array[T] { let len = self.length()
          #|  if len == 0 {
          #|    []
          #|  } else {
          #|    let arr = Array::make(len, self[0])
          #|    for i, v in self {
          #|      arr[i] = v
          #|    }
          #|    arr
          #|  } }
        ),
      ),
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
      "sort": build(
        (
          #|pub fn[T : Compare] sort(self : Array[T]) -> Unit { let len = self.length()
          #|  quick_sort(self[:len], None, get_limit(len)) }
        ),
      ),
      "quick_sort": build(
        (
          #|fn[T : Compare] quick_sort(arr : ArrayView[T], pred : T?, limit : Int) -> Unit { let mut limit = limit
          #|  let mut arr = arr
          #|  let mut pred = pred
          #|  let mut was_partitioned = true
          #|  let mut balanced = true
          #|  let insertion_sort_len = 16
          #|  while true {
          #|    let len = arr.length()
          #|    if len <= insertion_sort_len {
          #|      if len >= 2 {
          #|        ArrayView::insertion_sort(arr)
          #|      }
          #|      return
          #|    }
          #|    // Too many imbalanced partitions may lead to O(n^2) performance in quick sort.
          #|    // If the limit is reached, use heap sort to ensure O(n log n) performance.
          #|    if limit == 0 {
          #|      heap_sort(arr)
          #|      return
          #|    }
          #|    let (pivot_index, likely_sorted) = choose_pivot(arr)
          #|    // Try bubble sort if the array is likely already sorted.
          #|    if was_partitioned && balanced && likely_sorted {
          #|      if try_bubble_sort(arr) {
          #|        return
          #|      }
          #|    }
          #|    let (pivot, partitioned) = partition(arr, pivot_index)
          #|    was_partitioned = partitioned
          #|    balanced = minimum(pivot, len - pivot) >= len / 8
          #|    if !balanced {
          #|      limit -= 1
          #|    }
          #|    if pred is Some(pred) {
          #|      // pred is less than all elements in arr
          #|      // If pivot equals to pred, then we can skip all elements that are equal to pred.
          #|      if pred == arr[pivot] {
          #|        let mut i = pivot
          #|        while i < len && pred == arr[i] {
          #|          i = i + 1
          #|        }
          #|        arr = arr[i:len]
          #|        continue
          #|      }
          #|    }
          #|    let left = arr[0:pivot]
          #|    let right = arr[pivot + 1:len]
          #|    // Reduce the stack depth by only call quick_sort on the smaller partition.
          #|    if left.length() < right.length() {
          #|      quick_sort(left, pred, limit)
          #|      pred = Some(arr[pivot])
          #|      arr = right
          #|    } else {
          #|      quick_sort(right, Some(arr[pivot]), limit)
          #|      arr = left
          #|    }
          #|  } }
        ),
      ),
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
      "try_bubble_sort": build(
        (
          #|fn[T : Compare] try_bubble_sort(arr : ArrayView[T]) -> Bool { let max_tries = 8
          #|  let mut tries = 0
          #|  for i in 1..<arr.length() {
          #|    let mut sorted = true
          #|    for j = i; j > 0 && arr[j - 1] > arr[j]; j = j - 1 {
          #|      sorted = false
          #|      arr.swap(j, j - 1)
          #|    }
          #|    if !sorted {
          #|      tries += 1
          #|      if tries > max_tries {
          #|        return false
          #|      }
          #|    }
          #|  }
          #|  true }
        ),
      ),
      "insertion_sort": build(
        (
          #|fn[T : Compare] ArrayView::insertion_sort(arr : ArrayView[T]) -> Unit { for i in 1..<arr.length() {
          #|    for j = i; j > 0 && arr[j - 1] > arr[j]; j = j - 1 {
          #|      arr.swap(j, j - 1)
          #|    }
          #|  } }
        ),
      ),
      "partition": build(
        (
          #|fn[T : Compare] partition(arr : ArrayView[T], pivot_index : Int) -> (Int, Bool) { arr.swap(pivot_index, arr.length() - 1)
          #|  let pivot = arr[arr.length() - 1]
          #|  let mut i = 0
          #|  let mut partitioned = true
          #|  for j in 0..<(arr.length() - 1) {
          #|    if arr[j] < pivot {
          #|      if i != j {
          #|        arr.swap(i, j)
          #|        partitioned = false
          #|      }
          #|      i = i + 1
          #|    }
          #|  }
          #|  arr.swap(i, arr.length() - 1)
          #|  (i, partitioned) }
        ),
      ),
      "choose_pivot": build(
        (
          #|fn[T : Compare] choose_pivot(arr : ArrayView[T]) -> (Int, Bool) { let len = arr.length()
          #|  let use_median_of_medians = 50
          #|  let max_swaps = 4 * 3
          #|  let mut swaps = 0
          #|  let b = len / 4 * 2
          #|  if len >= 8 {
          #|    let a = len / 4 * 1
          #|    let c = len / 4 * 3
          #|    let sort_2 = (a : Int, b : Int) => if arr[a] > arr[b] {
          #|      arr.swap(a, b)
          #|      swaps += 1
          #|    }
          #|    let sort_3 = (a : Int, b : Int, c : Int) => {
          #|      sort_2(a, b)
          #|      sort_2(b, c)
          #|      sort_2(a, b)
          #|    }
          #|    if len > use_median_of_medians {
          #|      sort_3(a - 1, a, a + 1)
          #|      sort_3(b - 1, b, b + 1)
          #|      sort_3(c - 1, c, c + 1)
          #|    }
          #|    sort_3(a, b, c)
          #|  }
          #|  if swaps == max_swaps {
          #|    arr.rev_inplace()
          #|    (len - b - 1, true)
          #|  } else {
          #|    (b, swaps == 0)
          #|  } }
        ),
      ),
      "heap_sort": build(
        (
          #|fn[T : Compare] heap_sort(arr : ArrayView[T]) -> Unit { let len = arr.length()
          #|  for i = len / 2 - 1; i >= 0; i = i - 1 {
          #|    sift_down(arr, i)
          #|  }
          #|  for i = len - 1; i > 0; i = i - 1 {
          #|    arr.swap(0, i)
          #|    sift_down(arr[0:i], 0)
          #|  } }
        ),
      ),
      "sift_down": build(
        (
          #|fn[T : Compare] sift_down(arr : ArrayView[T], index : Int) -> Unit { let mut index = index
          #|  let len = arr.length()
          #|  let mut child = index * 2 + 1
          #|  while child < len {
          #|    if child + 1 < len && arr[child] < arr[child + 1] {
          #|      child = child + 1
          #|    }
          #|    if arr[index] >= arr[child] {
          #|      return
          #|    }
          #|    arr.swap(index, child)
          #|    index = child
          #|    child = index * 2 + 1
          #|  } }
        ),
      ),
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
      "length": build(
        (
          #|fn[T] FixedArraySlice::length(self : FixedArraySlice[T]) -> Int { self.end - self.start }
        ),
      ),
      "op_get": build(
        (
          #|fn[T] FixedArraySlice::op_get(self : FixedArraySlice[T], index : Int) -> T { self.array[self.start + index] }
        ),
      ),
      "rev_inplace": build(
        (
          #|fn[T] FixedArraySlice::rev_inplace(self : FixedArraySlice[T]) -> Unit { let len = self.length()
          #|  let mid_len = len / 2
          #|  for i in 0..<mid_len {
          #|    let j = len - i - 1
          #|    self.swap(i, j)
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_bench_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bench",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/double": moonbitlang_core_double_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
  },
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
      "keep": build(
        (
          #|pub fn[Any] keep(self : T, value : Any) -> Unit { let trait_object : &OpaqueValue = value
          #|  self._storage = trait_object }
        ),
      ),
      "dump_summaries": build(
        (
          #|pub fn dump_summaries(self : T) -> String { \"[\\{self.buffer.to_string()}]\" }
        ),
      ),
      "monotonic_clock_end": build(
        (
          #|pub fn monotonic_clock_end(ts : Timestamp) -> Double { let elapsed_secs : Double = instant_elapsed_as_secs_f64(ts)
          #|  elapsed_secs * 1000000.0 }
        ),
      ),
      "new": build(
        (
          #|pub fn new() -> T { let buffer = StringBuilder::new()
          #|  let summaries = Array::new()
          #|  { buffer, summaries, _storage: () } }
        ),
      ),
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
    }
  },
)

///|
let moonbitlang_core_bigint_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bigint",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/char": moonbitlang_core_char_module,
    "moonbitlang/core/uint": moonbitlang_core_uint_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/quickcheck/splitmix": moonbitlang_core_quickcheck_splitmix_module,
    "moonbitlang/core/string": moonbitlang_core_string_module,
  },
  fn(_env, build) {
    {
      "radix_bit_len": (None, Int(32)),
      "decimal_ratio": (None, String("0.302 // log10(2)")),
      "karatsuba_threshold": (None, Int(50)),
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
      "is_zero": build(
        (
          #|pub fn BigInt::is_zero(self : BigInt) -> Bool { self.len == 1 && self.limbs[0] == 0 }
        ),
      ),
      "to_string": build(
        (
          #|pub fn BigInt::to_string(self : BigInt) -> String { // This function first converts the BigInt to a decimal representation, with a radix of 2^(`decimal_radix_bit_len`).
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
          #|  s + ret }
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
          #|fn BigInt::copy(self : BigInt) -> BigInt { let new_limbs = FixedArray::make(self.len, 0U)
          #|  new_limbs.unsafe_blit(0, self.limbs, 0, self.len)
          #|  { limbs: new_limbs, sign: self.sign, len: self.len } }
        ),
      ),
      "max": build(
        (
          #|fn[T : Compare] max(a : T, b : T) -> T { if a > b {
          #|    a
          #|  } else {
          #|    b
          #|  } }
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
      "to_int": build(
        (
          #|pub fn BigInt::to_int(self : BigInt) -> Int { self.to_uint().reinterpret_as_int() }
        ),
      ),
      "to_uint": build(
        (
          #|pub fn BigInt::to_uint(self : BigInt) -> UInt { let value = if self.sign == Negative { (1N << 32) + self } else { self }
          #|  value.limbs[0] }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn BigInt::to_int64(self : BigInt) -> Int64 { self.to_uint64().reinterpret_as_int64() }
        ),
      ),
      "to_uint64": build(
        (
          #|pub fn BigInt::to_uint64(self : BigInt) -> UInt64 { let value = if self.sign == Negative { (1N << 64) + self } else { self }
          #|  let len = 64 / radix_bit_len
          #|  let len = if value.len < len { value.len } else { len }
          #|  let mut result = 0UL
          #|  for i = len - 1; i >= 0; i = i - 1 {
          #|    result = result << radix_bit_len
          #|    result = result | (value.limbs[i].to_uint64() & radix_mask)
          #|  }
          #|  result }
        ),
      ),
      "bit_length": build(
        (
          #|pub fn BigInt::bit_length(self : BigInt) -> Int { if self.len == 0 {
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
          #|  bit_length }
        ),
      ),
      "ctz": build(
        (
          #|pub fn BigInt::ctz(self : BigInt) -> Int { if self.is_zero() {
          #|    return 0
          #|  }
          #|  // Find first non-zero limb
          #|  let mut i = 0
          #|  while i < self.len && self.limbs[i] == 0 {
          #|    i = i + 1
          #|  }
          #|  radix_bit_len * i + self.limbs[i].ctz() }
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
          #|fn BigInt::limbs(self : Self) -> Iter[UInt] { self.limbs.iter().take(self.len) }
        ),
      ),
      "zero": (None, BigInt(0N)),
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
          #|pub fn BigInt::to_uint64(self : BigInt) -> UInt64 { let hi = (self >> 32).to_uint()
          #|  let lo = self.to_uint()
          #|  (hi.to_uint64() << 32) | lo.to_uint64() }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn BigInt::to_int64(self : BigInt) -> Int64 { let hi = (self >> 32).to_uint()
          #|  let lo = self.to_uint()
          #|  (hi.to_int64() << 32) | lo.to_int64() }
        ),
      ),
      "limbs": build(
        (
          #|fn BigInt::limbs(self : Self) -> Iter[UInt] { guard !self.is_zero() else { Iter::singleton(0) }
          #|  Iter::new(yield_ => for n = self * BigInt::from_int(self.signum())
          #|                          n > 0
          #|                          n = n >> 32 {
          #|    let limb = n.to_uint()
          #|    guard yield_(limb) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
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
          #|fn BigInt::signum(self : Self) -> Int { if self.is_zero() {
          #|    0
          #|  } else if is_neg(self) {
          #|    -1
          #|  } else {
          #|    1
          #|  } }
        ),
      ),
      "to_uint16": build(
        (
          #|pub fn BigInt::to_uint16(self : BigInt) -> UInt16 { self.to_int().to_uint16() }
        ),
      ),
      "to_int16": build(
        (
          #|pub fn BigInt::to_int16(self : BigInt) -> Int16 { self.to_int().to_int16() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_bool_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bool",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "to_int": build(
        (
          #|pub fn to_int(self : Bool) -> Int { if self {
          #|    1
          #|  } else {
          #|    0
          #|  } }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn to_int64(self : Bool) -> Int64 { if self {
          #|    1
          #|  } else {
          #|    0
          #|  } }
        ),
      ),
      "to_uint": build(
        (
          #|pub fn to_uint(self : Bool) -> UInt { if self {
          #|    1
          #|  } else {
          #|    0
          #|  } }
        ),
      ),
      "to_uint64": build(
        (
          #|pub fn to_uint64(self : Bool) -> UInt64 { if self {
          #|    1
          #|  } else {
          #|    0
          #|  } }
        ),
      ),
      "to_uint16": build(
        (
          #|pub fn to_uint16(self : Bool) -> UInt16 { if self {
          #|    1
          #|  } else {
          #|    0
          #|  } }
        ),
      ),
      "to_int16": build(
        (
          #|pub fn to_int16(self : Bool) -> Int16 { if self {
          #|    1
          #|  } else {
          #|    0
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_buffer_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/buffer",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/bytes": moonbitlang_core_bytes_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/string": moonbitlang_core_string_module,
  },
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
          #|pub fn length(self : T) -> Int { self.len }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn is_empty(self : T) -> Bool { self.len == 0 }
        ),
      ),
      "contents": build(
        (
          #|pub fn contents(self : T) -> Bytes { @bytes.from_fixedarray(self.data, len=self.len) }
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
          #|pub fn reset(self : T) -> Unit { self.data = self.initial_data
          #|  self.len = 0 }
        ),
      ),
      "to_bytes": build(
        (
          #|pub fn to_bytes(self : T) -> Bytes { @bytes.from_fixedarray(self.data, len=self.len) }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_builtin_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/builtin",
  deps={ "moonbitlang/core/abort": moonbitlang_core_abort_module },
  fn(_env, build) {
    {
      "run": build(
        (
          #|pub fn[T] Iter::run(self : Iter[T], f : (T) -> IterResult) -> IterResult { self(f) }
        ),
      ),
      "just_run": build(
        (
          #|pub fn[T] Iter::just_run(self : Iter[T], f : (T) -> IterResult) -> Unit { self(f) |> ignore }
        ),
      ),
      "each": build(
        (
          #|pub fn[T] Iter::each(self : Iter[T], f : (T) -> Unit raise?) -> Unit raise? { for a in self {
          #|    f(a)
          #|  } }
        ),
      ),
      "any": build(
        (
          #|pub fn[T] Iter::any(self : Iter[T], f : (T) -> Bool) -> Bool { self.run(k => if f(k) { IterEnd } else { IterContinue }) != IterContinue }
        ),
      ),
      "all": build(
        (
          #|pub fn[T] Iter::all(self : Iter[T], f : (T) -> Bool) -> Bool { self.run(k => if !f(k) { IterEnd } else { IterContinue }) == IterContinue }
        ),
      ),
      "count": build(
        (
          #|pub fn[T] Iter::count(self : Iter[T]) -> Int { self.fold((acc, _) => acc + 1, init=0) }
        ),
      ),
      "new": build(
        (
          #|pub fn[T] Iter::new(f : ((T) -> IterResult) -> IterResult) -> Iter[T] { Iter(f) }
        ),
      ),
      "empty": build(
        (
          #|pub fn[T] Iter::empty() -> Iter[T] { _ => IterContinue }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[T] Iter::singleton(a : T) -> Iter[T] { yield_ => yield_(a) }
        ),
      ),
      "repeat": build(
        (
          #|pub fn[T] Iter::repeat(a : T) -> Iter[T] { yield_ => loop yield_(a) {
          #|    IterContinue => continue yield_(a)
          #|    IterEnd => IterEnd
          #|  } }
        ),
      ),
      "filter": build(
        (
          #|pub fn[T] Iter::filter(self : Iter[T], f : (T) -> Bool) -> Iter[T] { yield_ => self.run(a => if f(a) { yield_(a) } else { IterContinue }) }
        ),
      ),
      "map": build(
        (
          #|pub fn[T, R] Iter::map(self : Iter[T], f : (T) -> R) -> Iter[R] { yield_ => self.run(a => yield_(f(a))) }
        ),
      ),
      "mapi": build(
        (
          #|pub fn[T, R] Iter::mapi(self : Iter[T], f : (Int, T) -> R) -> Iter[R] { yield_ => {
          #|    let mut i = -1
          #|    self.run(a => {
          #|      i = i + 1
          #|      yield_(f(i, a))
          #|    })
          #|  } }
        ),
      ),
      "filter_map": build(
        (
          #|pub fn[A, B] Iter::filter_map(self : Iter[A], f : (A) -> B?) -> Iter[B] { yield_ => self.run(a => match f(a) {
          #|    Some(b) => yield_(b)
          #|    None => IterContinue
          #|  }) }
        ),
      ),
      "map_option": build(
        (
          #|pub fn[A, B] Iter::map_option(self : Iter[A], f : (A) -> B?) -> Iter[B] { self.filter_map(f) }
        ),
      ),
      "flat_map": build(
        (
          #|pub fn[T, R] Iter::flat_map(self : Iter[T], f : (T) -> Iter[R]) -> Iter[R] { yield_ => self.run(x => f(x).run(yield_)) }
        ),
      ),
      "flatten": build(
        (
          #|pub fn[T] Iter::flatten(self : Iter[Iter[T]]) -> Iter[T] { yield_ => self.run(x => x.run(yield_)) }
        ),
      ),
      "tap": build(
        (
          #|pub fn[T] Iter::tap(self : Iter[T], f : (T) -> Unit) -> Iter[T] { self.map(a => {
          #|    f(a)
          #|    a
          #|  }) }
        ),
      ),
      "take": build(
        (
          #|pub fn[T] Iter::take(self : Iter[T], n : Int) -> Iter[T] { yield_ => {
          #|    // [..take(10,seq), next] would continue
          #|    // even if seq has less than 10 elements
          #|    // but `for x in [..take(10,seq), next ] { break }` would stop
          #|    //
          #|    let mut i = 0
          #|    let mut r = IterContinue
          #|    self.just_run(a => if i < n {
          #|      if yield_(a) == IterContinue {
          #|        i = i + 1
          #|        IterContinue
          #|      } else {
          #|        r = IterEnd
          #|        IterEnd
          #|      }
          #|    } else {
          #|      IterEnd
          #|    })
          #|    r
          #|  } }
        ),
      ),
      "take_while": build(
        (
          #|pub fn[T] Iter::take_while(self : Iter[T], f : (T) -> Bool) -> Iter[T] { yield_ => {
          #|    // `r` represents the overall return value.
          #|    // It is set to `IterEnd` only if `yield_(a)` returns `IterEnd`.
          #|    // so if `f(a)` returns `false`, it will return `IterEnd`
          #|    // immediately the iteration of current seq is terminated
          #|    // but [.. take_while(..), next] would continue
          #|    // See test \"take_while2\"
          #|    let mut r : IterResult = IterContinue
          #|    self.just_run(a => if f(a) {
          #|      if yield_(a) == IterContinue {
          #|        IterContinue
          #|      } else {
          #|        r = IterEnd
          #|        IterEnd
          #|      }
          #|    } else {
          #|      IterEnd
          #|    })
          #|    r
          #|  } }
        ),
      ),
      "map_while": build(
        (
          #|pub fn[A, B] Iter::map_while(self : Iter[A], f : (A) -> B?) -> Iter[B] { yield_ => {
          #|    let mut r : IterResult = IterContinue
          #|    self.just_run(a => match f(a) {
          #|      Some(b) =>
          #|        if yield_(b) == IterContinue {
          #|          IterContinue
          #|        } else {
          #|          r = IterEnd
          #|          IterEnd
          #|        }
          #|      None => IterEnd
          #|    })
          #|    r
          #|  } }
        ),
      ),
      "drop": build(
        (
          #|pub fn[T] Iter::drop(self : Iter[T], n : Int) -> Iter[T] { yield_ => {
          #|    let mut i = 0
          #|    self.run(a => if i < n {
          #|      i = i + 1
          #|      IterContinue
          #|    } else {
          #|      yield_(a)
          #|    })
          #|  } }
        ),
      ),
      "drop_while": build(
        (
          #|pub fn[T] Iter::drop_while(self : Iter[T], f : (T) -> Bool) -> Iter[T] { yield_ => {
          #|    let mut dropping = true
          #|    self.run(a => if dropping && f(a) {
          #|      IterContinue
          #|    } else {
          #|      dropping = false
          #|      yield_(a)
          #|    })
          #|  } }
        ),
      ),
      "find_first": build(
        (
          #|pub fn[T] Iter::find_first(self : Iter[T], f : (T) -> Bool) -> T? { for a in self {
          #|    if f(a) {
          #|      break Some(a)
          #|    }
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "peek": build(
        (
          #|pub fn[T] Iter::peek(self : Iter[T]) -> T? { let mut first = None
          #|  self.just_run(a => {
          #|    first = Some(a)
          #|    IterEnd
          #|  })
          #|  first }
        ),
      ),
      "prepend": build(
        (
          #|pub fn[T] Iter::prepend(self : Iter[T], a : T) -> Iter[T] { yield_ => if yield_(a) == IterContinue { self.run(yield_) } else { IterEnd } }
        ),
      ),
      "append": build(
        (
          #|pub fn[T] Iter::append(self : Iter[T], a : T) -> Iter[T] { yield_ => if self.run(yield_) == IterContinue { yield_(a) } else { IterEnd } }
        ),
      ),
      "concat": build(
        (
          #|pub fn[T] Iter::concat(self : Iter[T], other : Iter[T]) -> Iter[T] { yield_ => if self.run(yield_) == IterContinue {
          #|    other.run(yield_)
          #|  } else {
          #|    IterEnd
          #|  } }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[T] Iter::to_array(self : Iter[T]) -> Array[T] { let result = []
          #|  for e in self {
          #|    result.push(e)
          #|  }
          #|  result }
        ),
      ),
      "collect": build(
        (
          #|pub fn[T] Iter::collect(self : Iter[T]) -> Array[T] { let result = []
          #|  self.each(e => result.push(e))
          #|  result }
        ),
      ),
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
      "iter": build(
        (
          #|pub fn[T] Iter::iter(self : Iter[T]) -> Iter[T] { self }
        ),
      ),
      "last": build(
        (
          #|pub fn[A] Iter::last(self : Iter[A]) -> A? { let mut last = None
          #|  for a in self {
          #|    last = Some(a)
          #|  }
          #|  last }
        ),
      ),
      "head": build(
        (
          #|pub fn[A] Iter::head(self : Iter[A]) -> A? { for i in self {
          #|    break Some(i)
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "intersperse": build(
        (
          #|pub fn[A] Iter::intersperse(self : Iter[A], sep : A) -> Iter[A] { yield_ => {
          #|    let mut first = true
          #|    self.run(x => if first {
          #|      first = false
          #|      yield_(x)
          #|    } else if yield_(sep) == IterEnd {
          #|      IterEnd
          #|    } else {
          #|      yield_(x)
          #|    })
          #|  } }
        ),
      ),
      "contains": build(
        (
          #|pub fn[A : Eq] Iter::contains(self : Iter[A], value : A) -> Bool { for v in self {
          #|    if v == value {
          #|      break true
          #|    }
          #|  } else {
          #|    false
          #|  } }
        ),
      ),
      "nth": build(
        (
          #|pub fn[T] Iter::nth(self : Iter[T], n : Int) -> T? { self.drop(n).head() }
        ),
      ),
      "maximum": build(
        (
          #|pub fn[T : Compare] Iter::maximum(self : Iter[T]) -> T? { let mut res = None
          #|  for x in self {
          #|    match res {
          #|      None => res = Some(x)
          #|      Some(max) => if x > max { res = Some(x) }
          #|    }
          #|  }
          #|  res }
        ),
      ),
      "minimum": build(
        (
          #|pub fn[T : Compare] Iter::minimum(self : Iter[T]) -> T? { let mut res = None
          #|  for x in self {
          #|    match res {
          #|      None => res = Some(x)
          #|      Some(min) => if x < min { res = Some(x) }
          #|    }
          #|  }
          #|  res }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[T] Iter::iter2(self : Iter[T]) -> Iter2[Int, T] { yield_ => {
          #|    let mut index = -1
          #|    self.run(i => {
          #|      index += 1
          #|      yield_(index, i)
          #|    })
          #|  } }
        ),
      ),
      "length": build(
        (
          #|pub fn[A] UninitializedArray::length(self : UninitializedArray[A]) -> Int { let UninitializedArray(self) = self
          #|  self.length() }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn Double::to_int64(self : Double) -> Int64 { MyInt64::from_double(self).to_int64() }
        ),
      ),
      "to_uint64": build(
        (
          #|pub fn Double::to_uint64(self : Double) -> UInt64 { MyInt64::from_double_unsigned(self).to_uint64() }
        ),
      ),
      "from_fixed_array": build(
        (
          #|pub fn[T] Array::from_fixed_array(arr : FixedArray[T]) -> Array[T] { let len = arr.length()
          #|  let arr2 = Array::make_uninit(len)
          #|  UninitializedArray::unsafe_blit_fixed(arr2.buffer(), 0, arr, 0, len)
          #|  arr2 }
        ),
      ),
      "make": build(
        (
          #|pub fn[T] Array::make(len : Int, elem : T) -> Array[T] { let arr = Array::make_uninit(len)
          #|  for i in 0..<len {
          #|    arr.unsafe_set(i, elem)
          #|  }
          #|  arr }
        ),
      ),
      "capacity": build(
        (
          #|pub fn[T] Array::capacity(self : Array[T]) -> Int { self.buffer().0.length() }
        ),
      ),
      "unsafe_get": build(
        (
          #|pub fn[T] Array::unsafe_get(self : Array[T], idx : Int) -> T { self.buffer()[idx] }
        ),
      ),
      "op_get": build(
        (
          #|pub fn[T] Array::op_get(self : Array[T], index : Int) -> T { let len = self.length()
          #|  guard index >= 0 && index < len
          #|  self.buffer()[index] }
        ),
      ),
      "get": build(
        (
          #|pub fn[T] Array::get(self : Array[T], index : Int) -> T? { let len = self.length()
          #|  guard index >= 0 && index < len else { None }
          #|  Some(self.unsafe_get(index)) }
        ),
      ),
      "unsafe_set": build(
        (
          #|fn[T] Array::unsafe_set(self : Array[T], idx : Int, val : T) -> Unit { self.buffer()[idx] = val }
        ),
      ),
      "op_set": build(
        (
          #|pub fn[T] Array::op_set(self : Array[T], index : Int, value : T) -> Unit { let len = self.length()
          #|  guard index >= 0 && index < len
          #|  self.buffer()[index] = value }
        ),
      ),
      "append": build(
        (
          #|pub fn[T] Array::append(self : Array[T], other : Array[T]) -> Unit { other.blit_to(
          #|    self,
          #|    len=other.length(),
          #|    src_offset=0,
          #|    dst_offset=self.length(),
          #|  ) }
        ),
      ),
      "each": build(
        (
          #|pub fn[T] Array::each(self : Array[T], f : (T) -> Unit raise?) -> Unit raise? { for v in self {
          #|    f(v)
          #|  } }
        ),
      ),
      "rev_each": build(
        (
          #|pub fn[T] Array::rev_each(self : Array[T], f : (T) -> Unit) -> Unit { let len = self.length()
          #|  for i in 0..<len {
          #|    f(self[len - i - 1])
          #|  } }
        ),
      ),
      "clear": build(
        (
          #|pub fn[T] Array::clear(self : Array[T]) -> Unit { self.unsafe_truncate_to_length(0) }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[T] Array::is_empty(self : Array[T]) -> Bool { self.length() == 0 }
        ),
      ),
      "is_sorted": build(
        (
          #|pub fn[T : Compare] Array::is_sorted(self : Array[T]) -> Bool { for i = 1 {
          #|    if i >= self.length() {
          #|      break true
          #|    }
          #|    if self[i - 1] > self[i] {
          #|      break false
          #|    }
          #|    continue i + 1
          #|  } }
        ),
      ),
      "rev_inplace": build(
        (
          #|pub fn[T] Array::rev_inplace(self : Array[T]) -> Unit { let len = self.length()
          #|  for i in 0..<(len / 2) {
          #|    let temp = self.unsafe_get(i)
          #|    self.unsafe_set(i, self.unsafe_get(len - i - 1))
          #|    self.unsafe_set(len - i - 1, temp)
          #|  } }
        ),
      ),
      "rev": build(
        (
          #|pub fn[T] Array::rev(self : Array[T]) -> Array[T] { let len = self.length()
          #|  let arr = Array::make_uninit(len)
          #|  for i in 0..<len {
          #|    arr.unsafe_set(i, self.unsafe_get(len - i - 1))
          #|  }
          #|  arr }
        ),
      ),
      "split_at": build(
        (
          #|pub fn[T] Array::split_at(self : Array[T], index : Int) -> (Array[T], Array[T]) { if index < 0 || index > self.length() {
          #|    let len = self.length()
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{len} but the index is \\{index}\",
          #|    )
          #|  }
          #|  let v1 = Array::make_uninit(index)
          #|  let v2 = Array::make_uninit(self.length() - index)
          #|  UninitializedArray::unsafe_blit(v1.buffer(), 0, self.buffer(), 0, index)
          #|  if index != self.length() {
          #|    UninitializedArray::unsafe_blit(
          #|      v2.buffer(),
          #|      0,
          #|      self.buffer(),
          #|      index,
          #|      self.length() - index,
          #|    )
          #|  }
          #|  (v1, v2) }
        ),
      ),
      "contains": build(
        (
          #|pub fn[T : Eq] Array::contains(self : Array[T], value : T) -> Bool { for v in self {
          #|    if v == value {
          #|      break true
          #|    }
          #|  } else {
          #|    false
          #|  } }
        ),
      ),
      "starts_with": build(
        (
          #|pub fn[T : Eq] Array::starts_with(self : Array[T], prefix : Array[T]) -> Bool { if prefix.length() > self.length() {
          #|    return false
          #|  }
          #|  for i in 0..<prefix.length() {
          #|    if self.unsafe_get(i) != prefix.unsafe_get(i) {
          #|      break false
          #|    }
          #|  } else {
          #|    true
          #|  } }
        ),
      ),
      "ends_with": build(
        (
          #|pub fn[T : Eq] Array::ends_with(self : Array[T], suffix : Array[T]) -> Bool { if suffix.length() > self.length() {
          #|    return false
          #|  }
          #|  for i in 0..<suffix.length() {
          #|    if self.unsafe_get(self.length() - suffix.length() + i) !=
          #|      suffix.unsafe_get(i) {
          #|      break false
          #|    }
          #|  } else {
          #|    true
          #|  } }
        ),
      ),
      "search": build(
        (
          #|pub fn[T : Eq] Array::search(self : Array[T], value : T) -> Int? { for i, v in self {
          #|    if v == value {
          #|      break Some(i)
          #|    }
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "search_by": build(
        (
          #|pub fn[T] Array::search_by(self : Array[T], f : (T) -> Bool) -> Int? { for i, v in self {
          #|    if f(v) {
          #|      break Some(i)
          #|    }
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "swap": build(
        (
          #|pub fn[T] Array::swap(self : Array[T], i : Int, j : Int) -> Unit { if i >= self.length() || j >= self.length() || i < 0 || j < 0 {
          #|    let len = self.length()
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{len} but the index is (\\{i}, \\{j})\",
          #|    )
          #|  }
          #|  let temp = self.unsafe_get(i)
          #|  self.unsafe_set(i, self.unsafe_get(j))
          #|  self.unsafe_set(j, temp) }
        ),
      ),
      "retain": build(
        (
          #|pub fn[T] Array::retain(self : Array[T], f : (T) -> Bool raise?) -> Unit raise? { let len = self.length()
          #|  for i = 0, j = 0; i < len; {
          #|    let item = self.unsafe_get(i)
          #|    if f(item) {
          #|      self.unsafe_set(j, item)
          #|      continue i + 1, j + 1
          #|    }
          #|    continue i + 1, j
          #|  } else {
          #|    // we use `else` here to capture `j`
          #|    self.unsafe_truncate_to_length(j)
          #|  } }
        ),
      ),
      "resize": build(
        (
          #|pub fn[T] Array::resize(self : Array[T], new_len : Int, f : T) -> Unit { if new_len < 0 {
          #|    abort(\"negative new length\")
          #|  }
          #|  if new_len < self.length() {
          #|    self.unsafe_truncate_to_length(new_len)
          #|  } else {
          #|    let len = self.length()
          #|    for _ in len..<new_len {
          #|      self.push(f)
          #|    }
          #|  } }
        ),
      ),
      "flatten": build(
        (
          #|pub fn[T] Array::flatten(self : Array[Array[T]]) -> Array[T] { let mut len = 0
          #|  for x in self {
          #|    len += x.length()
          #|  }
          #|  let res = Array::make_uninit(len)
          #|  let mut i = 0
          #|  for xs in self {
          #|    res.unsafe_blit(i, xs, 0, xs.length())
          #|    i += xs.length()
          #|  }
          #|  res }
        ),
      ),
      "repeat": build(
        (
          #|pub fn[T] Array::repeat(self : Array[T], times : Int) -> Array[T] { let v = Array::new(capacity=self.length() * times)
          #|  for i in 0..<times {
          #|    v.append(self)
          #|  }
          #|  v }
        ),
      ),
      "dedup": build(
        (
          #|pub fn[T : Eq] Array::dedup(self : Array[T]) -> Unit { if self.is_empty() {
          #|    return
          #|  }
          #|  let mut w = 1
          #|  for i in 1..<self.length() {
          #|    if self[i] != self[w - 1] {
          #|      self[w] = self[i]
          #|      w = w + 1
          #|    }
          #|  }
          #|  self.unsafe_truncate_to_length(w) }
        ),
      ),
      "extract_if": build(
        (
          #|pub fn[T] Array::extract_if(self : Array[T], f : (T) -> Bool) -> Array[T] { let v = []
          #|  let indices = []
          #|  for i in 0..<self.length() {
          #|    if f(self[i]) {
          #|      v.push(self[i])
          #|      indices.push(i)
          #|    }
          #|  }
          #|  for i in 0..<indices.length() {
          #|    self.remove(indices[i] - i) |> ignore
          #|  }
          #|  v }
        ),
      ),
      "chunks": build(
        (
          #|pub fn[T] Array::chunks(self : Array[T], size : Int) -> Array[Array[T]] { guard size > 0
          #|  let chunks = []
          #|  let mut i = 0
          #|  while i < self.length() {
          #|    let chunk = Array::new(capacity=size)
          #|    for j = 0; j < size && i < self.length(); j = j + 1 {
          #|      chunk.push(self[i])
          #|      i = i + 1
          #|    }
          #|    chunks.push(chunk)
          #|  }
          #|  chunks }
        ),
      ),
      "windows": build(
        (
          #|pub fn[T] Array::windows(self : Array[T], size : Int) -> Array[ArrayView[T]] { guard size > 0
          #|  let len = self.length() - size + 1
          #|  if len < 1 {
          #|    return []
          #|  }
          #|  let windows = Array::new(capacity=len)
          #|  for i in 0..<len {
          #|    windows.push(self[i:i + size])
          #|  }
          #|  windows }
        ),
      ),
      "iter": build(
        (
          #|pub fn[T] Array::iter(self : Array[T]) -> Iter[T] { Iter::new(yield_ => for v in self {
          #|    guard yield_(v) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "rev_iter": build(
        (
          #|pub fn[T] Array::rev_iter(self : Array[T]) -> Iter[T] { Iter::new(yield_ => for i = self.length() - 1; i >= 0; i = i - 1 {
          #|    guard yield_(self.unsafe_get(i)) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[A] Array::iter2(self : Array[A]) -> Iter2[Int, A] { Iter2::new(yield_ => for i, v in self {
          #|    guard yield_(i, v) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "unsafe_pop_back": build(
        (
          #|pub fn[A] Array::unsafe_pop_back(self : Array[A]) -> Unit { self.unsafe_pop() |> ignore }
        ),
      ),
      "truncate": build(
        (
          #|pub fn[A] Array::truncate(self : Array[A], len : Int) -> Unit { guard len >= 0 && len < self.length() else { return }
          #|  self.unsafe_truncate_to_length(len) }
        ),
      ),
      "retain_map": build(
        (
          #|pub fn[A] Array::retain_map(self : Array[A], f : (A) -> A?) -> Unit { if self.is_empty() {
          #|    return
          #|  }
          #|  let buf = self.buffer()
          #|  let len = self.length()
          #|  let mut write_idx = 0
          #|  for read_idx in 0..<len {
          #|    let val = buf[read_idx]
          #|    match f(val) {
          #|      Some(new_val) => {
          #|        buf[write_idx] = new_val
          #|        write_idx += 1
          #|      }
          #|      None => ()
          #|    }
          #|  }
          #|  self.unsafe_truncate_to_length(write_idx) }
        ),
      ),
      "to_string": build(
        (
          #|pub fn[X : Show] Option::to_string(self : X?) -> String { match self {
          #|    None => \"None\"
          #|    Some(x) => \"Some(\" + x.to_string() + \")\"
          #|  } }
        ),
      ),
      "unwrap": build(
        (
          #|pub fn[X] Option::unwrap(self : X?) -> X { match self {
          #|    None => panic()
          #|    Some(x) => x
          #|  } }
        ),
      ),
      "get": build(
        (
          #|pub fn[T] FixedArray::get(self : FixedArray[T], idx : Int) -> T? { let len = self.length()
          #|  guard idx >= 0 && idx < len else { None }
          #|  Some(self.unsafe_get(idx)) }
        ),
      ),
      "iter": build(
        (
          #|pub fn[T] FixedArray::iter(self : FixedArray[T]) -> Iter[T] { Iter::new(yield_ => for v in self {
          #|    guard yield_(v) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[T] FixedArray::iter2(self : FixedArray[T]) -> Iter2[Int, T] { Iter2::new(yield_ => for i, v in self {
          #|    guard yield_(i, v) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "fill": build(
        (
          #|pub fn[T] FixedArray::fill(self : FixedArray[T], value : T) -> Unit { for i in 0..<self.length() {
          #|    self[i] = value
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[T] FixedArray::is_empty(self : FixedArray[T]) -> Bool { self.length() == 0 }
        ),
      ),
      "each": build(
        (
          #|pub fn[A, B] Iter2::each(self : Iter2[A, B], f : (A, B) -> Unit) -> Unit { self.run((a, b) => {
          #|    f(a, b)
          #|    IterContinue
          #|  })
          #|  |> ignore }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A, B] Iter2::iter(self : Iter2[A, B]) -> Iter[(A, B)] { Iter::new(yield_ => self.run((a, b) => yield_((a, b)))) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[A, B] Iter2::iter2(self : Iter2[A, B]) -> Iter2[A, B] { // This is a no-op to make sure
          #|  // `for k,v in map.iter2() { ... }`
          #|  // still work
          #|  self }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[A, B] Iter2::to_array(self : Iter2[A, B]) -> Array[(A, B)] { let arr = []
          #|  for k, v in self {
          #|    arr.push((k, v))
          #|  }
          #|  arr }
        ),
      ),
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
          #|fn MyInt64::lnot(self : MyInt64) -> MyInt64 { { hi: self.hi.lnot(), lo: self.lo.lnot() } }
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
          #|fn MyInt64::clz(self : MyInt64) -> Int { if self.hi != 0 {
          #|    self.hi.clz()
          #|  } else {
          #|    32 + self.lo.clz()
          #|  } }
        ),
      ),
      "ctz": build(
        (
          #|fn MyInt64::ctz(self : MyInt64) -> Int { if self.lo != 0 {
          #|    self.lo.ctz()
          #|  } else {
          #|    32 + self.hi.ctz()
          #|  } }
        ),
      ),
      "popcnt": build(
        (
          #|fn MyInt64::popcnt(self : MyInt64) -> Int { self.hi.popcnt() + self.lo.popcnt() }
        ),
      ),
      "from_int": build(
        (
          #|fn MyInt64::from_int(value : Int) -> MyInt64 { { hi: (value >> 31) & -1, lo: value | 0 } }
        ),
      ),
      "to_int": build(
        (
          #|fn MyInt64::to_int(self : MyInt64) -> Int { self.lo }
        ),
      ),
      "to_uint": build(
        (
          #|fn MyInt64::to_uint(self : MyInt64) -> UInt { self.lo.reinterpret_as_uint() }
        ),
      ),
      "extend_i32_u": build(
        (
          #|fn MyInt64::extend_i32_u(value : Int) -> MyInt64 { { hi: 0, lo: value } }
        ),
      ),
      "lnot": build(
        (
          #|pub fn Int64::lnot(self : Int64) -> Int64 { MyInt64::from_int64(self).lnot().to_int64() }
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
          #|pub fn Int64::ctz(self : Int64) -> Int { MyInt64::from_int64(self).ctz() }
        ),
      ),
      "clz": build(
        (
          #|pub fn Int64::clz(self : Int64) -> Int { MyInt64::from_int64(self).clz() }
        ),
      ),
      "popcnt": build(
        (
          #|pub fn Int64::popcnt(self : Int64) -> Int { MyInt64::from_int64(self).popcnt() }
        ),
      ),
      "to_int": build(
        (
          #|pub fn Int64::to_int(self : Int64) -> Int { MyInt64::from_int64(self).to_int() }
        ),
      ),
      "to_double": build(
        (
          #|pub fn Int64::to_double(self : Int64) -> Double { Double::convert_int64(self) }
        ),
      ),
      "to_byte": build(
        (
          #|pub fn Int64::to_byte(self : Int64) -> Byte { MyInt64::from_int64(self).to_int().to_byte() }
        ),
      ),
      "to_int16": build(
        (
          #|pub fn Int64::to_int16(self : Int64) -> Int16 { MyInt64::from_int64(self).to_int().to_int16() }
        ),
      ),
      "to_uint16": build(
        (
          #|pub fn Int64::to_uint16(self : Int64) -> UInt16 { MyInt64::from_int64(self).to_int().to_uint16() }
        ),
      ),
      "extend_uint": build(
        (
          #|pub fn UInt64::extend_uint(value : UInt) -> UInt64 { MyInt64::extend_i32_u(value.reinterpret_as_int()).to_uint64() }
        ),
      ),
      "reinterpret_as_double": build(
        (
          #|pub fn Int64::reinterpret_as_double(self : Int64) -> Double { MyInt64::reinterpret_as_double(MyInt64::from_int64(self)) }
        ),
      ),
      "reinterpret_as_double": build(
        (
          #|pub fn UInt64::reinterpret_as_double(self : UInt64) -> Double { MyInt64::reinterpret_as_double(MyInt64::from_uint64(self)) }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn Int::to_int64(self : Int) -> Int64 { MyInt64::from_int(self).to_int64() }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn Int16::to_int64(self : Int16) -> Int64 { MyInt64::from_int(self.to_int()).to_int64() }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn UInt16::to_int64(self : UInt16) -> Int64 { MyInt64::from_int(self.to_int()).to_int64() }
        ),
      ),
      "reinterpret_as_i64": build(
        (
          #|pub fn Double::reinterpret_as_i64(self : Double) -> Int64 { MyInt64::reinterpret_double(self).to_int64() }
        ),
      ),
      "reinterpret_as_int64": build(
        (
          #|pub fn Double::reinterpret_as_int64(self : Double) -> Int64 { MyInt64::reinterpret_double(self).to_int64() }
        ),
      ),
      "reinterpret_as_u64": build(
        (
          #|pub fn Double::reinterpret_as_u64(self : Double) -> UInt64 { MyInt64::reinterpret_double(self).to_uint64() }
        ),
      ),
      "reinterpret_as_uint64": build(
        (
          #|pub fn Double::reinterpret_as_uint64(self : Double) -> UInt64 { MyInt64::reinterpret_double(self).to_uint64() }
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
          #|pub fn UInt64::to_uint(self : UInt64) -> UInt { MyInt64::from_uint64(self).to_uint() }
        ),
      ),
      "to_int": build(
        (
          #|pub fn UInt64::to_int(self : UInt64) -> Int { MyInt64::from_uint64(self).to_int() }
        ),
      ),
      "to_double": build(
        (
          #|pub fn UInt64::to_double(self : UInt64) -> Double { Double::convert_uint64(self) }
        ),
      ),
      "trunc_double": build(
        (
          #|pub fn UInt64::trunc_double(value : Double) -> UInt64 { MyInt64::trunc_double_u(value).to_uint64() }
        ),
      ),
      "lnot": build(
        (
          #|pub fn UInt64::lnot(self : UInt64) -> UInt64 { MyInt64::lnot(MyInt64::from_uint64(self)).to_uint64() }
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
          #|pub fn UInt64::clz(self : UInt64) -> Int { MyInt64::from_uint64(self).clz() }
        ),
      ),
      "ctz": build(
        (
          #|pub fn UInt64::ctz(self : UInt64) -> Int { MyInt64::from_uint64(self).ctz() }
        ),
      ),
      "popcnt": build(
        (
          #|pub fn UInt64::popcnt(self : UInt64) -> Int { MyInt64::from_uint64(self).popcnt() }
        ),
      ),
      "to_float": build(
        (
          #|pub fn Int64::to_float(self : Int64) -> Float { self.to_double().to_float() }
        ),
      ),
      "to_float": build(
        (
          #|pub fn UInt64::to_float(self : UInt64) -> Float { Double::convert_uint64(self).to_float() }
        ),
      ),
      "repr": build(
        (
          #|pub fn[T : Show] repr(t : T) -> String { let logger = StringBuilder::new()
          #|  t.output(logger)
          #|  logger.to_string() }
        ),
      ),
      "to_hex_digit": build(
        (
          #|fn to_hex_digit(i : Int) -> Char { if i < 10 {
          #|    (i + '0').unsafe_to_char()
          #|  } else {
          #|    (i + 'a' - 10).unsafe_to_char()
          #|  } }
        ),
      ),
      "escape": build(
        (
          #|pub fn String::escape(self : String) -> String { let buf = StringBuilder::new()
          #|  Show::output(self, buf)
          #|  buf.to_string() }
        ),
      ),
      "lsr": build(
        (
          #|pub fn Int::lsr(self : Int, other : Int) -> Int { (self.reinterpret_as_uint() >> other).reinterpret_as_int() }
        ),
      ),
      "to_uint64": build(
        (
          #|pub fn Int::to_uint64(self : Int) -> UInt64 { self.to_int64().reinterpret_as_uint64() }
        ),
      ),
      "to_uint": build(
        (
          #|pub fn Char::to_uint(self : Char) -> UInt { self.to_int().reinterpret_as_uint() }
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
          #|pub fn Int::to_char(self : Int) -> Char? { if self is (0..=0xD7FF) || self is (0xE000..=0x10FFFF) {
          #|    Some(self.unsafe_to_char())
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "to_byte": build(
        (
          #|pub fn UInt64::to_byte(self : UInt64) -> Byte { self.to_int().to_byte() }
        ),
      ),
      "to_char": build(
        (
          #|pub fn Byte::to_char(self : Byte) -> Char { self.to_int().unsafe_to_char() }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn Byte::to_int64(self : Byte) -> Int64 { self.to_int().to_int64() }
        ),
      ),
      "to_uint64": build(
        (
          #|pub fn UInt::to_uint64(self : UInt) -> UInt64 { UInt64::extend_uint(self) }
        ),
      ),
      "to_byte": build(
        (
          #|pub fn UInt::to_byte(self : UInt) -> Byte { self.reinterpret_as_int().to_byte() }
        ),
      ),
      "to_double": build(
        (
          #|pub fn Byte::to_double(self : Byte) -> Double { self.to_int().to_double() }
        ),
      ),
      "null": build(
        (
          #|pub fn Json::null() -> Json { return Null }
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
      "make_uninit": build(
        (
          #|fn[T] Array::make_uninit(len : Int) -> Array[T] { { buf: UninitializedArray::make(len), len } }
        ),
      ),
      "new": build(
        (
          #|pub fn[T] Array::new(capacity~ : Int = 0) -> Array[T] { if capacity == 0 {
          #|    []
          #|  } else {
          #|    { buf: UninitializedArray::make(capacity), len: 0 }
          #|  } }
        ),
      ),
      "length": build(
        (
          #|pub fn[T] Array::length(self : Array[T]) -> Int { self.len }
        ),
      ),
      "unsafe_truncate_to_length": build(
        (
          #|fn[T] Array::unsafe_truncate_to_length(self : Array[T], new_len : Int) -> Unit { let len = self.length()
          #|  guard new_len <= len
          #|  for i in new_len..<len {
          #|    self.buf.set_null(i)
          #|  }
          #|  self.len = new_len }
        ),
      ),
      "buffer": build(
        (
          #|fn[T] Array::buffer(self : Array[T]) -> UninitializedArray[T] { self.buf }
        ),
      ),
      "resize_buffer": build(
        (
          #|fn[T] Array::resize_buffer(self : Array[T], new_capacity : Int) -> Unit { let new_buf = UninitializedArray::make(new_capacity)
          #|  let old_buf = self.buf
          #|  let old_cap = old_buf.0.length()
          #|  let copy_len = if old_cap < new_capacity { old_cap } else { new_capacity }
          #|  UninitializedArray::unsafe_blit(new_buf, 0, old_buf, 0, copy_len)
          #|  self.buf = new_buf }
        ),
      ),
      "realloc": build(
        (
          #|fn[T] Array::realloc(self : Array[T]) -> Unit { let old_cap = self.length()
          #|  let new_cap = if old_cap == 0 { 8 } else { old_cap * 2 }
          #|  self.resize_buffer(new_cap) }
        ),
      ),
      "reserve_capacity": build(
        (
          #|pub fn[T] Array::reserve_capacity(self : Array[T], capacity : Int) -> Unit { if self.capacity() >= capacity {
          #|    return
          #|  }
          #|  self.resize_buffer(capacity) }
        ),
      ),
      "shrink_to_fit": build(
        (
          #|pub fn[T] Array::shrink_to_fit(self : Array[T]) -> Unit { if self.capacity() <= self.length() {
          #|    return
          #|  }
          #|  self.resize_buffer(self.length()) }
        ),
      ),
      "push": build(
        (
          #|pub fn[T] Array::push(self : Array[T], value : T) -> Unit { if self.length() == self.buffer().0.length() {
          #|    self.realloc()
          #|  }
          #|  let length = self.length()
          #|  self.unsafe_set(length, value)
          #|  self.len = length + 1 }
        ),
      ),
      "pop": build(
        (
          #|pub fn[T] Array::pop(self : Array[T]) -> T? { let len = self.length()
          #|  if len == 0 {
          #|    None
          #|  } else {
          #|    let index = len - 1
          #|    let v = self.unsafe_get(index)
          #|    self.buf.set_null(index)
          #|    self.len = index
          #|    Some(v)
          #|  } }
        ),
      ),
      "unsafe_pop": build(
        (
          #|pub fn[T] Array::unsafe_pop(self : Array[T]) -> T { let len = self.length()
          #|  guard len != 0
          #|  let index = len - 1
          #|  let v = self.unsafe_get(index)
          #|  self.buf.set_null(index)
          #|  self.len = index
          #|  v }
        ),
      ),
      "remove": build(
        (
          #|pub fn[T] Array::remove(self : Array[T], index : Int) -> T { guard index >= 0 && index < self.length() else {
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{self.length()} but the index is \\{index}\",
          #|    )
          #|  }
          #|  let value = self.unsafe_get(index)
          #|  UninitializedArray::unsafe_blit(
          #|    self.buffer(),
          #|    index,
          #|    self.buffer(),
          #|    index + 1,
          #|    self.length() - index - 1,
          #|  )
          #|  self.unsafe_truncate_to_length(self.length() - 1)
          #|  value }
        ),
      ),
      "drain": build(
        (
          #|pub fn[T] Array::drain(self : Array[T], begin : Int, end : Int) -> Array[T] { guard begin >= 0 && end <= self.length() && begin <= end
          #|  let num = end - begin
          #|  let v = Array::make_uninit(num)
          #|  UninitializedArray::unsafe_blit(v.buffer(), 0, self.buffer(), begin, num)
          #|  UninitializedArray::unsafe_blit(
          #|    self.buffer(),
          #|    begin,
          #|    self.buffer(),
          #|    end,
          #|    self.length() - end,
          #|  )
          #|  self.unsafe_truncate_to_length(self.length() - num)
          #|  v }
        ),
      ),
      "insert": build(
        (
          #|pub fn[T] Array::insert(self : Array[T], index : Int, value : T) -> Unit { guard index >= 0 && index <= self.length() else {
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{self.length()} but the index is \\{index}\",
          #|    )
          #|  }
          #|  if self.length() == self.buffer().0.length() {
          #|    self.realloc()
          #|  }
          #|  UninitializedArray::unsafe_blit(
          #|    self.buffer(),
          #|    index + 1,
          #|    self.buffer(),
          #|    index,
          #|    self.length() - index,
          #|  )
          #|  let length = self.length()
          #|  self.unsafe_set(index, value)
          #|  self.len = length + 1 }
        ),
      ),
      "unsafe_grow_to_length": build(
        (
          #|fn[T] Array::unsafe_grow_to_length(self : Array[T], new_len : Int) -> Unit { guard new_len >= self.length()
          #|  let new_buf = UninitializedArray::make(new_len)
          #|  UninitializedArray::unsafe_blit(new_buf, 0, self.buf, 0, self.len)
          #|  self.len = new_len
          #|  self.buf = new_buf }
        ),
      ),
      "new": build(
        (
          #|pub fn Hasher::new(seed~ : Int = 0) -> Hasher { { acc: seed.reinterpret_as_uint() + GPRIME5 } }
        ),
      ),
      "combine": build(
        (
          #|pub fn[T : Hash] Hasher::combine(self : Hasher, value : T) -> Unit { value.hash_combine(self) }
        ),
      ),
      "combine_unit": build(
        (
          #|pub fn Hasher::combine_unit(self : Hasher) -> Unit { self.combine_uint(0) }
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
          #|pub fn Hasher::finalize(self : Hasher) -> Int { self.avalanche().reinterpret_as_int() }
        ),
      ),
      "avalanche": build(
        (
          #|fn Hasher::avalanche(self : Hasher) -> UInt { let mut acc = self.acc
          #|  acc = acc ^ (acc >> 15)
          #|  acc *= GPRIMES2
          #|  acc = acc ^ (acc >> 13)
          #|  acc *= GPRIME3
          #|  acc = acc ^ (acc >> 16)
          #|  acc }
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
      "new": build(
        (
          #|pub fn[T] Array::new(capacity~ : Int = 0) -> Array[T] { ignore(capacity)
          #|  [] }
        ),
      ),
      "unsafe_truncate_to_length": build(
        (
          #|fn[T] Array::unsafe_truncate_to_length(self : Array[T], new_len : Int) -> Unit { JSArray::ofAnyArray(self).set_length(new_len) }
        ),
      ),
      "reserve_capacity": build(
        (
          #|pub fn[T] Array::reserve_capacity(self : Array[T], capacity : Int) -> Unit { ignore(self)
          #|  ignore(capacity) }
        ),
      ),
      "shrink_to_fit": build(
        (
          #|pub fn[T] Array::shrink_to_fit(self : Array[T]) -> Unit { ignore(self) }
        ),
      ),
      "push": build(
        (
          #|pub fn[T] Array::push(self : Array[T], value : T) -> Unit { JSArray::ofAnyArray(self).push(JSValue::ofAny(value)) }
        ),
      ),
      "pop": build(
        (
          #|pub fn[T] Array::pop(self : Array[T]) -> T? { if self.length() == 0 {
          #|    None
          #|  } else {
          #|    let v = self.unsafe_pop()
          #|    Some(v)
          #|  } }
        ),
      ),
      "unsafe_pop": build(
        (
          #|pub fn[T] Array::unsafe_pop(self : Array[T]) -> T { JSArray::ofAnyArray(self).pop().toAny() }
        ),
      ),
      "remove": build(
        (
          #|pub fn[T] Array::remove(self : Array[T], index : Int) -> T { guard index >= 0 && index < self.length() else {
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{self.length()} but the index is \\{index}\",
          #|    )
          #|  }
          #|  let value = self.buffer()[index]
          #|  let _ = JSArray::ofAnyArray(self).splice(index, 1)
          #|  value }
        ),
      ),
      "drain": build(
        (
          #|pub fn[T] Array::drain(self : Array[T], begin : Int, end : Int) -> Array[T] { guard begin >= 0 && end <= self.length() && begin <= end else {
          #|    abort(
          #|      \"index out of bounds: the len is \\{self.length()} but the index is (\\{begin}, \\{end})\",
          #|    )
          #|  }
          #|  JSArray::ofAnyArray(self).splice(begin, end - begin).toAnyArray() }
        ),
      ),
      "insert": build(
        (
          #|pub fn[T] Array::insert(self : Array[T], index : Int, value : T) -> Unit { guard index >= 0 && index <= self.length() else {
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{self.length()} but the index is \\{index}\",
          #|    )
          #|  }
          #|  let _ = JSArray::ofAnyArray(self).splice1(index, 0, JSValue::ofAny(value)) }
        ),
      ),
      "unsafe_grow_to_length": build(
        (
          #|fn[T] Array::unsafe_grow_to_length(self : Array[T], new_len : Int) -> Unit { guard new_len >= self.length()
          #|  JSArray::ofAnyArray(self).set_length(new_len) }
        ),
      ),
      "length": build(
        (
          #|pub fn[T] ArrayView::length(self : ArrayView[T]) -> Int { self.len() }
        ),
      ),
      "op_get": build(
        (
          #|pub fn[T] ArrayView::op_get(self : ArrayView[T], index : Int) -> T { guard index >= 0 && index < self.len() else {
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{self.len()} but the index is \\{index}\",
          #|    )
          #|  }
          #|  self.buf()[self.start() + index] }
        ),
      ),
      "unsafe_get": build(
        (
          #|pub fn[T] ArrayView::unsafe_get(self : ArrayView[T], index : Int) -> T { self.buf()[self.start() + index] }
        ),
      ),
      "swap": build(
        (
          #|pub fn[T] ArrayView::swap(self : ArrayView[T], i : Int, j : Int) -> Unit { guard i >= 0 && i < self.len() && j >= 0 && j < self.len() else {
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{self.len()} but the index is (\\{i}, \\{j})\",
          #|    )
          #|  }
          #|  let temp = self.buf()[self.start() + i]
          #|  self.buf()[self.start() + i] = self.buf()[self.start() + j]
          #|  self.buf()[self.start() + j] = temp }
        ),
      ),
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
      "find_index": build(
        (
          #|pub fn[T] Array::find_index(self : Array[T], f : (T) -> Bool) -> Int? { self.search_by(f) }
        ),
      ),
      "pop_exn": build(
        (
          #|pub fn[T] Array::pop_exn(self : Array[T]) -> T { self.unsafe_pop() }
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
          #|pub fn Bytes::copy(self : Bytes) -> Bytes { Bytes::makei(self.length(), i => self[i]) }
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
      "dump": build(
        (
          #|pub fn[T] dump(t : T, name? : String, loc~ : SourceLoc) -> T { let name = match name {
          #|    Some(name) => name
          #|    None => \"\"
          #|  }
          #|  println(\"dump(\\{name}@\\{loc}) = \\{any_to_string(t)}\")
          #|  t }
        ),
      ),
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
      "new": build(
        (
          #|pub fn[K, V] Map::new(capacity~ : Int = 8) -> Map[K, V] { let capacity = capacity.next_power_of_two()
          #|  {
          #|    size: 0,
          #|    capacity,
          #|    capacity_mask: capacity - 1,
          #|    grow_at: calc_grow_threshold(capacity),
          #|    entries: FixedArray::make(capacity, None),
          #|    head: None,
          #|    tail: -1,
          #|  } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[K : Hash + Eq, V] Map::from_array(arr : Array[(K, V)]) -> Map[K, V] { let m = Map::new(capacity=arr.length())
          #|  arr.each(e => m.set(e.0, e.1))
          #|  m }
        ),
      ),
      "set": build(
        (
          #|pub fn[K : Hash + Eq, V] Map::set(self : Map[K, V], key : K, value : V) -> Unit { if self.size >= self.grow_at {
          #|    self.grow()
          #|  }
          #|  let hash = key.hash()
          #|  let (idx, psl) = for psl = 0, idx = hash & self.capacity_mask {
          #|    match self.entries[idx] {
          #|      None => break (idx, psl)
          #|      Some(curr_entry) => {
          #|        if curr_entry.hash == hash && curr_entry.key == key {
          #|          curr_entry.value = value
          #|          return
          #|        }
          #|        if psl > curr_entry.psl {
          #|          self.push_away(idx, curr_entry)
          #|          break (idx, psl)
          #|        }
          #|        continue psl + 1, (idx + 1) & self.capacity_mask
          #|      }
          #|    }
          #|  }
          #|  let entry = { prev: self.tail, next: None, psl, key, value, hash }
          #|  self.add_entry_to_tail(idx, entry) }
        ),
      ),
      "get": build(
        (
          #|pub fn[K : Hash + Eq, V] Map::get(self : Map[K, V], key : K) -> V? { let hash = key.hash()
          #|  for i = 0, idx = hash & self.capacity_mask {
          #|    guard self.entries[idx] is Some(entry) else { break None }
          #|    if entry.hash == hash && entry.key == key {
          #|      break Some(entry.value)
          #|    }
          #|    if i > entry.psl {
          #|      break None
          #|    }
          #|    continue i + 1, (idx + 1) & self.capacity_mask
          #|  } }
        ),
      ),
      "op_get": build(
        (
          #|pub fn[K : Hash + Eq, V] Map::op_get(self : Map[K, V], key : K) -> V? { self.get(key) }
        ),
      ),
      "contains": build(
        (
          #|pub fn[K : Hash + Eq, V] Map::contains(self : Map[K, V], key : K) -> Bool { // inline Map::get to avoid boxing
          #|  let hash = key.hash()
          #|  for i = 0, idx = hash & self.capacity_mask {
          #|    guard self.entries[idx] is Some(entry) else { break false }
          #|    if entry.hash == hash && entry.key == key {
          #|      break true
          #|    }
          #|    if i > entry.psl {
          #|      break false
          #|    }
          #|    continue i + 1, (idx + 1) & self.capacity_mask
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[K : Hash + Eq, V] Map::remove(self : Map[K, V], key : K) -> Unit { let hash = key.hash()
          #|  for i = 0, idx = hash & self.capacity_mask {
          #|    guard self.entries[idx] is Some(entry) else { break }
          #|    if entry.hash == hash && entry.key == key {
          #|      self.remove_entry(entry)
          #|      self.shift_back(idx)
          #|      self.size -= 1
          #|      break
          #|    }
          #|    if i > entry.psl {
          #|      break
          #|    }
          #|    continue i + 1, (idx + 1) & self.capacity_mask
          #|  } }
        ),
      ),
      "remove_entry": build(
        (
          #|fn[K, V] Map::remove_entry(self : Map[K, V], entry : Entry[K, V]) -> Unit { match entry.prev {
          #|    -1 => self.head = entry.next
          #|    idx => self.entries[idx].unwrap().next = entry.next
          #|  }
          #|  match entry.next {
          #|    None => self.tail = entry.prev
          #|    Some(next) => next.prev = entry.prev
          #|  } }
        ),
      ),
      "shift_back": build(
        (
          #|fn[K, V] Map::shift_back(self : Map[K, V], idx : Int) -> Unit { let next = (idx + 1) & self.capacity_mask
          #|  match self.entries[next] {
          #|    None | Some({ psl: 0, .. }) => self.entries[idx] = None
          #|    Some(entry) => {
          #|      entry.psl -= 1
          #|      self.set_entry(entry, idx)
          #|      self.shift_back(next)
          #|    }
          #|  } }
        ),
      ),
      "grow": build(
        (
          #|fn[K : Hash + Eq, V] Map::grow(self : Map[K, V]) -> Unit { let old_head = self.head
          #|  let new_capacity = self.capacity << 1
          #|  self.entries = FixedArray::make(new_capacity, None)
          #|  self.capacity = new_capacity
          #|  self.capacity_mask = new_capacity - 1
          #|  self.grow_at = calc_grow_threshold(self.capacity)
          #|  self.size = 0
          #|  self.head = None
          #|  self.tail = -1
          #|  loop old_head {
          #|    Some({ next, key, value, .. }) => {
          #|      self.set(key, value)
          #|      continue next
          #|    }
          #|    None => break
          #|  } }
        ),
      ),
      "calc_grow_threshold": build(
        (
          #|fn calc_grow_threshold(capacity : Int) -> Int { capacity * 13 / 16 }
        ),
      ),
      "size": build(
        (
          #|pub fn[K, V] Map::size(self : Map[K, V]) -> Int { self.size }
        ),
      ),
      "capacity": build(
        (
          #|pub fn[K, V] Map::capacity(self : Map[K, V]) -> Int { self.capacity }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[K, V] Map::is_empty(self : Map[K, V]) -> Bool { self.size == 0 }
        ),
      ),
      "clear": build(
        (
          #|pub fn[K, V] Map::clear(self : Map[K, V]) -> Unit { self.entries.fill(None)
          #|  self.size = 0
          #|  self.head = None
          #|  self.tail = -1 }
        ),
      ),
      "iter": build(
        (
          #|pub fn[K, V] Map::iter(self : Map[K, V]) -> Iter[(K, V)] { Iter::new(yield_ => loop self.head {
          #|    Some({ key, value, next, .. }) => {
          #|      guard yield_((key, value)) is IterContinue else { break IterEnd }
          #|      continue next
          #|    }
          #|    None => break IterContinue
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[K, V] Map::iter2(self : Map[K, V]) -> Iter2[K, V] { Iter2::new(yield_ => loop self.head {
          #|    Some({ key, value, next, .. }) => {
          #|      guard yield_(key, value) is IterContinue else { break IterEnd }
          #|      continue next
          #|    }
          #|    None => IterContinue
          #|  }) }
        ),
      ),
      "keys": build(
        (
          #|pub fn[K, V] Map::keys(self : Map[K, V]) -> Iter[K] { Iter::new(yield_ => loop self.head {
          #|    Some({ key, next, .. }) => {
          #|      guard yield_(key) is IterContinue else { break IterEnd }
          #|      continue next
          #|    }
          #|    None => IterContinue
          #|  }) }
        ),
      ),
      "values": build(
        (
          #|pub fn[K, V] Map::values(self : Map[K, V]) -> Iter[V] { Iter::new(yield_ => loop self.head {
          #|    Some({ value, next, .. }) => {
          #|      guard yield_(value) is IterContinue else { break IterEnd }
          #|      continue next
          #|    }
          #|    None => IterContinue
          #|  }) }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[K, V] Map::to_array(self : Map[K, V]) -> Array[(K, V)] { let arr = Array::make_uninit(self.size)
          #|  let mut i = 0
          #|  loop self.head {
          #|    Some({ key, value, next, .. }) => {
          #|      arr.unsafe_set(i, (key, value))
          #|      i += 1
          #|      continue next
          #|    }
          #|    None => break
          #|  }
          #|  arr }
        ),
      ),
      "of": build(
        (
          #|pub fn[K : Hash + Eq, V] Map::of(arr : FixedArray[(K, V)]) -> Map[K, V] { let length = arr.length()
          #|  let m = Map::new(capacity=length)
          #|  // arr.iter((e) => { m.set(e.0, e.1) })
          #|  for i in 0..<length {
          #|    let e = arr[i]
          #|    m.set(e.0, e.1)
          #|  }
          #|  m }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[K : Hash + Eq, V] Map::from_iter(iter : Iter[(K, V)]) -> Map[K, V] { let m = {}
          #|  for e in iter {
          #|    m.set(e.0, e.1)
          #|  }
          #|  m }
        ),
      ),
      "map": build(
        (
          #|pub fn[K, V, V2] Map::map(self : Map[K, V], f : (K, V) -> V2) -> Map[K, V2] { // copy structure
          #|  let other = {
          #|    capacity: self.capacity,
          #|    entries: FixedArray::make(self.capacity, None),
          #|    size: self.size,
          #|    capacity_mask: self.capacity_mask,
          #|    grow_at: self.grow_at,
          #|    head: None,
          #|    tail: self.tail,
          #|  }
          #|  if self.size == 0 {
          #|    return other
          #|  }
          #|  guard self.entries[self.tail] is Some(last)
          #|  loop (last, self.tail, None) {
          #|    ({ prev, psl, hash, key, value, .. }, idx, next) => {
          #|      let new_value = f(key, value)
          #|      let new_entry = { prev, next, psl, hash, key, value: new_value }
          #|      other.entries[idx] = Some(new_entry)
          #|      if prev != -1 {
          #|        continue (self.entries[prev].unwrap(), prev, Some(new_entry))
          #|      } else {
          #|        other.head = Some(new_entry)
          #|      }
          #|    }
          #|  }
          #|  other }
        ),
      ),
      "copy": build(
        (
          #|pub fn[K, V] Map::copy(self : Map[K, V]) -> Map[K, V] { // copy structure
          #|  let other = {
          #|    capacity: self.capacity,
          #|    entries: FixedArray::make(self.capacity, None),
          #|    size: self.size,
          #|    capacity_mask: self.capacity_mask,
          #|    grow_at: self.grow_at,
          #|    head: None,
          #|    tail: self.tail,
          #|  }
          #|  if self.size == 0 {
          #|    return other
          #|  }
          #|  guard self.entries[self.tail] is Some(last)
          #|  loop (last, self.tail, None) {
          #|    ({ prev, psl, hash, key, value, .. }, idx, next) => {
          #|      let new_entry = { prev, next, psl, hash, key, value }
          #|      other.entries[idx] = Some(new_entry)
          #|      if prev != -1 {
          #|        continue (self.entries[prev].unwrap(), prev, Some(new_entry))
          #|      } else {
          #|        other.head = Some(new_entry)
          #|      }
          #|    }
          #|  }
          #|  other }
        ),
      ),
      "new": build(
        (
          #|pub fn StringBuilder::new(size_hint~ : Int = 0) -> StringBuilder { ignore(size_hint)
          #|  { val: \"\" } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn StringBuilder::is_empty(self : StringBuilder) -> Bool { self.val == \"\" }
        ),
      ),
      "char_to_string": build(
        (
          #|fn char_to_string(char : Char) -> String { [char] }
        ),
      ),
      "to_string": build(
        (
          #|pub fn StringBuilder::to_string(self : StringBuilder) -> String { self.val }
        ),
      ),
      "reset": build(
        (
          #|pub fn StringBuilder::reset(self : StringBuilder) -> Unit { self.val = \"\" }
        ),
      ),
      "op_lt": build(
        (
          #|pub fn[T : Compare] op_lt(self_ : T, other : T) -> Bool { self_.compare(other).is_neg() }
        ),
      ),
      "op_gt": build(
        (
          #|pub fn[T : Compare] op_gt(self_ : T, other : T) -> Bool { self_.compare(other).is_pos() }
        ),
      ),
      "op_le": build(
        (
          #|pub fn[T : Compare] op_le(self_ : T, other : T) -> Bool { self_.compare(other).is_non_pos() }
        ),
      ),
      "op_ge": build(
        (
          #|pub fn[T : Compare] op_ge(self_ : T, other : T) -> Bool { self_.compare(other).is_non_neg() }
        ),
      ),
      "op_notequal": build(
        (
          #|pub fn[T : Eq] op_notequal(x : T, y : T) -> Bool { !(x == y) }
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
          #|pub fn StringBuilder::is_empty(self : StringBuilder) -> Bool { self.len == 0 }
        ),
      ),
      "to_string": build(
        (
          #|pub fn StringBuilder::to_string(self : StringBuilder) -> String { self.data
          #|  .unsafe_reinterpret_as_bytes()
          #|  .to_unchecked_string(offset=0, length=self.len) }
        ),
      ),
      "reset": build(
        (
          #|pub fn StringBuilder::reset(self : StringBuilder) -> Unit { self.len = 0 }
        ),
      ),
      "fail": build(
        (
          #|pub fn[T] fail(msg : String, loc~ : SourceLoc) -> T raise Failure { raise Failure(\"\\{loc} FAILED: \\{msg}\") }
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
      "to_int64": build(
        (
          #|pub fn Double::to_int64(self : Double) -> Int64 { if self != self {
          #|    0
          #|  } else if self >= 9223372036854775807 {
          #|    9223372036854775807L
          #|  } else if self <= -9223372036854775808 {
          #|    -9223372036854775808L
          #|  } else {
          #|    self.to_unchecked_int64()
          #|  } }
        ),
      ),
      "to_uint64": build(
        (
          #|pub fn Double::to_uint64(self : Double) -> UInt64 { if self != self {
          #|    0
          #|  } else if self >= 9223372036854775807 {
          #|    18446744073709551615UL
          #|  } else if self <= 0 {
          #|    0UL
          #|  } else {
          #|    self.to_unchecked_uint64()
          #|  } }
        ),
      ),
      "to_json": build(
        (
          #|pub fn ArgsLoc::to_json(self : ArgsLoc) -> String { let buf = StringBuilder::new(size_hint=10)
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
          #|  buf.to_string() }
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
          #|pub fn Double::to_int(self : Double) -> Int { if self != self {
          #|    0
          #|  } else if self >= 2147483647 {
          #|    2147483647
          #|  } else if self <= -2147483648 {
          #|    -2147483648
          #|  } else {
          #|    self.to_unchecked_int()
          #|  } }
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
      "next_power_of_two": build(
        (
          #|pub fn Int::next_power_of_two(self : Int) -> Int { guard self >= 0
          #|  if self <= 1 {
          #|    return 1
          #|  }
          #|  // The largest power of 2 that fits in a 32-bit signed integer is 2^30
          #|  let max_power_of_two = 1073741824 // 2^30
          #|  if self > max_power_of_two {
          #|    return max_power_of_two
          #|  }
          #|  // 2147483647 is the largest value of an integer
          #|  (2147483647 >> ((self - 1).clz() - 1)) + 1 }
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
          #|pub fn Int::is_leading_surrogate(self : Int) -> Bool { 0xD800 <= self && self <= 0xDBFF }
        ),
      ),
      "is_trailing_surrogate": build(
        (
          #|pub fn Int::is_trailing_surrogate(self : Int) -> Bool { 0xDC00 <= self && self <= 0xDFFF }
        ),
      ),
      "is_surrogate": build(
        (
          #|pub fn Int::is_surrogate(self : Int) -> Bool { 0xD800 <= self && self <= 0xDFFF }
        ),
      ),
      "println": build(
        (
          #|pub fn[T : Show] println(input : T) -> Unit { println_mono(input.to_string()) }
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
      "debug_string": build(
        (
          #|fn[T : Show] debug_string(t : T) -> String { let buf = StringBuilder::new(size_hint=50)
          #|  t.output(buf)
          #|  buf.to_string() }
        ),
      ),
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
          #|pub fn Byte::to_string(self : Byte) -> String { let i = self.to_int()
          #|  let hi = alphabet(i / 16)
          #|  let lo = alphabet(i % 16)
          #|  \"b'\\\\x\\{hi}\\{lo}'\" }
        ),
      ),
      "lnot": build(
        (
          #|pub fn Byte::lnot(self : Byte) -> Byte { self.to_int().lnot().to_byte() }
        ),
      ),
      "to_uint": build(
        (
          #|pub fn Byte::to_uint(self : Byte) -> UInt { self.to_int().reinterpret_as_uint() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_byte_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/byte",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "to_uint64": build(
        (
          #|pub fn to_uint64(self : Byte) -> UInt64 { self.to_uint().to_uint64() }
        ),
      ),
      "popcnt": build(
        (
          #|pub fn popcnt(self : Byte) -> Int { let mut n = self
          #|  n = (n & 0x55) + ((n >> 1) & 0x55)
          #|  n = (n & 0x33) + ((n >> 2) & 0x33)
          #|  n = (n & 0x0F) + ((n >> 4) & 0x0F)
          #|  n.to_int() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_bytes_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bytes",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "gPRIME1": (None, String("0x9E3779B1")),
      "gPRIME2": (None, String("0x85EBCA77")),
      "gPRIME3": (None, String("0xC2B2AE3D")),
      "gPRIME4": (None, String("0x27D4EB2F")),
      "gPRIME5": (None, String("0x165667B1")),
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
      "length": build(
        (
          #|pub fn View::length(self : View) -> Int { self.len() }
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
          #|pub fn View::iter(self : View) -> Iter[Byte] { Iter::new(yield_ => for i in 0..<self.len() {
          #|    guard yield_(self[i]) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "to_uint_be": build(
        (
          #|pub fn View::to_uint_be(self : View) -> UInt { (self[0].to_uint() << 24) +
          #|  (self[1].to_uint() << 16) +
          #|  (self[2].to_uint() << 8) +
          #|  self[3].to_uint() }
        ),
      ),
      "to_uint_le": build(
        (
          #|pub fn View::to_uint_le(self : View) -> UInt { self[0].to_uint() +
          #|  (self[1].to_uint() << 8) +
          #|  (self[2].to_uint() << 16) +
          #|  (self[3].to_uint() << 24) }
        ),
      ),
      "to_uint64_be": build(
        (
          #|pub fn View::to_uint64_be(self : View) -> UInt64 { (self[0].to_uint().to_uint64() << 56) +
          #|  (self[1].to_uint().to_uint64() << 48) +
          #|  (self[2].to_uint().to_uint64() << 40) +
          #|  (self[3].to_uint().to_uint64() << 32) +
          #|  (self[4].to_uint().to_uint64() << 24) +
          #|  (self[5].to_uint().to_uint64() << 16) +
          #|  (self[6].to_uint().to_uint64() << 8) +
          #|  self[7].to_uint().to_uint64() }
        ),
      ),
      "to_uint64_le": build(
        (
          #|pub fn View::to_uint64_le(self : View) -> UInt64 { self[0].to_uint().to_uint64() +
          #|  (self[1].to_uint().to_uint64() << 8) +
          #|  (self[2].to_uint().to_uint64() << 16) +
          #|  (self[3].to_uint().to_uint64() << 24) +
          #|  (self[4].to_uint().to_uint64() << 32) +
          #|  (self[5].to_uint().to_uint64() << 40) +
          #|  (self[6].to_uint().to_uint64() << 48) +
          #|  (self[7].to_uint().to_uint64() << 56) }
        ),
      ),
      "to_int_be": build(
        (
          #|pub fn View::to_int_be(self : View) -> Int { self.to_uint_be().reinterpret_as_int() }
        ),
      ),
      "to_int_le": build(
        (
          #|pub fn View::to_int_le(self : View) -> Int { self.to_uint_le().reinterpret_as_int() }
        ),
      ),
      "to_int64_be": build(
        (
          #|pub fn View::to_int64_be(self : View) -> Int64 { self.to_uint64_be().reinterpret_as_int64() }
        ),
      ),
      "to_int64_le": build(
        (
          #|pub fn View::to_int64_le(self : View) -> Int64 { self.to_uint64_le().reinterpret_as_int64() }
        ),
      ),
      "to_float_be": build(
        (
          #|pub fn View::to_float_be(self : View) -> Float { self.to_uint_be().reinterpret_as_float() }
        ),
      ),
      "to_float_le": build(
        (
          #|pub fn View::to_float_le(self : View) -> Float { self.to_uint_le().reinterpret_as_float() }
        ),
      ),
      "to_double_be": build(
        (
          #|pub fn View::to_double_be(self : View) -> Double { self.to_uint64_be().reinterpret_as_double() }
        ),
      ),
      "to_double_le": build(
        (
          #|pub fn View::to_double_le(self : View) -> Double { self.to_uint64_le().reinterpret_as_double() }
        ),
      ),
      "data": build(
        (
          #|pub fn View::data(self : View) -> Bytes { self.bytes() }
        ),
      ),
      "start_offset": build(
        (
          #|pub fn View::start_offset(self : View) -> Int { self.start() }
        ),
      ),
      "to_bytes": build(
        (
          #|pub fn View::to_bytes(self : View) -> Bytes { if self.len() == 0 && self.len() == self.bytes().length() {
          #|    return self.bytes()
          #|  }
          #|  let bytes = FixedArray::make(self.len(), (0 : Byte))
          #|  bytes.blit_from_bytes(0, self.bytes(), self.start_offset(), self.len())
          #|  unsafe_to_bytes(bytes) }
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
          #|pub fn to_array(self : Bytes) -> Array[Byte] { let len = self.length()
          #|  let rv = Array::make(len, b'0')
          #|  for i in 0..<len {
          #|    rv[i] = self[i]
          #|  }
          #|  rv }
        ),
      ),
      "iter": build(
        (
          #|pub fn iter(self : Bytes) -> Iter[Byte] { Iter::new(yield_ => for i in 0..<self.length() {
          #|    if yield_(self[i]) == IterEnd {
          #|      break IterEnd
          #|    }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn iter2(self : Bytes) -> Iter2[Int, Byte] { Iter2::new(yield_ => for i in 0..<self.length() {
          #|    if yield_(i, self[i]) == IterEnd {
          #|      break IterEnd
          #|    }
          #|  } else {
          #|    IterContinue
          #|  }) }
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
          #|pub fn default() -> Bytes { b\"\" }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_char_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/char",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "is_ascii": build(
        (
          #|pub fn Char::is_ascii(self : Self) -> Bool { self is ('\\u{00}'..='\\u{7F}') }
        ),
      ),
      "is_ascii_alphabetic": build(
        (
          #|pub fn Char::is_ascii_alphabetic(self : Self) -> Bool { self is ('A'..='Z' | 'a'..='z') }
        ),
      ),
      "is_ascii_control": build(
        (
          #|pub fn Char::is_ascii_control(self : Self) -> Bool { self is ('\\u{00}'..='\\u{1F}' | '\\u{7F}') }
        ),
      ),
      "is_ascii_digit": build(
        (
          #|pub fn Char::is_ascii_digit(self : Self) -> Bool { self is ('0'..='9') }
        ),
      ),
      "is_ascii_graphic": build(
        (
          #|pub fn Char::is_ascii_graphic(self : Self) -> Bool { self is ('\\u{21}'..='\\u{7E}') }
        ),
      ),
      "is_ascii_hexdigit": build(
        (
          #|pub fn Char::is_ascii_hexdigit(self : Self) -> Bool { self is ('0'..='9' | 'A'..='F' | 'a'..='f') }
        ),
      ),
      "is_ascii_lowercase": build(
        (
          #|pub fn Char::is_ascii_lowercase(self : Self) -> Bool { self is ('a'..='z') }
        ),
      ),
      "is_ascii_octdigit": build(
        (
          #|pub fn Char::is_ascii_octdigit(self : Self) -> Bool { self is ('0'..='7') }
        ),
      ),
      "is_ascii_punctuation": build(
        (
          #|pub fn Char::is_ascii_punctuation(self : Self) -> Bool { self
          #|  is ('\\u{21}'..='\\u{2F}'
          #|  | '\\u{3A}'..='\\u{40}'
          #|  | '\\u{5B}'..='\\u{60}'
          #|  | '\\u{7B}'..='\\u{7E}') }
        ),
      ),
      "is_ascii_uppercase": build(
        (
          #|pub fn Char::is_ascii_uppercase(self : Self) -> Bool { self is ('A'..='Z') }
        ),
      ),
      "is_ascii_whitespace": build(
        (
          #|pub fn Char::is_ascii_whitespace(self : Self) -> Bool { self is ('\\u{20}' | '\\u{09}' | '\\u{0A}' | '\\u{0B}' | '\\u{0C}' | '\\u{0D}') }
        ),
      ),
      "is_control": build(
        (
          #|pub fn Char::is_control(self : Self) -> Bool { self is ('\\u0000'..='\\u001F' | '\\u007F'..='\\u009F') }
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
          #|pub fn Char::is_whitespace(self : Self) -> Bool { self
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
          #|  | '\\u3000') }
        ),
      ),
      "is_numeric": build(
        (
          #|pub fn Char::is_numeric(self : Self) -> Bool { self
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
          #|  | '\\u{1FBF0}'..='\\u{1FBF9}') }
        ),
      ),
      "is_printable": build(
        (
          #|pub fn Char::is_printable(self : Self) -> Bool { // Check for control characters (Cc)
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
          #|  true }
        ),
      ),
      "to_ascii_lowercase": build(
        (
          #|pub fn Char::to_ascii_lowercase(self : Self) -> Char { if self.is_ascii_uppercase() {
          #|    return (self.to_int() + 32).unsafe_to_char()
          #|  }
          #|  self }
        ),
      ),
      "to_ascii_uppercase": build(
        (
          #|pub fn Char::to_ascii_uppercase(self : Self) -> Char { if self.is_ascii_lowercase() {
          #|    return (self.to_int() - 32).unsafe_to_char()
          #|  }
          #|  self }
        ),
      ),
      "char_to_string": build(
        (
          #|fn char_to_string(char : Char) -> String { [char] }
        ),
      ),
      "utf16_len": build(
        (
          #|pub fn Char::utf16_len(self : Self) -> Int { let code = self.to_int()
          #|  if code <= 0xFFFF {
          #|    1
          #|  } else {
          #|    2
          #|  } }
        ),
      ),
      "is_bmp": build(
        (
          #|pub fn Char::is_bmp(self : Self) -> Bool { self.to_int() <= 0xFFFF }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_cmp_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/cmp",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "maximum_by_key": build(
        (
          #|pub fn[T, K : Compare] maximum_by_key(x : T, y : T, f : (T) -> K) -> T { if f(x) > f(y) {
          #|    x
          #|  } else {
          #|    y
          #|  } }
        ),
      ),
      "minimum_by_key": build(
        (
          #|pub fn[T, K : Compare] minimum_by_key(x : T, y : T, f : (T) -> K) -> T { if f(x) > f(y) {
          #|    y
          #|  } else {
          #|    x
          #|  } }
        ),
      ),
      "maximum": build(
        (
          #|pub fn[T : Compare] maximum(x : T, y : T) -> T { if x > y {
          #|    x
          #|  } else {
          #|    y
          #|  } }
        ),
      ),
      "minimum": build(
        (
          #|pub fn[T : Compare] minimum(x : T, y : T) -> T { if x > y {
          #|    y
          #|  } else {
          #|    x
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_deque_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/deque",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/string": moonbitlang_core_string_module,
  },
  fn(_env, build) {
    {
      "pop_front_exn": build(
        (
          #|pub fn[A] pop_front_exn(self : T[A]) -> Unit { self.unsafe_pop_front() }
        ),
      ),
      "pop_back_exn": build(
        (
          #|pub fn[A] pop_back_exn(self : T[A]) -> Unit { self.unsafe_pop_back() }
        ),
      ),
      "filter_map_inplace": build(
        (
          #|pub fn[A] filter_map_inplace(self : T[A], f : (A) -> A?) -> Unit { self.retain_map(f) }
        ),
      ),
      "new": build(
        (
          #|pub fn[A] new(capacity~ : Int = 0) -> T[A] { T::{ buf: UninitializedArray::make(capacity), len: 0, head: 0, tail: 0 } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A] from_array(arr : Array[A]) -> T[A] { let deq = T::{
          #|    buf: UninitializedArray::make(arr.length()),
          #|    len: arr.length(),
          #|    head: 0,
          #|    tail: arr.length() - 1,
          #|  }
          #|  for i in 0..<arr.length() {
          #|    deq.buf[i] = arr[i]
          #|  }
          #|  deq }
        ),
      ),
      "copy": build(
        (
          #|pub fn[A] copy(self : T[A]) -> T[A] { let len = self.len
          #|  let deq = T::{
          #|    buf: UninitializedArray::make(len),
          #|    len,
          #|    head: 0,
          #|    tail: len - 1,
          #|  }
          #|  for i, x in self {
          #|    deq.buf[i] = x
          #|  }
          #|  deq }
        ),
      ),
      "of": build(
        (
          #|pub fn[A] of(arr : FixedArray[A]) -> T[A] { let deq = T::{
          #|    buf: UninitializedArray::make(arr.length()),
          #|    len: arr.length(),
          #|    head: 0,
          #|    tail: arr.length() - 1,
          #|  }
          #|  for i in 0..<arr.length() {
          #|    deq.buf[i] = arr[i]
          #|  }
          #|  deq }
        ),
      ),
      "length": build(
        (
          #|pub fn[A] length(self : T[A]) -> Int { self.len }
        ),
      ),
      "capacity": build(
        (
          #|pub fn[A] capacity(self : T[A]) -> Int { self.buf.length() }
        ),
      ),
      "realloc": build(
        (
          #|fn[A] realloc(self : T[A]) -> Unit { let old_cap = self.len
          #|  let new_cap = if old_cap == 0 { 8 } else { old_cap * 2 }
          #|  let new_buf = UninitializedArray::make(new_cap)
          #|  if old_cap > 0 {
          #|    if self.tail >= self.head {
          #|      for i = self.head, j = 0; i <= self.tail; i = i + 1, j = j + 1 {
          #|        new_buf[j] = self.buf[i]
          #|      }
          #|    } else {
          #|      let mut j = 0
          #|      for i in self.head..<self.buf.length() {
          #|        new_buf[j] = self.buf[i]
          #|        j += 1
          #|      }
          #|      for i in 0..=self.tail {
          #|        new_buf[j] = self.buf[i]
          #|        j += 1
          #|      }
          #|    }
          #|    self.tail = self.len - 1
          #|  } else {
          #|    self.tail = 0
          #|  }
          #|  self.head = 0
          #|  self.buf = new_buf }
        ),
      ),
      "front": build(
        (
          #|pub fn[A] front(self : T[A]) -> A? { if self.len == 0 {
          #|    None
          #|  } else {
          #|    Some(self.buf[self.head])
          #|  } }
        ),
      ),
      "back": build(
        (
          #|pub fn[A] back(self : T[A]) -> A? { if self.len == 0 {
          #|    None
          #|  } else {
          #|    Some(self.buf[self.tail])
          #|  } }
        ),
      ),
      "push_front": build(
        (
          #|pub fn[A] push_front(self : T[A], value : A) -> Unit { if self.len == self.buf.length() {
          #|    self.realloc()
          #|  }
          #|  if self.len != 0 {
          #|    self.head = (self.head + self.buf.length() - 1) % self.buf.length()
          #|  }
          #|  self.buf[self.head] = value
          #|  self.len += 1 }
        ),
      ),
      "push_back": build(
        (
          #|pub fn[A] push_back(self : T[A], value : A) -> Unit { if self.len == self.buf.length() {
          #|    self.realloc()
          #|  }
          #|  if self.len != 0 {
          #|    self.tail = (self.tail + self.buf.length() + 1) % self.buf.length()
          #|  }
          #|  self.buf[self.tail] = value
          #|  self.len += 1 }
        ),
      ),
      "unsafe_pop_front": build(
        (
          #|pub fn[A] unsafe_pop_front(self : T[A]) -> Unit { match self.len {
          #|    0 => abort(\"The deque is empty!\")
          #|    1 => {
          #|      set_null(self.buf, self.head)
          #|      self.len -= 1
          #|    }
          #|    _ => {
          #|      set_null(self.buf, self.head)
          #|      self.head = if self.head < self.buf.length() - 1 {
          #|        self.head + 1
          #|      } else {
          #|        0
          #|      }
          #|      self.len -= 1
          #|    }
          #|  } }
        ),
      ),
      "unsafe_pop_back": build(
        (
          #|pub fn[A] unsafe_pop_back(self : T[A]) -> Unit { match self.len {
          #|    0 => abort(\"The deque is empty!\")
          #|    1 => {
          #|      set_null(self.buf, self.tail)
          #|      self.len -= 1
          #|    }
          #|    _ => {
          #|      set_null(self.buf, self.tail)
          #|      self.tail = if self.tail > 0 {
          #|        self.tail - 1
          #|      } else {
          #|        self.buf.length() - 1
          #|      }
          #|      self.len -= 1
          #|    }
          #|  } }
        ),
      ),
      "pop_front": build(
        (
          #|pub fn[A] pop_front(self : T[A]) -> A? { match self.len {
          #|    0 => None
          #|    1 => {
          #|      let origin_head = self.buf[self.head]
          #|      set_null(self.buf, self.head)
          #|      self.len -= 1
          #|      Some(origin_head)
          #|    }
          #|    _ => {
          #|      let origin_head = self.buf[self.head]
          #|      set_null(self.buf, self.head)
          #|      self.head = if self.head < self.buf.length() - 1 {
          #|        self.head + 1
          #|      } else {
          #|        0
          #|      }
          #|      self.len -= 1
          #|      Some(origin_head)
          #|    }
          #|  } }
        ),
      ),
      "pop_back": build(
        (
          #|pub fn[A] pop_back(self : T[A]) -> A? { match self.len {
          #|    0 => None
          #|    1 => {
          #|      let origin_back = self.buf[self.tail]
          #|      set_null(self.buf, self.tail)
          #|      self.len -= 1
          #|      Some(origin_back)
          #|    }
          #|    _ => {
          #|      let origin_back = self.buf[self.tail]
          #|      set_null(self.buf, self.tail)
          #|      self.tail = if self.tail > 0 {
          #|        self.tail - 1
          #|      } else {
          #|        self.buf.length() - 1
          #|      }
          #|      self.len -= 1
          #|      Some(origin_back)
          #|    }
          #|  } }
        ),
      ),
      "op_get": build(
        (
          #|pub fn[A] op_get(self : T[A], index : Int) -> A { if index < 0 || index >= self.len {
          #|    let len = self.len
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{len} but the index is \\{index}\",
          #|    )
          #|  }
          #|  if self.head + index < self.buf.length() {
          #|    self.buf[self.head + index]
          #|  } else {
          #|    self.buf[self.head + index - self.buf.length()]
          #|  } }
        ),
      ),
      "op_set": build(
        (
          #|pub fn[A] op_set(self : T[A], index : Int, value : A) -> Unit { if index < 0 || index >= self.len {
          #|    let len = self.len
          #|    abort(
          #|      \"index out of bounds: the len is from 0 to \\{len} but the index is \\{index}\",
          #|    )
          #|  }
          #|  if self.head + index < self.buf.length() {
          #|    self.buf[self.head + index] = value
          #|  } else {
          #|    self.buf[self.head + index - self.buf.length()] = value
          #|  } }
        ),
      ),
      "as_views": build(
        (
          #|pub fn[A] T::as_views(self : T[A]) -> (@array.View[A], @array.View[A]) { guard self.len != 0 else { ([][:], [][:]) }
          #|  let { buf, head, len, .. } = self
          #|  let cap = buf.length()
          #|  let head_len = cap - head
          #|  if head_len >= len {
          #|    (buf[head:head + len], [][:])
          #|  } else {
          #|    (buf[head:cap], buf[:len - head_len])
          #|  } }
        ),
      ),
      "each": build(
        (
          #|pub fn[A] each(self : T[A], f : (A) -> Unit) -> Unit { for v in self {
          #|    f(v)
          #|  } }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[A] eachi(self : T[A], f : (Int, A) -> Unit) -> Unit { for i, v in self {
          #|    f(i, v)
          #|  } }
        ),
      ),
      "rev_each": build(
        (
          #|pub fn[A] rev_each(self : T[A], f : (A) -> Unit) -> Unit { for v in self.rev_iter() {
          #|    f(v)
          #|  } }
        ),
      ),
      "rev_eachi": build(
        (
          #|pub fn[A] rev_eachi(self : T[A], f : (Int, A) -> Unit) -> Unit { for i, v in self.rev_iter2() {
          #|    f(i, v)
          #|  } }
        ),
      ),
      "clear": build(
        (
          #|pub fn[A] clear(self : T[A]) -> Unit { let { head, buf, len, .. } = self
          #|  let cap = buf.length()
          #|  let head_len = cap - head
          #|  if head_len >= len {
          #|    for i in head..<(head + len) {
          #|      set_null(buf, i)
          #|    }
          #|  } else {
          #|    for i in head..<cap {
          #|      set_null(buf, i)
          #|    }
          #|    for i in 0..<(len - head_len) {
          #|      set_null(buf, i)
          #|    }
          #|  }
          #|  self.len = 0
          #|  self.head = 0
          #|  self.tail = 0 }
        ),
      ),
      "map": build(
        (
          #|pub fn[A, U] map(self : T[A], f : (A) -> U) -> T[U] { if self.len == 0 {
          #|    new()
          #|  } else {
          #|    let buf : UninitializedArray[U] = UninitializedArray::make(self.len)
          #|    for i in 0..<self.len {
          #|      buf[i] = f(self.buf[i])
          #|    }
          #|    T::{ buf, len: self.len, head: 0, tail: self.len - 1 }
          #|  } }
        ),
      ),
      "mapi": build(
        (
          #|pub fn[A, U] mapi(self : T[A], f : (Int, A) -> U) -> T[U] { if self.len == 0 {
          #|    new()
          #|  } else {
          #|    let buf : UninitializedArray[U] = UninitializedArray::make(self.len)
          #|    for i in 0..<self.len {
          #|      buf[i] = f(i, self.buf[i])
          #|    }
          #|    T::{ buf, len: self.len, head: 0, tail: self.len - 1 }
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[A] is_empty(self : T[A]) -> Bool { self.len == 0 }
        ),
      ),
      "search": build(
        (
          #|pub fn[A : Eq] search(self : T[A], value : A) -> Int? { for i in 0..<self.len {
          #|    if self.buf[i] == value {
          #|      return Some(i)
          #|    }
          #|  }
          #|  None }
        ),
      ),
      "contains": build(
        (
          #|pub fn[A : Eq] contains(self : T[A], value : A) -> Bool { self.iter().contains(value) }
        ),
      ),
      "reserve_capacity": build(
        (
          #|pub fn[A] reserve_capacity(self : T[A], capacity : Int) -> Unit { if self.capacity() >= capacity {
          #|    return
          #|  }
          #|  let new_buf : UninitializedArray[A] = UninitializedArray::make(capacity)
          #|  let { buf, len, head, .. } = self
          #|  self.buf = new_buf
          #|  self.head = 0
          #|  self.tail = 0
          #|  for i in 0..<len {
          #|    let idx = (head + i) % buf.length()
          #|    self.buf[i] = buf[idx]
          #|    self.tail += 1
          #|  } }
        ),
      ),
      "shrink_to_fit": build(
        (
          #|pub fn[A] shrink_to_fit(self : T[A]) -> Unit { if self.capacity() <= self.length() {
          #|    return
          #|  }
          #|  let { buf, len, head, .. } = self
          #|  self.buf = UninitializedArray::make(len)
          #|  self.head = 0
          #|  self.tail = 0
          #|  for i in 0..<len {
          #|    let idx = (head + i) % buf.length()
          #|    self.buf[i] = buf[idx]
          #|  } }
        ),
      ),
      "truncate": build(
        (
          #|pub fn[A] truncate(self : T[A], len : Int) -> Unit { guard len >= 0 && len < self.len else { return }
          #|  if len == 0 {
          #|    self.clear()
          #|    return
          #|  }
          #|  let { head, buf, .. } = self
          #|  let (front, back) = self.as_views()
          #|  if front.length() < len {
          #|    // `len` is wrapping around the end of the buffer.
          #|    // Thus, we need to drop the latter part of the back view.
          #|    self.len = len
          #|    let start = len - front.length()
          #|    self.tail = start - 1
          #|    for i in start..<back.length() {
          #|      set_null(buf, i)
          #|    }
          #|  } else {
          #|    // `len` is not wrapping around the end of the buffer. Thus, we need to drop:
          #|    // - The latter part of the front view;
          #|    // - The entire back view.
          #|    self.len = len
          #|    let start = head + len
          #|    self.tail = start - 1
          #|    for i in start..<self.buf.length() {
          #|      set_null(buf, i)
          #|    }
          #|    for i in 0..<back.length() {
          #|      set_null(buf, i)
          #|    }
          #|  } }
        ),
      ),
      "retain_map": build(
        (
          #|pub fn[A] retain_map(self : T[A], f : (A) -> A?) -> Unit { guard !self.is_empty() else { return }
          #|  let { head, buf, .. } = self
          #|  let cap = buf.length()
          #|  let head_len = cap - head
          #|  let mut idx = head
          #|  let (front, back) = self.as_views()
          #|  for cur in front {
          #|    if f(cur) is Some(v) {
          #|      buf[idx] = v
          #|      idx += 1
          #|    }
          #|  }
          #|  if back.length() == 0 {
          #|    self.truncate(idx - head)
          #|    return
          #|  }
          #|  for cur in back {
          #|    if idx == cap {
          #|      idx = 0
          #|    }
          #|    if f(cur) is Some(v) {
          #|      buf[idx] = v
          #|      idx += 1
          #|    }
          #|  }
          #|  if idx <= self.len - head_len {
          #|    self.truncate(idx + head_len)
          #|  } else {
          #|    self.truncate(idx - head)
          #|  } }
        ),
      ),
      "retain": build(
        (
          #|pub fn[A] retain(self : T[A], f : (A) -> Bool) -> Unit { guard !self.is_empty() else { return }
          #|  let { head, buf, .. } = self
          #|  let cap = buf.length()
          #|  let head_len = cap - head
          #|  let mut idx = head
          #|  let (front, back) = self.as_views()
          #|  for cur in front {
          #|    if f(cur) {
          #|      buf[idx] = cur
          #|      idx += 1
          #|    }
          #|  }
          #|  if back.length() == 0 {
          #|    self.truncate(idx - head)
          #|    return
          #|  }
          #|  for cur in back {
          #|    if idx == cap {
          #|      idx = 0
          #|    }
          #|    if f(cur) {
          #|      buf[idx] = cur
          #|      idx += 1
          #|    }
          #|  }
          #|  if idx <= self.len - head_len {
          #|    self.truncate(idx + head_len)
          #|  } else {
          #|    self.truncate(idx - head)
          #|  } }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A] iter(self : T[A]) -> Iter[A] { Iter::new(yield_ => {
          #|    guard !self.is_empty() else { IterContinue }
          #|    let { head, buf, len, .. } = self
          #|    let cap = buf.length()
          #|    let head_len = cap - head
          #|    if head_len >= len {
          #|      for i in head..<(head + len) {
          #|        guard yield_(buf[i]) is IterContinue else { return IterEnd }
          #|      }
          #|    } else {
          #|      for i in head..<cap {
          #|        guard yield_(buf[i]) is IterContinue else { return IterEnd }
          #|      }
          #|      for i in 0..<(len - head_len) {
          #|        guard yield_(buf[i]) is IterContinue else { return IterEnd }
          #|      }
          #|    }
          #|    IterContinue
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[A] iter2(self : T[A]) -> Iter2[Int, A] { Iter2::new(yield_ => {
          #|    guard !self.is_empty() else { IterContinue }
          #|    let { head, buf, len, .. } = self
          #|    let cap = buf.length()
          #|    let head_len = cap - head
          #|    let mut j = 0
          #|    if head_len >= len {
          #|      for i in head..<(head + len) {
          #|        guard yield_(j, buf[i]) is IterContinue else { return IterEnd }
          #|        j += 1
          #|      }
          #|    } else {
          #|      for i in head..<cap {
          #|        guard yield_(j, buf[i]) is IterContinue else { return IterEnd }
          #|        j += 1
          #|      }
          #|      for i in 0..<(len - head_len) {
          #|        guard yield_(j, buf[i]) is IterContinue else { return IterEnd }
          #|        j += 1
          #|      }
          #|    }
          #|    IterContinue
          #|  }) }
        ),
      ),
      "rev_iter": build(
        (
          #|pub fn[A] rev_iter(self : T[A]) -> Iter[A] { Iter::new(yield_ => {
          #|    guard !self.is_empty() else { IterContinue }
          #|    let { head, buf, len, .. } = self
          #|    let cap = buf.length()
          #|    let head_len = cap - head
          #|    if head_len >= len {
          #|      for i = head + len - 1; i >= head; i = i - 1 {
          #|        guard yield_(buf[i]) is IterContinue else { return IterEnd }
          #|      }
          #|    } else {
          #|      for i = len - head_len - 1; i >= 0; i = i - 1 {
          #|        guard yield_(buf[i]) is IterContinue else { return IterEnd }
          #|      }
          #|      for i = cap - 1; i >= head; i = i - 1 {
          #|        guard yield_(buf[i]) is IterContinue else { return IterEnd }
          #|      }
          #|    }
          #|    IterContinue
          #|  }) }
        ),
      ),
      "rev_iter2": build(
        (
          #|pub fn[A] rev_iter2(self : T[A]) -> Iter2[Int, A] { Iter2::new(yield_ => {
          #|    guard !self.is_empty() else { IterContinue }
          #|    let { head, buf, len, .. } = self
          #|    let cap = buf.length()
          #|    let head_len = cap - head
          #|    let mut j = 0
          #|    if head_len >= len {
          #|      for i = head + len - 1; i >= head; i = i - 1 {
          #|        guard yield_(j, buf[i]) is IterContinue else { return IterEnd }
          #|        j += 1
          #|      }
          #|    } else {
          #|      for i = len - head_len - 1; i >= 0; i = i - 1 {
          #|        guard yield_(j, buf[i]) is IterContinue else { return IterEnd }
          #|        j += 1
          #|      }
          #|      for i = cap - 1; i >= head; i = i - 1 {
          #|        guard yield_(j, buf[i]) is IterContinue else { return IterEnd }
          #|        j += 1
          #|      }
          #|    }
          #|    IterContinue
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A] from_iter(iter : Iter[A]) -> T[A] { let dq = new()
          #|  iter.each(e => dq.push_back(e))
          #|  dq }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[A] to_array(self : T[A]) -> Array[A] { let len = self.length()
          #|  if len == 0 {
          #|    []
          #|  } else {
          #|    let xs = Array::make(len, self[0])
          #|    for i in 0..<len {
          #|      xs[i] = self[i]
          #|    }
          #|    xs
          #|  } }
        ),
      ),
      "join": build(
        (
          #|pub fn T::join(self : T[String], separator : @string.View) -> String { let str = separator.to_string()
          #|  self.iter().join(str) }
        ),
      ),
      "flatten": build(
        (
          #|pub fn[A] T::flatten(self : T[T[A]]) -> T[A] { let mut len = 0
          #|  for deque in self {
          #|    len += deque.length()
          #|  }
          #|  let target = T::{
          #|    buf: UninitializedArray::make(len),
          #|    len,
          #|    head: 0,
          #|    tail: len - 1,
          #|  }
          #|  let mut i = 0
          #|  for deque in self {
          #|    let cap = deque.buf.length()
          #|    let head_len = cap - deque.head
          #|    target.buf.unsafe_blit(i, deque.buf, deque.head, head_len)
          #|    if head_len < deque.len {
          #|      target.buf.unsafe_blit(i + head_len, deque.buf, 0, deque.len - head_len)
          #|    }
          #|    i += deque.len
          #|  }
          #|  target }
        ),
      ),
      "drain": build(
        (
          #|pub fn[A] T::drain(self : T[A], start~ : Int, len? : Int) -> T[A] { let len = match len {
          #|    Some(l) => if l > self.len { self.len } else { l }
          #|    None => self.len - start
          #|  }
          #|  if len == 0 {
          #|    return new()
          #|  }
          #|  let deque = T::{
          #|    buf: UninitializedArray::make(len),
          #|    len,
          #|    head: 0,
          #|    tail: len - 1,
          #|  }
          #|  let cap = self.buf.length()
          #|  let start_idx = (self.head + start) % cap
          #|  let start_len = cap - start_idx
          #|  // copy to deque
          #|  if start_len < len {
          #|    deque.buf.unsafe_blit(0, self.buf, start_idx, start_len)
          #|    deque.buf.unsafe_blit(start_len, self.buf, 0, len - start_len)
          #|    for i in 0..<start_len {
          #|      set_null(self.buf, (start_idx + i) % cap)
          #|    }
          #|    for i in 0..<(len - start_len) {
          #|      set_null(self.buf, i)
          #|    }
          #|  } else {
          #|    deque.buf.unsafe_blit(0, self.buf, start_idx, len)
          #|    for i in 0..<len {
          #|      set_null(self.buf, start_idx + i)
          #|    }
          #|  }
          #|  // move self
          #|  // TODO: use blit
          #|  let new_head = self.head + len
          #|  for i = start - 1; i >= 0; i = i - 1 {
          #|    self.buf[(new_head + i) % cap] = self.buf[(self.head + i) % cap]
          #|    set_null(self.buf, (self.head + i) % cap)
          #|  }
          #|  self.head = new_head % cap
          #|  self.len -= len
          #|  deque }
        ),
      ),
      "binary_search_by": build(
        (
          #|pub fn[A] binary_search_by(self : T[A], cmp : (A) -> Int) -> Result[Int, Int] { let len = self.len
          #|  // Functional loop with two evolving bounds `i` (inclusive) and `j` (exclusive).
          #|  // `continue new_i, new_j` updates the pair for the next iteration, eliminating
          #|  // the need for mutable variables.
          #|  for i = 0, j = len; i < j; {
          #|    let h = i + (j - i) / 2
          #|    let ord = cmp(self[h])
          #|    if ord < 0 {
          #|      // Search the right half
          #|      continue h + 1, j
          #|    } else {
          #|      // ord == 0 (match) or ord > 0 (too large): keep searching left half to
          #|      // guarantee we land on the left-most occurrence.
          #|      continue i, h
          #|    }
          #|  } else {
          #|    // When the loop finishes, `i == j`.  If the deque is non-empty and the
          #|    // element at `i` matches, we found the left-most index; otherwise `i` is
          #|    // the correct insertion point.
          #|    if i < len && cmp(self[i]) == 0 {
          #|      Ok(i)
          #|    } else {
          #|      Err(i)
          #|    }
          #|  } }
        ),
      ),
      "get": build(
        (
          #|pub fn[A] get(self : T[A], index : Int) -> A? { if index >= 0 && index < self.len {
          #|    let physical_index = (self.head + index) % self.buf.length()
          #|    Some(self.buf[physical_index])
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "binary_search": build(
        (
          #|pub fn[A : Compare] binary_search(self : T[A], value : A) -> Result[Int, Int] { self.binary_search_by(x => x.compare(value)) }
        ),
      ),
      "rev_inplace": build(
        (
          #|pub fn[A] T::rev_inplace(self : T[A]) -> Unit { guard self.len > 0 else { return }
          #|  let cap = self.buf.length()
          #|  let mut left = self.head
          #|  let mut right = self.tail
          #|  for _ in 0..<(self.len / 2) {
          #|    let temp = self.buf[left]
          #|    self.buf[left] = self.buf[right]
          #|    self.buf[right] = temp
          #|    left = (left + 1) % cap
          #|    right = (right - 1 + cap) % cap
          #|  } }
        ),
      ),
      "rev": build(
        (
          #|pub fn[A] T::rev(self : T[A]) -> T[A] { let len = self.len
          #|  let new_buf = UninitializedArray::make(len)
          #|  // Copy elements in reverse order
          #|  for i in 0..<len {
          #|    let src_idx = (self.head + len - i - 1) % self.buf.length()
          #|    new_buf[i] = self.buf[src_idx]
          #|  }
          #|  // Create new deque with reversed elements
          #|  T::{ buf: new_buf, len, head: 0, tail: if len == 0 { 0 } else { len - 1 } } }
        ),
      ),
      "shuffle_in_place": build(
        (
          #|pub fn[A] T::shuffle_in_place(self : T[A], rand~ : (Int) -> Int) -> Unit { let n = self.len
          #|  let buf_length = self.buf.length()
          #|  for i = n - 1; i > 0; i = i - 1 {
          #|    let j = rand(i + 1)
          #|    // Calculate circular buffer positions
          #|    let i_pos = (self.head + i) % buf_length
          #|    let j_pos = (self.head + j) % buf_length
          #|    // Swap elements
          #|    let tmp = self.buf[i_pos]
          #|    self.buf[i_pos] = self.buf[j_pos]
          #|    self.buf[j_pos] = tmp
          #|  } }
        ),
      ),
      "shuffle": build(
        (
          #|pub fn[A] shuffle(self : T[A], rand~ : (Int) -> Int) -> T[A] { // Create a copy of the original deque
          #|  let new_deque = self.copy()
          #|  // Shuffle the copy in place
          #|  new_deque.shuffle_in_place(rand~)
          #|  // Return the shuffled copy
          #|  new_deque }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_double_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/double",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/int64": moonbitlang_core_int64_module,
    "moonbitlang/core/uint64": moonbitlang_core_uint64_module,
    "moonbitlang/core/double/internal/ryu": moonbitlang_core_double_internal_ryu_module,
  },
  fn(_env, build) {
    {
      "sinh": build(
        (
          #|pub fn Double::sinh(self : Double) -> Double { if self.is_nan() || self.is_inf() {
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
          #|  self * shuge }
        ),
      ),
      "cosh": build(
        (
          #|pub fn Double::cosh(self : Double) -> Double { if self.is_nan() {
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
          #|  infinity }
        ),
      ),
      "tanh": build(
        (
          #|pub fn Double::tanh(self : Double) -> Double { if self.is_nan() {
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
          #|  } }
        ),
      ),
      "asinh": build(
        (
          #|pub fn Double::asinh(self : Double) -> Double { if self.is_nan() || self.is_inf() {
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
          #|  } }
        ),
      ),
      "acosh": build(
        (
          #|pub fn Double::acosh(self : Double) -> Double { let one = 1.0
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
          #|  } }
        ),
      ),
      "atanh": build(
        (
          #|pub fn Double::atanh(self : Double) -> Double { let hx : Int = get_high_word(self).reinterpret_as_int()
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
          #|pub fn Double::sin(self : Double) -> Double { if self.is_inf() || self.is_nan() {
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
          #|  } }
        ),
      ),
      "cos": build(
        (
          #|pub fn Double::cos(self : Double) -> Double { if self.is_inf() || self.is_nan() {
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
          #|  } }
        ),
      ),
      "tan": build(
        (
          #|pub fn Double::tan(self : Double) -> Double { if self.is_inf() || self.is_nan() {
          #|    return not_a_number
          #|  }
          #|  let y = Array::make(2, 0.0)
          #|  let z = 0.0
          #|  if self.abs() <= PI_OVER_4 {
          #|    __kernal_tan(self, z, 1)
          #|  } else {
          #|    let n = rem_pio2(self, y)
          #|    __kernal_tan(y[0], y[1], 1 - ((n & 1) << 1))
          #|  } }
        ),
      ),
      "asin": build(
        (
          #|pub fn Double::asin(self : Double) -> Double { let huge = 1.0e+300
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
          #|  } }
        ),
      ),
      "acos": build(
        (
          #|pub fn Double::acos(self : Double) -> Double { let one : Double = 1.0
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
          #|  } }
        ),
      ),
      "atan": build(
        (
          #|pub fn Double::atan(self : Double) -> Double { if self.is_nan() || self == 0.0 {
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
          #|  } }
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
      "exp_bias": (None, Int(1023)),
      "exp_bits": (None, Int(11)),
      "frac_bits": (None, Int(52)),
      "trunc": build(
        (
          #|pub fn Double::trunc(self : Double) -> Double { let u64 = self.reinterpret_as_uint64()
          #|  let biased_exp = ((u64 >> frac_bits) & ((0x1UL << exp_bits) - 1)).to_int()
          #|  if biased_exp < exp_bias {
          #|    return (u64 & sign_mask).reinterpret_as_double()
          #|  } else if biased_exp >= exp_bias + frac_bits {
          #|    return self
          #|  }
          #|  let mask_shift = biased_exp - exp_bias + exp_bits
          #|  let trunc_mask = (sign_mask.reinterpret_as_int64() >> mask_shift).reinterpret_as_uint64()
          #|  return (u64 & trunc_mask).reinterpret_as_double() }
        ),
      ),
      "ceil": build(
        (
          #|pub fn Double::ceil(self : Double) -> Double { let trunced = self.trunc()
          #|  if self > trunced {
          #|    return trunced + 1.0
          #|  } else {
          #|    return trunced
          #|  } }
        ),
      ),
      "floor": build(
        (
          #|pub fn Double::floor(self : Double) -> Double { let trunced = self.trunc()
          #|  if self < trunced {
          #|    return trunced - 1.0
          #|  } else {
          #|    return trunced
          #|  } }
        ),
      ),
      "round": build(
        (
          #|pub fn Double::round(self : Double) -> Double { floor(self + 0.5) }
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
          #|pub fn signum(self : Double) -> Double { if self < 0.0 {
          #|    -1.0
          #|  } else if self > 0.0 {
          #|    1.0
          #|  } else {
          #|    self // handles 0.0, -0.0, NaN
          #|  } }
        ),
      ),
      "is_nan": build(
        (
          #|pub fn is_nan(self : Double) -> Bool { // only NaNs satisfy f != f.
          #|  self != self }
        ),
      ),
      "is_inf": build(
        (
          #|pub fn is_inf(self : Double) -> Bool { self > max_value || self < min_value }
        ),
      ),
      "is_pos_inf": build(
        (
          #|pub fn is_pos_inf(self : Double) -> Bool { self > max_value }
        ),
      ),
      "is_neg_inf": build(
        (
          #|pub fn is_neg_inf(self : Double) -> Bool { self < min_value }
        ),
      ),
      "to_string": build(
        (
          #|pub fn to_string(self : Double) -> String { @ryu.ryu_to_string(self) }
        ),
      ),
      "to_be_bytes": build(
        (
          #|pub fn to_be_bytes(self : Double) -> Bytes { self.reinterpret_as_uint64().to_be_bytes() }
        ),
      ),
      "to_le_bytes": build(
        (
          #|pub fn to_le_bytes(self : Double) -> Bytes { self.reinterpret_as_uint64().to_le_bytes() }
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
          #|pub fn Double::nan() -> Double { not_a_number }
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
          #|pub fn Double::min_normal() -> Double { min_positive }
        ),
      ),
      "exp": build(
        (
          #|pub fn Double::exp(self : Double) -> Double { fn get_high_word(x : Double) -> UInt {
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
          #|  } }
        ),
      ),
      "expm1": build(
        (
          #|pub fn Double::expm1(self : Double) -> Double { if self.is_nan() {
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
          #|  y }
        ),
      ),
      "round": build(
        (
          #|pub fn Double::round(self : Double) -> Double { floor(self + 0.5) }
        ),
      ),
      "to_uint": build(
        (
          #|pub fn to_uint(self : Double) -> UInt { if self != self {
          #|    0
          #|  } else if self >= 4294967295.0 {
          #|    4294967295U
          #|  } else if self <= 0 {
          #|    0
          #|  } else {
          #|    UInt::trunc_double(self)
          #|  } }
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
      "sqrt2": (
        None,
        String(
          "1.41421356237309504880168872420969807856967187537694807317667974",
        ),
      ),
      "ln2": (
        None,
        String(
          "0.693147180559945309417232121458176568075500134360255254120680009",
        ),
      ),
      "ln2_hi": (
        None,
        String("6.93147180369123816490e-01 // 3fe62e42 fee00000"),
      ),
      "ln2_lo": (
        None,
        String("1.90821492927058770002e-10 // 3dea39ef 35793c76"),
      ),
      "l1": (None, String("6.666666666666735130e-01 // 3FE55555 55555593")),
      "l2": (None, String("3.999999999940941908e-01 // 3FD99999 9997FA04")),
      "l3": (None, String("2.857142874366239149e-01 // 3FD24924 94229359")),
      "l4": (None, String("2.222219843214978396e-01 // 3FCC71C5 1D8E78AF")),
      "l5": (None, String("1.818357216161805012e-01 // 3FC74664 96CB03DE")),
      "l6": (None, String("1.531383769920937332e-01 // 3FC39A09 D078C69F")),
      "l7": (None, String("1.479819860511658591e-01 // 3FC2F112 DF3E5244")),
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
          #|pub fn Double::ln(self : Double) -> Double { if self < 0.0 {
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
          #|  k * ln2_hi - (hfsq - (s * (hfsq + r) + k * ln2_lo) - f) }
        ),
      ),
      "log2": build(
        (
          #|pub fn Double::log2(self : Double) -> Double { let (f, e) = frexp(self)
          #|  if f == 0.5 {
          #|    return e.to_double() - 1.0
          #|  }
          #|  ln(f) / ln2 + e.to_double() }
        ),
      ),
      "log10": build(
        (
          #|pub fn Double::log10(self : Double) -> Double { if self < 0.0 {
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
          #|  z + e * log10_2hi }
        ),
      ),
      "ln_1p": build(
        (
          #|pub fn Double::ln_1p(self : Double) -> Double { if self < -1.0 || self.is_nan() {
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
          #|  } }
        ),
      ),
      "cbrt": build(
        (
          #|pub fn Double::cbrt(self : Double) -> Double { if self.is_inf() || self.is_nan() || self == 0.0 {
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
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_double_internal_ryu_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/double/internal/ryu",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/bool": moonbitlang_core_bool_module,
  },
  fn(_env, build) {
    {
      "string_from_bytes": build(
        (
          #|fn string_from_bytes(bytes : FixedArray[Byte], from : Int, to : Int) -> String { let buf = StringBuilder::new(size_hint=bytes.length())
          #|  for i in from..<to {
          #|    buf.write_char(bytes[i].to_char())
          #|  }
          #|  buf.to_string() }
        ),
      ),
      "umul128": build(
        (
          #|fn umul128(a : UInt64, b : UInt64) -> (UInt64, UInt64) { let aLo = a & 0xffffffff
          #|  let aHi = a >> 32
          #|  let bLo = b & 0xffffffff
          #|  let bHi = b >> 32
          #|  let x = aLo * bLo
          #|  let y = aHi * bLo + (x >> 32)
          #|  let z = aLo * bHi + (y & 0xffffffff)
          #|  let w = aHi * bHi + (y >> 32) + (z >> 32)
          #|  let lo = a * b
          #|  let hi = w
          #|  (lo, hi) }
        ),
      ),
      "shiftright128": build(
        (
          #|fn shiftright128(lo : UInt64, hi : UInt64, dist : Int) -> UInt64 { (hi << (64 - dist)) | (lo >> dist) }
        ),
      ),
      "pow5Factor": build(
        (
          #|fn pow5Factor(value : UInt64) -> Int { // We want to find the largest power of 5 that divides value.
          #|  if value % 5UL != 0UL {
          #|    return 0
          #|  }
          #|  if value % 25UL != 0UL {
          #|    return 1
          #|  }
          #|  if value % 125UL != 0UL {
          #|    return 2
          #|  }
          #|  if value % 625UL != 0UL {
          #|    return 3
          #|  }
          #|  let mut count = 4
          #|  let mut value = value / 625UL
          #|  while value > 0UL {
          #|    if value % 5UL != 0UL {
          #|      return count
          #|    }
          #|    value = value / 5UL
          #|    count = count + 1
          #|  }
          #|  abort(\"IllegalArgumentException \\{value}\") }
        ),
      ),
      "multipleOfPowerOf5": build(
        (
          #|fn multipleOfPowerOf5(value : UInt64, p : Int) -> Bool { pow5Factor(value) >= p }
        ),
      ),
      "multipleOfPowerOf2": build(
        (
          #|fn multipleOfPowerOf2(value : UInt64, p : Int) -> Bool { (value & ((1UL << p) - 1UL)) == 0UL }
        ),
      ),
      "gPOW5_TABLE_SIZE": (None, Int(26)),
      "double_computePow5": build(
        (
          #|fn double_computePow5(i : Int) -> (UInt64, UInt64) { let base = i / gPOW5_TABLE_SIZE
          #|  let base2 = base * gPOW5_TABLE_SIZE
          #|  let offset = i - base2
          #|  let mul0 = gDOUBLE_POW5_SPLIT2[base * 2]
          #|  let mul1 = gDOUBLE_POW5_SPLIT2[base * 2 + 1]
          #|  if offset == 0 {
          #|    return (mul0, mul1)
          #|  }
          #|  let m : UInt64 = gDOUBLE_POW5_TABLE[offset]
          #|  let (low1, high1) = umul128(m, mul1)
          #|  let (low0, high0) = umul128(m, mul0)
          #|  let sum : UInt64 = high0 + low1
          #|  let mut high1 = high1
          #|  if sum < high0 {
          #|    high1 = high1 + 1UL
          #|  }
          #|  let delta : Int = pow5bits(i) - pow5bits(base2)
          #|  let a = shiftright128(low0, sum, delta) +
          #|    ((gPOW5_OFFSETS[i / 16] >> ((i % 16) << 1)) & 3).to_uint64()
          #|  let b = shiftright128(sum, high1, delta)
          #|  (a, b) }
        ),
      ),
      "double_computeInvPow5": build(
        (
          #|fn double_computeInvPow5(i : Int) -> (UInt64, UInt64) { let base = (i + gPOW5_TABLE_SIZE - 1) / gPOW5_TABLE_SIZE
          #|  let base2 = base * gPOW5_TABLE_SIZE
          #|  let offset = base2 - i
          #|  let mul0 = gDOUBLE_POW5_INV_SPLIT2[base * 2]
          #|  let mul1 = gDOUBLE_POW5_INV_SPLIT2[base * 2 + 1]
          #|  if offset == 0 {
          #|    return (mul0, mul1)
          #|  }
          #|  let m = gDOUBLE_POW5_TABLE[offset]
          #|  let (low1, high1) = umul128(m, mul1)
          #|  let (low0, high0) = umul128(m, mul0)
          #|  let sum = high0 + low1
          #|  let mut high1 = high1
          #|  if sum < high0 {
          #|    high1 = high1 + 1
          #|  }
          #|  let delta : Int = pow5bits(base2) - pow5bits(i)
          #|  let a = shiftright128(low0, sum, delta) +
          #|    1 +
          #|    ((gPOW5_INV_OFFSETS[i / 16] >> ((i % 16) << 1)) & 3).to_uint64()
          #|  let b = shiftright128(sum, high1, delta)
          #|  (a, b) }
        ),
      ),
      "decimal_length17": build(
        (
          #|fn decimal_length17(v : UInt64) -> Int { // This is slightly faster than a loop.
          #|  // The average output length is 16.38 digits, so we check high-to-low.
          #|  // Function precondition: v is not an 18, 19, or 20-digit number.
          #|  // (17 digits are sufficient for round-tripping.)
          #|  if v >= 10000000000000000 {
          #|    return 17
          #|  }
          #|  if v >= 1000000000000000 {
          #|    return 16
          #|  }
          #|  if v >= 100000000000000 {
          #|    return 15
          #|  }
          #|  if v >= 10000000000000 {
          #|    return 14
          #|  }
          #|  if v >= 1000000000000 {
          #|    return 13
          #|  }
          #|  if v >= 100000000000 {
          #|    return 12
          #|  }
          #|  if v >= 10000000000 {
          #|    return 11
          #|  }
          #|  if v >= 1000000000 {
          #|    return 10
          #|  }
          #|  if v >= 100000000 {
          #|    return 9
          #|  }
          #|  if v >= 10000000 {
          #|    return 8
          #|  }
          #|  if v >= 1000000 {
          #|    return 7
          #|  }
          #|  if v >= 100000 {
          #|    return 6
          #|  }
          #|  if v >= 10000 {
          #|    return 5
          #|  }
          #|  if v >= 1000 {
          #|    return 4
          #|  }
          #|  if v >= 100 {
          #|    return 3
          #|  }
          #|  if v >= 10 {
          #|    return 2
          #|  }
          #|  return 1 }
        ),
      ),
      "d2d": build(
        (
          #|fn d2d(ieeeMantissa : UInt64, ieeeExponent : UInt) -> FloatingDecimal64 { let mut e2 : Int = 0
          #|  let mut m2 : UInt64 = 0
          #|  if ieeeExponent == 0 {
          #|    // Denormal number - no implicit leading 1, and the exponent is 1, not 0.
          #|    e2 = 1 - gDOUBLE_BIAS - gDOUBLE_MANTISSA_BITS - 2
          #|    m2 = ieeeMantissa
          #|  } else {
          #|    // Add implicit leading 1.
          #|    e2 = ieeeExponent.reinterpret_as_int() -
          #|      gDOUBLE_BIAS -
          #|      gDOUBLE_MANTISSA_BITS -
          #|      2
          #|    m2 = (1UL << gDOUBLE_MANTISSA_BITS) | ieeeMantissa
          #|  }
          #|  let even = (m2 & 1UL) == 0UL
          #|  let mv = 4UL *
          #|    // Step 2: Determine the interval of valid decimal representations.
          #|    m2
          #|  // Implicit bool -> int conversion. True is 1, false is 0.
          #|  let mmShift = ieeeMantissa != 0UL || ieeeExponent <= 1
          #|  // We would compute mp and mm like this:
          #|  // uint64_t mp = 4 * m2 + 2;
          #|  // uint64_t mm = mv - 1 - mmShift;
          #|  // Step 3: Convert to a decimal power base using 128-bit arithmetic.
          #|  let mut vr = 0UL
          #|  let mut vp = 0UL
          #|  let mut vm = 0UL
          #|  let mut e10 : Int = 0
          #|  let mut vmIsTrailingZeros = false
          #|  let mut vrIsTrailingZeros = false
          #|  if e2 >= 0 {
          #|    // I tried special-casing q == 0, but there was no effect on performance.
          #|    // This expression is slightly faster than max(0, log10Pow2(e2) - 1).
          #|    let q : Int = log10Pow2(e2) - (e2 > 3).to_int()
          #|    e10 = q
          #|    let k = gDOUBLE_POW5_INV_BITCOUNT + pow5bits(q) - 1
          #|    let i = -e2 + q + k
          #|    let pow5 = double_computeInvPow5(q)
          #|    let vs = mulShiftAll64(m2, pow5, i, mmShift)
          #|    vr = vs.0
          #|    vp = vs.1
          #|    vm = vs.2
          #|    if q <= 21 {
          #|      // This should use q <= 22, but I think 21 is also safe. Smaller values
          #|      // may still be safe, but it's more difficult to reason about them.
          #|      // Only one of mp, mv, and mm can be a multiple of 5, if any.
          #|      let mvMod5 : Int = mv.to_int() - 5 * (mv / 5UL).to_int()
          #|      if mvMod5 == 0 {
          #|        vrIsTrailingZeros = multipleOfPowerOf5(mv, q)
          #|      } else if even {
          #|        // Same as min(e2 + (~mm & 1), pow5Factor(mm)) >= q
          #|        // <=> e2 + (~mm & 1) >= q && pow5Factor(mm) >= q
          #|        // <=> true && pow5Factor(mm) >= q, since e2 >= q.
          #|        vmIsTrailingZeros = multipleOfPowerOf5(
          #|          mv - 1UL - mmShift.to_uint64(),
          #|          q,
          #|        )
          #|      } else {
          #|        vp = vp - multipleOfPowerOf5(mv + 2UL, q).to_uint64()
          #|      }
          #|    }
          #|  } else {
          #|    // This expression is slightly faster than max(0, log10Pow5(-e2) - 1).
          #|    let q : Int = log10Pow5(-e2) - (-e2 > 1).to_int()
          #|    e10 = q + e2
          #|    let i : Int = -e2 - q
          #|    let k = pow5bits(i) - gDOUBLE_POW5_BITCOUNT
          #|    let j = q - k
          #|    let pow5 = double_computePow5(i)
          #|    let vs = mulShiftAll64(m2, pow5, j, mmShift)
          #|    vr = vs.0
          #|    vp = vs.1
          #|    vm = vs.2
          #|    if q <= 1 {
          #|      // {vr,vp,vm} is trailing zeros if {mv,mp,mm} has at least q trailing 0 bits.
          #|      // mv = 4 * m2, so it always has at least two trailing 0 bits.
          #|      vrIsTrailingZeros = true
          #|      if even {
          #|        vmIsTrailingZeros = mmShift.to_int() == 1
          #|      } else {
          #|        vp = vp - 1
          #|      }
          #|    } else if q < 63 {
          #|      vrIsTrailingZeros = multipleOfPowerOf2(mv, q)
          #|    }
          #|  }
          #|  // Step 4: Find the shortest decimal representation in the interval of valid representations.
          #|  let mut removed : Int = 0
          #|  let mut lastRemovedDigit : Int = 0
          #|  let mut output : UInt64 = 0UL
          #|  // On average, we remove ~2 digits.
          #|  if vmIsTrailingZeros || vrIsTrailingZeros {
          #|    // General case, which happens rarely (~0.7%).
          #|    while true {
          #|      let vpDiv10 = vp / 10
          #|      let vmDiv10 = vm / 10
          #|      if vpDiv10 <= vmDiv10 {
          #|        break
          #|      }
          #|      let vmMod10 : Int = vm.to_int() - 10 * vmDiv10.to_int()
          #|      let vrDiv10 = vr / 10
          #|      let vrMod10 : Int = vr.to_int() - 10 * vrDiv10.to_int()
          #|      vmIsTrailingZeros = vmIsTrailingZeros && vmMod10 == 0
          #|      vrIsTrailingZeros = vrIsTrailingZeros && lastRemovedDigit == 0
          #|      lastRemovedDigit = vrMod10
          #|      vr = vrDiv10
          #|      vp = vpDiv10
          #|      vm = vmDiv10
          #|      removed = removed + 1
          #|    }
          #|    if vmIsTrailingZeros {
          #|      while true {
          #|        let vmDiv10 = vm / 10
          #|        let vmMod10 : Int = vm.to_int() - 10 * vmDiv10.to_int()
          #|        if vmMod10 != 0 {
          #|          break
          #|        }
          #|        let vpDiv10 = vp / 10
          #|        let vrDiv10 = vr / 10
          #|        let vrMod10 : Int = vr.to_int() - 10 * vrDiv10.to_int()
          #|        vrIsTrailingZeros = vrIsTrailingZeros && lastRemovedDigit == 0
          #|        lastRemovedDigit = vrMod10
          #|        vr = vrDiv10
          #|        vp = vpDiv10
          #|        vm = vmDiv10
          #|        removed = removed + 1
          #|      }
          #|    }
          #|    if vrIsTrailingZeros && lastRemovedDigit == 5 && vr % 2 == 0 {
          #|      lastRemovedDigit = 4
          #|    }
          #|    output = vr +
          #|      ((vr == vm && (!even || !vmIsTrailingZeros)) || lastRemovedDigit >= 5)
          #|      .to_int64()
          #|      .reinterpret_as_uint64()
          #|  } else {
          #|    // Specialized for the common case (~99.3%). Percentages below are relative to this.
          #|    let mut roundUp = false
          #|    let vpDiv100 = vp / 100
          #|    let vmDiv100 = vm / 100
          #|    if vpDiv100 > vmDiv100 {
          #|      let vrDiv100 = vr / 100
          #|      let vrMod100 : Int = vr.to_int() - 100 * vrDiv100.to_int()
          #|      roundUp = vrMod100 >= 50
          #|      vr = vrDiv100
          #|      vp = vpDiv100
          #|      vm = vmDiv100
          #|      removed = removed + 2
          #|    }
          #|    // Loop iterations below (approximately), without optimization above:
          #|    // 0: 0.03%, 1: 13.8%, 2: 70.6%, 3: 14.0%, 4: 1.40%, 5: 0.14%, 6+: 0.02%
          #|    // Loop iterations below (approximately), with optimization above:
          #|    // 0: 70.6%, 1: 27.8%, 2: 1.40%, 3: 0.14%, 4+: 0.02%
          #|    while true {
          #|      let vpDiv10 = vp / 10
          #|      let vmDiv10 = vm / 10
          #|      if vpDiv10 <= vmDiv10 {
          #|        break
          #|      }
          #|      let vrDiv10 = vr / 10
          #|      let vrMod10 : Int = vr.to_int() - 10 * vrDiv10.to_int()
          #|      roundUp = vrMod10 >= 5
          #|      vr = vrDiv10
          #|      vp = vpDiv10
          #|      vm = vmDiv10
          #|      removed = removed + 1
          #|    }
          #|    output = vr + (vr == vm || roundUp).to_uint64()
          #|  }
          #|  let exp : Int = e10 + removed
          #|  let fd : FloatingDecimal64 = { mantissa: output, exponent: exp }
          #|  fd }
        ),
      ),
      "to_chars": build(
        (
          #|fn to_chars(v : FloatingDecimal64, sign : Bool) -> String { // Step 5: Print the decimal representation.
          #|  let result = FixedArray::make(25, Byte::default())
          #|  let mut index : Int = 0
          #|  if sign {
          #|    result[index] = b'-'
          #|    index += 1
          #|  }
          #|  let mut output = v.mantissa
          #|  let olength = decimal_length17(output)
          #|  let mut exp : Int = v.exponent + olength - 1
          #|  let scientificNotation = !(exp >= -6 && exp < 21)
          #|  if scientificNotation {
          #|    // Print the decimal digits.
          #|    for i in 0..<(olength - 1) {
          #|      let c = output % 10
          #|      output /= 10
          #|      // 48 is ASCII '0', the same applies below.
          #|      result[index + olength - i] = (48 + c.to_int()).to_byte()
          #|    }
          #|    result[index] = (48 + output.to_int() % 10).to_byte()
          #|    if olength > 1 {
          #|      result[index + 1] = b'.'
          #|    } else {
          #|      // If there are no decimals, suppress .0
          #|      index -= 1
          #|    }
          #|    index += olength + 1
          #|    // Print the exponent.
          #|    result[index] = b'e'
          #|    index += 1
          #|    if exp < 0 {
          #|      result[index] = b'-'
          #|      index += 1
          #|      exp = -exp
          #|    } else {
          #|      result[index] = b'+'
          #|      index += 1
          #|    }
          #|    if exp >= 100 {
          #|      let a = exp / 100
          #|      let b = exp / 10 % 10
          #|      let c = exp % 10
          #|      result[index + 0] = (48 + a).to_byte()
          #|      result[index + 1] = (48 + b).to_byte()
          #|      result[index + 2] = (48 + c).to_byte()
          #|      index += 3
          #|    } else if exp >= 10 {
          #|      let a = exp / 10
          #|      let b = exp % 10
          #|      result[index + 0] = (48 + a).to_byte()
          #|      result[index + 1] = (48 + b).to_byte()
          #|      index += 2
          #|    } else {
          #|      result[index] = (48 + exp).to_byte()
          #|      index += 1
          #|    }
          #|    string_from_bytes(result, 0, index)
          #|  } else {
          #|    // Otherwise follow the ECMAScript spec.
          #|    if exp < 0 {
          #|      // Decimal dot is before any of the digits.
          #|      result[index] = b'0'
          #|      index += 1
          #|      result[index] = b'.'
          #|      index += 1
          #|      for i = -1; i > exp; i = i - 1 {
          #|        result[index] = b'0'
          #|        index += 1
          #|      }
          #|      let current = index
          #|      for i in 0..<olength {
          #|        result[current + olength - i - 1] = (48 + (output % 10).to_int()).to_byte()
          #|        output /= 10
          #|        index += 1
          #|      }
          #|    } else if exp + 1 >= olength {
          #|      // Decimal dot is after any of the digits.
          #|      for i in 0..<olength {
          #|        result[index + olength - i - 1] = (48 + (output % 10).to_int()).to_byte()
          #|        output /= 10
          #|      }
          #|      index += olength
          #|      for i in olength..<(exp + 1) {
          #|        result[index] = b'0'
          #|        index += 1
          #|      }
          #|    } else {
          #|      // Decimal dot is somewhere between the digits.
          #|      let mut current = index + 1
          #|      for i in 0..<olength {
          #|        if olength - i - 1 == exp {
          #|          result[current + olength - i - 1] = b'.'
          #|          current -= 1
          #|        }
          #|        result[current + olength - i - 1] = (48 + (output % 10).to_int()).to_byte()
          #|        output /= 10
          #|      }
          #|      index += olength + 1
          #|    }
          #|    return string_from_bytes(result, 0, index)
          #|  } }
        ),
      ),
      "ryu_to_string": build(
        (
          #|pub fn ryu_to_string(val : Double) -> String { if val == 0.0 {
          #|    return \"0\"
          #|  }
          #|  // Step 1: Decode the floating-point number, and unify normalized and subnormal cases.
          #|  let bits : UInt64 = val.reinterpret_as_uint64()
          #|  // Decode bits into sign, mantissa, and exponent.
          #|  let ieeeSign = (
          #|      (bits >> (gDOUBLE_MANTISSA_BITS + gDOUBLE_EXPONENT_BITS)) & 1UL
          #|    ) !=
          #|    0UL
          #|  let ieeeMantissa : UInt64 = bits & ((1UL << gDOUBLE_MANTISSA_BITS) - 1UL)
          #|  let ieeeExponent : Int = ((bits >> gDOUBLE_MANTISSA_BITS) &
          #|  ((1UL << gDOUBLE_EXPONENT_BITS) - 1UL)).to_int()
          #|  if ieeeExponent == (1 << gDOUBLE_EXPONENT_BITS) - 1 ||
          #|    (ieeeExponent == 0 && ieeeMantissa == 0UL) {
          #|    return copy_special_str(ieeeSign, ieeeExponent != 0, ieeeMantissa != 0UL)
          #|  }
          #|  let mut v : FloatingDecimal64 = { mantissa: 0UL, exponent: 0 }
          #|  let small = d2d_small_int(ieeeMantissa, ieeeExponent)
          #|  match small {
          #|    Some(f) => {
          #|      let mut x = f
          #|      while true {
          #|        let q : UInt64 = x.mantissa / 10
          #|        let r = x.mantissa - 10UL * q
          #|        if r != 0 {
          #|          break
          #|        }
          #|        x = { mantissa: q, exponent: x.exponent + 1 }
          #|      }
          #|      v = x
          #|    }
          #|    None => v = d2d(ieeeMantissa, ieeeExponent.reinterpret_as_uint())
          #|  }
          #|  to_chars(v, ieeeSign) }
        ),
      ),
      "pow5bits": build(
        (
          #|fn pow5bits(e : Int) -> Int { ((e * 1217359).reinterpret_as_uint() >> 19).reinterpret_as_int() + 1 }
        ),
      ),
      "copy_special_str": build(
        (
          #|fn copy_special_str(sign : Bool, exponent : Bool, mantissa : Bool) -> String { if mantissa {
          #|    return \"NaN\"
          #|  }
          #|  let s = if sign { \"-\" } else { \"\" }
          #|  if exponent {
          #|    return s + \"Infinity\"
          #|  }
          #|  return s + \"0.0\" }
        ),
      ),
      "log10Pow5": build(
        (
          #|fn log10Pow5(e : Int) -> Int { ((e * 732923).reinterpret_as_uint() >> 20).reinterpret_as_int() }
        ),
      ),
      "log10Pow2": build(
        (
          #|fn log10Pow2(e : Int) -> Int { ((e * 78913).reinterpret_as_uint() >> 18).reinterpret_as_int() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_env_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/env",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "args": build(
        (
          #|pub fn args() -> Array[String] { get_cli_args_internal() }
        ),
      ),
      "now": build(
        (
          #|pub fn now() -> UInt64 { now_internal() }
        ),
      ),
      "current_dir": build(
        (
          #|pub fn current_dir() -> String? { current_dir_internal() }
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
          #|fn get_cli_args_internal() -> Array[String] { let args = get_cli_args_ffi()
          #|  string_array_from_extern(args) }
        ),
      ),
      "current_dir_internal": build(
        (
          #|fn current_dir_internal() -> String? { let dir = current_dir_ffi()
          #|  let dir = string_from_extern(dir)
          #|  if dir == \"\" {
          #|    None
          #|  } else {
          #|    Some(dir)
          #|  } }
        ),
      ),
      "get_cli_args_internal": build(
        (
          #|fn get_cli_args_internal() -> Array[String] { let tmp = get_cli_args_ffi()
          #|  let res = Array::new(capacity=tmp.length())
          #|  for i in 0..<tmp.length() {
          #|    res.push(utf8_bytes_to_mbt_string(tmp[i]))
          #|  }
          #|  res }
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
          #|fn now_internal() -> UInt64 { // time returns seconds since 1970-01-01 00:00:00 UTC
          #|  // to be consistent with other backends, we convert to milliseconds
          #|  time(0) * 1000 }
        ),
      ),
      "current_dir_internal": build(
        (
          #|fn current_dir_internal() -> String? { // TODO: On Windows getcwd may fail if the path is too long(Windows allows paths up to 32k characters)
          #|  let buf = Bytes::new(4096)
          #|  let res = getcwd(buf, buf.length())
          #|  if res == 0 {
          #|    None
          #|  } else {
          #|    Some(utf8_bytes_to_mbt_string(buf))
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_float_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/float",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/double": moonbitlang_core_double_module,
    "moonbitlang/core/uint": moonbitlang_core_uint_module,
  },
  fn(_env, build) {
    {
      "exp_bias": (None, Int(127)),
      "exp_bits": (None, Int(8)),
      "frac_bits": (None, Int(23)),
      "trunc": build(
        (
          #|pub fn Float::trunc(self : Float) -> Float { let u32 = self.reinterpret_as_uint()
          #|  let biased_exp = ((u32 >> frac_bits) & ((0x1U << exp_bits) - 1)).reinterpret_as_int()
          #|  if biased_exp < exp_bias {
          #|    return (u32 & sign_mask).reinterpret_as_float()
          #|  } else if biased_exp >= exp_bias + frac_bits {
          #|    return self
          #|  }
          #|  let mask_shift = biased_exp - exp_bias + exp_bits
          #|  let trunc_mask = (sign_mask.reinterpret_as_int() >> mask_shift).reinterpret_as_uint()
          #|  return (u32 & trunc_mask).reinterpret_as_float() }
        ),
      ),
      "ceil": build(
        (
          #|pub fn Float::ceil(self : Float) -> Float { let trunced = self.trunc()
          #|  if self > trunced {
          #|    return trunced + 1.0
          #|  } else {
          #|    return trunced
          #|  } }
        ),
      ),
      "floor": build(
        (
          #|pub fn Float::floor(self : Float) -> Float { let trunced = self.trunc()
          #|  if self < trunced {
          #|    return trunced - 1.0
          #|  } else {
          #|    return trunced
          #|  } }
        ),
      ),
      "round": build(
        (
          #|pub fn Float::round(self : Float) -> Float { floor(self + 0.5) }
        ),
      ),
      "default": build(
        (
          #|pub fn default() -> Float { 0.0 }
        ),
      ),
      "to_be_bytes": build(
        (
          #|pub fn to_be_bytes(self : Float) -> Bytes { self.reinterpret_as_uint().to_be_bytes() }
        ),
      ),
      "to_le_bytes": build(
        (
          #|pub fn to_le_bytes(self : Float) -> Bytes { self.reinterpret_as_uint().to_le_bytes() }
        ),
      ),
      "is_inf": build(
        (
          #|pub fn is_inf(self : Float) -> Bool { self.is_pos_inf() || self.is_neg_inf() }
        ),
      ),
      "is_pos_inf": build(
        (
          #|pub fn is_pos_inf(self : Float) -> Bool { self > max_value }
        ),
      ),
      "is_neg_inf": build(
        (
          #|pub fn is_neg_inf(self : Float) -> Bool { self < min_value }
        ),
      ),
      "is_nan": build(
        (
          #|pub fn is_nan(self : Float) -> Bool { self != self }
        ),
      ),
      "cbrt": build(
        (
          #|pub fn Float::cbrt(self : Float) -> Float { let b1 : UInt = 709958130 // B1 = (127-127.0/3-0.03306235651)*2**23 */
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
          #|  t.to_float() }
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
          #|pub fn Float::exp(self : Float) -> Float { let xd = self.to_double()
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
          #|  y.to_float() }
        ),
      ),
      "expm1": build(
        (
          #|pub fn Float::expm1(self : Float) -> Float { let float_ln2_hi : Float = 6.9314575195e-01 // 0x3f317200
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
          #|  } }
        ),
      ),
      "sinh": build(
        (
          #|pub fn Float::sinh(self : Float) -> Float { let x = self
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
          #|  h * k_expo2f(absx) * 2.0 }
        ),
      ),
      "cosh": build(
        (
          #|pub fn Float::cosh(self : Float) -> Float { let mut x = self
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
          #|  k_expo2f(x) }
        ),
      ),
      "tanh": build(
        (
          #|pub fn Float::tanh(self : Float) -> Float { let x = self
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
          #|  } }
        ),
      ),
      "asinh": build(
        (
          #|pub fn Float::asinh(self : Float) -> Float { let x = self
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
          #|  } }
        ),
      ),
      "acosh": build(
        (
          #|pub fn Float::acosh(self : Float) -> Float { let x = self
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
          #|  return x.ln() + ln2 }
        ),
      ),
      "atanh": build(
        (
          #|pub fn Float::atanh(self : Float) -> Float { let x = self
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
          #|  } }
        ),
      ),
      "ln": build(
        (
          #|pub fn Float::ln(self : Float) -> Float { let mut ix : UInt = self.reinterpret_as_uint()
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
          #|  y.to_float() }
        ),
      ),
      "ln_1p": build(
        (
          #|pub fn Float::ln_1p(self : Float) -> Float { let lg1_f : Float = 0.66666662693
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
          #|  s * (hfsq + r) + (dk * float_ln2_lo + c) - hfsq + f + dk * float_ln2_hi }
        ),
      ),
      "sin": build(
        (
          #|pub fn Float::sin(self : Float) -> Float { let x = self
          #|  if x.is_nan() || x.is_inf() {
          #|    return not_a_number
          #|  }
          #|  if x == 0.0 {
          #|    return x
          #|  }
          #|  let (x, q) = trig_reduce(x, SIN_SWITCHOVER)
          #|  sin_cos_core(x, q) }
        ),
      ),
      "cos": build(
        (
          #|pub fn Float::cos(self : Float) -> Float { let x = self
          #|  if x.is_nan() || x.is_inf() {
          #|    return not_a_number
          #|  }
          #|  if x == 0.0 {
          #|    return 1.0
          #|  }
          #|  let (x, q) = trig_reduce(x, COS_SWITCHOVER)
          #|  sin_cos_core(x, q + 1) }
        ),
      ),
      "tan": build(
        (
          #|pub fn Float::tan(self : Float) -> Float { let x = self
          #|  if x.is_nan() || x.is_inf() {
          #|    return not_a_number
          #|  }
          #|  if x == 0.0 {
          #|    return x
          #|  }
          #|  let (x, q) = trig_reduce(x, COS_SWITCHOVER)
          #|  tanf_poly(x, (q & 1) != 0) }
        ),
      ),
      "asin": build(
        (
          #|pub fn Float::asin(self : Float) -> Float { let x = self
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
          #|  } }
        ),
      ),
      "acos": build(
        (
          #|pub fn Float::acos(self : Float) -> Float { let x = self
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
          #|  two * (df + w) }
        ),
      ),
      "atan": build(
        (
          #|pub fn Float::atan(self : Float) -> Float { let x = self
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
          #|  } }
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
      "logf_off": (None, UInt(0x3f330000U)),
      "logf_table_bits": (None, Int(4)),
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
          #|pub fn Float::round(self : Float) -> Float { floor(self + 0.5) }
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
      "exp2f_table_bits": (None, Int(5)),
      "pow": build(
        (
          #|pub fn Float::pow(self : Float, other : Float) -> Float { self.to_double().pow(other.to_double()).to_float() }
        ),
      ),
      "to_int": build(
        (
          #|pub fn to_int(self : Float) -> Int { if self != self {
          #|    0
          #|  } else if self >= 2147483647 {
          #|    2147483647
          #|  } else if self <= -2147483648 {
          #|    -2147483648
          #|  } else {
          #|    self.to_unchecked_int()
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_hashmap_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/hashmap",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/test": moonbitlang_core_test_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/tuple": moonbitlang_core_tuple_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/int": moonbitlang_core_int_module,
  },
  fn(_env, build) {
    {
      "op_get": build(
        (
          #|pub fn[K : Hash + Eq, V] op_get(self : T[K, V], key : K) -> V? { self.get(key) }
        ),
      ),
      "debug_entries": build(
        (
          #|fn[K : Show, V : Show] debug_entries(self : T[K, V]) -> String { for s = \"\", i = 0; i < self.entries.length(); {
          #|    let s = if i > 0 { s + \",\" } else { s }
          #|    match self.entries[i] {
          #|      None => continue s + \"_\", i + 1
          #|      Some({ psl, key, value, .. }) =>
          #|        continue s + \"(\\{psl},\\{key},\\{value})\", i + 1
          #|    }
          #|  } else {
          #|    s
          #|  } }
        ),
      ),
      "clear": build(
        (
          #|pub fn[K, V] clear(self : T[K, V]) -> Unit { self.entries.fill(None)
          #|  self.size = 0 }
        ),
      ),
      "iter": build(
        (
          #|pub fn[K, V] iter(self : T[K, V]) -> Iter[(K, V)] { Iter::new(yield_ => for entry in self.entries {
          #|    if entry is Some({ key, value, .. }) {
          #|      guard yield_((key, value)) is IterContinue else { break IterEnd }
          #|    }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[K, V] iter2(self : T[K, V]) -> Iter2[K, V] { Iter2::new(yield_ => for entry in self.entries {
          #|    if entry is Some({ key, value, .. }) {
          #|      guard yield_(key, value) is IterContinue else { break IterEnd }
          #|    }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[K : Hash + Eq, V] from_iter(iter : Iter[(K, V)]) -> T[K, V] { let m = new()
          #|  iter.each(e => m[e.0] = e.1)
          #|  m }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[K, V] to_array(self : T[K, V]) -> Array[(K, V)] { let mut i = 0
          #|  let res = while i < self.capacity {
          #|    if self.entries[i] is Some({ key, value, .. }) {
          #|      i += 1
          #|      break Array::make(self.size, (key, value))
          #|    }
          #|    i += 1
          #|  } else {
          #|    []
          #|  }
          #|  if !res.is_empty() {
          #|    let mut res_idx = 1
          #|    while res_idx < res.length() && i < self.capacity {
          #|      if self.entries[i] is Some({ key, value, .. }) {
          #|        res[res_idx] = (key, value)
          #|        res_idx += 1
          #|      }
          #|      i += 1
          #|    }
          #|  }
          #|  res }
        ),
      ),
      "size": build(
        (
          #|pub fn[K, V] size(self : T[K, V]) -> Int { self.size }
        ),
      ),
      "capacity": build(
        (
          #|pub fn[K, V] capacity(self : T[K, V]) -> Int { self.capacity }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[K, V] is_empty(self : T[K, V]) -> Bool { self.size == 0 }
        ),
      ),
      "each": build(
        (
          #|pub fn[K, V] each(self : T[K, V], f : (K, V) -> Unit) -> Unit { for i in 0..<self.capacity {
          #|    if self.entries[i] is Some({ key, value, .. }) {
          #|      f(key, value)
          #|    }
          #|  } }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[K, V] eachi(self : T[K, V], f : (Int, K, V) -> Unit) -> Unit { for i = 0, idx = 0; i < self.capacity; {
          #|    match self.entries[i] {
          #|      Some({ key, value, .. }) => {
          #|        f(idx, key, value)
          #|        continue i + 1, idx + 1
          #|      }
          #|      None => continue i + 1, idx
          #|    }
          #|  } }
        ),
      ),
      "new": build(
        (
          #|pub fn[K, V] new(capacity~ : Int = 8) -> T[K, V] { let capacity = capacity.next_power_of_two()
          #|  {
          #|    size: 0,
          #|    capacity,
          #|    entries: FixedArray::make(capacity, None),
          #|    capacity_mask: capacity - 1,
          #|  } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[K : Hash + Eq, V] from_array(arr : Array[(K, V)]) -> T[K, V] { let m = new(capacity=arr.length())
          #|  arr.each(e => m.set(e.0, e.1))
          #|  m }
        ),
      ),
      "set": build(
        (
          #|pub fn[K : Hash + Eq, V] set(self : T[K, V], key : K, value : V) -> Unit { self.set_with_hash(key, value, key.hash()) }
        ),
      ),
      "op_set": build(
        (
          #|pub fn[K : Hash + Eq, V] op_set(self : T[K, V], key : K, value : V) -> Unit { self.set(key, value) }
        ),
      ),
      "get": build(
        (
          #|pub fn[K : Hash + Eq, V] get(self : T[K, V], key : K) -> V? { // self.get_with_hash(key, key.hash())
          #|  let hash = key.hash()
          #|  for i = 0, idx = hash & self.capacity_mask {
          #|    guard self.entries[idx] is Some(entry) else { break None }
          #|    if entry.hash == hash && entry.key == key {
          #|      break Some(entry.value)
          #|    }
          #|    if i > entry.psl {
          #|      break None
          #|    }
          #|    continue i + 1, (idx + 1) & self.capacity_mask
          #|  } }
        ),
      ),
      "get_with_hash": build(
        (
          #|fn[K : Eq, V] get_with_hash(self : T[K, V], key : K, hash : Int) -> V? { for i = 0, idx = hash & self.capacity_mask {
          #|    guard self.entries[idx] is Some(entry) else { break None }
          #|    if entry.hash == hash && entry.key == key {
          #|      break Some(entry.value)
          #|    }
          #|    if i > entry.psl {
          #|      break None
          #|    }
          #|    continue i + 1, (idx + 1) & self.capacity_mask
          #|  } }
        ),
      ),
      "contains": build(
        (
          #|pub fn[K : Hash + Eq, V] contains(self : T[K, V], key : K) -> Bool { let hash = key.hash()
          #|  for i = 0, idx = hash & self.capacity_mask {
          #|    guard self.entries[idx] is Some(entry) else { return false }
          #|    if entry.hash == hash && entry.key == key {
          #|      return true
          #|    }
          #|    if i > entry.psl {
          #|      return false
          #|    }
          #|    continue i + 1, (idx + 1) & self.capacity_mask
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[K : Hash + Eq, V] remove(self : T[K, V], key : K) -> Unit { let hash = key.hash()
          #|  for i = 0, idx = hash & self.capacity_mask {
          #|    match self.entries[idx] {
          #|      Some(entry) => {
          #|        if entry.hash == hash && entry.key == key {
          #|          self.entries[idx] = None
          #|          self.shift_back(idx)
          #|          self.size -= 1
          #|          break
          #|        }
          #|        if i > entry.psl {
          #|          break
          #|        }
          #|        continue i + 1, (idx + 1) & self.capacity_mask
          #|      }
          #|      None => break
          #|    }
          #|  } }
        ),
      ),
      "shift_back": build(
        (
          #|fn[K, V] shift_back(self : T[K, V], start_index : Int) -> Unit { for prev = start_index, curr = (start_index + 1) & self.capacity_mask {
          #|    match self.entries[curr] {
          #|      Some({ psl, hash, key, value }) => {
          #|        if psl == 0 {
          #|          break
          #|        }
          #|        self.entries[prev] = Some({ psl: psl - 1, hash, key, value })
          #|        self.entries[curr] = None
          #|        continue curr, (curr + 1) & self.capacity_mask
          #|      }
          #|      None => break
          #|    }
          #|  } }
        ),
      ),
      "grow": build(
        (
          #|fn[K : Eq, V] grow(self : T[K, V]) -> Unit { let old_entries = self.entries
          #|  let new_capacity = self.capacity << 1
          #|  self.entries = FixedArray::make(new_capacity, None)
          #|  self.capacity = new_capacity
          #|  self.capacity_mask = new_capacity - 1
          #|  self.size = 0
          #|  for i in 0..<old_entries.length() {
          #|    if old_entries[i] is Some({ key, value, hash, .. }) {
          #|      self.set_with_hash(key, value, hash)
          #|    }
          #|  } }
        ),
      ),
      "of": build(
        (
          #|pub fn[K : Eq + Hash, V] of(arr : FixedArray[(K, V)]) -> T[K, V] { let m = new(capacity=arr.length())
          #|  arr.each(e => m.set(e.0, e.1))
          #|  m }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_hashset_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/hashset",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/test": moonbitlang_core_test_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
  },
  fn(_env, build) {
    {
      "default_init_capacity": (None, Int(8)),
      "new": build(
        (
          #|pub fn[K] new(capacity~ : Int = default_init_capacity) -> T[K] { {
          #|    size: 0,
          #|    capacity,
          #|    grow_at: calc_grow_threshold(capacity),
          #|    entries: FixedArray::make(capacity, None),
          #|  } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[K : Hash + Eq] from_array(arr : Array[K]) -> T[K] { let m = new()
          #|  arr.each(e => m.add(e))
          #|  m }
        ),
      ),
      "of": build(
        (
          #|pub fn[K : Hash + Eq] of(arr : FixedArray[K]) -> T[K] { let m = new()
          #|  arr.each(e => m.add(e))
          #|  m }
        ),
      ),
      "add": build(
        (
          #|pub fn[K : Hash + Eq] add(self : T[K], key : K) -> Unit { if self.capacity == 0 || self.size >= self.grow_at {
          #|    self.grow()
          #|  }
          #|  let hash = key.hash()
          #|  let entry = { psl: 0, hash, key }
          #|  loop (0, self.index(hash), entry) {
          #|    (i, idx, entry) => {
          #|      if i == self.capacity {
          #|        panic()
          #|      }
          #|      match self.entries[idx] {
          #|        None => {
          #|          self.entries[idx] = Some(entry)
          #|          self.size += 1
          #|          break
          #|        }
          #|        Some(curr_entry) => {
          #|          if curr_entry.hash == entry.hash && curr_entry.key == entry.key {
          #|            self.entries[idx] = Some(entry)
          #|            break
          #|          }
          #|          if entry.psl > curr_entry.psl {
          #|            self.entries[idx] = Some(entry)
          #|            curr_entry.psl += 1
          #|            continue (i + 1, self.next_index(idx), curr_entry)
          #|          }
          #|          entry.psl += 1
          #|          continue (i + 1, self.next_index(idx), entry)
          #|        }
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "contains": build(
        (
          #|pub fn[K : Hash + Eq] contains(self : T[K], key : K) -> Bool { let hash = key.hash()
          #|  for i = 0, idx = self.index(hash)
          #|      i < self.capacity
          #|      i = i + 1, idx = self.next_index(idx) {
          #|    match self.entries[idx] {
          #|      Some(entry) => {
          #|        if entry.hash == hash && entry.key == key {
          #|          return true
          #|        }
          #|        if i > entry.psl {
          #|          return false
          #|        }
          #|      }
          #|      None => return false
          #|    }
          #|  }
          #|  false }
        ),
      ),
      "remove": build(
        (
          #|pub fn[K : Hash + Eq] remove(self : T[K], key : K) -> Unit { let hash = key.hash()
          #|  for i = 0, idx = self.index(hash)
          #|      i < self.capacity
          #|      i = i + 1, idx = self.next_index(idx) {
          #|    if self.entries[idx] is Some(entry) &&
          #|      entry.hash == hash &&
          #|      entry.key == key {
          #|      self.entries[idx] = None
          #|      self.shift_back(idx)
          #|      self.size -= 1
          #|      break
          #|    }
          #|  } }
        ),
      ),
      "size": build(
        (
          #|pub fn[K] size(self : T[K]) -> Int { self.size }
        ),
      ),
      "capacity": build(
        (
          #|pub fn[K] capacity(self : T[K]) -> Int { self.capacity }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[K] is_empty(self : T[K]) -> Bool { self.size == 0 }
        ),
      ),
      "each": build(
        (
          #|pub fn[K] each(self : T[K], f : (K) -> Unit) -> Unit { self.eachi((_i, k) => f(k)) }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[K] eachi(self : T[K], f : (Int, K) -> Unit) -> Unit { let mut idx = 0
          #|  for i in 0..<self.capacity {
          #|    if self.entries[i] is Some({ key, .. }) {
          #|      f(idx, key)
          #|      idx += 1
          #|    }
          #|  } }
        ),
      ),
      "clear": build(
        (
          #|pub fn[K] clear(self : T[K]) -> Unit { for i in 0..<self.capacity {
          #|    self.entries[i] = None
          #|  }
          #|  self.size = 0 }
        ),
      ),
      "union": build(
        (
          #|pub fn[K : Hash + Eq] union(self : T[K], other : T[K]) -> T[K] { let m = new()
          #|  self.each(k => m.add(k))
          #|  other.each(k => m.add(k))
          #|  m }
        ),
      ),
      "intersection": build(
        (
          #|pub fn[K : Hash + Eq] intersection(self : T[K], other : T[K]) -> T[K] { let m = new()
          #|  self.each(k => if other.contains(k) { m.add(k) })
          #|  m }
        ),
      ),
      "difference": build(
        (
          #|pub fn[K : Hash + Eq] difference(self : T[K], other : T[K]) -> T[K] { let m = new()
          #|  self.each(k => if !other.contains(k) { m.add(k) })
          #|  m }
        ),
      ),
      "symmetric_difference": build(
        (
          #|pub fn[K : Hash + Eq] symmetric_difference(self : T[K], other : T[K]) -> T[K] { let m = new()
          #|  self.each(k => if !other.contains(k) { m.add(k) })
          #|  other.each(k => if !self.contains(k) { m.add(k) })
          #|  m }
        ),
      ),
      "is_disjoint": build(
        (
          #|pub fn[K : Hash + Eq] is_disjoint(self : T[K], other : T[K]) -> Bool { if self.size() <= other.size() {
          #|    self.iter().all(k => !other.contains(k))
          #|  } else {
          #|    other.iter().all(k => !self.contains(k))
          #|  } }
        ),
      ),
      "is_subset": build(
        (
          #|pub fn[K : Hash + Eq] is_subset(self : T[K], other : T[K]) -> Bool { if self.size() <= other.size() {
          #|    self.iter().all(k => other.contains(k))
          #|  } else {
          #|    false
          #|  } }
        ),
      ),
      "is_superset": build(
        (
          #|pub fn[K : Hash + Eq] is_superset(self : T[K], other : T[K]) -> Bool { other.is_subset(self) }
        ),
      ),
      "iter": build(
        (
          #|pub fn[K] iter(self : T[K]) -> Iter[K] { Iter::new(yield_ => for entry in self.entries {
          #|    if entry is Some({ key, .. }) {
          #|      guard yield_(key) is IterContinue else { break IterEnd }
          #|    }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[K : Hash + Eq] from_iter(iter : Iter[K]) -> T[K] { let s = new()
          #|  iter.each(e => s.add(e))
          #|  s }
        ),
      ),
      "shift_back": build(
        (
          #|fn[K] shift_back(self : T[K], start_index : Int) -> Unit { for i = 0, prev = start_index, curr = self.next_index(start_index)
          #|      i < self.entries.length()
          #|      i = i + 1, prev = curr, curr = self.next_index(curr) {
          #|    match self.entries[curr] {
          #|      Some(entry) => {
          #|        if entry.psl == 0 {
          #|          break
          #|        }
          #|        entry.psl -= 1
          #|        self.entries[prev] = Some(entry)
          #|        self.entries[curr] = None
          #|      }
          #|      None => break
          #|    }
          #|  } }
        ),
      ),
      "grow": build(
        (
          #|fn[K : Hash + Eq] grow(self : T[K]) -> Unit { // handle zero capacity
          #|  if self.capacity == 0 {
          #|    self.capacity = default_init_capacity
          #|    self.grow_at = calc_grow_threshold(self.capacity)
          #|    self.size = 0
          #|    self.entries = FixedArray::make(self.capacity, None)
          #|    return
          #|  }
          #|  let old_entries = self.entries
          #|  self.entries = FixedArray::make(self.capacity * 2, None)
          #|  self.capacity = self.capacity * 2
          #|  self.grow_at = calc_grow_threshold(self.capacity)
          #|  self.size = 0
          #|  for i in 0..<old_entries.length() {
          #|    if old_entries[i] is Some({ key, .. }) {
          #|      self.add(key)
          #|    }
          #|  } }
        ),
      ),
      "index": build(
        (
          #|fn[K] index(self : T[K], hash : Int) -> Int { abs(hash) & (self.capacity - 1) }
        ),
      ),
      "abs": build(
        (
          #|fn abs(n : Int) -> Int { if n < 0 {
          #|    -n
          #|  } else {
          #|    n
          #|  } }
        ),
      ),
      "next_index": build(
        (
          #|fn[K] next_index(self : T[K], index : Int) -> Int { (index + 1) & (self.capacity - 1) }
        ),
      ),
      "calc_grow_threshold": build(
        (
          #|fn calc_grow_threshold(capacity : Int) -> Int { capacity * 13 / 16 }
        ),
      ),
      "debug_entries": build(
        (
          #|fn[K : Show] debug_entries(self : T[K]) -> String { let mut s = \"\"
          #|  for i in 0..<self.entries.length() {
          #|    if i > 0 {
          #|      s += \",\"
          #|    }
          #|    match self.entries[i] {
          #|      None => s += \"_\"
          #|      Some({ psl, key, .. }) => s += \"(\\{psl},\\{key})\"
          #|    }
          #|  }
          #|  s }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[K] to_array(self : T[K]) -> Array[K] { let mut i = 0
          #|  let res = while i < self.capacity {
          #|    if self.entries[i] is Some({ key, .. }) {
          #|      i += 1
          #|      break Array::make(self.size, key)
          #|    }
          #|    i += 1
          #|  } else {
          #|    []
          #|  }
          #|  if !res.is_empty() {
          #|    let mut res_idx = 1
          #|    while res_idx < res.length() && i < self.capacity {
          #|      if self.entries[i] is Some({ key, .. }) {
          #|        res[res_idx] = key
          #|        res_idx += 1
          #|      }
          #|      i += 1
          #|    }
          #|  }
          #|  res }
        ),
      ),
      "insert": build(
        (
          #|pub fn[K : Hash + Eq] insert(self : T[K], key : K) -> Unit { self.add(key) }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_immut_array_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/immut/array",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "core/array": moonbitlang_core_array_module,
  },
  fn(_env, build) {
    {
      "is_node": build(
        (
          #|fn[A] Tree::is_node(self : Tree[A]) -> Bool { self is Node(_, _) }
        ),
      ),
      "is_leaf": build(
        (
          #|fn[A] Tree::is_leaf(self : Tree[A]) -> Bool { self is Leaf(_) }
        ),
      ),
      "right_child": build(
        (
          #|fn[A] Tree::right_child(self : Tree[A]) -> Tree[A] { match self {
          #|    Node(children, _) => children[children.length() - 1]
          #|    Leaf(_) | Empty => abort(\"Should not get children on non-`Node`s\")
          #|  } }
        ),
      ),
      "left_child": build(
        (
          #|fn[A] Tree::left_child(self : Tree[A]) -> Tree[A] { match self {
          #|    Node(children, _) => children[0]
          #|    Leaf(_) | Empty => abort(\"Should not get children on non-`Node`s\")
          #|  } }
        ),
      ),
      "leaf_elements": build(
        (
          #|fn[A] Tree::leaf_elements(self : Tree[A]) -> FixedArray[A] { guard self is Leaf(children) else {
          #|    abort(\"Should not call `get_leaf_elements` on non-leaf nodes\")
          #|  }
          #|  children }
        ),
      ),
      "node_children": build(
        (
          #|fn[A] Tree::node_children(self : Tree[A]) -> FixedArray[Tree[A]] { guard self is Node(children, _) else {
          #|    abort(\"Should not call `node_children` on non-`Node`s\")
          #|  }
          #|  children }
        ),
      ),
      "local_size": build(
        (
          #|fn[A] Tree::local_size(self : Tree[A]) -> Int { match self {
          #|    Empty => 0
          #|    Leaf(l) => l.length()
          #|    Node(children, _) => children.length()
          #|  } }
        ),
      ),
      "size": build(
        (
          #|fn[A] Tree::size(self : Tree[A], shift : Int) -> Int { match self {
          #|    Empty => 0
          #|    Leaf(l) => l.length()
          #|    Node(_, Some(sizes)) => sizes[sizes.length() - 1]
          #|    Node(children, None) => {
          #|      let len_1 = children.length() - 1
          #|      (len_1 << shift) + children[len_1].size(shift - num_bits)
          #|    }
          #|  } }
        ),
      ),
      "new": build(
        (
          #|pub fn[A] new() -> T[A] { { tree: Tree::empty(), size: 0, shift: 0 } }
        ),
      ),
      "make": build(
        (
          #|pub fn[A] make(len : Int, value : A) -> T[A] { let quot = len / branching_factor
          #|  let rem = len % branching_factor
          #|  let leaves = if rem == 0 {
          #|    Array::make(quot, FixedArray::make(branching_factor, value))
          #|  } else {
          #|    let arr : Array[FixedArray[A]] = Array::make(
          #|      quot + 1,
          #|      FixedArray::make(branching_factor, value),
          #|    )
          #|    arr[quot] = FixedArray::make(rem, value)
          #|    arr
          #|  }
          #|  let size = len
          #|  let (shift, cap) = shift_cap_of_size(size)
          #|  let tree = if size == 0 { Empty } else { from_leaves(leaves[:], cap) }
          #|  { shift, tree, size } }
        ),
      ),
      "makei": build(
        (
          #|pub fn[A] makei(len : Int, f : (Int) -> A raise?) -> T[A] raise? { let quot = len / branching_factor
          #|  let rem = len % branching_factor
          #|  let leaves = if rem == 0 {
          #|    Array::makei(quot, k => FixedArray::makei(branching_factor, i => f(
          #|      k * branching_factor + i,
          #|    )))
          #|  } else {
          #|    let arr : Array[FixedArray[A]] = Array::make(quot + 1, [])
          #|    for k in 0..<quot {
          #|      arr[k] = FixedArray::makei(branching_factor, i => f(
          #|        k * branching_factor + i,
          #|      ))
          #|    }
          #|    arr[quot] = FixedArray::makei(rem, i => f(quot * branching_factor + i))
          #|    arr
          #|  }
          #|  let size = len
          #|  let (shift, cap) = shift_cap_of_size(size)
          #|  let tree = if size == 0 { Empty } else { from_leaves(leaves[:], cap) }
          #|  { shift, tree, size } }
        ),
      ),
      "of": build(
        (
          #|pub fn[A] of(arr : FixedArray[A]) -> T[A] { makei(arr.length(), i => arr[i]) }
        ),
      ),
      "copy": build(
        (
          #|pub fn[A] copy(self : T[A]) -> T[A] { fn copy(t : Tree[A]) -> Tree[A] {
          #|    match t {
          #|      Leaf(l) => Leaf(l.copy())
          #|      Empty => Empty
          #|      Node(node, sizes) =>
          #|        Node(
          #|          FixedArray::makei(node.length(), i => copy(node[i])),
          #|          match sizes {
          #|            Some(sizes) => Some(FixedArray::copy(sizes))
          #|            None => None
          #|          },
          #|        )
          #|    }
          #|  }
          #|  { tree: copy(self.tree), size: self.size, shift: self.shift } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A] from_array(arr : Array[A]) -> T[A] { makei(arr.length(), i => arr[i]) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A] from_iter(iter : Iter[A]) -> T[A] { let mut buf : FixedArray[A] = []
          #|  let mut index = 0
          #|  let leaves = []
          #|  iter.each(x => if index == 0 {
          #|    buf = FixedArray::make(branching_factor, x)
          #|    index += 1
          #|  } else if index < branching_factor {
          #|    buf[index] = x
          #|    index += 1
          #|  } else {
          #|    leaves.push(buf)
          #|    index = 1
          #|    buf = FixedArray::make(branching_factor, x)
          #|  })
          #|  if index == branching_factor {
          #|    leaves.push(buf)
          #|  } else if index > 0 {
          #|    let res = FixedArray::make(index, buf[0])
          #|    buf.blit_to(res, len=index)
          #|    leaves.push(res)
          #|  }
          #|  let size = leaves.fold(init=0, (acc, xs) => acc + xs.length())
          #|  let (shift, cap) = shift_cap_of_size(size)
          #|  let tree = if size == 0 { Empty } else { from_leaves(leaves[:], cap) }
          #|  { shift, tree, size } }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[A] to_array(self : T[A]) -> Array[A] { if self.is_empty() {
          #|    []
          #|  } else {
          #|    let arr = Array::make(self.length(), self[0])
          #|    self.eachi((i, v) => arr[i] = v)
          #|    arr
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[A] is_empty(self : T[A]) -> Bool { self.size == 0 }
        ),
      ),
      "length": build(
        (
          #|pub fn[A] length(self : T[A]) -> Int { self.size }
        ),
      ),
      "op_get": build(
        (
          #|pub fn[A] op_get(self : T[A], index : Int) -> A { if index == 0 {
          #|    self.tree.get_first()
          #|  } else if index == self.size - 1 {
          #|    self.tree.get_last()
          #|  } else {
          #|    self.tree.get(index, self.shift)
          #|  } }
        ),
      ),
      "get": build(
        (
          #|pub fn[A] get(self : T[A], index : Int) -> A? { guard 0 <= index && index < self.size else { None }
          #|  Some(self[index]) }
        ),
      ),
      "set": build(
        (
          #|pub fn[A] set(self : T[A], index : Int, value : A) -> T[A] { {
          #|    tree: self.tree.set(index, self.shift, value),
          #|    size: self.size,
          #|    shift: self.shift,
          #|  } }
        ),
      ),
      "push": build(
        (
          #|pub fn[A] push(self : T[A], value : A) -> T[A] { let (tree, shift) = self.tree.push_end(self.shift, value)
          #|  { tree, size: self.size + 1, shift } }
        ),
      ),
      "concat": build(
        (
          #|pub fn[A] concat(self : T[A], other : T[A]) -> T[A] { if self.is_empty() {
          #|    return other
          #|  }
          #|  if other.is_empty() {
          #|    return self
          #|  }
          #|  let (tree, shift) = Tree::concat(
          #|    self.tree,
          #|    self.shift,
          #|    other.tree,
          #|    other.shift,
          #|    true,
          #|  )
          #|  { tree, size: self.size + other.size, shift } }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A] iter(self : T[A]) -> Iter[A] { self.tree.iter() }
        ),
      ),
      "each": build(
        (
          #|pub fn[A] each(self : T[A], f : (A) -> Unit raise?) -> Unit raise? { self.tree.each(f) }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[A] eachi(self : T[A], f : (Int, A) -> Unit raise?) -> Unit raise? { self.tree.eachi(f, self.shift, 0) }
        ),
      ),
      "fold": build(
        (
          #|pub fn[A, B] fold(self : T[A], init~ : B, f : (B, A) -> B raise?) -> B raise? { self.tree.fold(init, f) }
        ),
      ),
      "fold_left": build(
        (
          #|pub fn[A] fold_left(self : T[A], f : (A, A) -> A raise?, init~ : A) -> A raise? { self.fold(init~, f) }
        ),
      ),
      "map": build(
        (
          #|pub fn[A, B] map(self : T[A], f : (A) -> B raise?) -> T[B] raise? { { tree: self.tree.map(f), size: self.size, shift: self.shift } }
        ),
      ),
      "shift_cap_of_size": build(
        (
          #|fn shift_cap_of_size(size : Int) -> (Int, Int) { let mut cap = branching_factor
          #|  let mut depth = 0
          #|  while cap < size {
          #|    cap *= branching_factor
          #|    depth += 1
          #|  }
          #|  let shift = num_bits * depth
          #|  (shift, cap) }
        ),
      ),
      "new": build(
        (
          #|pub fn[A] T::new() -> T[A] { new() }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A] T::from_iter(iter : Iter[A]) -> T[A] { from_iter(iter) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A] T::from_array(arr : Array[A]) -> T[A] { from_array(arr) }
        ),
      ),
      "make": build(
        (
          #|pub fn[A] T::make(len : Int, value : A) -> T[A] { make(len, value) }
        ),
      ),
      "makei": build(
        (
          #|pub fn[A] T::makei(len : Int, f : (Int) -> A) -> T[A] { makei(len, f) }
        ),
      ),
      "of": build(
        (
          #|pub fn[A] T::of(arr : FixedArray[A]) -> T[A] { of(arr) }
        ),
      ),
      "immutable_set": build(
        (
          #|fn[T] immutable_set(arr : FixedArray[T], i : Int, v : T) -> FixedArray[T] { let arr = arr.copy()
          #|  arr[i] = v
          #|  arr }
        ),
      ),
      "immutable_push": build(
        (
          #|fn[T] immutable_push(arr : FixedArray[T], val : T) -> FixedArray[T] { let len = arr.length()
          #|  let new_arr = FixedArray::make(len + 1, val)
          #|  arr.blit_to(new_arr, len~)
          #|  new_arr[len] = val
          #|  new_arr }
        ),
      ),
      "shr_as_uint": build(
        (
          #|fn shr_as_uint(x : Int, y : Int) -> Int { (x.reinterpret_as_uint() >> y).reinterpret_as_int() }
        ),
      ),
      "radix_indexing": build(
        (
          #|fn radix_indexing(index : Int, shift : Int) -> Int { shr_as_uint(index, shift) & bitmask }
        ),
      ),
      "get_branch_index": build(
        (
          #|fn get_branch_index(sizes : FixedArray[Int], index : Int) -> Int { let mut lo = 0
          #|  let mut hi = sizes.length()
          #|  while LINEAR_THRESHOLD < hi - lo {
          #|    let mid = (lo + hi) / 2
          #|    if sizes[mid] <= index {
          #|      lo = mid
          #|    } else {
          #|      hi = mid
          #|    }
          #|  }
          #|  while sizes[lo] <= index {
          #|    lo += 1
          #|  }
          #|  lo }
        ),
      ),
      "copy_sizes": build(
        (
          #|fn copy_sizes(sizes : FixedArray[Int]?) -> FixedArray[Int]? { match sizes {
          #|    Some(sizes) => Some(sizes.copy())
          #|    None => None
          #|  } }
        ),
      ),
      "min": build(
        (
          #|fn min(a : Int, b : Int) -> Int { if a < b {
          #|    a
          #|  } else {
          #|    b
          #|  } }
        ),
      ),
      "num_bits": (None, Int(5)),
      "empty": build(
        (
          #|fn[T] Tree::empty() -> Tree[T] { Tree::Empty }
        ),
      ),
      "new_branch_left": build(
        (
          #|fn[T] new_branch_left(leaf : FixedArray[T], shift : Int) -> Tree[T] { match shift {
          #|    0 => Leaf(leaf)
          #|    s => Node([new_branch_left(leaf, s - num_bits)], None) // size is None because we can use radix indexing
          #|  } }
        ),
      ),
      "get_first": build(
        (
          #|fn[T] Tree::get_first(self : Tree[T]) -> T { match self {
          #|    Leaf(leaf) => leaf[0]
          #|    Node(node, _) => node[0].get_first()
          #|    Empty => abort(\"Index out of bounds\")
          #|  } }
        ),
      ),
      "get_last": build(
        (
          #|fn[T] Tree::get_last(self : Tree[T]) -> T { match self {
          #|    Leaf(leaf) => leaf[leaf.length() - 1]
          #|    Node(node, _) => node[node.length() - 1].get_last()
          #|    Empty => abort(\"Index out of bounds\")
          #|  } }
        ),
      ),
      "get": build(
        (
          #|fn[T] Tree::get(self : Tree[T], index : Int, shift : Int) -> T { fn get_radix(node : Tree[T], shift : Int) -> T {
          #|    match node {
          #|      Leaf(leaf) => leaf[index & bitmask]
          #|      Node(node, None) =>
          #|        get_radix(node[radix_indexing(index, shift)], shift - num_bits)
          #|      Node(_, Some(_)) =>
          #|        abort(\"Unreachable: Node should not have sizes in get_radix\")
          #|      Empty => abort(\"Index out of bounds\")
          #|    }
          #|  }
          #|  match self {
          #|    Leaf(leaf) => leaf[index]
          #|    Node(children, Some(sizes)) => {
          #|      let branch_index = get_branch_index(sizes, index)
          #|      let sub_index = if branch_index == 0 {
          #|        index
          #|      } else {
          #|        index - sizes[branch_index - 1]
          #|      }
          #|      children[branch_index].get(sub_index, shift - num_bits)
          #|    }
          #|    Node(_, None) => get_radix(self, shift)
          #|    Empty => abort(\"Index out of bounds\")
          #|  } }
        ),
      ),
      "set": build(
        (
          #|fn[T] Tree::set(self : Tree[T], index : Int, shift : Int, value : T) -> Tree[T] { // TODO: optimize this as loop
          #|  fn set_radix(node : Tree[T], shift : Int) -> Tree[T] {
          #|    match node {
          #|      Leaf(leaf) => Leaf(immutable_set(leaf, index & bitmask, value))
          #|      Node(node, None) => {
          #|        let sub_idx = radix_indexing(index, shift)
          #|        Node(
          #|          immutable_set(
          #|            node,
          #|            sub_idx,
          #|            set_radix(node[radix_indexing(index, shift)], shift - num_bits),
          #|          ),
          #|          None,
          #|        )
          #|      }
          #|      Node(_, Some(_)) =>
          #|        abort(\"Unreachable: Node should not have sizes in set_radix\")
          #|      Empty => abort(\"Index out of bounds\")
          #|    }
          #|  }
          #|  match self {
          #|    Leaf(leaf) => Leaf(immutable_set(leaf, index & bitmask, value))
          #|    Node(children, Some(sizes)) => {
          #|      let branch_index = get_branch_index(sizes, index)
          #|      let sub_index = if branch_index == 0 {
          #|        index
          #|      } else {
          #|        index - sizes[branch_index - 1]
          #|      }
          #|      Node(
          #|        immutable_set(
          #|          children,
          #|          branch_index,
          #|          children[branch_index].set(sub_index, shift - num_bits, value),
          #|        ),
          #|        Some(sizes),
          #|      )
          #|    }
          #|    Node(_children, None) => set_radix(self, shift)
          #|    Empty => abort(\"Index out of bounds\")
          #|  } }
        ),
      ),
      "push_end": build(
        (
          #|fn[T] Tree::push_end(self : Tree[T], shift : Int, value : T) -> (Tree[T], Int) { fn update_sizes_last(sizes : FixedArray[Int]?) -> FixedArray[Int]? {
          #|    match sizes {
          #|      Some(sizes) => {
          #|        let new_sizes = sizes.copy()
          #|        new_sizes[new_sizes.length() - 1] += 1
          #|        Some(new_sizes)
          #|      }
          #|      None => None
          #|    }
          #|  }
          #|  fn push_sizes_last(sizes : FixedArray[Int]?) -> FixedArray[Int]? {
          #|    match sizes {
          #|      Some(sizes) => Some(immutable_push(sizes, 1 + sizes[sizes.length() - 1]))
          #|      None => None
          #|    }
          #|  }
          #|  fn worker(node : Tree[T], shift : Int) -> Tree[T]? {
          #|    match node {
          #|      Leaf(leaf) => {
          #|        if shift != 0 {
          #|          abort(
          #|            \"Unreachable: Leaf should not have a non-zero shift, which means we have not reached the bottom of the tree\",
          #|          )
          #|        }
          #|        if leaf.length() < branching_factor {
          #|          Some(Leaf(immutable_push(leaf, value)))
          #|        } else {
          #|          None
          #|        }
          #|      }
          #|      Node(nodes, sizes) => {
          #|        let len = nodes.length()
          #|        match worker(nodes[len - 1], shift - num_bits) {
          #|          // We have successfully pushed the value, now duplicate its ancestor nodes.
          #|          Some(new_node) => {
          #|            let new_nodes = nodes.copy()
          #|            new_nodes[len - 1] = new_node
          #|            let sizes = update_sizes_last(sizes)
          #|            Some(Node(new_nodes, sizes))
          #|          }
          #|          // We need to create a new node to push the value.
          #|          None =>
          #|            if len < branching_factor {
          #|              let sizes = push_sizes_last(sizes)
          #|              Some(
          #|                Node(
          #|                  immutable_push(
          #|                    nodes,
          #|                    new_branch_left([value], shift - num_bits),
          #|                  ),
          #|                  sizes,
          #|                ),
          #|              )
          #|            } else {
          #|              None
          #|            }
          #|        }
          #|      }
          #|      Empty => Some(Leaf([value]))
          #|    }
          #|  }
          #|  match worker(self, shift) {
          #|    Some(new_tree) => (new_tree, shift)
          #|    None => {
          #|      let new_branch = new_branch_left([value], shift)
          #|      (
          #|        match self {
          #|          Leaf(_leaf) => Node([self, new_branch], None)
          #|          Node(_nodes, Some(sizes)) => {
          #|            let len = sizes[sizes.length() - 1]
          #|            let sizes = FixedArray::from_array([len, 1 + len])
          #|            Node([self, new_branch], Some(sizes))
          #|          }
          #|          Node(_nodes, None) => Node([self, new_branch], None)
          #|          Empty =>
          #|            abort(
          #|              \"Unreachable: Empty tree should have fallen into the Some(new_tree) branch\",
          #|            )
          #|        },
          #|        shift + num_bits,
          #|      )
          #|    }
          #|  } }
        ),
      ),
      "each": build(
        (
          #|fn[A] Tree::each(self : Tree[A], f : (A) -> Unit raise?) -> Unit raise? { match self {
          #|    Empty => ()
          #|    Leaf(l) => l.each(f)
          #|    Node(ns, _) => ns.each(t => t.each(f))
          #|  } }
        ),
      ),
      "iter": build(
        (
          #|fn[A] Tree::iter(self : Tree[A]) -> Iter[A] { Iter::new(yield_ => match self {
          #|    Empty => IterContinue
          #|    Leaf(l) => l.iter().run(yield_)
          #|    Node(ns, _) =>
          #|      for n in ns {
          #|        guard n.iter().run(yield_) is IterContinue else { break IterEnd }
          #|      } else {
          #|        IterContinue
          #|      }
          #|  }) }
        ),
      ),
      "map": build(
        (
          #|fn[A, B] Tree::map(self : Tree[A], f : (A) -> B raise?) -> Tree[B] raise? { match self {
          #|    Empty => Empty
          #|    Leaf(l) => Leaf(l.map(f))
          #|    Node(n, szs) =>
          #|      Node(FixedArray::makei(n.length(), i => n[i].map(f)), copy_sizes(szs))
          #|  } }
        ),
      ),
      "redis_plan": build(
        (
          #|fn[A] redis_plan(t : FixedArray[Tree[A]]) -> (FixedArray[Int], Int) { let node_counts = FixedArray::makei(t.length(), i => t[i].local_size())
          #|  let total_nodes = node_counts.fold(init=0, (acc, x) => acc + x)
          #|  // round up to the nearest integer of S/branching_factor
          #|  let opt_len = (total_nodes + branching_factor - 1) / branching_factor
          #|  let mut new_len = t.length()
          #|  let mut i = 0
          #|  while opt_len + e_max_2 < new_len {
          #|    // Skip over all nodes satisfying the invariant.
          #|    while node_counts[i] > branching_factor - e_max_2 {
          #|      i += 1
          #|    }
          #|    // Found short node, so redistribute over the next nodes
          #|    let mut remaining_nodes = node_counts[i]
          #|    while remaining_nodes > 0 {
          #|      let min_size = min(remaining_nodes + node_counts[i + 1], branching_factor)
          #|      node_counts[i] = min_size
          #|      remaining_nodes = remaining_nodes + node_counts[i + 1] - min_size
          #|      i += 1
          #|    }
          #|    for j in i..<(new_len - 1) {
          #|      node_counts[j] = node_counts[j + 1]
          #|    }
          #|    new_len -= 1
          #|    i -= 1
          #|  }
          #|  return (node_counts, new_len) }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_immut_hashmap_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/immut/hashmap",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/tuple": moonbitlang_core_tuple_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/immut/internal/sparse_array": moonbitlang_core_immut_internal_sparse_array_module,
    "moonbitlang/core/immut/internal/path": moonbitlang_core_immut_internal_path_module,
    "moonbitlang/core/list": moonbitlang_core_list_module,
  },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn[K, V] new() -> T[K, V] { None }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[K : Hash, V] singleton(key : K, value : V) -> T[K, V] { Some(Flat(key, value, @path.of(key))) }
        ),
      ),
      "contains": build(
        (
          #|pub fn[K : Eq + Hash, V] contains(self : T[K, V], key : K) -> Bool { self.get(key) is Some(_) }
        ),
      ),
      "find": build(
        (
          #|pub fn[K : Eq + Hash, V] find(self : T[K, V], key : K) -> V? { self.get(key) }
        ),
      ),
      "get": build(
        (
          #|pub fn[K : Eq + Hash, V] get(self : T[K, V], key : K) -> V? { match self.0 {
          #|    None => None
          #|    Some(node) => node.get_with_path(key, @path.of(key))
          #|  } }
        ),
      ),
      "op_get": build(
        (
          #|pub fn[K : Eq + Hash, V] op_get(self : T[K, V], key : K) -> V? { self.get(key) }
        ),
      ),
      "map": build(
        (
          #|pub fn[K, V, A] map(self : T[K, V], f : (V) -> A raise?) -> T[K, A] raise? { self.map_with_key((_k, v) => f(v)) }
        ),
      ),
      "add": build(
        (
          #|pub fn[K : Eq + Hash, V] add(self : T[K, V], key : K, value : V) -> T[K, V] { match self.0 {
          #|    None => Some(Flat(key, value, @path.of(key)))
          #|    Some(node) => Some(node.add_with_path(key, value, @path.of(key)))
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[K : Eq + Hash, V] remove(self : T[K, V], key : K) -> T[K, V] { match self.0 {
          #|    None => None
          #|    Some(node) => node.remove_with_path(key, @path.of(key))
          #|  } }
        ),
      ),
      "size": build(
        (
          #|pub fn[K, V] size(self : T[K, V]) -> Int { fn node_size(node) {
          #|    match node {
          #|      Leaf(_, _, bucket) => 1 + bucket.length()
          #|      Flat(_) => 1
          #|      Branch(children) =>
          #|        for i = 0, total_size = 0; i < children.data.length(); {
          #|          continue i + 1, total_size + node_size(children.data[i])
          #|        } else {
          #|          total_size
          #|        }
          #|    }
          #|  }
          #|  match self.0 {
          #|    None => 0
          #|    Some(node) => node_size(node)
          #|  } }
        ),
      ),
      "union": build(
        (
          #|pub fn[K : Eq, V] T::union(self : T[K, V], other : T[K, V]) -> T[K, V] { fn go(node1 : Node[_], node2) {
          #|    match (node1, node2) {
          #|      (_, Flat(key2, value2, path2)) => node1.add_with_path(key2, value2, path2)
          #|      (Flat(key1, value1, path1), _) =>
          #|        match node2.get_with_path(key1, path1) {
          #|          Some(_) => node2
          #|          None => node2.add_with_path(key1, value1, path1)
          #|        }
          #|      (Branch(children1), Branch(children2)) =>
          #|        Branch(children1.union(children2, go))
          #|      (Leaf(key1, value1, bucket1), Leaf(key2, value2, bucket2)) => {
          #|        let kvs1 = bucket1.add((key1, value1))
          #|        let kvs2 = bucket2.add((key2, value2))
          #|        match kvs1.filter(kv => kvs2.lookup(kv.0) is None) {
          #|          Empty => node2
          #|          More(head, tail~) => Leaf(key2, value2, bucket2 + tail.add(head))
          #|        }
          #|      }
          #|      _ => abort(\"Unreachable\")
          #|    }
          #|  }
          #|  match (self.0, other.0) {
          #|    (None, x) | (x, None) => x
          #|    (Some(a), Some(b)) => Some(go(a, b))
          #|  } }
        ),
      ),
      "intersection": build(
        (
          #|pub fn[K : Eq, V] T::intersection(self : T[K, V], other : T[K, V]) -> T[K, V] { fn go(node1 : Node[_], node2) {
          #|    match (node1, node2) {
          #|      (_, Flat(key2, _, path2)) =>
          #|        match node1.get_with_path(key2, path2) {
          #|          Some(_) => Some(node2)
          #|          None => None
          #|        }
          #|      (Flat(key1, _, path1), _) =>
          #|        match node2.get_with_path(key1, path1) {
          #|          Some(value2) => Some(Flat(key1, value2, path1))
          #|          None => None
          #|        }
          #|      (Branch(children1), Branch(children2)) =>
          #|        match children1.intersection(children2, go) {
          #|          None => None
          #|          Some({ data: [Flat(key, value, path)], elem_info }) =>
          #|            Some(Flat(key, value, path.push(elem_info.first_idx())))
          #|          Some(children) => Some(Branch(children))
          #|        }
          #|      (Leaf(key1, value1, bucket1), Leaf(key2, value2, bucket2)) => {
          #|        let kvs1 = bucket1.add((key1, value1))
          #|        let kvs2 = bucket2.add((key2, value2))
          #|        match kvs2.filter(kv => kvs1.lookup(kv.0) is Some(_)) {
          #|          Empty => None
          #|          More(head, tail~) => Some(Leaf(head.0, head.1, tail))
          #|        }
          #|      }
          #|      _ => abort(\"Unreachable\")
          #|    }
          #|  }
          #|  match (self.0, other.0) {
          #|    (None, _) | (_, None) => None
          #|    (Some(a), Some(b)) => go(a, b)
          #|  } }
        ),
      ),
      "difference": build(
        (
          #|pub fn[K : Eq, V] T::difference(self : T[K, V], other : T[K, V]) -> T[K, V] { fn go(node1 : Node[_], node2) {
          #|    match (node1, node2) {
          #|      (node, Flat(k, _, path)) => node.remove_with_path(k, path)
          #|      (Flat(key, _, path), _) =>
          #|        match node2.get_with_path(key, path) {
          #|          Some(_) => None
          #|          None => Some(node1)
          #|        }
          #|      (Branch(children1), Branch(children2)) =>
          #|        match children1.difference(children2, go) {
          #|          None => None
          #|          Some({ data: [Flat(key, value, path)], elem_info }) =>
          #|            Some(Flat(key, value, path.push(elem_info.first_idx())))
          #|          Some(children) => Some(Branch(children))
          #|        }
          #|      (Leaf(key1, value1, bucket1), Leaf(key2, value2, bucket2)) => {
          #|        let kvs1 = bucket1.add((key1, value1))
          #|        let kvs2 = bucket2.add((key2, value2))
          #|        match kvs1.filter(kv => not(kvs2.lookup(kv.0) is Some(_))) {
          #|          Empty => None
          #|          More(head, tail~) => Some(Leaf(head.0, head.1, tail))
          #|        }
          #|      }
          #|      _ => abort(\"Unreachable\")
          #|    }
          #|  }
          #|  match (self.0, other.0) {
          #|    (None, _) => None
          #|    (_, None) => self
          #|    (Some(a), Some(b)) => go(a, b)
          #|  } }
        ),
      ),
      "each": build(
        (
          #|pub fn[K, V] each(self : T[K, V], f : (K, V) -> Unit raise?) -> Unit raise? { fn go(node) raise? {
          #|    match node {
          #|      Leaf(k, v, bucket) => {
          #|        f(k, v)
          #|        bucket.each(kv => f(kv.0, kv.1))
          #|      }
          #|      Flat(k, v, _) => f(k, v)
          #|      Branch(children) => children.each(go)
          #|    }
          #|  }
          #|  match self.0 {
          #|    None => ()
          #|    Some(node) => go(node)
          #|  } }
        ),
      ),
      "keys": build(
        (
          #|pub fn[K, V] keys(self : T[K, V]) -> Iter[K] { self.iter().map(p => p.0) }
        ),
      ),
      "values": build(
        (
          #|pub fn[K, V] values(self : T[K, V]) -> Iter[V] { self.iter().map(p => p.1) }
        ),
      ),
      "elems": build(
        (
          #|pub fn[K, V] elems(self : T[K, V]) -> Iter[V] { self.values() }
        ),
      ),
      "iter": build(
        (
          #|pub fn[K, V] iter(self : T[K, V]) -> Iter[(K, V)] { fn go(node) -> Iter[(K, V)] {
          #|    match node {
          #|      Leaf(k, v, bucket) => Iter::singleton((k, v)) + bucket.iter()
          #|      Flat(k, v, _) => Iter::singleton((k, v))
          #|      Branch(children) => children.data.iter().flat_map(go)
          #|    }
          #|  }
          #|  match self.0 {
          #|    None => Iter::empty()
          #|    Some(node) => go(node)
          #|  } }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[K, V] iter2(self : T[K, V]) -> Iter2[K, V] { Iter2::new(yield_ => for kv in self {
          #|    guard yield_(kv.0, kv.1) is IterContinue else { break IterEnd }
          #|  } else {
          #|    IterContinue
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[K : Eq + Hash, V] from_iter(iter : Iter[(K, V)]) -> T[K, V] { iter.fold(init=new(), (m, e) => m.add(e.0, e.1)) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[K : Eq + Hash, V] from_array(arr : Array[(K, V)]) -> T[K, V] { loop (arr.length(), new()) {
          #|    (0, map) => map
          #|    (n, map) => {
          #|      let (k, v) = arr[n - 1]
          #|      continue (n - 1, map.add(k, v))
          #|    }
          #|  } }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[K, V] to_array(self : T[K, V]) -> Array[(K, V)] { let arr = Array::new(capacity=self.size())
          #|  self.each((k, v) => arr.push((k, v)))
          #|  arr }
        ),
      ),
      "of": build(
        (
          #|pub fn[K : Eq + Hash, V] of(arr : FixedArray[(K, V)]) -> T[K, V] { loop (arr.length(), new()) {
          #|    (0, map) => map
          #|    (n, map) => {
          #|      let (k, v) = arr[n - 1]
          #|      continue (n - 1, map.add(k, v))
          #|    }
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_immut_hashset_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/immut/hashset",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/immut/internal/sparse_array": moonbitlang_core_immut_internal_sparse_array_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/immut/internal/path": moonbitlang_core_immut_internal_path_module,
    "moonbitlang/core/list": moonbitlang_core_list_module,
  },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn[A] new() -> T[A] { None }
        ),
      ),
      "contains": build(
        (
          #|pub fn[A : Eq + Hash] contains(self : T[A], key : A) -> Bool { self.0 is Some(node) && node.contains(key, @path.of(key)) }
        ),
      ),
      "contains": build(
        (
          #|fn[A : Eq] Node::contains(self : Node[A], key : A, path : Path) -> Bool { loop (self, path) {
          #|    (Leaf(key1, bucket), _) => key == key1 || bucket.contains(key)
          #|    (Flat(key1, path1), path) => path == path1 && key == key1
          #|    (Branch(children), path) => {
          #|      let idx = path.idx()
          #|      if children[idx] is Some(child) {
          #|        continue (child, path.next())
          #|      }
          #|      false
          #|    }
          #|  } }
        ),
      ),
      "join_2": build(
        (
          #|fn[A] join_2(key1 : A, path1 : Path, key2 : A, path2 : Path) -> Node[A] { let idx1 = path1.idx()
          #|  let idx2 = path2.idx()
          #|  if idx1 == idx2 {
          #|    let node = if path1.is_last() {
          #|      Leaf(key2, @list.singleton(key1))
          #|    } else {
          #|      join_2(key1, path1.next(), key2, path2.next())
          #|    }
          #|    Branch(@sparse_array.singleton(idx1, node))
          #|  } else {
          #|    let (node1, node2) = if path1.is_last() {
          #|      (Leaf(key1, @list.empty()), Leaf(key2, @list.empty()))
          #|    } else {
          #|      (Flat(key1, path1.next()), Flat(key2, path2.next()))
          #|    }
          #|    Branch(@sparse_array.doubleton(idx1, node1, idx2, node2))
          #|  } }
        ),
      ),
      "add_with_path": build(
        (
          #|fn[A : Eq] add_with_path(self : Node[A], key : A, path : Path) -> Node[A] { match self {
          #|    Leaf(key1, bucket) =>
          #|      if key == key1 || bucket.contains(key) {
          #|        self
          #|      } else {
          #|        Leaf(key, bucket.add(key1))
          #|      }
          #|    Flat(key1, path1) =>
          #|      if path == path1 && key == key1 {
          #|        self
          #|      } else {
          #|        join_2(key1, path1, key, path)
          #|      }
          #|    Branch(children) => {
          #|      let idx = path.idx()
          #|      match children[idx] {
          #|        Some(child) => {
          #|          let child = child.add_with_path(key, path.next())
          #|          Branch(children.replace(idx, child))
          #|        }
          #|        None => {
          #|          let child = Flat(key, path.next())
          #|          Branch(children.add(idx, child))
          #|        }
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "add": build(
        (
          #|pub fn[A : Eq + Hash] add(self : T[A], key : A) -> T[A] { match self.0 {
          #|    None => Some(Flat(key, @path.of(key)))
          #|    Some(node) => Some(node.add_with_path(key, @path.of(key)))
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[A : Eq + Hash] remove(self : T[A], key : A) -> T[A] { match self.0 {
          #|    None => None
          #|    Some(node) => node.remove_with_path(key, @path.of(key))
          #|  } }
        ),
      ),
      "remove_with_path": build(
        (
          #|fn[A : Eq] remove_with_path(self : Node[A], key : A, path : Path) -> Node[A]? { match self {
          #|    Leaf(key1, bucket) =>
          #|      if key1 == key {
          #|        match bucket {
          #|          @list.Empty => None
          #|          More(key2, tail=xs) => Some(Leaf(key2, xs))
          #|        }
          #|      } else if bucket.find_index(key.op_equal(_)) is Some(index) {
          #|        Some(Leaf(key1, bucket.remove_at(index)))
          #|      } else {
          #|        Some(self)
          #|      }
          #|    Flat(key1, path1) =>
          #|      if path == path1 && key == key1 {
          #|        None
          #|      } else {
          #|        Some(self)
          #|      }
          #|    Branch(children) => {
          #|      let idx = path.idx()
          #|      match children[idx] {
          #|        None => Some(self)
          #|        Some(child) => {
          #|          let new_child = child.remove_with_path(key, path.next())
          #|          let new_children = match (children.size(), new_child) {
          #|            (1, None) => return None
          #|            (_, None) => children.remove(idx)
          #|            (_, Some(new_child)) => children.replace(idx, new_child)
          #|          }
          #|          match new_children.data {
          #|            [Flat(key1, path1)] =>
          #|              Some(Flat(key1, path1.push(new_children.elem_info.first_idx())))
          #|            _ => Some(Branch(new_children))
          #|          }
          #|        }
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "size": build(
        (
          #|pub fn[A] size(self : T[A]) -> Int { fn node_size(node) {
          #|    match node {
          #|      Leaf(_, bucket) => 1 + bucket.length()
          #|      Flat(_) => 1
          #|      Branch(children) =>
          #|        for i = 0, total_size = 0; i < children.data.length(); {
          #|          continue i + 1, total_size + node_size(children.data[i])
          #|        } else {
          #|          total_size
          #|        }
          #|    }
          #|  }
          #|  match self.0 {
          #|    None => 0
          #|    Some(node) => node_size(node)
          #|  } }
        ),
      ),
      "union": build(
        (
          #|pub fn[K : Eq] T::union(self : T[K], other : T[K]) -> T[K] { fn go(node1, node2) {
          #|    match (node1, node2) {
          #|      (node, Flat(key, path)) | (Flat(key, path), node) =>
          #|        node.add_with_path(key, path)
          #|      (Branch(children1), Branch(children2)) =>
          #|        Branch(children1.union(children2, go))
          #|      (Leaf(key1, bucket1), Leaf(key2, bucket2)) => {
          #|        let keys1 = bucket1.add(key1)
          #|        let keys2 = bucket2.add(key2)
          #|        match keys1.filter(k => !keys2.contains(k)) {
          #|          Empty => node2
          #|          More(head, tail~) => Leaf(key2, bucket2 + tail.add(head))
          #|        }
          #|      }
          #|      _ => abort(\"Unreachable\")
          #|    }
          #|  }
          #|  match (self.0, other.0) {
          #|    (None, x) | (x, None) => x
          #|    (Some(a), Some(b)) => Some(go(a, b))
          #|  } }
        ),
      ),
      "intersection": build(
        (
          #|pub fn[K : Eq] T::intersection(self : T[K], other : T[K]) -> T[K] { fn go(node1, node2) {
          #|    match (node1, node2) {
          #|      (node, Flat(key, path) as flat) | (Flat(key, path) as flat, node) =>
          #|        if node.contains(key, path) {
          #|          Some(flat)
          #|        } else {
          #|          None
          #|        }
          #|      (Branch(children1), Branch(children2)) =>
          #|        match children1.intersection(children2, go) {
          #|          None => None
          #|          Some({ data: [Flat(key, path)], elem_info }) =>
          #|            Some(Flat(key, path.push(elem_info.first_idx())))
          #|          Some(children) => Some(Branch(children))
          #|        }
          #|      (Leaf(key1, bucket1), Leaf(key2, bucket2)) => {
          #|        let keys1 = bucket1.add(key1)
          #|        let keys2 = bucket2.add(key2)
          #|        match keys1.filter(keys2.contains(_)) {
          #|          Empty => None
          #|          More(head, tail~) => Some(Leaf(head, tail))
          #|        }
          #|      }
          #|      _ => abort(\"Unreachable\")
          #|    }
          #|  }
          #|  match (self.0, other.0) {
          #|    (None, _) | (_, None) => None
          #|    (Some(a), Some(b)) => go(a, b)
          #|  } }
        ),
      ),
      "difference": build(
        (
          #|pub fn[K : Eq] T::difference(self : T[K], other : T[K]) -> T[K] { fn go(node1 : Node[_], node2) {
          #|    match (node1, node2) {
          #|      (node, Flat(k, path)) => node.remove_with_path(k, path)
          #|      (Flat(key, path) as flat, node) =>
          #|        if node.contains(key, path) {
          #|          None
          #|        } else {
          #|          Some(flat)
          #|        }
          #|      (Branch(children1), Branch(children2)) =>
          #|        match children1.difference(children2, go) {
          #|          None => None
          #|          Some({ data: [Flat(key, path)], elem_info }) =>
          #|            Some(Flat(key, path.push(elem_info.first_idx())))
          #|          Some(children) => Some(Branch(children))
          #|        }
          #|      (Leaf(key1, bucket1), Leaf(key2, bucket2)) => {
          #|        let keys1 = bucket1.add(key1)
          #|        let keys2 = bucket2.add(key2)
          #|        match keys1.filter(k => !keys2.contains(k)) {
          #|          Empty => None
          #|          More(head, tail~) => Some(Leaf(head, tail))
          #|        }
          #|      }
          #|      _ => abort(\"Unreachable\")
          #|    }
          #|  }
          #|  match (self.0, other.0) {
          #|    (None, _) => None
          #|    (_, None) => self
          #|    (Some(a), Some(b)) => go(a, b)
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[A] is_empty(self : T[A]) -> Bool { self.0 is None }
        ),
      ),
      "each": build(
        (
          #|pub fn[A] each(self : T[A], f : (A) -> Unit raise?) -> Unit raise? { fn go(node) raise? {
          #|    match node {
          #|      Leaf(k, bucket) => {
          #|        f(k)
          #|        bucket.each(f)
          #|      }
          #|      Flat(k, _) => f(k)
          #|      Branch(children) => children.each(go)
          #|    }
          #|  }
          #|  match self.0 {
          #|    None => ()
          #|    Some(node) => go(node)
          #|  } }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A] iter(self : T[A]) -> Iter[A] { fn go(node) -> Iter[A] {
          #|    match node {
          #|      Leaf(k, bucket) => Iter::singleton(k) + bucket.iter()
          #|      Flat(k, _) => Iter::singleton(k)
          #|      Branch(children) => children.data.iter().flat_map(go)
          #|    }
          #|  }
          #|  match self.0 {
          #|    None => Iter::empty()
          #|    Some(node) => go(node)
          #|  } }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A : Eq + Hash] from_iter(iter : Iter[A]) -> T[A] { iter.fold(init=new(), (s, e) => s.add(e)) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A : Eq + Hash] from_array(arr : Array[A]) -> T[A] { loop (arr.length(), new()) {
          #|    (0, set) => set
          #|    (n, set) => {
          #|      let k = arr[n - 1]
          #|      continue (n - 1, set.add(k))
          #|    }
          #|  } }
        ),
      ),
      "of": build(
        (
          #|pub fn[A : Eq + Hash] of(arr : FixedArray[A]) -> T[A] { loop (arr.length(), new()) {
          #|    (0, set) => set
          #|    (n, set) => {
          #|      let k = arr[n - 1]
          #|      continue (n - 1, set.add(k))
          #|    }
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_immut_internal_path_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/immut/internal/path",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "of": build(
        (
          #|pub fn[A : Hash] of(key : A) -> Path { key.hash().reinterpret_as_uint() | HEAD_TAG }
        ),
      ),
      "is_last": build(
        (
          #|pub fn Path::is_last(self : Path) -> Bool { let Path(self) = self
          #|  self <= MAX_TAIL }
        ),
      ),
      "push": build(
        (
          #|pub fn Path::push(self : Path, idx : Int) -> Path { let Path(self) = self
          #|  (self << SEGMENT_LENGTH) | idx.reinterpret_as_uint() }
        ),
      ),
      "idx": build(
        (
          #|pub fn Path::idx(self : Path) -> Int { let Path(self) = self
          #|  (self & INDEX_MASK).reinterpret_as_int() }
        ),
      ),
      "next": build(
        (
          #|pub fn Path::next(self : Path) -> Path { let Path(self) = self
          #|  self >> SEGMENT_LENGTH }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_immut_internal_sparse_array_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/immut/internal/sparse_array",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
  },
  fn(_env, build) {
    {
      "empty": build(
        (
          #|pub fn[X] empty() -> SparseArray[X] { { elem_info: empty_bitset, data: [] } }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[X] singleton(idx : Int, value : X) -> SparseArray[X] { { elem_info: empty_bitset.add(idx), data: [value] } }
        ),
      ),
      "op_get": build(
        (
          #|pub fn[X] op_get(self : SparseArray[X], idx : Int) -> X? { if self.elem_info.has(idx) {
          #|    Some(self.data[self.elem_info.index_of(idx)])
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "unsafe_get": build(
        (
          #|fn[X] unsafe_get(self : SparseArray[X], idx : Int) -> X { self.data[self.elem_info.index_of(idx)] }
        ),
      ),
      "add": build(
        (
          #|pub fn[X] add(self : SparseArray[X], idx : Int, value : X) -> SparseArray[X] { let old_data = self.data
          #|  let old_len = old_data.length()
          #|  let new_len = old_len + 1
          #|  let pos_of_new_item = self.elem_info.index_of(idx)
          #|  let new_data = FixedArray::make(new_len, value)
          #|  old_data.blit_to(new_data, len=pos_of_new_item)
          #|  old_data.blit_to(
          #|    new_data,
          #|    len=old_len - pos_of_new_item,
          #|    src_offset=pos_of_new_item,
          #|    dst_offset=pos_of_new_item + 1,
          #|  )
          #|  { elem_info: self.elem_info.add(idx), data: new_data } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[X] remove(self : SparseArray[X], idx : Int) -> SparseArray[X] { let old_data = self.data
          #|  let old_len = old_data.length()
          #|  let pos_of_removed_item = self.elem_info.index_of(idx)
          #|  let new_data = FixedArray::make(old_len - 1, old_data.unsafe_get(0))
          #|  old_data.blit_to(
          #|    new_data,
          #|    len=pos_of_removed_item,
          #|    src_offset=0,
          #|    dst_offset=0,
          #|  )
          #|  old_data.blit_to(
          #|    new_data,
          #|    len=old_len - pos_of_removed_item - 1,
          #|    src_offset=pos_of_removed_item + 1,
          #|    dst_offset=pos_of_removed_item,
          #|  )
          #|  { elem_info: self.elem_info.remove(idx), data: new_data } }
        ),
      ),
      "size": build(
        (
          #|pub fn[X] size(self : SparseArray[X]) -> Int { self.data.length() }
        ),
      ),
      "each": build(
        (
          #|pub fn[X] each(self : SparseArray[X], f : (X) -> Unit raise?) -> Unit raise? { for i in 0..<self.elem_info.size() {
          #|    f(self.data[i])
          #|  } }
        ),
      ),
      "has": build(
        (
          #|pub fn Bitset::has(self : Bitset, idx : Int) -> Bool { (self.0 & (1U << idx)) != 0 }
        ),
      ),
      "index_of": build(
        (
          #|pub fn Bitset::index_of(self : Bitset, idx : Int) -> Int { (self.0 & ((1U << idx) - 1)).popcnt() }
        ),
      ),
      "first_idx": build(
        (
          #|pub fn Bitset::first_idx(self : Bitset) -> Int { self.0.ctz() }
        ),
      ),
      "union": build(
        (
          #|pub fn Bitset::union(self : Bitset, other : Bitset) -> Bitset { Bitset(self.0 | other.0) }
        ),
      ),
      "intersection": build(
        (
          #|pub fn Bitset::intersection(self : Bitset, other : Bitset) -> Bitset { Bitset(self.0 & other.0) }
        ),
      ),
      "add": build(
        (
          #|pub fn Bitset::add(self : Bitset, idx : Int) -> Bitset { Bitset(self.0 | (1U << idx)) }
        ),
      ),
      "remove": build(
        (
          #|pub fn Bitset::remove(self : Bitset, idx : Int) -> Bitset { Bitset(self.0 ^ (1U << idx)) }
        ),
      ),
      "size": build(
        (
          #|pub fn Bitset::size(self : Bitset) -> Int { let Bitset(self) = self
          #|  self.popcnt() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_immut_list_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/immut/list",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
    "moonbitlang/core/option": moonbitlang_core_option_module,
  },
  fn(_env, build) {
    {
      "add": build(
        (
          #|pub fn[A] add(self : T[A], head : A) -> T[A] { Cons(head, self) }
        ),
      ),
      "to_json": build(
        (
          #|pub fn[A : ToJson] to_json(self : T[A]) -> Json { ToJson::to_json(self) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A] from_array(arr : Array[A]) -> T[A] { for i = arr.length() - 1, list = Nil; i >= 0; {
          #|    continue i - 1, Cons(arr[i], list)
          #|  } else {
          #|    list
          #|  } }
        ),
      ),
      "length": build(
        (
          #|pub fn[A] length(self : T[A]) -> Int { loop (self, 0) {
          #|    (Nil, len) => len
          #|    (Cons(_, rest), acc) => continue (rest, acc + 1)
          #|  } }
        ),
      ),
      "each": build(
        (
          #|pub fn[A] each(self : T[A], f : (A) -> Unit raise?) -> Unit raise? { loop self {
          #|    Nil => ()
          #|    Cons(head, tail) => {
          #|      f(head)
          #|      continue tail
          #|    }
          #|  } }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[A] eachi(self : T[A], f : (Int, A) -> Unit raise?) -> Unit raise? { loop (self, 0) {
          #|    (Nil, _) => ()
          #|    (Cons(x, xs), i) => {
          #|      f(i, x)
          #|      continue (xs, i + 1)
          #|    }
          #|  } }
        ),
      ),
      "map": build(
        (
          #|pub fn[A, B] map(self : T[A], f : (A) -> B) -> T[B] { match self {
          #|    Nil => Nil
          #|    Cons(head, tail) => Cons(f(head), tail.map(f))
          #|  } }
        ),
      ),
      "mapi": build(
        (
          #|pub fn[A, B] mapi(self : T[A], f : (Int, A) -> B raise?) -> T[B] raise? { fn go(xs : T[A], i : Int, f : (Int, A) -> B raise?) -> T[B] raise? {
          #|    match xs {
          #|      Nil => Nil
          #|      Cons(x, xs) => Cons(f(i, x), go(xs, i + 1, f))
          #|    }
          #|  }
          #|  go(self, 0, f) }
        ),
      ),
      "rev_map": build(
        (
          #|pub fn[A, B] rev_map(self : T[A], f : (A) -> B raise?) -> T[B] raise? { loop (Nil, self) {
          #|    (acc, Nil) => acc
          #|    (acc, Cons(x, xs)) => continue (Cons(f(x), acc), xs)
          #|  } }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[A] to_array(self : T[A]) -> Array[A] { match self {
          #|    Nil => []
          #|    Cons(x, xs) => {
          #|      let arr = [x]
          #|      loop xs {
          #|        Nil => ()
          #|        Cons(x, xs) => {
          #|          arr.push(x)
          #|          continue xs
          #|        }
          #|      }
          #|      arr
          #|    }
          #|  } }
        ),
      ),
      "filter": build(
        (
          #|pub fn[A] filter(self : T[A], f : (A) -> Bool raise?) -> T[A] raise? { match self {
          #|    Nil => Nil
          #|    Cons(head, tail) =>
          #|      if f(head) {
          #|        Cons(head, tail.filter(f))
          #|      } else {
          #|        tail.filter(f)
          #|      }
          #|  } }
        ),
      ),
      "all": build(
        (
          #|pub fn[A] all(self : T[A], f : (A) -> Bool raise?) -> Bool raise? { loop self {
          #|    Nil => true
          #|    Cons(head, tail) => if f(head) { continue tail } else { false }
          #|  } }
        ),
      ),
      "any": build(
        (
          #|pub fn[A] any(self : T[A], f : (A) -> Bool raise?) -> Bool raise? { match self {
          #|    Nil => false
          #|    Cons(head, tail) => f(head) || tail.any(f)
          #|  } }
        ),
      ),
      "tail": build(
        (
          #|pub fn[A] tail(self : T[A]) -> T[A] { match self {
          #|    Nil => Nil
          #|    Cons(_, tail) => tail
          #|  } }
        ),
      ),
      "unsafe_head": build(
        (
          #|pub fn[A] unsafe_head(self : T[A]) -> A { match self {
          #|    Nil => abort(\"head of empty list\")
          #|    Cons(head, _) => head
          #|  } }
        ),
      ),
      "head_exn": build(
        (
          #|pub fn[A] head_exn(self : T[A]) -> A { self.unsafe_head() }
        ),
      ),
      "head": build(
        (
          #|pub fn[A] head(self : T[A]) -> A? { match self {
          #|    Nil => None
          #|    Cons(head, _) => Some(head)
          #|  } }
        ),
      ),
      "unsafe_last": build(
        (
          #|pub fn[A] unsafe_last(self : T[A]) -> A { loop self {
          #|    Nil => abort(\"last of empty list\")
          #|    Cons(head, Nil) => head
          #|    Cons(_, tail) => continue tail
          #|  } }
        ),
      ),
      "last": build(
        (
          #|pub fn[A] last(self : T[A]) -> A? { loop self {
          #|    Nil => None
          #|    Cons(head, Nil) => Some(head)
          #|    Cons(_, tail) => continue tail
          #|  } }
        ),
      ),
      "concat": build(
        (
          #|pub fn[A] concat(self : T[A], other : T[A]) -> T[A] { match self {
          #|    Nil => other
          #|    Cons(head, tail) => Cons(head, tail.concat(other))
          #|  } }
        ),
      ),
      "rev_concat": build(
        (
          #|pub fn[A] rev_concat(self : T[A], other : T[A]) -> T[A] { loop (self, other) {
          #|    (Nil, other) => other
          #|    (Cons(head, tail), other) => continue (tail, Cons(head, other))
          #|  } }
        ),
      ),
      "rev": build(
        (
          #|pub fn[A] rev(self : T[A]) -> T[A] { self.rev_concat(Nil) }
        ),
      ),
      "fold": build(
        (
          #|pub fn[A, B] fold(self : T[A], init~ : B, f : (B, A) -> B raise?) -> B raise? { match self {
          #|    Nil => init
          #|    Cons(head, tail) => tail.fold(f, init=f(init, head))
          #|  } }
        ),
      ),
      "zip": build(
        (
          #|pub fn[A, B] zip(self : T[A], other : T[B]) -> T[(A, B)]? { let mut acc = Nil
          #|  let res = loop (self, other) {
          #|    (Nil, Nil) => break Some(acc)
          #|    (Cons(x, xs), Cons(y, ys)) => {
          #|      acc = Cons((x, y), acc)
          #|      continue (xs, ys)
          #|    }
          #|    (_, _) => break None
          #|  }
          #|  res.map(T::rev) }
        ),
      ),
      "concat_map": build(
        (
          #|pub fn[A, B] concat_map(self : T[A], f : (A) -> T[B]) -> T[B] { self.flat_map(f) }
        ),
      ),
      "flat_map": build(
        (
          #|pub fn[A, B] flat_map(self : T[A], f : (A) -> T[B] raise?) -> T[B] raise? { match self {
          #|    Nil => Nil
          #|    Cons(head, tail) => f(head).concat(tail.flat_map(f))
          #|  } }
        ),
      ),
      "filter_map": build(
        (
          #|pub fn[A, B] filter_map(self : T[A], f : (A) -> B?) -> T[B] { loop (Nil, self) {
          #|    (acc, Nil) => acc.rev()
          #|    (acc, Cons(x, xs)) =>
          #|      match f(x) {
          #|        Some(v) => continue (acc.add(v), xs)
          #|        None => continue (acc, xs)
          #|      }
          #|  } }
        ),
      ),
      "unsafe_nth": build(
        (
          #|pub fn[A] unsafe_nth(self : T[A], n : Int) -> A { loop (self, n) {
          #|    (Nil, _) => abort(\"nth: index out of bounds\")
          #|    (Cons(head, _), 0) => head
          #|    (Cons(_, tail), n) => continue (tail, n - 1)
          #|  } }
        ),
      ),
      "nth_exn": build(
        (
          #|pub fn[A] nth_exn(self : T[A], n : Int) -> A { self.unsafe_nth(n) }
        ),
      ),
      "nth": build(
        (
          #|pub fn[A] nth(self : T[A], n : Int) -> A? { loop (self, n) {
          #|    (Nil, _) => None
          #|    (Cons(head, _), 0) => Some(head)
          #|    (Cons(_, tail), n) => continue (tail, n - 1)
          #|  } }
        ),
      ),
      "repeat": build(
        (
          #|pub fn[A] repeat(n : Int, x : A) -> T[A] { if n == 0 {
          #|    Nil
          #|  } else {
          #|    Cons(x, repeat(n - 1, x))
          #|  } }
        ),
      ),
      "intersperse": build(
        (
          #|pub fn[A] intersperse(self : T[A], separator : A) -> T[A] { match self {
          #|    Nil => Nil
          #|    Cons(head, Nil) => Cons(head, Nil)
          #|    Cons(head, tail) => Cons(head, Cons(separator, tail.intersperse(separator)))
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[A] is_empty(self : T[A]) -> Bool { self is Nil }
        ),
      ),
      "unzip": build(
        (
          #|pub fn[A, B] unzip(self : T[(A, B)]) -> (T[A], T[B]) { let mut xs = Nil
          #|  let mut ys = Nil
          #|  // implemented with loop to avoid stack overflow
          #|  loop self.rev() {
          #|    Nil => break (xs, ys)
          #|    Cons((x, y), tail) => {
          #|      xs = Cons(x, xs)
          #|      ys = Cons(y, ys)
          #|      continue tail
          #|    }
          #|  } }
        ),
      ),
      "flatten": build(
        (
          #|pub fn[A] flatten(self : T[T[A]]) -> T[A] { match self {
          #|    Nil => Nil
          #|    Cons(head, tail) => head.concat(tail.flatten())
          #|  } }
        ),
      ),
      "unsafe_maximum": build(
        (
          #|pub fn[A : Compare] unsafe_maximum(self : T[A]) -> A { match self {
          #|    Nil => abort(\"maximum: empty list\")
          #|    Cons(x, Nil) => x
          #|    Cons(x, xs) => {
          #|      let y = xs.unsafe_maximum()
          #|      if x > y {
          #|        x
          #|      } else {
          #|        y
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "maximum": build(
        (
          #|pub fn[A : Compare] maximum(self : T[A]) -> A? { match self {
          #|    Nil => None
          #|    Cons(x, Nil) => Some(x)
          #|    Cons(x, xs) =>
          #|      match xs.maximum() {
          #|        None => Some(x)
          #|        Some(y) => Some(if x > y { x } else { y })
          #|      }
          #|  } }
        ),
      ),
      "unsafe_minimum": build(
        (
          #|pub fn[A : Compare] unsafe_minimum(self : T[A]) -> A { match self {
          #|    Nil => abort(\"minimum: empty list\")
          #|    Cons(x, Nil) => x
          #|    Cons(x, xs) => {
          #|      let y = xs.unsafe_minimum()
          #|      if x < y {
          #|        x
          #|      } else {
          #|        y
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "minimum": build(
        (
          #|pub fn[A : Compare] minimum(self : T[A]) -> A? { match self {
          #|    Nil => None
          #|    Cons(x, Nil) => Some(x)
          #|    Cons(x, xs) =>
          #|      match xs.minimum() {
          #|        None => Some(x)
          #|        Some(y) => Some(if x < y { x } else { y })
          #|      }
          #|  } }
        ),
      ),
      "sort": build(
        (
          #|pub fn[A : Compare] sort(self : T[A]) -> T[A] { match self {
          #|    Nil => Nil
          #|    Cons(x, xs) => {
          #|      let smaller = xs.filter(y => y < x)
          #|      let greater = xs.filter(y => y >= x)
          #|      smaller.sort().concat(Cons(x, greater.sort()))
          #|    }
          #|  } }
        ),
      ),
      "contains": build(
        (
          #|pub fn[A : Eq] contains(self : T[A], value : A) -> Bool { loop self {
          #|    Nil => false
          #|    Cons(x, xs) => if x == value { true } else { continue xs }
          #|  } }
        ),
      ),
      "unfold": build(
        (
          #|pub fn[A, S] unfold(f : (S) -> (A, S)? raise?, init~ : S) -> T[A] raise? { match f(init) {
          #|    Some((element, new_state)) => Cons(element, unfold(init=new_state, f))
          #|    None => Nil
          #|  } }
        ),
      ),
      "take": build(
        (
          #|pub fn[A] take(self : T[A], n : Int) -> T[A] { fn go(n, t) {
          #|    match (n, t) {
          #|      (_, Nil) => Nil
          #|      (1, Cons(x, _)) => Cons(x, Nil)
          #|      (n, Cons(x, xs)) => Cons(x, go(n - 1, xs))
          #|    }
          #|  }
          #|  if n <= 0 {
          #|    Nil
          #|  } else {
          #|    go(n, self)
          #|  } }
        ),
      ),
      "drop": build(
        (
          #|pub fn[A] drop(self : T[A], n : Int) -> T[A] { if n <= 0 {
          #|    self
          #|  } else {
          #|    loop (n, self) {
          #|      (_, Nil) => Nil
          #|      (1, Cons(_, xs)) => xs
          #|      (n, Cons(_, xs)) => continue (n - 1, xs)
          #|    }
          #|  } }
        ),
      ),
      "take_while": build(
        (
          #|pub fn[A] take_while(self : T[A], p : (A) -> Bool) -> T[A] { match self {
          #|    Nil => Nil
          #|    Cons(x, xs) => if p(x) { Cons(x, xs.take_while(p)) } else { Nil }
          #|  } }
        ),
      ),
      "drop_while": build(
        (
          #|pub fn[A] drop_while(self : T[A], p : (A) -> Bool raise?) -> T[A] raise? { loop self {
          #|    Nil => Nil
          #|    Cons(x, xs) => if p(x) { continue xs } else { Cons(x, xs) }
          #|  } }
        ),
      ),
      "lookup": build(
        (
          #|pub fn[A : Eq, B] lookup(self : T[(A, B)], v : A) -> B? { loop self {
          #|    Nil => None
          #|    Cons((x, y), xs) => if x == v { Some(y) } else { continue xs }
          #|  } }
        ),
      ),
      "find": build(
        (
          #|pub fn[A] find(self : T[A], f : (A) -> Bool raise?) -> A? raise? { loop self {
          #|    Nil => None
          #|    Cons(element, list) =>
          #|      if f(element) {
          #|        Some(element)
          #|      } else {
          #|        continue list
          #|      }
          #|  } }
        ),
      ),
      "findi": build(
        (
          #|pub fn[A] findi(self : T[A], f : (A, Int) -> Bool raise?) -> A? raise? { loop (self, 0) {
          #|    (list, index) =>
          #|      match list {
          #|        Nil => None
          #|        Cons(element, list) =>
          #|          if f(element, index) {
          #|            Some(element)
          #|          } else {
          #|            continue (list, index + 1)
          #|          }
          #|      }
          #|  } }
        ),
      ),
      "remove_at": build(
        (
          #|pub fn[A] remove_at(self : T[A], index : Int) -> T[A] { match (index, self) {
          #|    (0, Cons(_, tail)) => tail
          #|    (_, Cons(head, tail)) => Cons(head, tail.remove_at(index - 1))
          #|    (_, Nil) => Nil
          #|    // abort(\"remove_at: index out of bounds\")
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[A : Eq] remove(self : T[A], elem : A) -> T[A] { match self {
          #|    Nil => Nil
          #|    Cons(head, tail) =>
          #|      if head == elem {
          #|        tail
          #|      } else {
          #|        Cons(head, tail.remove(elem))
          #|      }
          #|  } }
        ),
      ),
      "is_prefix": build(
        (
          #|pub fn[A : Eq] is_prefix(self : T[A], prefix : T[A]) -> Bool { loop (self, prefix) {
          #|    (_, Nil) => true
          #|    (Nil, Cons(_)) => false
          #|    (Cons(h1, t1), Cons(h2, t2)) =>
          #|      if h1 == h2 {
          #|        continue (t1, t2)
          #|      } else {
          #|        false
          #|      }
          #|  } }
        ),
      ),
      "is_suffix": build(
        (
          #|pub fn[A : Eq] is_suffix(self : T[A], suffix : T[A]) -> Bool { self.rev().is_prefix(suffix.rev()) }
        ),
      ),
      "intercalate": build(
        (
          #|pub fn[A] intercalate(self : T[T[A]], sep : T[A]) -> T[A] { self.intersperse(sep).flatten() }
        ),
      ),
      "default": build(
        (
          #|pub fn[X] default() -> T[X] { Nil }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A] iter(self : T[A]) -> Iter[A] { Iter::new(yield_ => loop self {
          #|    Nil => IterContinue
          #|    Cons(head, tail) => {
          #|      if yield_(head) == IterEnd {
          #|        break IterEnd
          #|      }
          #|      continue tail
          #|    }
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[A] iter2(self : T[A]) -> Iter2[Int, A] { Iter2::new(yield_ => loop (self, 0) {
          #|    (Nil, _) => IterEnd
          #|    (Cons(head, tail), i) => {
          #|      if yield_(i, head) == IterEnd {
          #|        break IterEnd
          #|      }
          #|      continue (tail, i + 1)
          #|    }
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A] from_iter(iter : Iter[A]) -> T[A] { iter.fold(init=Nil, (acc, e) => Cons(e, acc)).rev() }
        ),
      ),
      "from_iter_rev": build(
        (
          #|pub fn[A] from_iter_rev(iter : Iter[A]) -> T[A] { iter.fold(init=Nil, (acc, e) => Cons(e, acc)) }
        ),
      ),
      "of": build(
        (
          #|pub fn[A] of(arr : FixedArray[A]) -> T[A] { for i = arr.length() - 1, list = Nil; i >= 0; {
          #|    continue i - 1, Cons(arr[i], list)
          #|  } else {
          #|    list
          #|  } }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[A] singleton(x : A) -> T[A] { Cons(x, Nil) }
        ),
      ),
      "init_": build(
        (
          #|pub fn[A] init_(self : T[A]) -> T[A] { fn aux(self) {
          #|    match self {
          #|      Nil => Nil
          #|      Cons(_, Nil) => Nil
          #|      Cons(head, tail) => Cons(head, aux(tail))
          #|    }
          #|  }
          #|  aux(self) }
        ),
      ),
      "equal": build(
        (
          #|pub fn[A : Eq] equal(self : T[A], other : T[A]) -> Bool { loop (self, other) {
          #|    (Nil, Nil) => true
          #|    (Cons(h, t), Cons(h1, t1)) => if h == h1 { continue (t, t1) } else { false }
          #|    (_, _) => false
          #|  } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A] T::from_array(arr : Array[A]) -> T[A] { from_array(arr) }
        ),
      ),
      "default": build(
        (
          #|pub fn[X] T::default() -> T[X] { Nil }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A] T::from_iter(iter : Iter[A]) -> T[A] { from_iter(iter) }
        ),
      ),
      "of": build(
        (
          #|pub fn[A] T::of(arr : FixedArray[A]) -> T[A] { of(arr) }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_immut_priority_queue_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/immut/priority_queue",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
  },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn[A] new() -> T[A] { { node: Empty, size: 0 } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A : Compare] from_array(array : Array[A]) -> T[A] { let mut pq = new()
          #|  for i in 0..<array.length() {
          #|    pq = pq.push(array[i])
          #|  }
          #|  pq }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[A : Compare] to_array(self : T[A]) -> Array[A] { let arr : Array[A] = []
          #|  fn go(x : Node[A]) {
          #|    match x {
          #|      Empty => return
          #|      Leaf(a) => arr.push(a)
          #|      Branch(a, left=l, right=r) => {
          #|        arr.push(a)
          #|        go(l)
          #|        go(r)
          #|      }
          #|    }
          #|  }
          #|  go(self.node)
          #|  arr.sort_by((x, y) => y.compare(x))
          #|  arr }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A : Compare] iter(self : T[A]) -> Iter[A] { Iter::new(yield_ => {
          #|    let arr = self.to_array()
          #|    for i in 0..<arr.length() {
          #|      guard yield_(arr[i]) is IterContinue else { break IterEnd }
          #|    } else {
          #|      IterContinue
          #|    }
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A : Compare] T::from_iter(iter : Iter[A]) -> T[A] { iter.fold(init=new(), (s, e) => s.push(e)) }
        ),
      ),
      "path": build(
        (
          #|fn path(size : Int) -> Path { loop (size, 0) {
          #|    (1, y) => Path(y)
          #|    (x, y) => continue (x >> 1, (y << 1) | (x & 1))
          #|  } }
        ),
      ),
      "is_left": build(
        (
          #|fn is_left(self : Path) -> Bool { (self.0 & 1) == 0 }
        ),
      ),
      "next": build(
        (
          #|fn next(self : Path) -> Path { Path(self.0 >> 1) }
        ),
      ),
      "pop": build(
        (
          #|pub fn[A : Compare] pop(self : T[A]) -> T[A]? { match self.node {
          #|    Empty => None
          #|    Leaf(_) => Some({ node: Empty, size: 0 })
          #|    Branch(_) => {
          #|      let (value, temp) = self.node.remove_last_leaf(path(self.size))
          #|      Some({ node: temp.change_and_down(value), size: self.size - 1 })
          #|    }
          #|  } }
        ),
      ),
      "remove_last_leaf": build(
        (
          #|fn[A : Compare] remove_last_leaf(self : Node[A], path : Path) -> (A, Node[A]) { match self {
          #|    Empty => abort(\"Priority queue is empty!\")
          #|    Leaf(a) => (a, Empty)
          #|    Branch(a, left=Leaf(l_top), right=Empty) => (l_top, Leaf(a))
          #|    Branch(a, left=l, right=r) =>
          #|      if path.is_left() {
          #|        let (e, ld) = l.remove_last_leaf(path.next())
          #|        (e, Branch(a, left=ld, right=r))
          #|      } else {
          #|        let (e, rd) = r.remove_last_leaf(path.next())
          #|        (e, Branch(a, left=l, right=rd))
          #|      }
          #|  } }
        ),
      ),
      "change_and_down": build(
        (
          #|fn[A : Compare] change_and_down(self : Node[A], value : A) -> Node[A] { match self {
          #|    Empty => abort(\"unreachable\")
          #|    Leaf(_) => Leaf(value)
          #|    Branch(_, left=l, right=r) =>
          #|      match (l, r) {
          #|        (Leaf(l_top), Empty) =>
          #|          if value >= l_top {
          #|            Branch(value, left=l, right=Empty)
          #|          } else {
          #|            Branch(l_top, left=Leaf(value), right=Empty)
          #|          }
          #|        (Branch(l_top, ..) | Leaf(l_top), Branch(r_top, ..) | Leaf(r_top)) =>
          #|          if value >= l_top && value >= r_top {
          #|            Branch(value, left=l, right=r)
          #|          } else if l_top >= r_top {
          #|            Branch(l_top, left=l.change_and_down(value), right=r)
          #|          } else {
          #|            Branch(r_top, left=l, right=r.change_and_down(value))
          #|          }
          #|        _ => abort(\"unreachable\")
          #|      }
          #|  } }
        ),
      ),
      "unsafe_pop": build(
        (
          #|pub fn[A : Compare] unsafe_pop(self : T[A]) -> T[A] { match self.node {
          #|    Empty => abort(\"Priority queue is empty!\")
          #|    Leaf(_) => { node: Empty, size: 0 }
          #|    Branch(_) => {
          #|      let (value, temp) = self.node.remove_last_leaf(path(self.size))
          #|      { node: temp.change_and_down(value), size: self.size - 1 }
          #|    }
          #|  } }
        ),
      ),
      "push": build(
        (
          #|pub fn[A : Compare] push(self : T[A], value : A) -> T[A] { match self.node {
          #|    Empty => { node: Leaf(value), size: 1 }
          #|    Leaf(_) | Branch(_) => {
          #|      let size = self.size + 1
          #|      { node: self.node.push(value, path(size)), size }
          #|    }
          #|  } }
        ),
      ),
      "push": build(
        (
          #|fn[A : Compare] Node::push(self : Node[A], value : A, path : Path) -> Node[A] { match self {
          #|    Empty => Leaf(value)
          #|    Leaf(a) => {
          #|      let (high, low) = if a > value { (a, value) } else { (value, a) }
          #|      Branch(high, left=Leaf(low), right=Empty)
          #|    }
          #|    Branch(a, left=l, right=r) => {
          #|      let (high, low) = if a > value { (a, value) } else { (value, a) }
          #|      if path.is_left() {
          #|        Branch(high, left=l.push(low, path.next()), right=r)
          #|      } else {
          #|        Branch(high, left=l, right=r.push(low, path.next()))
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "peek": build(
        (
          #|pub fn[A] peek(self : T[A]) -> A? { match self.node {
          #|    Empty => None
          #|    Leaf(a) => Some(a)
          #|    Branch(a, ..) => Some(a)
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[A] is_empty(self : T[A]) -> Bool { self.node is Empty }
        ),
      ),
      "length": build(
        (
          #|pub fn[A] length(self : T[A]) -> Int { self.size }
        ),
      ),
      "of": build(
        (
          #|pub fn[A : Compare] of(arr : FixedArray[A]) -> T[A] { let mut pq = new()
          #|  for i in 0..<arr.length() {
          #|    pq = pq.push(arr[i])
          #|  }
          #|  pq }
        ),
      ),
      "pop_exn": build(
        (
          #|pub fn[A : Compare] pop_exn(self : T[A]) -> T[A] { self.unsafe_pop() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_immut_sorted_map_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/immut/sorted_map",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/tuple": moonbitlang_core_tuple_module,
    "moonbitlang/core/string": moonbitlang_core_string_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
  },
  fn(_env, build) {
    {
      "add": build(
        (
          #|pub fn[K : Compare, V] add(self : T[K, V], key : K, value : V) -> T[K, V] { match self {
          #|    Empty => singleton(key, value)
          #|    Tree(k, value=v, l, r, ..) => {
          #|      let c = key.compare(k)
          #|      if c == 0 {
          #|        make_tree(k, value, l, r)
          #|      } else if c < 0 {
          #|        balance(k, v, l.add(key, value), r)
          #|      } else {
          #|        balance(k, v, l, r.add(key, value))
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "split_max": build(
        (
          #|fn[K : Compare, V] split_max(self : T[K, V]) -> (K, V, T[K, V]) { match self {
          #|    Tree(k, value=v, l, Empty, ..) => (k, v, l)
          #|    Tree(k, value=v, l, r, ..) => {
          #|      let (k1, v1, r) = r.split_max()
          #|      (k1, v1, balance(k, v, l, r))
          #|    }
          #|    Empty => abort(\"Map::split_max error\")
          #|  } }
        ),
      ),
      "split_min": build(
        (
          #|fn[K : Compare, V] split_min(self : T[K, V]) -> (K, V, T[K, V]) { match self {
          #|    Tree(k, value=v, Empty, r, ..) => (k, v, r)
          #|    Tree(k, value=v, l, r, ..) => {
          #|      let (k1, v1, l) = l.split_min()
          #|      (k1, v1, balance(k, v, l, r))
          #|    }
          #|    Empty => abort(\"Map::split_min error\")
          #|  } }
        ),
      ),
      "glue": build(
        (
          #|fn[K : Compare, V] glue(l : T[K, V], r : T[K, V]) -> T[K, V] { match (l, r) {
          #|    (Empty, r) => r
          #|    (l, Empty) => l
          #|    (l, r) =>
          #|      if l.size() > r.size() {
          #|        let (k, v, l) = l.split_max()
          #|        balance(k, v, l, r)
          #|      } else {
          #|        let (k, v, r) = r.split_min()
          #|        balance(k, v, l, r)
          #|      }
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[K : Compare, V] remove(self : T[K, V], key : K) -> T[K, V] { match self {
          #|    Empty => Empty
          #|    Tree(k, value=v, l, r, ..) => {
          #|      let c = key.compare(k)
          #|      if c == 0 {
          #|        glue(l, r)
          #|      } else if c < 0 {
          #|        balance(k, v, l.remove(key), r)
          #|      } else {
          #|        balance(k, v, l, r.remove(key))
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[K, V] to_array(self : T[K, V]) -> Array[(K, V)] { let arr = []
          #|  self.each((k, v) => arr.push((k, v)))
          #|  arr }
        ),
      ),
      "ratio": (None, Int(5)),
      "balance": build(
        (
          #|fn[K, V] balance(key : K, value : V, l : T[K, V], r : T[K, V]) -> T[K, V] { //       1                   2
          #|  //      / \\                 / \\
          #|  //     x   2       --->    1   z
          #|  //        / \\             / \\
          #|  //       y   z           x   y
          #|  fn single_l(k1, v1, x, r) {
          #|    guard r is Tree(k2, value=v2, y, z, ..)
          #|    make_tree(k2, v2, make_tree(k1, v1, x, y), z)
          #|  }
          #|  fn single_r(k2, v2, l, z) {
          #|    guard l is Tree(k1, value=v1, x, y, ..)
          #|    make_tree(k1, v1, x, make_tree(k2, v2, y, z))
          #|  }
          #|  //      1                 2
          #|  //     / \\              /   \\
          #|  //    x   3            1     3
          #|  //       / \\    -->   / \\   / \\
          #|  //      2   z        x  y1 y2  z
          #|  //     / \\
          #|  //    y1 y2
          #|  fn double_l(k1, v1, x, r) {
          #|    guard r is Tree(k3, value=v3, Tree(k2, value=v2, y1, y2, ..), z, ..)
          #|    make_tree(k2, v2, make_tree(k1, v1, x, y1), make_tree(k3, v3, y2, z))
          #|  }
          #|  //      3                 2
          #|  //     / \\              /   \\
          #|  //    1   z            1     3
          #|  //   / \\        -->   / \\   / \\
          #|  //  x  2             x  y1 y2  z
          #|  //    / \\
          #|  //   y1 y2
          #|  fn double_r(k3, v3, l, z) {
          #|    guard l is Tree(k1, value=v1, x, Tree(k2, value=v2, y1, y2, ..), ..)
          #|    make_tree(k2, v2, make_tree(k1, v1, x, y1), make_tree(k3, v3, y2, z))
          #|  }
          #|  let ln = l.size()
          #|  let rn = r.size()
          #|  if ln + rn < 2 {
          #|    make_tree(key, value, l, r)
          #|  } else if rn > ratio * ln {
          #|    // right is too big
          #|    guard r is Tree(_, rl, rr, ..)
          #|    let rln = rl.size()
          #|    let rrn = rr.size()
          #|    if rln < rrn {
          #|      single_l(key, value, l, r)
          #|    } else {
          #|      double_l(key, value, l, r)
          #|    }
          #|  } else if ln > ratio * rn {
          #|    // left is too big
          #|    guard l is Tree(_, ll, lr, ..)
          #|    let lln = ll.size()
          #|    let lrn = lr.size()
          #|    if lrn < lln {
          #|      single_r(key, value, l, r)
          #|    } else {
          #|      double_r(key, value, l, r)
          #|    }
          #|  } else {
          #|    make_tree(key, value, l, r)
          #|  } }
        ),
      ),
      "insert": build(
        (
          #|pub fn[K : Compare, V] insert(self : T[K, V], key : K, value : V) -> T[K, V] { self.add(key, value) }
        ),
      ),
      "new": build(
        (
          #|pub fn[K, V] T::new() -> T[K, V] { Empty }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[K, V] T::singleton(key : K, value : V) -> T[K, V] { singleton(key, value) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[K : Compare, V] T::from_array(array : Array[(K, V)]) -> T[K, V] { from_array(array) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[K : Compare, V] T::from_iter(iter : Iter[(K, V)]) -> T[K, V] { from_iter(iter) }
        ),
      ),
      "of": build(
        (
          #|pub fn[K : Compare, V] T::of(array : FixedArray[(K, V)]) -> T[K, V] { of(array) }
        ),
      ),
      "empty": build(
        (
          #|pub fn[K, V] T::empty() -> T[K, V] { Empty }
        ),
      ),
      "new": build(
        (
          #|pub fn[K, V] new() -> T[K, V] { Empty }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[K, V] singleton(key : K, value : V) -> T[K, V] { Tree(key, value~, size=1, Empty, Empty) }
        ),
      ),
      "contains": build(
        (
          #|pub fn[K : Compare, V] contains(self : T[K, V], key : K) -> Bool { loop self {
          #|    Empty => false
          #|    Tree(k, l, r, ..) => {
          #|      let c = key.compare(k)
          #|      if c == 0 {
          #|        true
          #|      } else if c < 0 {
          #|        continue l
          #|      } else {
          #|        continue r
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "size": build(
        (
          #|pub fn[K, V] size(self : T[K, V]) -> Int { match self {
          #|    Empty => 0
          #|    Tree(_) as t => t.size
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[K, V] is_empty(self : T[K, V]) -> Bool { self.size() == 0 }
        ),
      ),
      "make_tree": build(
        (
          #|fn[K, V] make_tree(key : K, value : V, l : T[K, V], r : T[K, V]) -> T[K, V] { let size = l.size() + r.size() + 1
          #|  Tree(key, value~, size~, l, r) }
        ),
      ),
      "lookup": build(
        (
          #|pub fn[K : Compare, V] lookup(self : T[K, V], key : K) -> V? { self.get(key) }
        ),
      ),
      "get": build(
        (
          #|pub fn[K : Compare, V] get(self : T[K, V], key : K) -> V? { loop self {
          #|    Empty => None
          #|    Tree(k, value~, l, r, ..) => {
          #|      let c = key.compare(k)
          #|      if c == 0 {
          #|        Some(value)
          #|      } else if c < 0 {
          #|        continue l
          #|      } else {
          #|        continue r
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "op_get": build(
        (
          #|pub fn[K : Compare, V] op_get(self : T[K, V], key : K) -> V? { self.get(key) }
        ),
      ),
      "each": build(
        (
          #|pub fn[K, V] each(self : T[K, V], f : (K, V) -> Unit) -> Unit { match self {
          #|    Empty => ()
          #|    Tree(k, value~, l, r, ..) => {
          #|      l.each(f)
          #|      f(k, value)
          #|      r.each(f)
          #|    }
          #|  } }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[K, V] eachi(self : T[K, V], f : (Int, K, V) -> Unit) -> Unit { fn do_eachi(m : T[K, V], f, i) {
          #|    match m {
          #|      Empty => ()
          #|      Tree(k, value~, l, r, ..) => {
          #|        do_eachi(l, f, i)
          #|        f(l.size() + i, k, value)
          #|        do_eachi(r, f, l.size() + i + 1)
          #|      }
          #|    }
          #|  }
          #|  do_eachi(self, f, 0) }
        ),
      ),
      "map": build(
        (
          #|pub fn[K, X, Y] map(self : T[K, X], f : (X) -> Y) -> T[K, Y] { match self {
          #|    Empty => Empty
          #|    Tree(k, value~, size~, l, r) =>
          #|      Tree(k, value=f(value), size~, l.map(f), r.map(f))
          #|  } }
        ),
      ),
      "map_with_key": build(
        (
          #|pub fn[K, X, Y] map_with_key(self : T[K, X], f : (K, X) -> Y) -> T[K, Y] { match self {
          #|    Empty => Empty
          #|    Tree(k, value~, l, r, size~) =>
          #|      Tree(k, value=f(k, value), size~, l.map_with_key(f), r.map_with_key(f))
          #|  } }
        ),
      ),
      "fold": build(
        (
          #|pub fn[K, V, A] fold(self : T[K, V], init~ : A, f : (A, V) -> A) -> A { self.foldl_with_key((acc, _k, v) => f(acc, v), init~) }
        ),
      ),
      "debug_tree": build(
        (
          #|fn[K : Show, V : Show] debug_tree(self : T[K, V]) -> String { match self {
          #|    Empty => \"_\"
          #|    Tree(k, value~, l, r, ..) => {
          #|      let l = l.debug_tree()
          #|      let r = r.debug_tree()
          #|      \"(\\{k},\\{value},\\{l},\\{r})\"
          #|    }
          #|  } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[K : Compare, V] from_array(array : Array[(K, V)]) -> T[K, V] { for i = 0, mp = Empty; i < array.length(); {
          #|    let (k, v) = array[i]
          #|    continue i + 1, mp.add(k, v)
          #|  } else {
          #|    mp
          #|  } }
        ),
      ),
      "iter": build(
        (
          #|pub fn[K, V] iter(self : T[K, V]) -> Iter[(K, V)] { Iter::new(yield_ => {
          #|    fn go(t) {
          #|      match t {
          #|        Empty => IterContinue
          #|        Tree(k, value~, l, r, ..) =>
          #|          if go(l) is IterEnd {
          #|            IterEnd
          #|          } else if yield_((k, value)) is IterEnd {
          #|            IterEnd
          #|          } else {
          #|            go(r)
          #|          }
          #|      }
          #|    }
          #|    go(self)
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[K, V] iter2(self : T[K, V]) -> Iter2[K, V] { Iter2::new(yield_ => {
          #|    fn go(t) {
          #|      match t {
          #|        Empty => IterContinue
          #|        Tree(k, value~, l, r, ..) =>
          #|          if go(l) is IterEnd {
          #|            IterEnd
          #|          } else if yield_(k, value) is IterEnd {
          #|            IterEnd
          #|          } else {
          #|            go(r)
          #|          }
          #|      }
          #|    }
          #|    go(self)
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[K : Compare, V] from_iter(iter : Iter[(K, V)]) -> T[K, V] { iter.fold(init=new(), (m, e) => m.add(e.0, e.1)) }
        ),
      ),
      "keys": build(
        (
          #|pub fn[K, V] keys(self : T[K, V]) -> Array[K] { self.iter().map(p => p.0).collect() }
        ),
      ),
      "values": build(
        (
          #|pub fn[K, V] values(self : T[K, V]) -> Iter[V] { self.iter().map(p => p.1) }
        ),
      ),
      "elems": build(
        (
          #|pub fn[K, V] elems(self : T[K, V]) -> Array[V] { self.values().collect() }
        ),
      ),
      "of": build(
        (
          #|pub fn[K : Compare, V] of(array : FixedArray[(K, V)]) -> T[K, V] { for i = 0, mp = Empty; i < array.length(); {
          #|    let (k, v) = array[i]
          #|    continue i + 1, mp.add(k, v)
          #|  } else {
          #|    mp
          #|  } }
        ),
      ),
      "to_json": build(
        (
          #|pub fn[K : Show, V : ToJson] to_json(self : T[K, V]) -> Json { ToJson::to_json(self) }
        ),
      ),
      "new": build(
        (
          #|fn[K, V] InorderIterator::new(root : T[K, V]) -> InorderIterator[K, V] { let it = InorderIterator([])
          #|  it.move_left(root)
          #|  it }
        ),
      ),
      "next": build(
        (
          #|fn[K, V] InorderIterator::next(self : InorderIterator[K, V]) -> (K, V)? { let InorderIterator(s) = self
          #|  guard s.pop() is Some(curr) else { return None }
          #|  guard curr is Tree(key, _, right, value~, ..)
          #|  self.move_left(right)
          #|  Some((key, value)) }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_immut_sorted_set_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/immut/sorted_set",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
  },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn[A] T::new() -> T[A] { Empty }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[A] T::singleton(value : A) -> T[A] { singleton(value) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A : Compare] T::from_array(array : Array[A]) -> T[A] { from_array(array) }
        ),
      ),
      "of": build(
        (
          #|pub fn[A : Compare] T::of(array : FixedArray[A]) -> T[A] { of(array) }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A] iter(self : T[A]) -> Iter[A] { Iter::new(yield_ => {
          #|    fn go(t) {
          #|      match t {
          #|        Empty => IterContinue
          #|        Node(left~, right~, value~, ..) =>
          #|          if go(left) is IterEnd {
          #|            IterEnd
          #|          } else if yield_(value) is IterEnd {
          #|            IterEnd
          #|          } else {
          #|            go(right)
          #|          }
          #|      }
          #|    }
          #|    go(self)
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A : Compare] from_iter(iter : Iter[A]) -> T[A] { iter.fold(init=new(), (s, e) => s.add(e)) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A : Compare] T::from_iter(iter : Iter[A]) -> T[A] { from_iter(iter) }
        ),
      ),
      "new": build(
        (
          #|fn[A] InorderIterator::new(root : T[A]) -> InorderIterator[A] { let it = InorderIterator([])
          #|  it.move_left(root)
          #|  it }
        ),
      ),
      "next": build(
        (
          #|fn[A] InorderIterator::next(self : InorderIterator[A]) -> A? { let InorderIterator(s) = self
          #|  guard s.pop() is Some(curr) else { return None }
          #|  guard curr is Node(right~, value~, ..)
          #|  self.move_left(right)
          #|  Some(value) }
        ),
      ),
      "new": build(
        (
          #|pub fn[A] new() -> T[A] { Empty }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[A] singleton(value : A) -> T[A] { Node(left=Empty, value~, right=Empty, size=1) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A : Compare] from_array(array : Array[A]) -> T[A] { for i = array.length() - 1, set = Empty; i >= 0; {
          #|    continue i - 1, set.add(array[i])
          #|  } else {
          #|    set
          #|  } }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[A] to_array(self : T[A]) -> Array[A] { let arr = []
          #|  fn aux(set : T[A]) {
          #|    match set {
          #|      Empty => ()
          #|      Node(left~, value~, right~, ..) => {
          #|        aux(left)
          #|        arr.push(value)
          #|        aux(right)
          #|        //TODO: rewrite [...aux(left),value,...aux(right)]
          #|      }
          #|    }
          #|  }
          #|  aux(self)
          #|  arr }
        ),
      ),
      "remove_min": build(
        (
          #|pub fn[A : Compare] remove_min(self : T[A]) -> T[A] { match self {
          #|    Empty => abort(\"remove_min: empty ImmutableSet\")
          #|    Node(left~, right~, value~, ..) =>
          #|      if left is Empty {
          #|        right
          #|      } else {
          #|        balance(left.remove_min(), value, right)
          #|      }
          #|  } }
        ),
      ),
      "add": build(
        (
          #|pub fn[A : Compare] add(self : T[A], value : A) -> T[A] { match self {
          #|    Empty => Node(left=Empty, value~, right=Empty, size=1)
          #|    Node(left~, right~, value=node_value, ..) => {
          #|      let compare_result = value.compare(node_value)
          #|      if compare_result == 0 {
          #|        self
          #|      } else if compare_result < 0 {
          #|        let ll = left.add(value)
          #|        if physical_equal(left, ll) {
          #|          self
          #|        } else {
          #|          balance(ll, node_value, right)
          #|        }
          #|      } else {
          #|        let rr = right.add(value)
          #|        if physical_equal(right, rr) {
          #|          self
          #|        } else {
          #|          balance(left, node_value, rr)
          #|        }
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[A : Compare] remove(self : T[A], value : A) -> T[A] { match self {
          #|    Empty => Empty
          #|    Node(left~, right~, value=node_value, ..) => {
          #|      let compare_result = value.compare(node_value)
          #|      if compare_result == 0 {
          #|        left.merge(right)
          #|      } else if compare_result < 0 {
          #|        let new_left = left.remove(value)
          #|        if physical_equal(left, new_left) {
          #|          self
          #|        } else {
          #|          balance(new_left, node_value, right)
          #|        }
          #|      } else {
          #|        let new_right = right.remove(value)
          #|        if physical_equal(right, new_right) {
          #|          self
          #|        } else {
          #|          balance(left, node_value, new_right)
          #|        }
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "min": build(
        (
          #|pub fn[A : Compare] min(self : T[A]) -> A { match self {
          #|    Empty => abort(\"min: there are no values in sorted_set.\")
          #|    Node(left~, value~, ..) => if left is Empty { value } else { left.min() }
          #|  } }
        ),
      ),
      "min_option": build(
        (
          #|pub fn[A : Compare] min_option(self : T[A]) -> A? { match self {
          #|    Empty => None
          #|    Node(left~, value~, ..) =>
          #|      if left is Empty {
          #|        Some(value)
          #|      } else {
          #|        left.min_option()
          #|      }
          #|  } }
        ),
      ),
      "max": build(
        (
          #|pub fn[A : Compare] max(self : T[A]) -> A { match self {
          #|    Empty => abort(\"max: there are no values in ImmutableSet.\")
          #|    Node(right~, value~, ..) => if right is Empty { value } else { right.max() }
          #|  } }
        ),
      ),
      "max_option": build(
        (
          #|pub fn[A : Compare] max_option(self : T[A]) -> A? { match self {
          #|    Empty => None
          #|    Node(right~, value~, ..) =>
          #|      if right is Empty {
          #|        Some(value)
          #|      } else {
          #|        right.max_option()
          #|      }
          #|  } }
        ),
      ),
      "split": build(
        (
          #|pub fn[A : Compare] split(self : T[A], divide : A) -> (T[A], Bool, T[A]) { match self {
          #|    Empty => (Empty, false, Empty)
          #|    Node(left~, right~, value~, ..) => {
          #|      let compare_result = divide.compare(value)
          #|      if compare_result == 0 {
          #|        (left, true, right)
          #|      } else if compare_result < 0 {
          #|        let (left_left, present, right_left) = left.split(divide)
          #|        (left_left, present, join(right_left, value, right))
          #|      } else {
          #|        let (left_right, present, right_right) = right.split(divide)
          #|        (join(left, value, left_right), present, right_right)
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[A] is_empty(self : T[A]) -> Bool { self is Empty }
        ),
      ),
      "contains": build(
        (
          #|pub fn[A : Compare] contains(self : T[A], value : A) -> Bool { match self {
          #|    Empty => false
          #|    Node(left~, right~, value=node_value, ..) => {
          #|      let compare_result = value.compare(node_value)
          #|      compare_result == 0 ||
          #|      (if compare_result < 0 { left } else { right }).contains(value)
          #|    }
          #|  } }
        ),
      ),
      "union": build(
        (
          #|pub fn[A : Compare] union(self : T[A], other : T[A]) -> T[A] { match (self, other) {
          #|    (Empty, _) => other
          #|    (_, Empty) => self
          #|    (
          #|      Node(left=l1, value=v1, right=r1, size=s1),
          #|      Node(left=l2, value=v2, right=r2, size=s2),
          #|    ) =>
          #|      if s1 >= s2 {
          #|        if s2 == 1 {
          #|          self.add(v2)
          #|        } else {
          #|          let (l2, _, r2) = other.split(v1)
          #|          join(l1.union(l2), v1, r1.union(r2))
          #|        }
          #|      } else if s1 == 1 {
          #|        other.add(v1)
          #|      } else {
          #|        let (l1, _, r1) = self.split(v2)
          #|        join(l1.union(l2), v2, r1.union(r2))
          #|      }
          #|  } }
        ),
      ),
      "inter": build(
        (
          #|pub fn[A : Compare] inter(self : T[A], other : T[A]) -> T[A] { self.intersection(other) }
        ),
      ),
      "intersection": build(
        (
          #|pub fn[A : Compare] intersection(self : T[A], other : T[A]) -> T[A] { match (self, other) {
          #|    (Empty, _) | (_, Empty) => Empty
          #|    (Node(left=l1, value=v1, right=r1, ..), _) =>
          #|      match other.split(v1) {
          #|        (l2, false, r2) => l1.intersection(l2).concat(r1.intersection(r2))
          #|        (l2, true, r2) => join(l1.intersection(l2), v1, r1.intersection(r2))
          #|      }
          #|  } }
        ),
      ),
      "diff": build(
        (
          #|pub fn[A : Compare] diff(self : T[A], other : T[A]) -> T[A] { self.difference(other) }
        ),
      ),
      "difference": build(
        (
          #|pub fn[A : Compare] difference(self : T[A], other : T[A]) -> T[A] { match (self, other) {
          #|    (Empty, _) => Empty
          #|    (_, Empty) => self
          #|    (Node(left=l1, value=v1, right=r1, ..), _) =>
          #|      match other.split(v1) {
          #|        (l2, false, r2) => join(l1.difference(l2), v1, r1.difference(r2))
          #|        (l2, true, r2) => l1.difference(l2).concat(r1.difference(r2))
          #|      }
          #|  } }
        ),
      ),
      "symmetric_difference": build(
        (
          #|pub fn[A : Compare] symmetric_difference(self : T[A], other : T[A]) -> T[A] { match (self, other) {
          #|    (Empty, _) => other
          #|    (_, Empty) => self
          #|    (Node(left=l1, value=v1, right=r1, ..), _) =>
          #|      match other.split(v1) {
          #|        (l2, false, r2) =>
          #|          join(l1.symmetric_difference(l2), v1, r1.symmetric_difference(r2))
          #|        (l2, true, r2) =>
          #|          l1.symmetric_difference(l2).concat(r1.symmetric_difference(r2))
          #|      }
          #|  } }
        ),
      ),
      "subset": build(
        (
          #|pub fn[A : Compare] subset(self : T[A], other : T[A]) -> Bool { match (self, other) {
          #|    (Empty, _) => true
          #|    (_, Empty) => false
          #|    (
          #|      Node(left=l1, value=v1, right=r1, ..),
          #|      Node(left=l2, value=v2, right=r2, ..),
          #|    ) => {
          #|      let compare_result = v1.compare(v2)
          #|      if compare_result == 0 {
          #|        l1.subset(l2) && r1.subset(r2)
          #|      } else if compare_result < 0 {
          #|        Node(left=l1, value=v1, right=Empty, size=1).subset(l2) &&
          #|        r1.subset(self)
          #|      } else {
          #|        Node(left=Empty, value=v1, right=r1, size=1).subset(r2) &&
          #|        l1.subset(self)
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "disjoint": build(
        (
          #|pub fn[A : Compare] disjoint(self : T[A], other : T[A]) -> Bool { match (self, other) {
          #|    (Empty, _) | (_, Empty) => true
          #|    (Node(left=l1, value=v1, right=r1, ..), _) =>
          #|      if physical_equal(self, other) {
          #|        false
          #|      } else {
          #|        match other.split_bis(v1) {
          #|          NotFound(l2, r2) => l1.disjoint(l2) && r1.disjoint(r2())
          #|          Found => false
          #|        }
          #|      }
          #|  } }
        ),
      ),
      "each": build(
        (
          #|pub fn[A] each(self : T[A], f : (A) -> Unit raise?) -> Unit raise? { match self {
          #|    Empty => ()
          #|    Node(left~, value~, right~, ..) => {
          #|      left.each(f)
          #|      f(value)
          #|      right.each(f)
          #|    }
          #|  } }
        ),
      ),
      "all": build(
        (
          #|pub fn[A : Compare] all(self : T[A], f : (A) -> Bool raise?) -> Bool raise? { match self {
          #|    Empty => true
          #|    Node(left~, value~, right~, ..) => f(value) && left.all(f) && right.all(f)
          #|  } }
        ),
      ),
      "any": build(
        (
          #|pub fn[A : Compare] any(self : T[A], f : (A) -> Bool raise?) -> Bool raise? { match self {
          #|    Empty => false
          #|    Node(left~, value~, right~, ..) => f(value) || left.any(f) || right.any(f)
          #|  } }
        ),
      ),
      "filter": build(
        (
          #|pub fn[A : Compare] filter(self : T[A], f : (A) -> Bool raise?) -> T[A] raise? { match self {
          #|    Empty => Empty
          #|    Node(left~, value~, right~, ..) => {
          #|      let l = left.filter(f)
          #|      let v = f(value)
          #|      let r = right.filter(f)
          #|      if v {
          #|        if physical_equal(l, left) && physical_equal(r, right) {
          #|          self
          #|        } else {
          #|          join(l, value, r)
          #|        }
          #|      } else {
          #|        l.concat(r)
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "to_json": build(
        (
          #|pub fn[A : ToJson] to_json(self : T[A]) -> Json { ToJson::to_json(self) }
        ),
      ),
      "split_bis": build(
        (
          #|fn[A : Compare] split_bis(self : T[A], value : A) -> SplitBis[A] { match self {
          #|    Empty => NotFound(Empty, () => Empty)
          #|    Node(left~, value=node_value, right~, ..) => {
          #|      let compare_result = value.compare(node_value)
          #|      if compare_result == 0 {
          #|        Found
          #|      } else if compare_result < 0 {
          #|        match left.split_bis(value) {
          #|          Found => Found
          #|          NotFound(ll, rl) => NotFound(ll, () => join(rl(), node_value, right))
          #|        }
          #|      } else {
          #|        match right.split_bis(value) {
          #|          Found => Found
          #|          NotFound(lr, rr) => NotFound(join(left, node_value, lr), rr)
          #|        }
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "size": build(
        (
          #|pub fn[A] size(self : T[A]) -> Int { match self {
          #|    Empty => 0
          #|    Node(size~, ..) => size
          #|  } }
        ),
      ),
      "create": build(
        (
          #|fn[A] create(left : T[A], value : A, right : T[A]) -> T[A] { Node(left~, right~, value~, size=left.size() + right.size() + 1) }
        ),
      ),
      "balance": build(
        (
          #|fn[A] balance(left : T[A], value : A, right : T[A]) -> T[A] { let left_size = left.size()
          #|  let right_size = right.size()
          #|  if left_size + right_size < 2 {
          #|    create(left, value, right)
          #|  } else if left_size > right_size * BALANCE_RATIO {
          #|    match left {
          #|      Empty => abort(\"balance: left is empty.\")
          #|      Node(left=ll, value=lv, right=lr, ..) =>
          #|        if ll.size() >= lr.size() {
          #|          create(ll, lv, create(lr, value, right))
          #|        } else {
          #|          match lr {
          #|            Empty => abort(\"balance: right left.right is empty.\")
          #|            Node(left=lrl, value=lrv, right=lrr, ..) =>
          #|              create(create(ll, lv, lrl), lrv, create(lrr, value, right))
          #|          }
          #|        }
          #|    }
          #|  } else if right_size > left_size * BALANCE_RATIO {
          #|    match right {
          #|      Empty => abort(\"balance: right is empty\")
          #|      Node(left=rl, value=rv, right=rr, ..) =>
          #|        if rr.size() >= rl.size() {
          #|          create(create(left, value, rl), rv, rr)
          #|        } else {
          #|          match rl {
          #|            Empty => abort(\"balance: right.left is empty\")
          #|            Node(left=rll, value=rlv, right=rlr, ..) =>
          #|              create(create(left, value, rll), rlv, create(rlr, rv, rr))
          #|          }
          #|        }
          #|    }
          #|  } else {
          #|    create(left, value, right)
          #|  } }
        ),
      ),
      "add_min_value": build(
        (
          #|fn[A : Compare] add_min_value(self : T[A], value : A) -> T[A] { match self {
          #|    Empty => singleton(value)
          #|    Node(left~, value=node_value, right~, ..) =>
          #|      balance(left.add_min_value(value), node_value, right)
          #|  } }
        ),
      ),
      "add_max_value": build(
        (
          #|fn[A : Compare] add_max_value(self : T[A], value : A) -> T[A] { match self {
          #|    Empty => singleton(value)
          #|    Node(left~, value=node_value, right~, ..) =>
          #|      balance(left, node_value, right.add_max_value(value))
          #|  } }
        ),
      ),
      "join": build(
        (
          #|fn[A : Compare] join(left : T[A], value : A, right : T[A]) -> T[A] { match (left, right) {
          #|    (Empty, _) => right.add_min_value(value)
          #|    (_, Empty) => left.add_max_value(value)
          #|    (
          #|      Node(left=ll, value=lv, right=lr, size=ls),
          #|      Node(left=rl, value=rv, right=rr, size=rs),
          #|    ) =>
          #|      if ls > rs * BALANCE_RATIO {
          #|        balance(ll, lv, join(lr, value, right))
          #|      } else if rs > ls * BALANCE_RATIO {
          #|        balance(join(left, value, rl), rv, rr)
          #|      } else {
          #|        create(left, value, right)
          #|      }
          #|  } }
        ),
      ),
      "try_join": build(
        (
          #|fn[A : Compare] try_join(left : T[A], value : A, right : T[A]) -> T[A] { if (left == Empty || left.max().compare(value) < 0) &&
          #|    (right == Empty || value.compare(right.min()) < 0) {
          #|    join(left, value, right)
          #|  } else {
          #|    left.union(right.add(value))
          #|  } }
        ),
      ),
      "merge": build(
        (
          #|fn[A : Compare] merge(self : T[A], other : T[A]) -> T[A] { match (self, other) {
          #|    (Empty, _) => other
          #|    (_, Empty) => self
          #|    _ => balance(self, other.min(), other.remove_min())
          #|  } }
        ),
      ),
      "concat": build(
        (
          #|fn[A : Compare] concat(self : T[A], other : T[A]) -> T[A] { match (self, other) {
          #|    (Empty, _) => other
          #|    (_, Empty) => self
          #|    _ => join(self, other.min(), other.remove_min())
          #|  } }
        ),
      ),
      "of": build(
        (
          #|pub fn[A : Compare] of(array : FixedArray[A]) -> T[A] { for i = array.length() - 1, set = Empty; i >= 0; {
          #|    continue i - 1, set.add(array[i])
          #|  } else {
          #|    set
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_int_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/int",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/uint": moonbitlang_core_uint_module,
  },
  fn(_env, build) {
    {
      "max_value": (None, Int(2147483647)),
      "min_value": (None, Int(-2147483648)),
      "abs": build(
        (
          #|pub fn Int::abs(self : Int) -> Int { if self < 0 {
          #|    -self
          #|  } else {
          #|    self
          #|  } }
        ),
      ),
      "to_be_bytes": build(
        (
          #|pub fn to_be_bytes(self : Int) -> Bytes { self.reinterpret_as_uint().to_be_bytes() }
        ),
      ),
      "to_le_bytes": build(
        (
          #|pub fn to_le_bytes(self : Int) -> Bytes { self.reinterpret_as_uint().to_le_bytes() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_int16_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/int16",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
  },
  fn(_env, build) {
    {
      "abs": build(
        (
          #|pub fn Int16::abs(self : Int16) -> Int16 { if self < 0 {
          #|    -self
          #|  } else {
          #|    self
          #|  } }
        ),
      ),
      "reinterpret_as_uint16": build(
        (
          #|pub fn Int16::reinterpret_as_uint16(self : Int16) -> UInt16 { self.to_int().to_uint16() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_int64_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/int64",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/bytes": moonbitlang_core_bytes_module,
    "moonbitlang/core/uint": moonbitlang_core_uint_module,
    "moonbitlang/core/uint64": moonbitlang_core_uint64_module,
  },
  fn(_env, build) {
    {
      "max_value": (None, Int64(9223372036854775807L)),
      "min_value": (None, Int64(-9223372036854775808L)),
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
          #|pub fn Int64::abs(self : Int64) -> Int64 { if self < 0L {
          #|    -self
          #|  } else {
          #|    self
          #|  } }
        ),
      ),
      "to_be_bytes": build(
        (
          #|pub fn to_be_bytes(self : Int64) -> Bytes { self.reinterpret_as_uint64().to_be_bytes() }
        ),
      ),
      "to_le_bytes": build(
        (
          #|pub fn to_le_bytes(self : Int64) -> Bytes { self.reinterpret_as_uint64().to_le_bytes() }
        ),
      ),
      "gPRIME2": (None, UInt(0x85EBCA77U)),
      "gPRIME3": (None, UInt(0xC2B2AE3DU)),
      "gPRIME4": (None, UInt(0x27D4EB2FU)),
      "gPRIME5": (None, UInt(0x165667B1U)),
      "slow_hash": build(
        (
          #|fn slow_hash(self : Int64) -> Int { let self = self.reinterpret_as_uint64()
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
          #|  b.hash() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_json_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/json",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/char": moonbitlang_core_char_module,
    "moonbitlang/core/double": moonbitlang_core_double_module,
    "moonbitlang/core/string": moonbitlang_core_string_module,
    "moonbitlang/core/strconv": moonbitlang_core_strconv_module,
    "moonbitlang/core/option": moonbitlang_core_option_module,
  },
  fn(_env, build) {
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
      "decode_error": build(
        (
          #|fn[T] decode_error(path : JsonPath, msg : String) -> T raise JsonDecodeError { raise JsonDecodeError((path, msg)) }
        ),
      ),
      "as_null": build(
        (
          #|pub fn as_null(self : JsonValue) -> Unit? { guard self is Null else { return None }
          #|  Some(()) }
        ),
      ),
      "as_bool": build(
        (
          #|pub fn as_bool(self : JsonValue) -> Bool? { match self {
          #|    True => Some(true)
          #|    False => Some(false)
          #|    _ => None
          #|  } }
        ),
      ),
      "as_number": build(
        (
          #|pub fn as_number(self : JsonValue) -> Double? { guard self is Number(n, ..) else { return None }
          #|  Some(n) }
        ),
      ),
      "as_string": build(
        (
          #|pub fn as_string(self : JsonValue) -> String? { guard self is String(s) else { return None }
          #|  Some(s) }
        ),
      ),
      "as_array": build(
        (
          #|pub fn as_array(self : JsonValue) -> Array[JsonValue]? { guard self is Array(arr) else { return None }
          #|  Some(arr) }
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
          #|pub fn as_object(self : JsonValue) -> Map[String, JsonValue]? { guard self is Object(obj) else { return None }
          #|  Some(obj) }
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
    }
  },
)

///|
let moonbitlang_core_list_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/list",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
  },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn[A] new() -> List[A] { Empty }
        ),
      ),
      "empty": build(
        (
          #|pub fn[A] empty() -> List[A] { Empty }
        ),
      ),
      "construct": build(
        (
          #|pub fn[A] construct(head : A, tail : List[A]) -> List[A] { More(head, tail~) }
        ),
      ),
      "prepend": build(
        (
          #|pub fn[A] prepend(self : List[A], head : A) -> List[A] { More(head, tail=self) }
        ),
      ),
      "add": build(
        (
          #|pub fn[A] add(self : List[A], head : A) -> List[A] { More(head, tail=self) }
        ),
      ),
      "to_json": build(
        (
          #|pub fn[A : ToJson] to_json(self : List[A]) -> Json { ToJson::to_json(self) }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A] from_array(arr : Array[A]) -> List[A] { for i = arr.length() - 1, list = Empty; i >= 0; {
          #|    continue i - 1, More(arr[i], tail=list)
          #|  } else {
          #|    list
          #|  } }
        ),
      ),
      "length": build(
        (
          #|pub fn[A] length(self : List[A]) -> Int { loop (self, 0) {
          #|    (Empty, len) => len
          #|    (More(_, tail=rest), acc) => continue (rest, acc + 1)
          #|  } }
        ),
      ),
      "each": build(
        (
          #|pub fn[A] each(self : List[A], f : (A) -> Unit raise?) -> Unit raise? { loop self {
          #|    Empty => ()
          #|    More(head, tail~) => {
          #|      f(head)
          #|      continue tail
          #|    }
          #|  } }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[A] eachi(self : List[A], f : (Int, A) -> Unit raise?) -> Unit raise? { loop (self, 0) {
          #|    (Empty, _) => ()
          #|    (More(x, tail=xs), i) => {
          #|      f(i, x)
          #|      continue (xs, i + 1)
          #|    }
          #|  } }
        ),
      ),
      "map": build(
        (
          #|pub fn[A, B] map(self : List[A], f : (A) -> B raise?) -> List[B] raise? { match self {
          #|    Empty => Empty
          #|    More(hd, tail~) => {
          #|      let dest = More(f(hd), tail=Empty)
          #|      loop (dest, tail) {
          #|        (_, Empty) => ()
          #|        (More(_) as dest, More(hd, tail~)) => {
          #|          dest.tail = More(f(hd), tail=Empty)
          #|          continue (dest.tail, tail)
          #|        }
          #|        // unreachable
          #|        (Empty, _) => panic()
          #|      }
          #|      dest
          #|    }
          #|  } }
        ),
      ),
      "mapi": build(
        (
          #|pub fn[A, B] mapi(self : List[A], f : (Int, A) -> B raise?) -> List[B] raise? { match self {
          #|    Empty => Empty
          #|    More(hd, tail~) => {
          #|      let dest = More(f(0, hd), tail=Empty)
          #|      loop (1, dest, tail) {
          #|        (_, _, Empty) => ()
          #|        (i, More(_) as dest, More(hd, tail~)) => {
          #|          dest.tail = More(f(i, hd), tail=Empty)
          #|          continue (i + 1, dest.tail, tail)
          #|        }
          #|        // unreachable
          #|        (_, Empty, _) => panic()
          #|      }
          #|      dest
          #|    }
          #|  } }
        ),
      ),
      "rev_map": build(
        (
          #|pub fn[A, B] rev_map(self : List[A], f : (A) -> B raise?) -> List[B] raise? { loop (Empty, self) {
          #|    (acc, Empty) => acc
          #|    (acc, More(x, tail=xs)) => continue (More(f(x), tail=acc), xs)
          #|  } }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[A] to_array(self : List[A]) -> Array[A] { match self {
          #|    Empty => []
          #|    More(x, tail=xs) => {
          #|      let arr = [x]
          #|      loop xs {
          #|        Empty => ()
          #|        More(x, tail=xs) => {
          #|          arr.push(x)
          #|          continue xs
          #|        }
          #|      }
          #|      arr
          #|    }
          #|  } }
        ),
      ),
      "filter": build(
        (
          #|pub fn[A] filter(self : List[A], f : (A) -> Bool raise?) -> List[A] raise? { loop self {
          #|    Empty => Empty
          #|    More(head, tail~) =>
          #|      if !f(head) {
          #|        continue tail
          #|      } else {
          #|        let dest = More(head, tail=Empty)
          #|        loop (dest, tail) {
          #|          (_, Empty) => ()
          #|          (More(_) as dest, More(hd, tail~)) =>
          #|            if f(hd) {
          #|              dest.tail = More(hd, tail=Empty)
          #|              continue (dest.tail, tail)
          #|            } else {
          #|              continue (dest, tail)
          #|            }
          #|          (Empty, _) =>
          #|            // unreachable
          #|            panic()
          #|        }
          #|        dest
          #|      }
          #|  } }
        ),
      ),
      "all": build(
        (
          #|pub fn[A] all(self : List[A], f : (A) -> Bool raise?) -> Bool raise? { loop self {
          #|    Empty => true
          #|    More(head, tail~) => if f(head) { continue tail } else { false }
          #|  } }
        ),
      ),
      "any": build(
        (
          #|pub fn[A] any(self : List[A], f : (A) -> Bool raise?) -> Bool raise? { loop self {
          #|    Empty => false
          #|    More(head, tail~) => if f(head) { true } else { continue tail }
          #|  } }
        ),
      ),
      "unsafe_head": build(
        (
          #|pub fn[A] unsafe_head(self : List[A]) -> A { match self {
          #|    Empty => abort(\"head of empty list\")
          #|    More(head, tail=_) => head
          #|  } }
        ),
      ),
      "unsafe_tail": build(
        (
          #|pub fn[A] unsafe_tail(self : List[A]) -> List[A] { match self {
          #|    Empty => abort(\"tail of empty list\")
          #|    More(_, tail~) => tail
          #|  } }
        ),
      ),
      "head": build(
        (
          #|pub fn[A] head(self : List[A]) -> A? { match self {
          #|    Empty => None
          #|    More(head, tail=_) => Some(head)
          #|  } }
        ),
      ),
      "unsafe_last": build(
        (
          #|pub fn[A] unsafe_last(self : List[A]) -> A { loop self {
          #|    Empty => abort(\"last of empty list\")
          #|    More(head, tail=Empty) => head
          #|    More(_, tail~) => continue tail
          #|  } }
        ),
      ),
      "last": build(
        (
          #|pub fn[A] last(self : List[A]) -> A? { loop self {
          #|    Empty => None
          #|    More(head, tail=Empty) => Some(head)
          #|    More(_, tail~) => continue tail
          #|  } }
        ),
      ),
      "concat": build(
        (
          #|pub fn[A] concat(self : List[A], other : List[A]) -> List[A] { match self {
          #|    Empty => other
          #|    More(hd, tail=Empty) => More(hd, tail=other)
          #|    More(hd, tail~) => {
          #|      let dest = More(hd, tail=Empty)
          #|      loop (dest, tail) {
          #|        (More(_) as dest, Empty) => dest.tail = other
          #|        (More(_) as dest, More(head, tail~)) => {
          #|          dest.tail = More(head, tail=Empty)
          #|          continue (dest.tail, tail)
          #|        }
          #|        // unreachable
          #|        (Empty, _) => panic()
          #|      }
          #|      dest
          #|    }
          #|  } }
        ),
      ),
      "rev_concat": build(
        (
          #|pub fn[A] rev_concat(self : List[A], other : List[A]) -> List[A] { loop (self, other) {
          #|    (Empty, other) => other
          #|    (More(head, tail~), other) => continue (tail, More(head, tail=other))
          #|  } }
        ),
      ),
      "rev": build(
        (
          #|pub fn[A] rev(self : List[A]) -> List[A] { self.rev_concat(Empty) }
        ),
      ),
      "zip": build(
        (
          #|pub fn[A, B] List::zip(self : List[A], other : List[B]) -> List[(A, B)] { let res = loop (self, other, Empty) {
          #|    (Empty, _, acc) => break acc
          #|    (_, Empty, acc) => break acc
          #|    (More(x, tail=xs), More(y, tail=ys), acc) =>
          #|      continue (xs, ys, More((x, y), tail=acc))
          #|  }
          #|  res.reverse_inplace() }
        ),
      ),
      "filter_map": build(
        (
          #|pub fn[A, B] filter_map(self : List[A], f : (A) -> B? raise?) -> List[B] raise? { loop self {
          #|    Empty => Empty
          #|    More(hd, tail~) =>
          #|      match f(hd) {
          #|        None => continue tail
          #|        Some(head) => {
          #|          let dest = More(head, tail=Empty)
          #|          loop (dest, tail) {
          #|            (_, Empty) => ()
          #|            (More(_) as dest, More(hd, tail~)) =>
          #|              match f(hd) {
          #|                None => continue (dest, tail)
          #|                Some(head) => {
          #|                  dest.tail = More(head, tail=Empty)
          #|                  continue (dest.tail, tail)
          #|                }
          #|              }
          #|            (Empty, _) => panic()
          #|          }
          #|          dest
          #|        }
          #|      }
          #|  } }
        ),
      ),
      "unsafe_nth": build(
        (
          #|pub fn[A] unsafe_nth(self : List[A], n : Int) -> A { loop (self, n) {
          #|    (Empty, _) => abort(\"nth: index out of bounds\")
          #|    (More(head, tail=_), 0) => head
          #|    (More(_, tail~), n) => continue (tail, n - 1)
          #|  } }
        ),
      ),
      "nth": build(
        (
          #|pub fn[A] nth(self : List[A], n : Int) -> A? { loop (self, n) {
          #|    (Empty, _) => None
          #|    (More(head, tail=_), 0) => Some(head)
          #|    (More(_, tail~), n) => continue (tail, n - 1)
          #|  } }
        ),
      ),
      "repeat": build(
        (
          #|pub fn[A] repeat(n : Int, x : A) -> List[A] { loop (Empty, n) {
          #|    (acc, n) => if n <= 0 { acc } else { continue (More(x, tail=acc), n - 1) }
          #|  } }
        ),
      ),
      "intersperse": build(
        (
          #|pub fn[A] intersperse(self : List[A], separator : A) -> List[A] { match self {
          #|    Empty => Empty
          #|    More(head, tail=Empty) => More(head, tail=Empty)
          #|    More(head, tail~) => {
          #|      let dest = More(head, tail=Empty)
          #|      loop (dest, tail) {
          #|        (_, Empty) => ()
          #|        (More(_) as dest, More(hd, tail=tl)) => {
          #|          let new_tail = More(hd, tail=Empty)
          #|          dest.tail = More(separator, tail=new_tail)
          #|          continue (new_tail, tl)
          #|        }
          #|        // unreachable
          #|        (Empty, _) => panic()
          #|      }
          #|      dest
          #|    }
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[A] is_empty(self : List[A]) -> Bool { self is Empty }
        ),
      ),
      "unzip": build(
        (
          #|pub fn[A, B] unzip(self : List[(A, B)]) -> (List[A], List[B]) { match self {
          #|    Empty => (Empty, Empty)
          #|    More((x, y), tail~) => {
          #|      let xs = More(x, tail=Empty)
          #|      let ys = More(y, tail=Empty)
          #|      loop (tail, xs, ys) {
          #|        (Empty, _, _) => ()
          #|        (More((x, y), tail~), More(_) as xptr, More(_) as yptr) => {
          #|          xptr.tail = More(x, tail=Empty)
          #|          yptr.tail = More(y, tail=Empty)
          #|          continue (tail, xptr.tail, yptr.tail)
          #|        }
          #|        (_, _, _) => abort(\"unreachable\")
          #|      }
          #|      (xs, ys)
          #|    }
          #|  } }
        ),
      ),
      "flatten": build(
        (
          #|pub fn[A] flatten(self : List[List[A]]) -> List[A] { loop self {
          #|    Empty => Empty
          #|    More(head, tail~) =>
          #|      match head {
          #|        // continue until we have at least one element
          #|        Empty => continue tail
          #|        More(hd, tail=tl) => {
          #|          let dest = More(hd, tail=Empty)
          #|          // copy all the elements of `head` first
          #|          let dest1 = loop (dest, tl) {
          #|            (dest, Empty) => dest
          #|            (More(_) as dest, More(hd, tail~)) => {
          #|              dest.tail = More(hd, tail=Empty)
          #|              continue (dest.tail, tail)
          #|            }
          #|            (Empty, _) => panic()
          #|          }
          #|          // continue looping on the `tail` of `self`
          #|          loop_over_tail~: loop (dest1, tail) {
          #|            (_, Empty) => ()
          #|            (More(_) as dest, More(t_hd, tail=Empty)) => dest.tail = t_hd
          #|            (dest, More(t_hd, tail=t_tl)) =>
          #|              loop (dest, t_hd) {
          #|                (dest, Empty) => continue loop_over_tail~ (dest, t_tl)
          #|                (More(_) as dest, More(hd, tail~)) => {
          #|                  dest.tail = More(hd, tail=Empty)
          #|                  continue (dest.tail, tail)
          #|                }
          #|                (Empty, _) => panic()
          #|              }
          #|          }
          #|          dest
          #|        }
          #|      }
          #|  } }
        ),
      ),
      "unsafe_maximum": build(
        (
          #|pub fn[A : Compare] unsafe_maximum(self : List[A]) -> A { match self {
          #|    Empty => abort(\"maximum: empty list\")
          #|    More(head, tail~) =>
          #|      loop (tail, head) {
          #|        (Empty, curr_max) => curr_max
          #|        (More(item, tail~), curr_max) =>
          #|          continue (tail, if item > curr_max { item } else { curr_max })
          #|      }
          #|  } }
        ),
      ),
      "maximum": build(
        (
          #|pub fn[A : Compare] maximum(self : List[A]) -> A? { match self {
          #|    Empty => None
          #|    More(head, tail~) =>
          #|      loop (tail, head) {
          #|        (Empty, curr_max) => Some(curr_max)
          #|        (More(item, tail~), curr_max) =>
          #|          continue (tail, if item > curr_max { item } else { curr_max })
          #|      }
          #|  } }
        ),
      ),
      "unsafe_minimum": build(
        (
          #|pub fn[A : Compare] unsafe_minimum(self : List[A]) -> A { match self {
          #|    Empty => abort(\"minimum: empty list\")
          #|    More(head, tail~) =>
          #|      loop (tail, head) {
          #|        (Empty, curr_min) => curr_min
          #|        (More(item, tail~), curr_min) =>
          #|          continue (tail, if item < curr_min { item } else { curr_min })
          #|      }
          #|  } }
        ),
      ),
      "minimum": build(
        (
          #|pub fn[A : Compare] minimum(self : List[A]) -> A? { match self {
          #|    Empty => None
          #|    More(head, tail~) =>
          #|      loop (tail, head) {
          #|        (Empty, curr_min) => Some(curr_min)
          #|        (More(item, tail~), curr_min) =>
          #|          continue (tail, if item < curr_min { item } else { curr_min })
          #|      }
          #|  } }
        ),
      ),
      "sort": build(
        (
          #|pub fn[A : Compare] sort(self : List[A]) -> List[A] { let arr = self.to_array()
          #|  arr.sort()
          #|  from_array(arr) }
        ),
      ),
      "contains": build(
        (
          #|pub fn[A : Eq] contains(self : List[A], value : A) -> Bool { loop self {
          #|    Empty => false
          #|    More(x, tail=xs) => if x == value { true } else { continue xs }
          #|  } }
        ),
      ),
      "unfold": build(
        (
          #|pub fn[A, S] unfold(f : (S) -> (A, S)? raise?, init~ : S) -> List[A] raise? { match f(init) {
          #|    None => Empty
          #|    Some((element, new_state)) => {
          #|      let dest = More(element, tail=Empty)
          #|      loop (dest, f(new_state)) {
          #|        (_, None) => ()
          #|        (More(_) as dest, Some((element, new_state))) => {
          #|          dest.tail = More(element, tail=Empty)
          #|          continue (dest.tail, f(new_state))
          #|        }
          #|        (Empty, _) => panic()
          #|      }
          #|      dest
          #|    }
          #|  } }
        ),
      ),
      "rev_unfold": build(
        (
          #|pub fn[A, S] rev_unfold(f : (S) -> (A, S)? raise?, init~ : S) -> List[A] raise? { loop (f(init), Empty) {
          #|    (None, acc) => acc
          #|    (Some((x, s)), acc) => continue (f(s), More(x, tail=acc))
          #|  } }
        ),
      ),
      "take": build(
        (
          #|pub fn[A] take(self : List[A], n : Int) -> List[A] { if n <= 0 {
          #|    Empty
          #|  } else {
          #|    match self {
          #|      Empty => Empty
          #|      More(head, tail~) => {
          #|        let dest = More(head, tail=Empty)
          #|        loop (dest, tail, n - 1) {
          #|          (_, Empty, _) => ()
          #|          (_, _, 0) => ()
          #|          (More(_) as dest, More(x, tail=xs), n) => {
          #|            dest.tail = More(x, tail=Empty)
          #|            continue (dest.tail, xs, n - 1)
          #|          }
          #|          (Empty, _, _) => panic()
          #|        }
          #|        dest
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "drop": build(
        (
          #|pub fn[A] drop(self : List[A], n : Int) -> List[A] { if n <= 0 {
          #|    self
          #|  } else {
          #|    loop (n, self) {
          #|      (_, Empty) => Empty
          #|      (1, More(_, tail=xs)) => xs
          #|      (n, More(_, tail=xs)) => continue (n - 1, xs)
          #|    }
          #|  } }
        ),
      ),
      "take_while": build(
        (
          #|pub fn[A] take_while(self : List[A], p : (A) -> Bool raise?) -> List[A] raise? { match self {
          #|    Empty => Empty
          #|    More(head, tail~) =>
          #|      if p(head) {
          #|        let dest = More(head, tail=Empty)
          #|        loop (dest, tail) {
          #|          (_, Empty) => ()
          #|          (More(_) as dest, More(x, tail=xs)) if p(x) => {
          #|            dest.tail = More(x, tail=Empty)
          #|            continue (dest.tail, xs)
          #|          }
          #|          (More(_), _) => ()
          #|          (Empty, _) => panic()
          #|        }
          #|        dest
          #|      } else {
          #|        Empty
          #|      }
          #|  } }
        ),
      ),
      "drop_while": build(
        (
          #|pub fn[A] drop_while(self : List[A], p : (A) -> Bool raise?) -> List[A] raise? { loop self {
          #|    Empty => Empty
          #|    More(x, tail=xs) => if p(x) { continue xs } else { More(x, tail=xs) }
          #|  } }
        ),
      ),
      "lookup": build(
        (
          #|pub fn[A : Eq, B] lookup(self : List[(A, B)], v : A) -> B? { loop self {
          #|    Empty => None
          #|    More((x, y), tail=xs) => if x == v { Some(y) } else { continue xs }
          #|  } }
        ),
      ),
      "find": build(
        (
          #|pub fn[A] find(self : List[A], f : (A) -> Bool raise?) -> A? raise? { loop self {
          #|    Empty => None
          #|    More(element, tail=list) =>
          #|      if f(element) {
          #|        Some(element)
          #|      } else {
          #|        continue list
          #|      }
          #|  } }
        ),
      ),
      "findi": build(
        (
          #|pub fn[A] findi(self : List[A], f : (A, Int) -> Bool raise?) -> A? raise? { loop (self, 0) {
          #|    (list, index) =>
          #|      match list {
          #|        Empty => None
          #|        More(element, tail=list) =>
          #|          if f(element, index) {
          #|            Some(element)
          #|          } else {
          #|            continue (list, index + 1)
          #|          }
          #|      }
          #|  } }
        ),
      ),
      "remove_at": build(
        (
          #|pub fn[A] remove_at(self : List[A], index : Int) -> List[A] { match (index, self) {
          #|    (_, Empty) => Empty
          #|    (_..<0, _) => self
          #|    (0, More(_, tail~)) => tail
          #|    (n, More(head, tail~)) => {
          #|      let dest = More(head, tail=Empty)
          #|      loop (dest, tail, n - 1) {
          #|        (_, Empty, _) => ()
          #|        (More(_) as dest, More(_, tail~), 0) => dest.tail = tail
          #|        (More(_) as dest, More(x, tail=xs), n) => {
          #|          dest.tail = More(x, tail=Empty)
          #|          continue (dest.tail, xs, n - 1)
          #|        }
          #|        (Empty, _, _) => panic()
          #|      }
          #|      dest
          #|    }
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[A : Eq] remove(self : List[A], elem : A) -> List[A] { match self {
          #|    Empty => Empty
          #|    More(head, tail~) if head == elem => tail
          #|    More(head, tail~) => {
          #|      let dest = More(head, tail~)
          #|      loop (dest, tail) {
          #|        (_, Empty) => ()
          #|        (More(_) as dest, More(x, tail=xs)) =>
          #|          if x == elem {
          #|            dest.tail = xs
          #|          } else {
          #|            dest.tail = More(x, tail=Empty)
          #|            continue (dest.tail, xs)
          #|          }
          #|        (Empty, _) => panic()
          #|      }
          #|      dest
          #|    }
          #|  } }
        ),
      ),
      "is_prefix": build(
        (
          #|pub fn[A : Eq] is_prefix(self : List[A], prefix : List[A]) -> Bool { loop (self, prefix) {
          #|    (_, Empty) => true
          #|    (Empty, More(_)) => false
          #|    (More(h1, tail=t1), More(h2, tail=t2)) =>
          #|      if h1 == h2 {
          #|        continue (t1, t2)
          #|      } else {
          #|        false
          #|      }
          #|  } }
        ),
      ),
      "is_suffix": build(
        (
          #|pub fn[A : Eq] is_suffix(self : List[A], suffix : List[A]) -> Bool { self.rev().is_prefix(suffix.rev()) }
        ),
      ),
      "intercalate": build(
        (
          #|pub fn[A] intercalate(self : List[List[A]], sep : List[A]) -> List[A] { self.intersperse(sep).flatten() }
        ),
      ),
      "default": build(
        (
          #|pub fn[X] default() -> List[X] { Empty }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A] iter(self : List[A]) -> Iter[A] { Iter::new(yield_ => loop self {
          #|    Empty => IterContinue
          #|    More(head, tail~) => {
          #|      if yield_(head) == IterEnd {
          #|        break IterEnd
          #|      }
          #|      continue tail
          #|    }
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[A] iter2(self : List[A]) -> Iter2[Int, A] { Iter2::new(yield_ => loop (self, 0) {
          #|    (Empty, _) => IterEnd
          #|    (More(head, tail~), i) => {
          #|      if yield_(i, head) == IterEnd {
          #|        break IterEnd
          #|      }
          #|      continue (tail, i + 1)
          #|    }
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A] from_iter(iter : Iter[A]) -> List[A] { let mut res = Empty
          #|  let mut ptr = Empty
          #|  for x in iter {
          #|    match (res, ptr) {
          #|      (Empty, _) => {
          #|        res = More(x, tail=Empty)
          #|        ptr = res
          #|      }
          #|      (More(_), More(_) as ptr_) => {
          #|        ptr_.tail = More(x, tail=Empty)
          #|        ptr = ptr_.tail
          #|      }
          #|      (_, _) => panic()
          #|    }
          #|  }
          #|  res }
        ),
      ),
      "from_iter_rev": build(
        (
          #|pub fn[A] from_iter_rev(iter : Iter[A]) -> List[A] { iter.fold(init=Empty, (acc, e) => More(e, tail=acc)) }
        ),
      ),
      "of": build(
        (
          #|pub fn[A] of(arr : FixedArray[A]) -> List[A] { for i = arr.length() - 1, list = Empty; i >= 0; {
          #|    continue i - 1, More(arr[i], tail=list)
          #|  } else {
          #|    list
          #|  } }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[A] singleton(x : A) -> List[A] { More(x, tail=Empty) }
        ),
      ),
      "reverse_inplace": build(
        (
          #|fn[A] reverse_inplace(self : List[A]) -> List[A] { match self {
          #|    Empty | More(_, tail=Empty) => self
          #|    More(head, tail~) =>
          #|      loop (More(head, tail=Empty), tail) {
          #|        (result, Empty) => result
          #|        (result, More(_, tail=xs) as new_result) => {
          #|          new_result.tail = result
          #|          continue (new_result, xs)
          #|        }
          #|      }
          #|  } }
        ),
      ),
      "rev_fold": build(
        (
          #|pub fn[A, B] rev_fold(self : List[A], init~ : B, f : (B, A) -> B) -> B { let xs = self.to_array()
          #|  let mut acc = init
          #|  for x in xs.rev_iter() {
          #|    acc = f(acc, x)
          #|  }
          #|  acc }
        ),
      ),
      "rev_foldi": build(
        (
          #|pub fn[A, B] rev_foldi(self : List[A], init~ : B, f : (Int, B, A) -> B) -> B { self.rev().foldi(init~, (i, b, a) => f(i, b, a)) }
        ),
      ),
      "tail": build(
        (
          #|pub fn[A] tail(self : List[A]) -> List[A] { match self {
          #|    Empty => Empty
          #|    More(_, tail~) => tail
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_math_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/math",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/double": moonbitlang_core_double_module,
    "moonbitlang/core/float": moonbitlang_core_float_module,
    "moonbitlang/core/int": moonbitlang_core_int_module,
    "moonbitlang/core/bigint": moonbitlang_core_bigint_module,
    "moonbitlang/core/random": moonbitlang_core_random_module,
  },
  fn(_env, build) {
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
      "maximum": build(
        (
          #|pub fn[T : Compare] maximum(x : T, y : T) -> T { if x > y {
          #|    x
          #|  } else {
          #|    y
          #|  } }
        ),
      ),
      "minimum": build(
        (
          #|pub fn[T : Compare] minimum(x : T, y : T) -> T { if x > y {
          #|    y
          #|  } else {
          #|    x
          #|  } }
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
      "pi": (None, String("0x3.243F6A8885A308CA8A54")),
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
      "logf_off": (None, UInt(0x3f330000U)),
      "logf_table_bits": (None, Int(4)),
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
      "exp2f_table_bits": (None, Int(5)),
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
  },
)

///|
let moonbitlang_core_option_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/option",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/quickcheck/splitmix": moonbitlang_core_quickcheck_splitmix_module,
  },
  fn(_env, build) {
    {
      "map": build(
        (
          #|pub fn[T, U] map(self : T?, f : (T) -> U) -> U? { match self {
          #|    Some(t) => Some(f(t))
          #|    None => None
          #|  } }
        ),
      ),
      "map_or": build(
        (
          #|pub fn[T, U] map_or(self : T?, default : U, f : (T) -> U) -> U { match self {
          #|    None => default
          #|    Some(x) => f(x)
          #|  } }
        ),
      ),
      "map_or_else": build(
        (
          #|pub fn[T, U] map_or_else(self : T?, default : () -> U, f : (T) -> U) -> U { match self {
          #|    None => default()
          #|    Some(x) => f(x)
          #|  } }
        ),
      ),
      "bind": build(
        (
          #|pub fn[T, U] bind(self : T?, f : (T) -> U?) -> U? { match self {
          #|    Some(t) => f(t)
          #|    None => None
          #|  } }
        ),
      ),
      "flatten": build(
        (
          #|pub fn[T] flatten(self : T??) -> T? { match self {
          #|    Some(inner) => inner
          #|    None => None
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[T] is_empty(self : T?) -> Bool { self is None }
        ),
      ),
      "filter": build(
        (
          #|pub fn[T] filter(self : T?, f : (T) -> Bool) -> T? { match self {
          #|    Some(t) => if f(t) { self } else { None }
          #|    None => None
          #|  } }
        ),
      ),
      "unwrap_or": build(
        (
          #|pub fn[T] Option::unwrap_or(self : T?, default : T) -> T { match self {
          #|    None => default
          #|    Some(t) => t
          #|  } }
        ),
      ),
      "unwrap_or_else": build(
        (
          #|pub fn[T] Option::unwrap_or_else(self : T?, default : () -> T) -> T { match self {
          #|    None => default()
          #|    Some(t) => t
          #|  } }
        ),
      ),
      "unwrap_or_default": build(
        (
          #|pub fn[T : Default] Option::unwrap_or_default(self : T?) -> T { match self {
          #|    None => T::default()
          #|    Some(t) => t
          #|  } }
        ),
      ),
      "iter": build(
        (
          #|pub fn[T] iter(self : T?) -> Iter[T] { match self {
          #|    Some(v) => Iter::singleton(v)
          #|    None => Iter::empty()
          #|  } }
        ),
      ),
      "or_error": build(
        (
          #|pub fn[T, Err : Error] or_error(self : T?, err : Err) -> T raise Err { match self {
          #|    Some(v) => v
          #|    None => raise err
          #|  } }
        ),
      ),
      "when": build(
        (
          #|pub fn[T] when(condition : Bool, value : () -> T) -> T? { if condition {
          #|    Some(value())
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "unless": build(
        (
          #|pub fn[T] unless(condition : Bool, value : () -> T) -> T? { when(!condition, value) }
        ),
      ),
      "empty": build(
        (
          #|pub fn[T] empty() -> T? { None }
        ),
      ),
      "some": build(
        (
          #|pub fn[T] some(value : T) -> T? { Some(value) }
        ),
      ),
      "or": build(
        (
          #|pub fn[T] Option::or(self : T?, default : T) -> T { match self {
          #|    None => default
          #|    Some(t) => t
          #|  } }
        ),
      ),
      "or_else": build(
        (
          #|pub fn[T] Option::or_else(self : T?, default : () -> T) -> T { match self {
          #|    None => default()
          #|    Some(t) => t
          #|  } }
        ),
      ),
      "or_default": build(
        (
          #|pub fn[T : Default] Option::or_default(self : T?) -> T { match self {
          #|    None => T::default()
          #|    Some(t) => t
          #|  } }
        ),
      ),
      "is_some": build(
        (
          #|pub fn[T] is_some(self : T?) -> Bool { self is Some(_) }
        ),
      ),
      "is_none": build(
        (
          #|pub fn[T] is_none(self : T?) -> Bool { self is None }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_prelude_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/prelude",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/bigint": moonbitlang_core_bigint_module,
    "moonbitlang/core/set": moonbitlang_core_set_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
  },
  fn(_env, build) {
    {
      "tap": build(
        (
          #|pub fn[T] tap(value : T, f : (T) -> Unit) -> T { f(value)
          #|  value }
        ),
      ),
      "then": build(
        (
          #|pub fn[T, R] then(value : T, f : (T) -> R) -> R { f(value) }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_priority_queue_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/priority_queue",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/quickcheck/splitmix": moonbitlang_core_quickcheck_splitmix_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
  },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn[A] new() -> T[A] { { len: 0, top: Nil } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A : Compare] from_array(arr : Array[A]) -> T[A] { // CR: bad formatting
          #|  let len = arr.length()
          #|  for i = 0, acc = Node::Nil {
          #|    if i < len {
          #|      continue i + 1, meld(acc, Cons(content=arr[i], sibling=Nil, child=Nil))
          #|    } else {
          #|      break { len, top: acc }
          #|    }
          #|  } }
        ),
      ),
      "copy_node": build(
        (
          #|fn[A] copy_node(x : Node[A]) -> Node[A] { match x {
          #|    Nil => Nil
          #|    Cons(_) as node =>
          #|      Cons(
          #|        content=node.content,
          #|        sibling=copy_node(node.sibling),
          #|        child=copy_node(node.child),
          #|      )
          #|  } }
        ),
      ),
      "copy": build(
        (
          #|pub fn[A] copy(self : T[A]) -> T[A] { let new_que : T[A] = { len: self.len, top: copy_node(self.top) }
          #|  new_que }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[A : Compare] to_array(self : T[A]) -> Array[A] { let arr = Array::new(capacity=self.len)
          #|  fn go(x : Node[A]) {
          #|    match x {
          #|      Cons(_) as x => {
          #|        arr.push(x.content)
          #|        go(x.sibling)
          #|        go(x.child)
          #|      }
          #|      Nil => ()
          #|    }
          #|  }
          #|  go(self.top)
          #|  arr.sort_by((x, y) => y.compare(x))
          #|  arr }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A : Compare] iter(self : T[A]) -> Iter[A] { Iter::new(yield_ => {
          #|    let arr = self.to_array()
          #|    for i in 0..<arr.length() {
          #|      if yield_(arr[i]) == IterEnd {
          #|        break IterEnd
          #|      }
          #|    } else {
          #|      IterContinue
          #|    }
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[K : Compare] from_iter(iter : Iter[K]) -> T[K] { let s = new()
          #|  iter.each(e => s.push(e))
          #|  s }
        ),
      ),
      "meld": build(
        (
          #|fn[A : Compare] meld(x : Node[A], y : Node[A]) -> Node[A] { match (x, y) {
          #|    (Nil, _) => y
          #|    (_, Nil) => x
          #|    (Cons(_) as x_top, Cons(_) as y_top) =>
          #|      if x_top.content > y_top.content {
          #|        y_top.sibling = x_top.child
          #|        x_top.child = y
          #|        x
          #|      } else {
          #|        x_top.sibling = y_top.child
          #|        y_top.child = x
          #|        y
          #|      }
          #|  } }
        ),
      ),
      "merges": build(
        (
          #|fn[A : Compare] merges(x : Node[A]) -> Node[A] { loop (x, Nil) {
          #|    (Nil, acc) => acc
          #|    (Cons(sibling=Nil, ..) as x, acc) => meld(acc, x)
          #|    (Cons(sibling=Cons(sibling=s2, ..) as s1, ..) as x, acc) => {
          #|      x.sibling = Nil
          #|      s1.sibling = Nil
          #|      continue (s2, meld(acc, meld(x, s1)))
          #|    }
          #|  } }
        ),
      ),
      "length": build(
        (
          #|pub fn[A] length(self : T[A]) -> Int { self.len }
        ),
      ),
      "unsafe_pop": build(
        (
          #|pub fn[A : Compare] unsafe_pop(self : T[A]) -> Unit { self.top = match self.top {
          #|    Nil => abort(\"The PriorityQueue is empty!\")
          #|    Cons(child~, ..) => merges(child)
          #|  }
          #|  self.len -= 1 }
        ),
      ),
      "pop": build(
        (
          #|pub fn[A : Compare] pop(self : T[A]) -> A? { let result = self.peek()
          #|  self.top = match self.top {
          #|    Nil => Nil
          #|    Cons(child~, ..) => {
          #|      self.len -= 1
          #|      merges(child)
          #|    }
          #|  }
          #|  result }
        ),
      ),
      "push": build(
        (
          #|pub fn[A : Compare] push(self : T[A], value : A) -> Unit { self.top = meld(self.top, Cons(content=value, sibling=Nil, child=Nil))
          #|  self.len += 1 }
        ),
      ),
      "peek": build(
        (
          #|pub fn[A] peek(self : T[A]) -> A? { match self.top {
          #|    Nil => None
          #|    Cons(content~, ..) => Some(content)
          #|  } }
        ),
      ),
      "clear": build(
        (
          #|pub fn[A] clear(self : T[A]) -> Unit { self.top = Nil
          #|  self.len = 0 }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[A] is_empty(self : T[A]) -> Bool { self.len == 0 }
        ),
      ),
      "of": build(
        (
          #|pub fn[A : Compare] of(arr : FixedArray[A]) -> T[A] { // CR: bad formatting
          #|  let len = arr.length()
          #|  for i = 0, acc = Node::Nil {
          #|    if i < len {
          #|      continue i + 1, meld(acc, Cons(content=arr[i], sibling=Nil, child=Nil))
          #|    } else {
          #|      break { len, top: acc }
          #|    }
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_queue_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/queue",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
  },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn[A] new() -> T[A] { { length: 0, first: None, last: None } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[A] from_array(arr : Array[A]) -> T[A] { guard arr.length() > 0 else { return new() }
          #|  let length = arr.length()
          #|  let last = { content: arr[length - 1], next: None }
          #|  let first = for i = length - 2, x = last; i >= 0; {
          #|    continue i - 1, { content: arr[i], next: Some(x) }
          #|  } else {
          #|    x
          #|  }
          #|  { length, first: Some(first), last: Some(last) } }
        ),
      ),
      "clear": build(
        (
          #|pub fn[A] clear(self : T[A]) -> Unit { self.length = 0
          #|  self.first = None
          #|  self.last = None }
        ),
      ),
      "length": build(
        (
          #|pub fn[A] length(self : T[A]) -> Int { self.length }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[A] is_empty(self : T[A]) -> Bool { self.length == 0 }
        ),
      ),
      "push": build(
        (
          #|pub fn[A] push(self : T[A], x : A) -> Unit { let cell = Some({ content: x, next: None })
          #|  match self.last {
          #|    None => {
          #|      self.length = 1
          #|      self.first = cell
          #|      self.last = cell
          #|    }
          #|    Some(last) => {
          #|      last.next = cell
          #|      self.length += 1
          #|      self.last = cell
          #|    }
          #|  } }
        ),
      ),
      "unsafe_peek": build(
        (
          #|pub fn[A] unsafe_peek(self : T[A]) -> A { match self.first {
          #|    None => abort(\"Queue is empty\")
          #|    Some(first) => first.content
          #|  } }
        ),
      ),
      "peek": build(
        (
          #|pub fn[A] peek(self : T[A]) -> A? { match self.first {
          #|    None => None
          #|    Some(first) => Some(first.content)
          #|  } }
        ),
      ),
      "unsafe_pop": build(
        (
          #|pub fn[A] unsafe_pop(self : T[A]) -> A { match self.first {
          #|    None => abort(\"Queue is empty\")
          #|    Some({ content, next: None }) => {
          #|      self.clear()
          #|      content
          #|    }
          #|    Some({ content, next }) => {
          #|      self.length -= 1
          #|      self.first = next
          #|      content
          #|    }
          #|  } }
        ),
      ),
      "pop": build(
        (
          #|pub fn[A] pop(self : T[A]) -> A? { match self.first {
          #|    None => None
          #|    Some({ content, next: None }) => {
          #|      self.clear()
          #|      Some(content)
          #|    }
          #|    Some({ content, next }) => {
          #|      self.length -= 1
          #|      self.first = next
          #|      Some(content)
          #|    }
          #|  } }
        ),
      ),
      "each": build(
        (
          #|pub fn[A] each(self : T[A], f : (A) -> Unit) -> Unit { loop self.first {
          #|    Some({ content, next }) => {
          #|      f(content)
          #|      continue next
          #|    }
          #|    None => ()
          #|  } }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[A] eachi(self : T[A], f : (Int, A) -> Unit) -> Unit { loop (self.first, 0) {
          #|    (Some({ content, next }), index) => {
          #|      f(index, content)
          #|      continue (next, index + 1)
          #|    }
          #|    (None, _) => ()
          #|  } }
        ),
      ),
      "fold": build(
        (
          #|pub fn[A, B] fold(self : T[A], init~ : B, f : (B, A) -> B) -> B { loop (self.first, init) {
          #|    (None, acc) => acc
          #|    (Some({ content, next }), acc) => continue (next, f(acc, content))
          #|  } }
        ),
      ),
      "copy": build(
        (
          #|pub fn[A] copy(self : T[A]) -> T[A] { guard self.first is Some({ content, next }) else { return new() }
          #|  let first = { content, next: None }
          #|  let last = loop (first, next) {
          #|    (pre, Some({ content, next })) => {
          #|      let curr = { content, next: None }
          #|      pre.next = Some(curr)
          #|      continue (curr, next)
          #|    }
          #|    (pre, None) => pre
          #|  }
          #|  { length: self.length, first: Some(first), last: Some(last) } }
        ),
      ),
      "transfer": build(
        (
          #|pub fn[A] transfer(self : T[A], dst : T[A]) -> Unit { if self.length > 0 {
          #|    match dst.last {
          #|      None => {
          #|        dst.length = self.length
          #|        dst.first = self.first
          #|        dst.last = self.last
          #|        self.clear()
          #|      }
          #|      Some(last) => {
          #|        last.next = self.first
          #|        dst.length = dst.length + self.length
          #|        dst.last = self.last
          #|        self.clear()
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "iter": build(
        (
          #|pub fn[A] iter(self : T[A]) -> Iter[A] { Iter::new(yield_ => loop self.first {
          #|    Some({ content, next }) => {
          #|      if yield_(content) == IterEnd {
          #|        break IterEnd
          #|      }
          #|      continue next
          #|    }
          #|    None => IterContinue
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[A] from_iter(iter : Iter[A]) -> T[A] { let q = new()
          #|  iter.each(e => q.push(e))
          #|  q }
        ),
      ),
      "of": build(
        (
          #|pub fn[A] of(arr : FixedArray[A]) -> T[A] { guard arr.length() > 0 else { return new() }
          #|  let length = arr.length()
          #|  let last = { content: arr[length - 1], next: None }
          #|  let first = for i = length - 2, x = last; i >= 0; {
          #|    continue i - 1, { content: arr[i], next: Some(x) }
          #|  } else {
          #|    Some(x)
          #|  }
          #|  { length, first, last: Some(last) } }
        ),
      ),
      "peek_exn": build(
        (
          #|pub fn[A] peek_exn(self : T[A]) -> A { self.unsafe_peek() }
        ),
      ),
      "pop_exn": build(
        (
          #|pub fn[A] pop_exn(self : T[A]) -> A { self.unsafe_pop() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_quickcheck_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/quickcheck",
  deps={
    "moonbitlang/core/quickcheck/splitmix": moonbitlang_core_quickcheck_splitmix_module,
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/char": moonbitlang_core_char_module,
  },
  fn(_env, build) {
    {
      "gen": build(
        (
          #|pub fn[T : Arbitrary] gen(size? : Int, state? : @splitmix.RandomState) -> T { let size = match size {
          #|    None => 0
          #|    Some(x) => x
          #|  }
          #|  let state = match state {
          #|    None => @splitmix.RandomState::default()
          #|    Some(x) => x
          #|  }
          #|  Arbitrary::arbitrary(size, state) }
        ),
      ),
      "samples": build(
        (
          #|pub fn[X : Arbitrary] samples(x : Int) -> Array[X] { let rs = @splitmix.new()
          #|  let array = Array::make(x, X::arbitrary(0, rs))
          #|  for i in 1..<x {
          #|    array[i] = X::arbitrary(i, rs)
          #|  }
          #|  array }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_quickcheck_splitmix_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/quickcheck/splitmix",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn RandomState::new(seed~ : UInt64 = 37) -> RandomState { new(seed~) }
        ),
      ),
      "new": build(
        (
          #|pub fn new(seed~ : UInt64 = 37) -> RandomState { { seed: mix64(seed), gamma: mix_gamma(seed + golden_gamma) } }
        ),
      ),
      "clone": build(
        (
          #|pub fn clone(self : RandomState) -> RandomState { { ..self } }
        ),
      ),
      "next": build(
        (
          #|pub fn next(self : RandomState) -> Unit { self.next_uint64() |> ignore }
        ),
      ),
      "next_uint64": build(
        (
          #|pub fn next_uint64(self : RandomState) -> UInt64 { let { seed, gamma } = self
          #|  self.seed = seed + gamma
          #|  mix64(self.seed) }
        ),
      ),
      "next_uint": build(
        (
          #|pub fn next_uint(self : RandomState) -> UInt { self.next_uint64().to_uint() }
        ),
      ),
      "next_int64": build(
        (
          #|pub fn next_int64(self : RandomState) -> Int64 { self.next_uint64().reinterpret_as_int64() }
        ),
      ),
      "next_two_uint": build(
        (
          #|pub fn next_two_uint(self : RandomState) -> (UInt, UInt) { let g = self.next_uint64()
          #|  ((g >> 32).to_uint(), g.to_uint()) }
        ),
      ),
      "next_int": build(
        (
          #|pub fn next_int(self : RandomState) -> Int { self.next_uint().reinterpret_as_int() }
        ),
      ),
      "next_positive_int": build(
        (
          #|pub fn next_positive_int(self : RandomState) -> Int { let r = self.next_int()
          #|  match r {
          #|    -2147483648 => 2147483647
          #|    0 => 1
          #|    r if r < 0 => -r
          #|    r => r
          #|  } }
        ),
      ),
      "next_float": build(
        (
          #|pub fn next_float(self : RandomState) -> Float { let u = self.next_uint64()
          #|  (u >> 11).to_float() * float_ulp }
        ),
      ),
      "next_double": build(
        (
          #|pub fn next_double(self : RandomState) -> Double { let u = self.next_uint64()
          #|  (u >> 11).to_double() * double_ulp }
        ),
      ),
      "split": build(
        (
          #|pub fn split(self : RandomState) -> RandomState { let seed1 = self.seed + self.gamma
          #|  self.seed = seed1 + self.gamma
          #|  { seed: mix64(seed1), gamma: mix_gamma(self.seed) } }
        ),
      ),
      "shift_xor": build(
        (
          #|fn shift_xor(n : Int, w : UInt64) -> UInt64 { w ^ (w >> n) }
        ),
      ),
      "shift_xor_mul": build(
        (
          #|fn shift_xor_mul(n : Int, k : UInt64, w : UInt64) -> UInt64 { shift_xor(n, w) * k }
        ),
      ),
      "mix64": build(
        (
          #|fn mix64(z0 : UInt64) -> UInt64 { let z1 = shift_xor_mul(30, 0xff51afd7ed558ccd, z0)
          #|  let z2 = shift_xor_mul(33, 0xc4ceb9fe1a85ec53, z1)
          #|  shift_xor(33, z2) }
        ),
      ),
      "mix64variant13": build(
        (
          #|fn mix64variant13(z0 : UInt64) -> UInt64 { let z1 = shift_xor_mul(30, 0xbf58476d1ce4e5b9, z0)
          #|  let z2 = shift_xor_mul(27, 0x94d049bb133111eb, z1)
          #|  shift_xor(31, z2) }
        ),
      ),
      "mix_gamma": build(
        (
          #|fn mix_gamma(z0 : UInt64) -> UInt64 { let z1 = mix64variant13(z0 | 1)
          #|  let n = (z1 | (z1 >> 1)).popcnt()
          #|  if n >= 24 {
          #|    z1
          #|  } else {
          #|    z1 ^ 0xaaaaaaaaaaaaaaaa
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_random_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/random",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/double": moonbitlang_core_double_module,
    "moonbitlang/core/random/internal/random_source": moonbitlang_core_random_internal_random_source_module,
    "moonbitlang/core/bigint": moonbitlang_core_bigint_module,
  },
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
          #|fn next(self : Rand) -> UInt64 { let Rand(s) = self
          #|  s.next() }
        ),
      ),
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
      "double": build(
        (
          #|pub fn double(self : Rand) -> Double { Double::convert_uint64(self.next() << 11 >> 11) /
          #|  Double::convert_uint64(1UL << 53) }
        ),
      ),
      "float": build(
        (
          #|pub fn float(self : Rand) -> Float { (self.uint() << 8 >> 8).to_float() / (1U << 24).to_float() }
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
    }
  },
)

///|
let moonbitlang_core_random_internal_random_source_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/random/internal/random_source",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/array": moonbitlang_core_array_module,
    "moonbitlang/core/bytes": moonbitlang_core_bytes_module,
  },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn ChaCha8::new(seed : Bytes) -> ChaCha8 { let seed = FixedArray::makei(SEED_CHUNK_NUM * 2, i => seed[i * 4:i * 4 + 4].to_uint_le())
          #|  let buffer = FixedArray::make(BUFFER_CHUNK_NUM * 2, 0U)
          #|  chacha_block(seed, buffer, 0)
          #|  { seed, buffer, counter: 0, i: 0, n: BUFFER_CHUNK_NUM.reinterpret_as_uint() } }
        ),
      ),
      "next": build(
        (
          #|pub fn ChaCha8::next(self : ChaCha8) -> UInt64? { let i = self.i
          #|  if i >= self.n {
          #|    return None
          #|  }
          #|  self.i = i + 1
          #|  let index = i.reinterpret_as_int() & (BUFFER_CHUNK_NUM - 1)
          #|  let lo = self.buffer[index * 2].to_uint64()
          #|  let hi = self.buffer[index * 2 + 1].to_uint64()
          #|  Some((hi << 32) | lo) }
        ),
      ),
      "refill": build(
        (
          #|pub fn ChaCha8::refill(self : ChaCha8) -> Unit { self.counter += COUNTER_INC
          #|  if self.counter == COUNTER_MAX {
          #|    // reseed
          #|    // 1 chunk = 64 bits = number of bits in UInt * 2
          #|    self.buffer.blit_to(
          #|      self.seed,
          #|      len=SEED_CHUNK_NUM * 2,
          #|      src_offset=(BUFFER_CHUNK_NUM - SEED_CHUNK_NUM) * 2,
          #|    )
          #|    self.counter = 0
          #|  }
          #|  chacha_block(self.seed, self.buffer, self.counter)
          #|  self.i = 0
          #|  self.n = if self.counter == COUNTER_MAX - COUNTER_INC {
          #|    (BUFFER_CHUNK_NUM - SEED_CHUNK_NUM).reinterpret_as_uint()
          #|  } else {
          #|    BUFFER_CHUNK_NUM.reinterpret_as_uint()
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_rational_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/rational",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/double": moonbitlang_core_double_module,
    "moonbitlang/core/int64": moonbitlang_core_int64_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
  },
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
          #|pub fn reciprocal(self : T) -> T { if self.numerator < 0L {
          #|    new_unchecked(-self.denominator, -self.numerator)
          #|  } else {
          #|    new_unchecked(self.denominator, self.numerator)
          #|  } }
        ),
      ),
      "neg": build(
        (
          #|pub fn T::neg(self : T) -> T { new_unchecked(-self.numerator, self.denominator) }
        ),
      ),
      "abs": build(
        (
          #|pub fn T::abs(self : T) -> T { new_unchecked(self.numerator.abs(), self.denominator) }
        ),
      ),
      "to_double": build(
        (
          #|pub fn to_double(self : T) -> Double { // TODO: complete algorithm
          #|  self.numerator.to_double() / self.denominator.to_double() }
        ),
      ),
      "nan_error": build(
        (
          #|fn[T] nan_error() -> T raise RationalError { raise RationalError(\"Rational::from_double: cannot convert NaN\") }
        ),
      ),
      "overflow_error": build(
        (
          #|fn[T] overflow_error() -> T raise RationalError { raise RationalError(\"Rational::from_double: overflow\") }
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
          #|pub fn T::ceil(self : T) -> Int64 { let sign = if self.numerator < 0L { -1L } else { 1L }
          #|  let quotient = self.numerator / self.denominator
          #|  if self.numerator % self.denominator == 0L {
          #|    quotient
          #|  } else {
          #|    quotient + (1L + sign) / 2L
          #|  } }
        ),
      ),
      "floor": build(
        (
          #|pub fn T::floor(self : T) -> Int64 { let sign = if self.numerator < 0L { -1L } else { 1L }
          #|  let quotient = self.numerator / self.denominator
          #|  if self.numerator % self.denominator == 0L {
          #|    quotient
          #|  } else {
          #|    quotient + (-1L + sign) / 2L
          #|  } }
        ),
      ),
      "trunc": build(
        (
          #|pub fn T::trunc(self : T) -> Int64 { if self.numerator < 0L {
          #|    -(-self.numerator / self.denominator)
          #|  } else {
          #|    self.numerator / self.denominator
          #|  } }
        ),
      ),
      "fract": build(
        (
          #|pub fn fract(self : T) -> T { new_unchecked(self.numerator % self.denominator, self.denominator) }
        ),
      ),
      "is_integer": build(
        (
          #|pub fn is_integer(self : T) -> Bool { self.denominator == 1L }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_ref_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/ref",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
  },
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn[T] Ref::new(x : T) -> Ref[T] { { val: x } }
        ),
      ),
      "new": build(
        (
          #|pub fn[T] new(x : T) -> Ref[T] { { val: x } }
        ),
      ),
      "map": build(
        (
          #|pub fn[T, R] map(self : Ref[T], f : (T) -> R raise?) -> Ref[R] raise? { { val: f(self.val) } }
        ),
      ),
      "protect": build(
        (
          #|pub fn[T, R] protect(self : Ref[T], a : T, f : () -> R raise?) -> R raise? { let old = self.val
          #|  self.val = a
          #|  try f() catch {
          #|    err => {
          #|      self.val = old
          #|      raise err
          #|    }
          #|  } noraise {
          #|    r => {
          #|      self.val = old
          #|      r
          #|    }
          #|  } }
        ),
      ),
      "swap": build(
        (
          #|pub fn[T] Ref::swap(self : Ref[T], that : Ref[T]) -> Unit { let tmp = self.val
          #|  self.val = that.val
          #|  that.val = tmp }
        ),
      ),
      "update": build(
        (
          #|pub fn[T] update(self : Ref[T], f : (T) -> T raise?) -> Unit raise? { self.val = f(self.val) }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_result_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/result",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
  },
  fn(_env, build) {
    {
      "map": build(
        (
          #|pub fn[T, E, U] map(self : Result[T, E], f : (T) -> U) -> Result[U, E] { match self {
          #|    Ok(value) => Ok(f(value))
          #|    Err(err) => Err(err)
          #|  } }
        ),
      ),
      "map_err": build(
        (
          #|pub fn[T, E, F] map_err(self : Result[T, E], f : (E) -> F) -> Result[T, F] { match self {
          #|    Ok(value) => Ok(value)
          #|    Err(err) => Err(f(err))
          #|  } }
        ),
      ),
      "err": build(
        (
          #|pub fn[T, E] err(value : E) -> Result[T, E] { Err(value) }
        ),
      ),
      "ok": build(
        (
          #|pub fn[T, E] ok(value : T) -> Result[T, E] { Ok(value) }
        ),
      ),
      "is_ok": build(
        (
          #|pub fn[T, E] is_ok(self : Result[T, E]) -> Bool { self is Ok(_) }
        ),
      ),
      "is_err": build(
        (
          #|pub fn[T, E] is_err(self : Result[T, E]) -> Bool { self is Err(_) }
        ),
      ),
      "or": build(
        (
          #|pub fn[T, E] or(self : Result[T, E], default : T) -> T { match self {
          #|    Ok(value) => value
          #|    Err(_) => default
          #|  } }
        ),
      ),
      "or_else": build(
        (
          #|pub fn[T, E] or_else(self : Result[T, E], default : () -> T) -> T { match self {
          #|    Ok(value) => value
          #|    Err(_) => default()
          #|  } }
        ),
      ),
      "flatten": build(
        (
          #|pub fn[T, E] flatten(self : Result[Result[T, E], E]) -> Result[T, E] { match self {
          #|    Ok(value) => value
          #|    Err(err) => Err(err)
          #|  } }
        ),
      ),
      "fold": build(
        (
          #|pub fn[T, E, V] fold(self : Result[T, E], ok : (T) -> V, err : (E) -> V) -> V { match self {
          #|    Ok(value) => ok(value)
          #|    Err(error) => err(error)
          #|  } }
        ),
      ),
      "to_option": build(
        (
          #|pub fn[T, E] to_option(self : Result[T, E]) -> T? { match self {
          #|    Ok(value) => Some(value)
          #|    Err(_) => None
          #|  } }
        ),
      ),
      "unwrap": build(
        (
          #|pub fn[T, E] unwrap(self : Result[T, E]) -> T { match self {
          #|    Ok(x) => x
          #|    Err(_) => abort(\"called `Result::unwrap()` on an `Err` value\")
          #|  } }
        ),
      ),
      "unwrap_err": build(
        (
          #|pub fn[T, E] unwrap_err(self : Result[T, E]) -> E { match self {
          #|    Ok(_) => abort(\"called `Result::unwrap_err()` on an `Ok` value\")
          #|    Err(e) => e
          #|  } }
        ),
      ),
      "unwrap_or_error": build(
        (
          #|pub fn[T, E : Error] unwrap_or_error(self : Result[T, E]) -> T raise E { match self {
          #|    Ok(x) => x
          #|    Err(e) => raise e
          #|  } }
        ),
      ),
      "wrap0": build(
        (
          #|pub fn[T, E : Error] wrap0(f~ : () -> T raise E) -> Result[T, E] { try f() |> Ok catch {
          #|    e => Err(e)
          #|  } }
        ),
      ),
      "wrap1": build(
        (
          #|pub fn[T, A, E : Error] wrap1(f~ : (A) -> T raise E, a : A) -> Result[T, E] { try f(a) |> Ok catch {
          #|    e => Err(e)
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_set_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/set",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/int": moonbitlang_core_int_module,
  },
  fn(_env, build) {
    {
      "calc_grow_threshold": build(
        (
          #|fn calc_grow_threshold(capacity : Int) -> Int { capacity * 13 / 16 }
        ),
      ),
      "new": build(
        (
          #|pub fn[K] Set::new(capacity~ : Int = 8) -> Set[K] { let capacity = capacity.next_power_of_two()
          #|  {
          #|    size: 0,
          #|    capacity,
          #|    capacity_mask: capacity - 1,
          #|    grow_at: calc_grow_threshold(capacity),
          #|    entries: FixedArray::make(capacity, None),
          #|    list: FixedArray::make(capacity, { prev: None, next: None }),
          #|    head: None,
          #|    tail: None,
          #|  } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[K : Hash + Eq] Set::from_array(arr : Array[K]) -> Set[K] { let m = Set::new(capacity=arr.length())
          #|  arr.each(e => m.add(e))
          #|  m }
        ),
      ),
      "add_and_check": build(
        (
          #|pub fn[K : Hash + Eq] add_and_check(self : Set[K], key : K) -> Bool { if self.size >= self.grow_at {
          #|    self.grow()
          #|  }
          #|  let hash = key.hash()
          #|  let insert_entry = { idx: -1, psl: 0, hash, key }
          #|  let list_node : SListNode[K] = { prev: None, next: None }
          #|  for i = 0, idx = hash & self.capacity_mask, entry = insert_entry, node = list_node {
          #|    match self.entries[idx] {
          #|      None => {
          #|        self.entries[idx] = Some(entry)
          #|        self.list[idx] = node
          #|        entry.idx = idx
          #|        self.add_entry_to_tail(insert_entry)
          #|        self.size += 1
          #|        break true
          #|      }
          #|      Some(curr_entry) => {
          #|        let curr_node = self.list[curr_entry.idx]
          #|        if curr_entry.hash == entry.hash && curr_entry.key == entry.key {
          #|          break false
          #|        }
          #|        if entry.psl > curr_entry.psl {
          #|          self.entries[idx] = Some(entry)
          #|          self.list[idx] = node
          #|          entry.idx = idx
          #|          curr_entry.psl += 1
          #|          continue i + 1, (idx + 1) & self.capacity_mask, curr_entry, curr_node
          #|        } else {
          #|          entry.psl += 1
          #|          continue i + 1, (idx + 1) & self.capacity_mask, entry, node
          #|        }
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "add": build(
        (
          #|pub fn[K : Hash + Eq] add(self : Set[K], key : K) -> Unit { if self.size >= self.grow_at {
          #|    self.grow()
          #|  }
          #|  let hash = key.hash()
          #|  let insert_entry = { idx: -1, psl: 0, hash, key }
          #|  let list_node : SListNode[K] = { prev: None, next: None }
          #|  for i = 0, idx = hash & self.capacity_mask, entry = insert_entry, node = list_node {
          #|    match self.entries[idx] {
          #|      None => {
          #|        self.entries[idx] = Some(entry)
          #|        self.list[idx] = node
          #|        entry.idx = idx
          #|        self.add_entry_to_tail(insert_entry)
          #|        self.size += 1
          #|        break
          #|      }
          #|      Some(curr_entry) => {
          #|        let curr_node = self.list[curr_entry.idx]
          #|        if curr_entry.hash == entry.hash && curr_entry.key == entry.key {
          #|          break
          #|        }
          #|        if entry.psl > curr_entry.psl {
          #|          self.entries[idx] = Some(entry)
          #|          self.list[idx] = node
          #|          entry.idx = idx
          #|          curr_entry.psl += 1
          #|          continue i + 1, (idx + 1) & self.capacity_mask, curr_entry, curr_node
          #|        } else {
          #|          entry.psl += 1
          #|          continue i + 1, (idx + 1) & self.capacity_mask, entry, node
          #|        }
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "contains": build(
        (
          #|pub fn[K : Hash + Eq] contains(self : Set[K], key : K) -> Bool { let hash = key.hash()
          #|  for i = 0, idx = hash & self.capacity_mask {
          #|    match self.entries[idx] {
          #|      Some(entry) => {
          #|        if entry.hash == hash && entry.key == key {
          #|          break true
          #|        }
          #|        if i > entry.psl {
          #|          break false
          #|        }
          #|        continue i + 1, (idx + 1) & self.capacity_mask
          #|      }
          #|      None => break false
          #|    }
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[K : Hash + Eq] remove(self : Set[K], key : K) -> Unit { let hash = key.hash()
          #|  for i = 0, idx = hash & self.capacity_mask {
          #|    match self.entries[idx] {
          #|      Some(entry) => {
          #|        if entry.hash == hash && entry.key == key {
          #|          self.entries[idx] = None
          #|          self.remove_entry(entry)
          #|          self.shift_back(idx)
          #|          self.size -= 1
          #|          break
          #|        }
          #|        if i > entry.psl {
          #|          break
          #|        }
          #|        continue i + 1, (idx + 1) & self.capacity_mask
          #|      }
          #|      None => break
          #|    }
          #|  } }
        ),
      ),
      "remove_and_check": build(
        (
          #|pub fn[K : Hash + Eq] remove_and_check(self : Set[K], key : K) -> Bool { let hash = key.hash()
          #|  for i = 0, idx = hash & self.capacity_mask {
          #|    match self.entries[idx] {
          #|      Some(entry) => {
          #|        if entry.hash == hash && entry.key == key {
          #|          self.entries[idx] = None
          #|          self.remove_entry(entry)
          #|          self.shift_back(idx)
          #|          self.size -= 1
          #|          break true
          #|        }
          #|        if i > entry.psl {
          #|          break false
          #|        }
          #|        continue i + 1, (idx + 1) & self.capacity_mask
          #|      }
          #|      None => break false
          #|    }
          #|  } }
        ),
      ),
      "add_entry_to_tail": build(
        (
          #|fn[K] add_entry_to_tail(self : Set[K], entry : SEntry[K]) -> Unit { match self.tail {
          #|    None => {
          #|      self.head = Some(entry)
          #|      self.tail = Some(entry)
          #|    }
          #|    Some(tail) => {
          #|      self.list[tail.idx].next = Some(entry)
          #|      self.list[entry.idx].prev = Some(tail)
          #|      self.tail = Some(entry)
          #|    }
          #|  } }
        ),
      ),
      "remove_entry": build(
        (
          #|fn[K : Eq] remove_entry(self : Set[K], entry : SEntry[K]) -> Unit { let node = self.list[entry.idx]
          #|  if self.is_empty() {
          #|    self.head = None
          #|    self.tail = None
          #|  } else {
          #|    if self.head.unwrap() == entry {
          #|      self.head = node.next
          #|    }
          #|    if self.tail.unwrap() == entry {
          #|      self.tail = node.prev
          #|    }
          #|    if node.prev is Some(prev) {
          #|      self.list[prev.idx].next = node.next
          #|    }
          #|    if node.next is Some(next) {
          #|      self.list[next.idx].prev = node.prev
          #|    }
          #|  }
          #|  node.prev = None
          #|  node.next = None }
        ),
      ),
      "shift_back": build(
        (
          #|fn[K] shift_back(self : Set[K], start_index : Int) -> Unit { for prev = start_index, curr = (start_index + 1) & self.capacity_mask {
          #|    match (self.entries[curr], self.list[curr]) {
          #|      (Some(entry), currNode) => {
          #|        if entry.psl == 0 {
          #|          break
          #|        }
          #|        entry.psl -= 1
          #|        entry.idx = prev
          #|        self.entries[prev] = Some(entry)
          #|        self.entries[curr] = None
          #|        self.list[prev].prev = currNode.prev
          #|        self.list[prev].next = currNode.next
          #|        currNode.prev = None
          #|        currNode.next = None
          #|        continue curr, (curr + 1) & self.capacity_mask
          #|      }
          #|      (None, _) => break
          #|    }
          #|  } }
        ),
      ),
      "grow": build(
        (
          #|fn[K : Hash + Eq] grow(self : Set[K]) -> Unit { let old_head = self.head
          #|  let old_list = self.list
          #|  let new_capacity = self.capacity << 1
          #|  self.entries = FixedArray::make(new_capacity, None)
          #|  self.list = FixedArray::make(new_capacity, { prev: None, next: None })
          #|  self.capacity = new_capacity
          #|  self.capacity_mask = new_capacity - 1
          #|  self.grow_at = calc_grow_threshold(self.capacity)
          #|  self.size = 0
          #|  self.head = None
          #|  self.tail = None
          #|  loop old_head {
          #|    Some({ idx, key, .. }) => {
          #|      self.add(key)
          #|      continue old_list[idx].next
          #|    }
          #|    None => break
          #|  } }
        ),
      ),
      "size": build(
        (
          #|pub fn[K] size(self : Set[K]) -> Int { self.size }
        ),
      ),
      "capacity": build(
        (
          #|pub fn[K] capacity(self : Set[K]) -> Int { self.capacity }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[K] is_empty(self : Set[K]) -> Bool { self.size == 0 }
        ),
      ),
      "each": build(
        (
          #|pub fn[K] each(self : Set[K], f : (K) -> Unit raise?) -> Unit raise? { loop self.head {
          #|    Some({ key, idx, .. }) => {
          #|      f(key)
          #|      continue self.list[idx].next
          #|    }
          #|    None => break
          #|  } }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[K] eachi(self : Set[K], f : (Int, K) -> Unit raise?) -> Unit raise? { loop (0, self.head) {
          #|    (i, Some({ key, idx, .. })) => {
          #|      f(i, key)
          #|      continue (i + 1, self.list[idx].next)
          #|    }
          #|    (_, None) => break
          #|  } }
        ),
      ),
      "clear": build(
        (
          #|pub fn[K] clear(self : Set[K]) -> Unit { self.entries.fill(None)
          #|  self.size = 0
          #|  self.head = None
          #|  self.tail = None }
        ),
      ),
      "iter": build(
        (
          #|pub fn[K] iter(self : Set[K]) -> Iter[K] { Iter::new(yield_ => loop self.head {
          #|    Some({ key, idx, .. }) => {
          #|      if yield_(key) == IterEnd {
          #|        break IterEnd
          #|      }
          #|      continue self.list[idx].next
          #|    }
          #|    None => break IterContinue
          #|  }) }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[K] to_array(self : Set[K]) -> Array[K] { let res = Array::new(capacity=self.size)
          #|  loop self.head {
          #|    Some({ key, idx, .. }) => {
          #|      res.push(key)
          #|      continue self.list[idx].next
          #|    }
          #|    None => break
          #|  }
          #|  res }
        ),
      ),
      "of": build(
        (
          #|pub fn[K : Hash + Eq] Set::of(arr : FixedArray[K]) -> Set[K] { let length = arr.length()
          #|  let m = Set::new(capacity=length)
          #|  // arr.iter((e) => { m.set(e.0, e.1) })
          #|  for i in 0..<length {
          #|    let e = arr[i]
          #|    m.add(e)
          #|  }
          #|  m }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[K : Hash + Eq] Set::from_iter(iter : Iter[K]) -> Set[K] { let m = Set::new()
          #|  iter.each(e => m.add(e))
          #|  m }
        ),
      ),
      "difference": build(
        (
          #|pub fn[K : Hash + Eq] difference(self : Set[K], other : Set[K]) -> Set[K] { let m = Set::new()
          #|  self.each(k => if !other.contains(k) { m.add(k) })
          #|  m }
        ),
      ),
      "union": build(
        (
          #|pub fn[K : Hash + Eq] union(self : Set[K], other : Set[K]) -> Set[K] { let m = Set::new()
          #|  self.each(k => m.add(k))
          #|  other.each(k => m.add(k))
          #|  m }
        ),
      ),
      "intersection": build(
        (
          #|pub fn[K : Hash + Eq] intersection(self : Set[K], other : Set[K]) -> Set[K] { let m = Set::new()
          #|  self.each(k => if other.contains(k) { m.add(k) })
          #|  m }
        ),
      ),
      "insert": build(
        (
          #|pub fn[K : Hash + Eq] insert(self : Set[K], key : K) -> Unit { self.add(key) }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_sorted_map_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/sorted_map",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/option": moonbitlang_core_option_module,
    "moonbitlang/core/tuple": moonbitlang_core_tuple_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
  },
  fn(_env, build) {
    {
      "op_set": build(
        (
          #|pub fn[K : Compare, V] op_set(self : T[K, V], key : K, value : V) -> Unit { self.add(key, value) }
        ),
      ),
      "new": build(
        (
          #|pub fn[K, V] new() -> T[K, V] { { root: None, size: 0 } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[K : Compare, V] from_array(entries : Array[(K, V)]) -> T[K, V] { let map = { root: None, size: 0 }
          #|  entries.each(e => map.add(e.0, e.1))
          #|  map }
        ),
      ),
      "add": build(
        (
          #|pub fn[K : Compare, V] add(self : T[K, V], key : K, value : V) -> Unit { let (new_root, inserted) = add_node(self.root, key, value)
          #|  if self.root != new_root {
          #|    self.root = new_root
          #|  }
          #|  if inserted {
          #|    self.size += 1
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[K : Compare, V] remove(self : T[K, V], key : K) -> Unit { if self.root is Some(old_root) {
          #|    let (new_root, deleted) = delete_node(old_root, key)
          #|    if self.root != new_root {
          #|      self.root = new_root
          #|    }
          #|    if deleted {
          #|      self.size -= 1
          #|    }
          #|  } }
        ),
      ),
      "get": build(
        (
          #|pub fn[K : Compare, V] get(self : T[K, V], key : K) -> V? { loop self.root {
          #|    Some(node) => {
          #|      let cmp = key.compare(node.key)
          #|      if cmp == 0 {
          #|        break Some(node.value)
          #|      } else if cmp > 0 {
          #|        continue node.right
          #|      } else {
          #|        continue node.left
          #|      }
          #|    }
          #|    None => break None
          #|  } }
        ),
      ),
      "contains": build(
        (
          #|pub fn[K : Compare, V] contains(self : T[K, V], key : K) -> Bool { match self.get(key) {
          #|    Some(_) => true
          #|    None => false
          #|  } }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[K, V] is_empty(self : T[K, V]) -> Bool { self.size == 0 }
        ),
      ),
      "size": build(
        (
          #|pub fn[K, V] size(self : T[K, V]) -> Int { self.size }
        ),
      ),
      "clear": build(
        (
          #|pub fn[K, V] clear(self : T[K, V]) -> Unit { self.root = None
          #|  self.size = 0 }
        ),
      ),
      "each": build(
        (
          #|pub fn[K, V] each(self : T[K, V], f : (K, V) -> Unit raise?) -> Unit raise? { fn dfs(root : Node[K, V]?) -> Unit raise? {
          #|    if root is Some(root) {
          #|      dfs(root.left)
          #|      f(root.key, root.value)
          #|      dfs(root.right)
          #|    }
          #|  }
          #|  dfs(self.root) }
        ),
      ),
      "keys": build(
        (
          #|pub fn[K, V] keys(self : T[K, V]) -> Array[K] { let keys = Array::new(capacity=self.size)
          #|  self.each((k, _v) => keys.push(k))
          #|  keys }
        ),
      ),
      "values": build(
        (
          #|pub fn[K, V] values(self : T[K, V]) -> Array[V] { let values = Array::new(capacity=self.size)
          #|  self.each((_k, v) => values.push(v))
          #|  values }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[K, V] to_array(self : T[K, V]) -> Array[(K, V)] { let arr = Array::new(capacity=self.size)
          #|  self.each((k, v) => arr.push((k, v)))
          #|  arr }
        ),
      ),
      "iter": build(
        (
          #|pub fn[K, V] iter(self : T[K, V]) -> Iter[(K, V)] { Iter::new(yield_ => {
          #|    fn go(x : Node[K, V]?) {
          #|      match x {
          #|        None => IterContinue
          #|        Some({ left, right, key, value, .. }) =>
          #|          if go(left) is IterEnd {
          #|            IterEnd
          #|          } else if yield_((key, value)) is IterEnd {
          #|            IterEnd
          #|          } else {
          #|            go(right)
          #|          }
          #|      }
          #|    }
          #|    go(self.root)
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn[K, V] iter2(self : T[K, V]) -> Iter2[K, V] { Iter2::new(yield_ => {
          #|    fn go(x : Node[K, V]?) {
          #|      match x {
          #|        None => IterContinue
          #|        Some({ left, right, key, value, .. }) =>
          #|          if go(left) is IterEnd {
          #|            IterEnd
          #|          } else if yield_(key, value) is IterEnd {
          #|            IterEnd
          #|          } else {
          #|            go(right)
          #|          }
          #|      }
          #|    }
          #|    go(self.root)
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[K : Compare, V] from_iter(iter : Iter[(K, V)]) -> T[K, V] { let m = new()
          #|  iter.each(e => m[e.0] = e.1)
          #|  m }
        ),
      ),
      "range": build(
        (
          #|pub fn[K : Compare, V] range(self : T[K, V], low : K, high : K) -> Iter2[K, V] { Iter2::new(yield_ => {
          #|    fn go(x : Node[K, V]?) {
          #|      match x {
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
          #|      }
          #|    }
          #|    go(self.root)
          #|  }) }
        ),
      ),
      "update_height": build(
        (
          #|fn[K, V] update_height(self : Node[K, V]) -> Unit { self.height = 1 + max(height(self.left), height(self.right)) }
        ),
      ),
      "height_ge": build(
        (
          #|fn[K, V] height_ge(x1 : Node[K, V]?, x2 : Node[K, V]?) -> Bool { match x2 {
          #|    None => true
          #|    Some(n2) =>
          #|      match x1 {
          #|        None => false
          #|        Some(n1) => n1.height >= n2.height
          #|      }
          #|  } }
        ),
      ),
      "balance": build(
        (
          #|fn[K, V] balance(root : Node[K, V]) -> Node[K, V] { let (l, r) = (root.left, root.right)
          #|  let (hl, hr) = (height(l), height(r))
          #|  let new_root = if hl > hr + 1 {
          #|    let { left: ll, right: lr, .. } = l.unwrap()
          #|    if height_ge(ll, lr) {
          #|      rotate_r(root)
          #|    } else {
          #|      rotate_lr(root)
          #|    }
          #|  } else if hr > hl + 1 {
          #|    let { left: rl, right: rr, .. } = r.unwrap()
          #|    if height_ge(rr, rl) {
          #|      rotate_l(root)
          #|    } else {
          #|      rotate_rl(root)
          #|    }
          #|  } else {
          #|    root
          #|  }
          #|  new_root.update_height()
          #|  new_root }
        ),
      ),
      "rotate_l": build(
        (
          #|fn[K, V] rotate_l(n : Node[K, V]) -> Node[K, V] { let r = n.right.unwrap()
          #|  n.right = r.left
          #|  r.left = Some(n)
          #|  n.update_height()
          #|  r.update_height()
          #|  r }
        ),
      ),
      "rotate_r": build(
        (
          #|fn[K, V] rotate_r(n : Node[K, V]) -> Node[K, V] { let l = n.left.unwrap()
          #|  n.left = l.right
          #|  l.right = Some(n)
          #|  n.update_height()
          #|  l.update_height()
          #|  l }
        ),
      ),
      "rotate_lr": build(
        (
          #|fn[K, V] rotate_lr(n : Node[K, V]) -> Node[K, V] { let l = n.left.unwrap()
          #|  let v = rotate_l(l)
          #|  n.left = Some(v)
          #|  rotate_r(n) }
        ),
      ),
      "rotate_rl": build(
        (
          #|fn[K, V] rotate_rl(n : Node[K, V]) -> Node[K, V] { let r = n.right.unwrap()
          #|  let v = rotate_r(r)
          #|  n.right = Some(v)
          #|  rotate_l(n) }
        ),
      ),
      "op_get": build(
        (
          #|pub fn[K : Compare, V] op_get(self : T[K, V], key : K) -> V? { self.get(key) }
        ),
      ),
      "of": build(
        (
          #|pub fn[K : Compare, V] of(entries : Array[(K, V)]) -> T[K, V] { let map = { root: None, size: 0 }
          #|  entries.each(e => map.add(e.0, e.1))
          #|  map }
        ),
      ),
      "new_node": build(
        (
          #|fn[K, V] new_node(key : K, value : V) -> Node[K, V] { { key, value, left: None, right: None, height: 1 } }
        ),
      ),
      "max": build(
        (
          #|fn max(x : Int, y : Int) -> Int { if x > y {
          #|    x
          #|  } else {
          #|    y
          #|  } }
        ),
      ),
      "height": build(
        (
          #|fn[K, V] height(node : Node[K, V]?) -> Int { match node {
          #|    None => 0
          #|    Some(n) => n.height
          #|  } }
        ),
      ),
      "debug_node": build(
        (
          #|fn[K : Show, V : Show] debug_node(self : Node[K, V]) -> String { let l = match self.left {
          #|    Some(left) => left.debug_node()
          #|    None => \"_\"
          #|  }
          #|  let r = match self.right {
          #|    Some(right) => right.debug_node()
          #|    None => \"_\"
          #|  }
          #|  \"([\\{self.height}]\\{self.key},\\{self.value},\\{l},\\{r})\" }
        ),
      ),
      "debug_tree": build(
        (
          #|fn[K : Show, V : Show] debug_tree(self : T[K, V]) -> String { match self.root {
          #|    Some(root) => root.debug_node()
          #|    None => \"_\"
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_sorted_set_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/sorted_set",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/option": moonbitlang_core_option_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
  },
  fn(_env, build) {
    {
      "from_iter": build(
        (
          #|pub fn[V : Compare] T::from_iter(iter : Iter[V]) -> T[V] { from_iter(iter) }
        ),
      ),
      "of": build(
        (
          #|pub fn[V : Compare] of(array : Array[V]) -> T[V] { let set = new()
          #|  for i in 0..<array.length() {
          #|    set.add(array[i])
          #|  }
          #|  set }
        ),
      ),
      "deep_clone": build(
        (
          #|pub fn[V] deep_clone(self : T[V]) -> T[V] { self.copy() }
        ),
      ),
      "diff": build(
        (
          #|pub fn[V : Compare] diff(self : T[V], src : T[V]) -> T[V] { let ret = new()
          #|  self.each(x => if !src.contains(x) { ret.add(x) })
          #|  ret }
        ),
      ),
      "intersect": build(
        (
          #|pub fn[V : Compare] intersect(self : T[V], src : T[V]) -> T[V] { self.intersection(src) }
        ),
      ),
      "max": build(
        (
          #|fn max(x : Int, y : Int) -> Int { if x > y {
          #|    x
          #|  } else {
          #|    y
          #|  } }
        ),
      ),
      "height": build(
        (
          #|fn[V] height(node : Node[V]?) -> Int { match node {
          #|    None => 0
          #|    Some(n) => n.height
          #|  } }
        ),
      ),
      "debug_node": build(
        (
          #|fn[V : Show] debug_node(self : Node[V]) -> String { let l = match self.left {
          #|    Some(left) => left.debug_node()
          #|    None => \"_\"
          #|  }
          #|  let r = match self.right {
          #|    Some(right) => right.debug_node()
          #|    None => \"_\"
          #|  }
          #|  let value = self.value
          #|  let height = self.height
          #|  \"([\\{height}]\\{value},\\{l},\\{r})\" }
        ),
      ),
      "debug_tree": build(
        (
          #|fn[V : Show] debug_tree(self : T[V]) -> String { match self.root {
          #|    Some(root) => root.debug_node()
          #|    None => \"_\"
          #|  } }
        ),
      ),
      "new": build(
        (
          #|pub fn[V] new() -> T[V] { { root: None, size: 0 } }
        ),
      ),
      "singleton": build(
        (
          #|pub fn[V] singleton(value : V) -> T[V] { { root: Some({ value, left: None, right: None, height: 1 }), size: 1 } }
        ),
      ),
      "from_array": build(
        (
          #|pub fn[V : Compare] from_array(array : Array[V]) -> T[V] { let set = new()
          #|  for i in 0..<array.length() {
          #|    set.add(array[i])
          #|  }
          #|  set }
        ),
      ),
      "copy": build(
        (
          #|pub fn[V] copy(self : T[V]) -> T[V] { match self.root {
          #|    None => new()
          #|    Some(_) => { root: copy_tree(self.root), size: self.size }
          #|  } }
        ),
      ),
      "copy_tree": build(
        (
          #|fn[V] copy_tree(node : Node[V]?) -> Node[V]? { match node {
          #|    None => None
          #|    Some(node) => {
          #|      let left = copy_tree(node.left)
          #|      let right = copy_tree(node.right)
          #|      let new_node = new_node(node.value, left~, right~, height=node.height)
          #|      Some(new_node)
          #|    }
          #|  } }
        ),
      ),
      "add": build(
        (
          #|pub fn[V : Compare] add(self : T[V], value : V) -> Unit { let (new_root, inserted) = add_node(self.root, value)
          #|  if self.root != new_root {
          #|    self.root = new_root
          #|  }
          #|  if inserted {
          #|    self.size += 1
          #|  } }
        ),
      ),
      "remove": build(
        (
          #|pub fn[V : Compare] remove(self : T[V], value : V) -> Unit { if self.root is Some(old_root) {
          #|    let (new_root, deleted) = delete_node(old_root, value)
          #|    if self.root != new_root {
          #|      self.root = new_root
          #|    }
          #|    if deleted {
          #|      self.size -= 1
          #|    }
          #|  } }
        ),
      ),
      "contains": build(
        (
          #|pub fn[V : Compare] contains(self : T[V], value : V) -> Bool { loop (self.root, value) {
          #|    (None, _) => false
          #|    (Some(node), value) => {
          #|      let compare_result = value.compare(node.value)
          #|      if compare_result == 0 {
          #|        true
          #|      } else if compare_result < 0 {
          #|        continue (node.left, value)
          #|      } else {
          #|        continue (node.right, value)
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "union": build(
        (
          #|pub fn[V : Compare] union(self : T[V], src : T[V]) -> T[V] { fn aux(a : Node[V]?, b : Node[V]?) -> Node[V]? {
          #|    match (a, b) {
          #|      (Some(_), None) => a
          #|      (None, Some(_)) => b
          #|      (Some({ value: va, left: la, right: ra, .. }), Some(_)) => {
          #|        let (l, r) = split(b, va)
          #|        Some(join(aux(la, l), va, aux(ra, r)))
          #|      }
          #|      (None, None) => None
          #|    }
          #|  }
          #|  match (self.root, src.root) {
          #|    (Some(_), Some(_)) => {
          #|      let t1 = copy_tree(self.root)
          #|      let t2 = copy_tree(src.root)
          #|      let t = aux(t1, t2)
          #|      let mut ct = 0
          #|      let ret = { root: t, size: 0 }
          #|      // TODO: optimize this. Avoid counting the size of the set.
          #|      ret.each(_x => ct = ct + 1)
          #|      ret.size = ct
          #|      ret
          #|    }
          #|    (Some(_), None) => { root: copy_tree(self.root), size: self.size }
          #|    (None, Some(_)) => { root: copy_tree(src.root), size: src.size }
          #|    (None, None) => new()
          #|  } }
        ),
      ),
      "split": build(
        (
          #|fn[V : Compare] split(root : Node[V]?, value : V) -> (Node[V]?, Node[V]?) { match root {
          #|    None => (None, None)
          #|    Some(node) => {
          #|      let comp = value.compare(node.value)
          #|      if comp == 0 {
          #|        (node.left, node.right)
          #|      } else if comp < 0 {
          #|        let (l, r) = split(node.left, value)
          #|        (l, Some(join(r, node.value, node.right)))
          #|      } else {
          #|        let (l, r) = split(node.right, value)
          #|        (Some(join(node.left, node.value, l)), r)
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "join": build(
        (
          #|fn[V : Compare] join(left : Node[V]?, value : V, right : Node[V]?) -> Node[V] { let (hl, hr) = (height(left), height(right))
          #|  if hl > hr + 1 {
          #|    join_right(left, value, right)
          #|  } else if hr > hl + 1 {
          #|    join_left(left, value, right)
          #|  } else {
          #|    new_node_update_height(value, left~, right~)
          #|  } }
        ),
      ),
      "join_left": build(
        (
          #|fn[V : Compare] join_left(l : Node[V]?, v : V, r : Node[V]?) -> Node[V] { let { value: rv, left: rl, right: rr, .. } = r.unwrap()
          #|  let node = if height(rl) <= height(l) + 1 {
          #|    let new_l = new_node_update_height(left=l, v, right=rl)
          #|    if height(Some(new_l)) <= height(rr) + 1 {
          #|      new_node_update_height(left=Some(new_l), rv, right=rr)
          #|    } else {
          #|      let new_l = rotate_l(new_l)
          #|      let new = new_node_update_height(left=Some(new_l), rv, right=rr)
          #|      rotate_r(new)
          #|    }
          #|  } else {
          #|    let new_l = join_left(l, v, rl)
          #|    let new = new_node_update_height(left=Some(new_l), rv, right=rr)
          #|    if height(Some(new_l)) <= height(rr) + 1 {
          #|      new
          #|    } else {
          #|      rotate_r(new)
          #|    }
          #|  }
          #|  node.update_height()
          #|  node }
        ),
      ),
      "join_right": build(
        (
          #|fn[V : Compare] join_right(l : Node[V]?, v : V, r : Node[V]?) -> Node[V] { let { value: lv, left: ll, right: lr, .. } = l.unwrap()
          #|  let node = if height(lr) <= height(r) + 1 {
          #|    let new_r = new_node_update_height(left=lr, v, right=r)
          #|    if height(Some(new_r)) <= height(ll) + 1 {
          #|      new_node_update_height(left=ll, lv, right=Some(new_r))
          #|    } else {
          #|      let new_r = rotate_r(new_r)
          #|      let new = new_node_update_height(left=ll, lv, right=Some(new_r))
          #|      rotate_l(new)
          #|    }
          #|  } else {
          #|    let new_r = join_right(lr, v, r)
          #|    let new = new_node_update_height(left=ll, lv, right=Some(new_r))
          #|    if height(Some(new_r)) <= height(ll) + 1 {
          #|      new
          #|    } else {
          #|      rotate_l(new)
          #|    }
          #|  }
          #|  node.update_height()
          #|  node }
        ),
      ),
      "difference": build(
        (
          #|pub fn[V : Compare] difference(self : T[V], src : T[V]) -> T[V] { let ret = new()
          #|  self.each(x => if !src.contains(x) { ret.add(x) })
          #|  ret }
        ),
      ),
      "symmetric_difference": build(
        (
          #|pub fn[V : Compare] symmetric_difference(self : T[V], other : T[V]) -> T[V] { // TODO: Optimize this function to avoid creating two intermediate sets.
          #|  let set1 = self.difference(other)
          #|  let set2 = other.difference(self)
          #|  set1.union(set2) }
        ),
      ),
      "intersection": build(
        (
          #|pub fn[V : Compare] intersection(self : T[V], src : T[V]) -> T[V] { let ret = new()
          #|  self.each(x => if src.contains(x) { ret.add(x) })
          #|  ret }
        ),
      ),
      "subset": build(
        (
          #|pub fn[V : Compare] subset(self : T[V], src : T[V]) -> Bool { let mut ret = true
          #|  self.each(x => if !src.contains(x) { ret = false })
          #|  ret }
        ),
      ),
      "disjoint": build(
        (
          #|pub fn[V : Compare] disjoint(self : T[V], src : T[V]) -> Bool { let mut ret = true
          #|  self.each(x => if src.contains(x) { ret = false })
          #|  ret }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn[V] is_empty(self : T[V]) -> Bool { self.root is None }
        ),
      ),
      "size": build(
        (
          #|pub fn[V] size(self : T[V]) -> Int { self.size }
        ),
      ),
      "each": build(
        (
          #|pub fn[V] each(self : T[V], f : (V) -> Unit raise?) -> Unit raise? { fn dfs(root : Node[V]?) -> Unit raise? {
          #|    if root is Some(root) {
          #|      dfs(root.left)
          #|      f(root.value)
          #|      dfs(root.right)
          #|    }
          #|  }
          #|  dfs(self.root) }
        ),
      ),
      "eachi": build(
        (
          #|pub fn[V] eachi(self : T[V], f : (Int, V) -> Unit raise?) -> Unit raise? { let mut i = 0
          #|  self.each(v => {
          #|    f(i, v)
          #|    i = i + 1
          #|  }) }
        ),
      ),
      "to_array": build(
        (
          #|pub fn[V] to_array(self : T[V]) -> Array[V] { if self.size == 0 {
          #|    []
          #|  } else {
          #|    let padding = self.root.unwrap().value
          #|    let arr = Array::make(self.size, padding)
          #|    let mut i = 0
          #|    fn dfs(root : Node[V]?) -> Unit {
          #|      if root is Some(root) {
          #|        dfs(root.left)
          #|        arr[i] = root.value
          #|        i = i + 1
          #|        dfs(root.right)
          #|      }
          #|    }
          #|    dfs(self.root)
          #|    arr
          #|  } }
        ),
      ),
      "iter": build(
        (
          #|pub fn[V] iter(self : T[V]) -> Iter[V] { Iter::new(yield_ => {
          #|    fn go(x : Node[V]?) {
          #|      match x {
          #|        None => IterContinue
          #|        Some({ left, right, value, .. }) =>
          #|          if go(left) is IterEnd {
          #|            IterEnd
          #|          } else if yield_(value) is IterEnd {
          #|            IterEnd
          #|          } else {
          #|            go(right)
          #|          }
          #|      }
          #|    }
          #|    go(self.root)
          #|  }) }
        ),
      ),
      "from_iter": build(
        (
          #|pub fn[V : Compare] from_iter(iter : Iter[V]) -> T[V] { let s = new()
          #|  iter.each(e => s.add(e))
          #|  s }
        ),
      ),
      "range": build(
        (
          #|pub fn[V : Compare] range(self : T[V], low : V, high : V) -> Iter[V] { Iter::new(yield_ => {
          #|    fn go(x : Node[V]?) {
          #|      match x {
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
          #|      }
          #|    }
          #|    go(self.root)
          #|  }) }
        ),
      ),
      "update_height": build(
        (
          #|fn[V] update_height(self : Node[V]) -> Unit { self.height = 1 + max(height(self.left), height(self.right)) }
        ),
      ),
      "height_ge": build(
        (
          #|fn[V] height_ge(x1 : Node[V]?, x2 : Node[V]?) -> Bool { match x2 {
          #|    None => true
          #|    Some(n2) =>
          #|      match x1 {
          #|        None => false
          #|        Some(n1) => n1.height >= n2.height
          #|      }
          #|  } }
        ),
      ),
      "balance": build(
        (
          #|fn[V] balance(root : Node[V]) -> Node[V] { let (l, r) = (root.left, root.right)
          #|  let (hl, hr) = (height(l), height(r))
          #|  let new_root = if hl > hr + 1 {
          #|    let { left: ll, right: lr, .. } = l.unwrap()
          #|    if height_ge(ll, lr) {
          #|      rotate_r(root)
          #|    } else {
          #|      rotate_lr(root)
          #|    }
          #|  } else if hr > hl + 1 {
          #|    let { left: rl, right: rr, .. } = r.unwrap()
          #|    if height_ge(rr, rl) {
          #|      rotate_l(root)
          #|    } else {
          #|      rotate_rl(root)
          #|    }
          #|  } else {
          #|    root
          #|  }
          #|  new_root.update_height()
          #|  new_root }
        ),
      ),
      "rotate_l": build(
        (
          #|fn[V] rotate_l(n : Node[V]) -> Node[V] { let r = n.right.unwrap()
          #|  n.right = r.left
          #|  r.left = Some(n)
          #|  n.update_height()
          #|  r.update_height()
          #|  r }
        ),
      ),
      "rotate_r": build(
        (
          #|fn[V] rotate_r(n : Node[V]) -> Node[V] { let l = n.left.unwrap()
          #|  n.left = l.right
          #|  l.right = Some(n)
          #|  n.update_height()
          #|  l.update_height()
          #|  l }
        ),
      ),
      "rotate_lr": build(
        (
          #|fn[V] rotate_lr(n : Node[V]) -> Node[V] { let l = n.left.unwrap()
          #|  let v = rotate_l(l)
          #|  n.left = Some(v)
          #|  rotate_r(n) }
        ),
      ),
      "rotate_rl": build(
        (
          #|fn[V] rotate_rl(n : Node[V]) -> Node[V] { let r = n.right.unwrap()
          #|  let v = rotate_r(r)
          #|  n.right = Some(v)
          #|  rotate_l(n) }
        ),
      ),
      "add_node": build(
        (
          #|fn[V : Compare] add_node(root : Node[V]?, value : V) -> (Node[V]?, Bool) { match root {
          #|    None => (Some(new_node(value)), true)
          #|    Some(n) => {
          #|      let comp = value.compare(n.value)
          #|      if comp == 0 {
          #|        n.value = value
          #|        (Some(n), false)
          #|      } else {
          #|        let (l, r) = (n.left, n.right)
          #|        if comp < 0 {
          #|          let (nl, inserted) = add_node(l, value)
          #|          n.left = nl
          #|          (Some(balance(n)), inserted)
          #|        } else {
          #|          let (nr, inserted) = add_node(r, value)
          #|          n.right = nr
          #|          (Some(balance(n)), inserted)
          #|        }
          #|      }
          #|    }
          #|  } }
        ),
      ),
      "delete_node": build(
        (
          #|fn[V : Compare] delete_node(root : Node[V], value : V) -> (Node[V]?, Bool) { let comp = value.compare(root.value)
          #|  if comp == 0 {
          #|    let (l, r) = (root.left, root.right)
          #|    let n = match (l, r) {
          #|      (Some(_), Some(nr)) => {
          #|        root.right = replace_root_with_min(root, nr)
          #|        Some(balance(root))
          #|      }
          #|      (None, Some(_)) => r
          #|      (Some(_), None) | (None, None) => l
          #|    }
          #|    (n, true)
          #|  } else if comp < 0 {
          #|    match root.left {
          #|      None => (Some(root), false)
          #|      Some(l) => {
          #|        let (nl, deleted) = delete_node(l, value)
          #|        root.left = nl
          #|        (Some(balance(root)), deleted)
          #|      }
          #|    }
          #|  } else {
          #|    match root.right {
          #|      None => (Some(root), false)
          #|      Some(r) => {
          #|        let (nr, deleted) = delete_node(r, value)
          #|        root.right = nr
          #|        (Some(balance(root)), deleted)
          #|      }
          #|    }
          #|  } }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_strconv_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/strconv",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/double": moonbitlang_core_double_module,
    "moonbitlang/core/uint64": moonbitlang_core_uint64_module,
    "moonbitlang/core/string": moonbitlang_core_string_module,
    "moonbitlang/core/char": moonbitlang_core_char_module,
  },
  fn(_env, build) {
    {
      "parse": build(
        (
          #|pub fn[A : FromStr] parse(str : String) -> A raise StrConvError { A::from_string(str) }
        ),
      ),
      "parse_bool": build(
        (
          #|pub fn parse_bool(str : @string.View) -> Bool raise StrConvError { match str {
          #|    \"1\" | \"t\" | \"T\" | \"true\" | \"TRUE\" | \"True\" => true
          #|    \"0\" | \"f\" | \"F\" | \"false\" | \"FALSE\" | \"False\" => false
          #|    _ => syntax_err()
          #|  } }
        ),
      ),
      "mantissa_explicit_bits": (None, Int(52)),
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
          #|fn is_fast_path(self : Number) -> Bool { min_exponent_fast_path <= self.exponent &&
          #|  self.exponent <= max_exponent_disguised_fast_path &&
          #|  self.mantissa <= max_mantissa_fast_path &&
          #|  !self.many_digits }
        ),
      ),
      "pow10_fast_path": build(
        (
          #|fn pow10_fast_path(exponent : Int) -> Double { table[exponent & 31] }
        ),
      ),
      "try_fast_path": build(
        (
          #|fn try_fast_path(self : Number) -> Double? { if self.is_fast_path() {
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
          #|  } }
        ),
      ),
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
      "range_err_str": (None, String("value out of range")),
      "syntax_err_str": (None, String("invalid syntax")),
      "base_err_str": (None, String("invalid base")),
      "range_err": build(
        (
          #|fn[T] range_err() -> T raise StrConvError { raise StrConvError(range_err_str) }
        ),
      ),
      "syntax_err": build(
        (
          #|fn[T] syntax_err() -> T raise StrConvError { raise StrConvError(syntax_err_str) }
        ),
      ),
      "base_err": build(
        (
          #|fn[T] base_err() -> T raise StrConvError { raise StrConvError(base_err_str) }
        ),
      ),
      "max_shift": (None, Int(59)),
      "powtab": (None, String("[")),
      "new_priv": build(
        (
          #|fn Decimal::new_priv() -> Decimal { {
          #|    digits: FixedArray::make(800, Byte::default()),
          #|    digits_num: 0,
          #|    decimal_point: 0,
          #|    negative: false,
          #|    truncated: false,
          #|  } }
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
          #|fn to_double_priv(self : Decimal) -> Double raise StrConvError { let mut exponent = 0
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
          #|  bits.reinterpret_as_double() }
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
          #|fn rounded_integer(self : Decimal) -> Int64 { if self.decimal_point > 20 {
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
          #|  n }
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
      "left_shift_cheats": (None, String("[")),
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
          #|fn trim(self : Decimal) -> Unit { while self.digits_num > 0 && self.digits[self.digits_num - 1] == 0 {
          #|    self.digits_num -= 1
          #|  }
          #|  if self.digits_num == 0 {
          #|    self.decimal_point = 0
          #|  } }
        ),
      ),
      "to_string": build(
        (
          #|fn Decimal::to_string(self : Decimal) -> String { Show::to_string(self) }
        ),
      ),
      "new": build(
        (
          #|pub fn Decimal::new() -> Decimal { Decimal::new_priv() }
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
          #|pub fn to_double(self : Decimal) -> Double raise StrConvError { self.to_double_priv() }
        ),
      ),
      "shift": build(
        (
          #|pub fn shift(self : Decimal, s : Int) -> Unit { self.shift_priv(s) }
        ),
      ),
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
    }
  },
)

///|
let moonbitlang_core_string_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/string",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/char": moonbitlang_core_char_module,
  },
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
          #|pub fn View::to_array(self : View) -> Array[Char] { self
          #|  .iter()
          #|  .fold(init=Array::new(capacity=self.length()), (rv, c) => {
          #|    rv.push(c)
          #|    rv
          #|  }) }
        ),
      ),
      "to_bytes": build(
        (
          #|pub fn View::to_bytes(self : View) -> Bytes { let array = FixedArray::make(self.length() * 2, Byte::default())
          #|  array.blit_from_string(0, self.data(), self.start_offset(), self.length())
          #|  array |> unsafe_to_bytes }
        ),
      ),
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
          #|pub fn View::trim_space(self : View) -> View { self.trim(\" \\n\\r\\t\") }
        ),
      ),
      "trim_space": build(
        (
          #|pub fn trim_space(self : String) -> View { self[:].trim_space() }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn View::is_empty(self : View) -> Bool { self.length() == 0 }
        ),
      ),
      "is_empty": build(
        (
          #|pub fn is_empty(self : String) -> Bool { self == \"\" }
        ),
      ),
      "is_blank": build(
        (
          #|pub fn View::is_blank(self : View) -> Bool { self.trim_space().is_empty() }
        ),
      ),
      "is_blank": build(
        (
          #|pub fn is_blank(self : String) -> Bool { self[:].is_blank() }
        ),
      ),
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
      "rev": build(
        (
          #|pub fn View::rev(self : View) -> String { let buf = StringBuilder::new(size_hint=self.length())
          #|  for c in self.rev_iter() {
          #|    buf.write_char(c)
          #|  }
          #|  buf.to_string() }
        ),
      ),
      "rev": build(
        (
          #|pub fn rev(self : String) -> String { self[:].rev() }
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
          #|pub fn View::to_lower(self : View) -> View { // TODO: deal with non-ascii characters
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
          #|  buf.to_string() }
        ),
      ),
      "to_lower": build(
        (
          #|pub fn to_lower(self : String) -> String { // TODO: deal with non-ascii characters
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
          #|  buf.to_string() }
        ),
      ),
      "to_upper": build(
        (
          #|pub fn View::to_upper(self : View) -> View { // TODO: deal with non-ascii characters
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
          #|  buf.to_string() }
        ),
      ),
      "to_upper": build(
        (
          #|pub fn to_upper(self : String) -> String { // TODO: deal with non-ascii characters
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
          #|  buf.to_string() }
        ),
      ),
      "fold": build(
        (
          #|pub fn[A] View::fold(self : View, init~ : A, f : (A, Char) -> A) -> A { let mut rv = init
          #|  for c in self {
          #|    rv = f(rv, c)
          #|  }
          #|  rv }
        ),
      ),
      "fold": build(
        (
          #|pub fn[A] fold(self : String, init~ : A, f : (A, Char) -> A) -> A { self[:].fold(init~, f) }
        ),
      ),
      "rev_fold": build(
        (
          #|pub fn[A] View::rev_fold(self : View, init~ : A, f : (A, Char) -> A) -> A { let mut rv = init
          #|  for c in self.rev_iter() {
          #|    rv = f(rv, c)
          #|  }
          #|  rv }
        ),
      ),
      "rev_fold": build(
        (
          #|pub fn[A] rev_fold(self : String, init~ : A, f : (A, Char) -> A) -> A { self[:].rev_fold(init~, f) }
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
      "default": build(
        (
          #|pub fn default() -> String { \"\" }
        ),
      ),
      "to_bytes": build(
        (
          #|pub fn to_bytes(self : String) -> Bytes { let array = FixedArray::make(self.length() * 2, Byte::default())
          #|  array.blit_from_string(0, self, 0, self.length())
          #|  array |> unsafe_to_bytes }
        ),
      ),
      "to_array": build(
        (
          #|pub fn to_array(self : String) -> Array[Char] { self
          #|  .iter()
          #|  .fold(init=Array::new(capacity=self.length()), (rv, c) => {
          #|    rv.push(c)
          #|    rv
          #|  }) }
        ),
      ),
      "iter": build(
        (
          #|pub fn iter(self : String) -> Iter[Char] { Iter::new(yield_ => {
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
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn iter2(self : String) -> Iter2[Int, Char] { Iter2::new(yield_ => {
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
          #|  }) }
        ),
      ),
      "rev_iter": build(
        (
          #|pub fn rev_iter(self : String) -> Iter[Char] { Iter::new(yield_ => {
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
          #|  }) }
        ),
      ),
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
          #|pub fn data(self : View) -> String { self.str() }
        ),
      ),
      "start_offset": build(
        (
          #|pub fn start_offset(self : View) -> Int { self.start() }
        ),
      ),
      "length": build(
        (
          #|pub fn length(self : View) -> Int { self.end() - self.start() }
        ),
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
          #|pub fn View::char_length(self : View) -> Int { self.str().char_length(start_offset=self.start(), end_offset=self.end()) }
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
      "iter": build(
        (
          #|pub fn View::iter(self : View) -> Iter[Char] { Iter::new(yield_ => for index in self.start()..<self.end() {
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
          #|  }) }
        ),
      ),
      "iter2": build(
        (
          #|pub fn View::iter2(self : View) -> Iter2[Int, Char] { Iter2::new(yield_ => {
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
          #|  }) }
        ),
      ),
      "rev_iter": build(
        (
          #|pub fn View::rev_iter(self : View) -> Iter[Char] { Iter::new(yield_ => for index = self.end() - 1
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
          #|  }) }
        ),
      ),
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
    }
  },
)

///|
let moonbitlang_core_test_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/test",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/bench": moonbitlang_core_bench_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
  },
  fn(_env, build) {
    {
      "eq": build(
        (
          #|pub fn[T : Show + Eq] eq(a : T, b : T, loc~ : SourceLoc) -> Unit raise { if a != b {
          #|    let a = debug_string(a)
          #|    let b = debug_string(b)
          #|    fail(\"`\\{a} == \\{b}`\", loc~)
          #|  } }
        ),
      ),
      "ne": build(
        (
          #|pub fn[T : Show + Eq] ne(a : T, b : T, loc~ : SourceLoc) -> Unit raise { if !(a != b) {
          #|    let a = debug_string(a)
          #|    let b = debug_string(b)
          #|    fail(\"`\\{a} != \\{b}`\", loc~)
          #|  } }
        ),
      ),
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
      "new": build(
        (
          #|pub fn new(name : String) -> T { { name, buffer: StringBuilder::new() } }
        ),
      ),
      "debug_string": build(
        (
          #|fn[T : Show] debug_string(t : T) -> String { let buf = StringBuilder::new(size_hint=50)
          #|  t.output(buf)
          #|  buf.to_string() }
        ),
      ),
      "same_object": build(
        (
          #|pub fn[T : Show] same_object(a : T, b : T, loc~ : SourceLoc) -> Unit raise { if !physical_equal(a, b) {
          #|    let a = debug_string(a)
          #|    let b = debug_string(b)
          #|    fail(\"`\\{a} is \\{b}`\", loc~)
          #|  } }
        ),
      ),
      "is_not": build(
        (
          #|pub fn[T : Show] is_not(a : T, b : T, loc~ : SourceLoc) -> Unit raise { if physical_equal(a, b) {
          #|    let a = debug_string(a)
          #|    let b = debug_string(b)
          #|    fail(\"`!(\\{a} is \\{b})`\", loc~)
          #|  } }
        ),
      ),
      "fail": build(
        (
          #|pub fn[T] fail(msg : String, loc~ : SourceLoc) -> T raise { @builtin.fail(msg, loc~) }
        ),
      ),
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
    }
  },
)

///|
let moonbitlang_core_tuple_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/tuple",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/quickcheck": moonbitlang_core_quickcheck_module,
    "moonbitlang/core/quickcheck/splitmix": moonbitlang_core_quickcheck_splitmix_module,
  },
  fn(_env, build) {
    {
      "pair": build(
        (
          #|pub fn[T, U] pair(x : T, y : U) -> (T, U) { (x, y) }
        ),
      ),
      "fst": build(
        (
          #|pub fn[T, U] fst(tuple : (T, U)) -> T { tuple.0 }
        ),
      ),
      "snd": build(
        (
          #|pub fn[T, U] snd(tuple : (T, U)) -> U { tuple.1 }
        ),
      ),
      "map_fst": build(
        (
          #|pub fn[T, U, V] map_fst(f : (T) -> U, tuple : (T, V)) -> (U, V) { (f(tuple.0), tuple.1) }
        ),
      ),
      "map_snd": build(
        (
          #|pub fn[T, U, V] map_snd(f : (T) -> U, tuple : (V, T)) -> (V, U) { (tuple.0, f(tuple.1)) }
        ),
      ),
      "swap": build(
        (
          #|pub fn[T, U] swap(tuple : (T, U)) -> (U, T) { (tuple.1, tuple.0) }
        ),
      ),
      "curry": build(
        (
          #|pub fn[T, U, V] curry(f : (T, U) -> V) -> (T) -> (U) -> V { (x : T) => (y : U) => f(x, y) }
        ),
      ),
      "uncurry": build(
        (
          #|pub fn[T, U, V] uncurry(f : (T) -> (U) -> V) -> (T, U) -> V { (x : T, y : U) => f(x)(y) }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_uint_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/uint",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "to_int64": build(
        (
          #|pub fn to_int64(self : UInt) -> Int64 { self.to_uint64().reinterpret_as_int64() }
        ),
      ),
      "default": build(
        (
          #|pub fn default() -> UInt { 0 }
        ),
      ),
      "to_be_bytes": build(
        (
          #|pub fn to_be_bytes(self : UInt) -> Bytes { [
          #|    (self >> 24).to_byte(),
          #|    (self >> 16).to_byte(),
          #|    (self >> 8).to_byte(),
          #|    self.to_byte(),
          #|  ] }
        ),
      ),
      "to_le_bytes": build(
        (
          #|pub fn to_le_bytes(self : UInt) -> Bytes { [
          #|    self.to_byte(),
          #|    (self >> 8).to_byte(),
          #|    (self >> 16).to_byte(),
          #|    (self >> 24).to_byte(),
          #|  ] }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_uint16_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/uint16",
  deps={
    "moonbitlang/core/builtin": moonbitlang_core_builtin_module,
    "moonbitlang/core/json": moonbitlang_core_json_module,
  },
  fn(_env, build) {
    {
      "to_uint": build(
        (
          #|pub fn UInt16::to_uint(self : UInt16) -> UInt { self.to_int().reinterpret_as_uint() }
        ),
      ),
      "to_uint64": build(
        (
          #|pub fn UInt16::to_uint64(self : UInt16) -> UInt64 { self.to_int().to_uint64() }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_uint64_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/uint64",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "to_be_bytes": build(
        (
          #|pub fn to_be_bytes(self : UInt64) -> Bytes { [
          #|    (self >> 56).to_byte(),
          #|    (self >> 48).to_byte(),
          #|    (self >> 40).to_byte(),
          #|    (self >> 32).to_byte(),
          #|    (self >> 24).to_byte(),
          #|    (self >> 16).to_byte(),
          #|    (self >> 8).to_byte(),
          #|    self.to_byte(),
          #|  ] }
        ),
      ),
      "to_le_bytes": build(
        (
          #|pub fn to_le_bytes(self : UInt64) -> Bytes { [
          #|    self.to_byte(),
          #|    (self >> 8).to_byte(),
          #|    (self >> 16).to_byte(),
          #|    (self >> 24).to_byte(),
          #|    (self >> 32).to_byte(),
          #|    (self >> 40).to_byte(),
          #|    (self >> 48).to_byte(),
          #|    (self >> 56).to_byte(),
          #|  ] }
        ),
      ),
    }
  },
)

///|
let moonbitlang_core_unit_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/unit",
  deps={ "moonbitlang/core/builtin": moonbitlang_core_builtin_module },
  fn(_env, build) {
    {
      "to_string": build(
        (
          #|pub fn to_string(self : Unit) -> String { let _ = self
          #|  \"()\" }
        ),
      ),
      "default": build(
        (
          #|pub fn default() -> Unit { () }
        ),
      ),
    }
  },
)
