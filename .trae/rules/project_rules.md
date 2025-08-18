使用 moon test 测试
moon test -h
Test the current package

Usage: moon test [OPTIONS] [SINGLE_FILE]

Options:
      --std                        Enable the standard library (default)
      --nostd                      Disable the standard library
  -g, --debug                      Emit debug information
      --release                    Compile in release mode
      --strip                      Enable stripping debug information
      --no-strip                   Disable stripping debug information
      --target <TARGET>            Select output target [possible values: wasm, wasm-gc, js, native, llvm, all]
      --enable-coverage            Enable coverage instrumentation
      --sort-input                 Sort input files
      --output-wat                 Output WAT instead of WASM
  -d, --deny-warn                  Treat all warnings as errors
      --no-render                  Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
      --warn-list <WARN_LIST>      Warn list config
      --alert-list <ALERT_LIST>    Alert list config
  -j, --jobs <JOBS>                Set the max number of jobs to run in parallel
      --render-no-loc <MIN_LEVEL>  Render no-location diagnostics starting from a certain level [default: error] [possible values: info, warn, error]
  -p, --package [<PACKAGE>...]     Run test in the specified package
  -f, --file <FILE>                Run test in the specified file. Only valid when `--package` is also specified
  -i, --index <INDEX>              Run only the index-th test in the file. Only valid when `--file` is also specified
      --doc-index <DOC_INDEX>      Run only the index-th doc test in the file. Only valid when `--file` is also specified
  -u, --update                     Update the test snapshot
  -l, --limit <LIMIT>              Limit of expect test update passes to run, in order to avoid infinite loops [default: 256]
  -h, --help                       Print help

Manifest Options:
      --frozen                   Do not sync dependencies, assuming local dependencies are up-to-date
      --build-only               Only build, do not run the tests
      --no-parallelize           Run the tests in a target backend sequentially
      --test-failure-json        Print failure message in JSON format
      --patch-file <PATCH_FILE>  Path to the patch file
      --doc                      Run doc test
  [SINGLE_FILE]              Run test in single file (.mbt or .mbt.md)

Common Options:
  -C, --directory <SOURCE_DIR>   The source code directory. Defaults to the current directory
      --target-dir <TARGET_DIR>  The target directory. Defaults to `source_dir/target`
  -q, --quiet                    Suppress output
  -v, --verbose                  Increase verbosity
      --trace                    Trace the execution of the program
      --dry-run                  Do not actually run the command
      --build-graph              Generate build graph

不要创建 temp 文件来测试，可以修改src/test.mbt文件在调用 moon test 来测试
测试结果如果不符合预期，diff 会输出差异，预期的在前面，实际的在后面
例如
Diff:
----
Cons(1, Cons(2, Nil)()
----

意思是
预期：
Cons(1, Cons(2, Nil))
实际：
()
