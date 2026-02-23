"""
A minimal Pony program with intentional style violations for demonstrating
pony-lint. Run `pony-lint examples/violator` to see the diagnostics.
"""

actor Main
  new create(env: Env) =>
    let x: U32 = 42 
	let url = "https://example.com"
    //this is a comment with no space
    let long_line: String = "This line is intentionally long enough to exceed the eighty-column limit that pony-lint enforces"
    env.out.print(url)
    env.out.print(x.string())
    env.out.print(long_line)
