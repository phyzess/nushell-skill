# Nushell Cookbook

Load this reference when writing non-trivial Nu commands, translating shell snippets, or debugging Nu-specific errors.

## Mental model

- Nu pipelines pass structured values, not just text.
- `open` parses known file types. Use `open --raw` for byte/text fidelity.
- Environment variables live under `$env`, for example `$env.PATH` and `$env.HOME`.
- Optional access uses `?`, for example `$env.GITHUB_TOKEN?`.
- External commands are fine in pipelines, but their stdout is usually text. Use `lines`, `from json`, or `parse` before structured operations.

## Bash to Nu translations

| Bash/zsh habit | Nushell equivalent |
| --- | --- |
| `$HOME` | `$env.HOME` |
| `$VAR` | `$env.VAR` for env vars, `$var` for Nu variables |
| `export FOO=bar` | `$env.FOO = "bar"` |
| `FOO=bar cmd` | `with-env { FOO: "bar" } { cmd }` |
| `cmd1 && cmd2` | Run sequential statements, or use `if $env.LAST_EXIT_CODE == 0 { cmd2 }` for external status |
| `cmd1 \|\| cmd2` | `try { cmd1 } catch { cmd2 }` for Nu errors; inspect `$env.LAST_EXIT_CODE` for external status |
| `$(cmd)` | `(cmd)` |
| `grep pattern` | `where`, `find`, or `str contains`; use `rg` for file search |
| `cat file` | `open --raw file` for text, `open file` for structured formats |
| `jq '.scripts' package.json` | `open package.json | get scripts` |
| `wc -l` | `lines | length` |
| `head -n 20` | `first 20` |
| `tail -n 20` | `last 20` |

## Files and search

```nu
# List files as a table
ls

# List only regular files
ls | where type == file

# Recursive names from an external tool
rg --files | lines

# Search file contents and keep output as lines
rg "TODO|FIXME" . | lines

# Read first lines from a text file
open --raw src/main.ts | lines | first 80 | str join (char nl)
```

## Structured data

```nu
# JSON
open package.json | get -o dependencies | default {}

# TOML
open pyproject.toml | get tool

# CSV
open data.csv | where status == "active" | select id name status

# Convert text output from external command to JSON
git status --porcelain | lines | each { |line| { status: ($line | str substring 0..1), path: ($line | str substring 3..) } } | to json
```

## Environment and secrets

```nu
# Check presence without printing the value
$env.OPENAI_API_KEY? | is-not-empty

# Check several required variables
["OPENAI_API_KEY", "ANTHROPIC_API_KEY"]
| each { |name| { name: $name, present: (($env | get -o $name) | is-not-empty) } }

# Temporarily set env for a command
with-env { NODE_ENV: "test" } { npm test }
```

Do not output raw secret values. If a command would print secrets, redact or change the command.

## Conditions and status

```nu
# File exists
if ("package.json" | path exists) { open package.json | get scripts | to json }

# Directory exists
if ("node_modules" | path exists) { print "installed" } else { print "missing" }

# External command status
git diff --quiet
if $env.LAST_EXIT_CODE == 0 { print "clean" } else { print "changed" }

# Nu error handling
try {
  open missing.json
} catch {
  {}
}
```

## Quoting

When the host tool invokes a command through another shell, prefer single quotes around the whole Nu program:

```bash
nu -lc 'open package.json | get scripts | to json'
```

Inside that Nu program, use double quotes for strings:

```bash
nu -lc 'ls | where name =~ "src|test"'
```

If the Nu program itself needs single quotes, avoid nested quoting by using double quotes inside Nu, a here-doc through the host shell, or a temporary `.nu` script.

## External command boundaries

External commands do not always produce structured Nu values. Convert deliberately:

```nu
# Call an external command whose name conflicts with a Nu builtin
^find . -maxdepth 2 -type f | lines | sort

# Text lines
rg --files | lines | where $it ends-with ".ts"

# JSON emitted by a CLI
some-cli --json | from json | get items

# Preserve raw output
git diff -- README.md | complete
```

Use `complete` when you need stdout, stderr, and exit code together:

```nu
let result = (git status --porcelain | complete)
{ code: $result.exit_code, stdout: $result.stdout, stderr: $result.stderr }
```
