---
name: nushell
description: Helps agents run terminal commands correctly in Nushell-first environments and translate shell logic into Nushell's structured pipelines. Use when the user, workspace instructions, or environment indicates Nushell is preferred; when writing, reviewing, or debugging Nushell commands; or when converting bash/zsh/fish snippets to Nu. Do not use solely because a task involves the terminal.
metadata:
  short-description: Run commands the Nushell way
---

# Nushell

## Activation gate

Use this skill only when at least one signal confirms Nushell is relevant:

- The user says they use Nushell or asks for Nu syntax.
- Workspace instructions such as `AGENTS.md` say to use Nushell.
- The active shell is `nu`, or `$SHELL` points to Nu.
- A command, script, config, or error is clearly Nushell-specific.

If Nushell is not confirmed, do not force it. Use the user's stated shell or the project's existing conventions. `nu --version` only proves Nu is installed; it is not enough by itself to prove the user prefers Nushell. If detection is needed, check availability first with `command -v nu` from a POSIX-like host shell or `nu --version` when `nu` is already expected.

## Command execution policy

- For terminal commands that depend on shell parsing, environment variables, aliases, PATH, globbing, conditions, or pipelines, run through `nu -lc '...'`.
- Use Nushell syntax inside the quoted command. Do not write bash conditionals, `$VAR`, `export`, `&&`, `||`, or `$(...)` unless invoking a POSIX shell intentionally.
- Prefer structured pipelines over text scraping: use records, tables, `where`, `select`, `get`, `first`, `length`, `to json`, and `from json`.
- When reading plain text, use `open --raw path`; plain `open path` may parse Markdown, JSON, CSV, TOML, or YAML into structured data.
- `try`/`catch` handles Nushell errors, not every external command failure. For external commands, inspect `$env.LAST_EXIT_CODE` or use `complete` when stdout, stderr, and exit code all matter.
- For secrets, only test presence or emptiness. Never print secret values.
- If a task genuinely requires POSIX shell semantics, invoke the required shell explicitly and keep the exception narrow, for example `bash -lc '...'`.

## Quick patterns

```nu
# Run one command from a non-Nu host shell
nu -lc 'version | select version commit_hash | to json'

# Check an environment variable without revealing it
nu -lc '$env.OPENAI_API_KEY? | is-not-empty'

# Read text exactly as text
nu -lc 'open --raw README.md | lines | first 40 | str join (char nl)'

# Read structured JSON
nu -lc 'open package.json | get scripts | to json'

# Find files with ripgrep and continue in Nu
nu -lc 'rg --files | lines | where $it =~ "test|spec" | first 20'

# Fail softly when optional files are absent
nu -lc 'try { open package.json | get scripts } catch { {} } | to json'
```

## Workflow

1. Confirm Nushell relevance using the activation gate.
2. Decide whether the command needs shell semantics. If it is a direct executable call with no shell logic, run it normally if the tool supports argv-style execution; otherwise use `nu -lc`.
3. Write the command in native Nu syntax.
4. Prefer structured output for follow-up reasoning. End with `to json` when the result will be consumed programmatically.
5. If an error appears, diagnose it as a Nushell type, parsing, quoting, or external-command boundary issue before rewriting it as bash.

## Common agent mistakes

- Do not treat `open` as `cat`; use `open --raw` for text.
- Do not use `$VAR`, `export`, `&&`, `||`, or `$(...)` as if this were bash.
- Do not assume `try { external-command } catch { ... }` catches a non-zero exit status.
- Do not call builtins as external commands by accident. If a system command conflicts with a Nu builtin, prefix it with `^`, for example `^find`.
- Do not treat "Nu is installed" as "Nu is the preferred shell."

## When more detail is needed

- For common translations and examples, read [references/cookbook.md](references/cookbook.md).
- For Nu self-reporting after `nu` is already executable, run or inspect [scripts/nu_probe.nu](scripts/nu_probe.nu). This script is not a bootstrap detector for systems where `nu` might be absent.
