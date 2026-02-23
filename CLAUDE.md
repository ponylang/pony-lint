# pony-lint

A text-based linter for Pony source files.

## Package Structure

- `pony_lint/` -- main package (flat structure, no sub-packages)
- `test/` -- all tests, imports `pony_lint` via `use lint = "../pony_lint"`
- `examples/` -- example programs with intentional violations

## Key Concepts

- **Rules** are stateless `val` primitives implementing `TextRule`. Each receives a `SourceFile val` and returns an array of diagnostics.
- **Rule IDs** follow the `category/rule-name` pattern (e.g., `style/line-length`).
- **`lint/*` diagnostics** are operational errors (malformed suppressions, unreadable files). They cannot be suppressed and cause exit code 2.
- **Configuration precedence**: CLI `--disable` > `.pony-lint.json` rule entry > `.pony-lint.json` category entry > rule default.

## Build

```bash
make          # build and link
make test     # build and run all tests
make lint     # run pony-lint on its own source (pony_lint/ and test/)
make clean    # remove build artifacts and corral cache
```

## Adding a New Rule

1. Create `pony_lint/<rule_name>.pony` with a primitive implementing `TextRule`.
2. Register it in `pony_lint/main.pony` in the `all_rules` array.
3. Add tests in `test/<rule_name>_test.pony` and register them in `test/main.pony`.
