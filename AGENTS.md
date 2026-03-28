# Repository Guidelines

## Project Structure & Module Organization
This repository is a MoonBit package centered on an interpreter:
- `interpreter/`: core evaluator, parser integration, runtime values, builtin operations, and module loading.
- Root `.mbt` files (`vm.mbt`, `alias.mbt`, `export.mbt`): package-facing API and exports.
- `test/`: executable test suite files (`*.mbt`) plus `test/moon.pkg`.
- `example/`: minimal usage example package.
- `.github/workflows/check.yaml`: CI source of truth for checks, formatting, and tests.

Keep new interpreter logic in `interpreter/` and add matching tests in `test/`.

## Build, Test, and Development Commands
Use MoonBit CLI commands from repo root:
- `moon update && moon install`: sync and install dependencies.
- `moon check --deny-warn --target js`: typecheck with warnings treated as errors (CI default).
- `moon test --target js`: run package and `test/` suite.
- `moon fmt`: format code; run before opening a PR.
- `moon info --target js`: refresh package metadata; CI expects no uncommitted diffs afterward.

Typical local validation flow:
`moon fmt && moon check --deny-warn --target js && moon test --target js`

## Coding Style & Naming Conventions
- Follow `moon fmt` output; do not hand-format around it.
- Use 2-space indentation and keep lines readable.
- File/module names use `snake_case` (for example `pattern_matching.mbt`).
- Types/constructors use `UpperCamelCase`; functions/values use `snake_case`.
- Prefer small, focused modules and explicit imports in `moon.pkg`.

## Testing Guidelines
- Add or update tests in `test/*.mbt` for each behavior change.
- Name test files by feature area (for example `control_flow.mbt`, `pattern_matching.mbt`).
- Cover both success and failure/error-path behavior for parser/interpreter changes.
- Run `moon test --target js` locally before pushing.

## Commit & Pull Request Guidelines
Recent history follows conventional-style prefixes:
- `feat(interpreter): ...`
- `refactor(parser): ...`
- `chore: ...`, `build: ...`, `upgrade: ...`

Use imperative subjects, optional scope, and keep commits focused. For PRs include:
- concise problem/solution summary,
- linked issue (if any),
- test evidence (commands run),
- notes on parser/runtime behavior changes.
