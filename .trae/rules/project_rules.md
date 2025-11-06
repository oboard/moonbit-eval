使用 moon test 测试，不要创建 temp 或者 debug 文件来测试，可以修改src/test.mbt文件在调用 moon test 来测试
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

# Project Agents.md Guide

This is a [MoonBit](https://docs.moonbitlang.com) project.

## Project Structure

- MoonBit packages are organized per directory, for each directory, there is a
  `package.json` file listing its dependencies. Each package has its files and
  blackbox test files (common, ending in `_test.mbt`) and whitebox test files
  (ending in `_wbtest.mbt`).

- In the toplevel directory, this is a `moon.mod.json` file listing about the
  module and some meta information.

## Coding convention

- MoonBit code is organized in block style, each block is separated by `///|`,
  the order of each block is irrelevant. In some refactorings, you can process
  block by block independently.

- Try to keep deprecated blocks in file called `deprecated.mbt` in each
  directory.

## Tooling

- `moon fmt` is used to format your code properly.

- `moon info` is used to update the generated interface of the package, each
  package has a generated interface file `.mbti`, it is a brief formal
  description of the package. If nothing in `.mbti` changes, this means your
  change does not bring the visible changes to the external package users, it is
  typically a safe refactoring.

- In the last step, run `moon info && moon fmt` to update the interface and
  format the code. Check the diffs of `.mbti` file to see if the changes are
  expected.

- Run `moon test` to check the test is passed. MoonBit supports snapshot
  testing, so when your changes indeed change the behavior of the code, you
  should run `moon test --update` to update the snapshot.

- You can run `moon check` to check the code is linted correctly.

- When writing tests, you are encouraged to use `inspect` and run
  `moon test --update` to update the snapshots, only use assertions like
  `assert_eq` when you are in some loops where each snapshot may vary. You can
  use `moon coverage analyze > uncovered.log` to see which parts of your code
  are not covered by tests.

- agent-todo.md has some small tasks that are easy for AI to pick up, agent is
  welcome to finish the tasks and check the box when you are done
