# Examples

Each subdirectory is a self-contained Pony program with intentional style
violations for demonstrating pony-lint.

## [violator](violator/)

A minimal Pony program that triggers all four Phase 1 rules: line length,
trailing whitespace, hard tabs, and comment spacing. Run
`build/release/pony-lint examples/violator` to see the diagnostics produced for
each violation. Start here if you're new to pony-lint.
