# Nushell Skill

An agent skill for Nushell-first terminal work.

This skill teaches agents to use Nushell deliberately instead of treating every terminal task as bash/zsh. It helps agents recognize when Nushell is actually relevant, run commands through `nu -lc` when shell semantics matter, use Nu's structured pipelines, and avoid common mistakes around `open`, `$env`, external command status, and quoting.

## What This Skill Does

- Uses Nushell only when the user, workspace, or command context indicates it is relevant.
- Translates common bash/zsh habits into native Nushell patterns.
- Encourages structured pipelines with records, tables, `where`, `select`, `get`, `from json`, and `to json`.
- Keeps secret handling safe by checking only presence or emptiness.
- Documents external command boundaries, including `complete`, `$env.LAST_EXIT_CODE`, and `^command` for builtin name conflicts.

## What This Skill Does Not Do

- It does not force Nushell just because Nu is installed.
- It does not replace POSIX shell when a task genuinely requires POSIX behavior.
- It does not bootstrap Nushell onto machines where `nu` is unavailable.

## Skill Layout

```text
nushell-skill/
├── SKILL.md                 # Required skill instructions and trigger policy
├── references/
│   └── cookbook.md          # Optional detailed Nushell examples
├── scripts/
│   └── nu_probe.nu          # Optional Nu self-report script
└── agents/
    └── openai.yaml          # Optional OpenAI/Codex UI metadata
```

The portable part of the skill is `SKILL.md` plus any referenced files. `agents/openai.yaml` is optional product-specific metadata and can be ignored by agents that do not use it.

## Installation

Clone or copy this repository into the skill directory used by your agent, keeping `SKILL.md` at the skill root.

For Codex-style skill directories:

```sh
git clone git@github.com:phyzess/nushell-skill.git ~/.codex/skills/nushell
```

Or with HTTPS:

```sh
git clone https://github.com/phyzess/nushell-skill.git ~/.codex/skills/nushell
```

For project-local use, place the folder wherever your agent discovers skills, then reference or enable the `nushell` skill according to that agent's configuration.

## Usage

The skill is designed for implicit use when Nushell is clearly relevant:

- The user says they use Nushell.
- Workspace instructions such as `AGENTS.md` require Nushell.
- The active shell is Nu.
- The task is about writing, debugging, or translating Nushell commands.

You can also invoke it explicitly:

```text
Use $nushell to translate this bash command into Nushell.
```

## Compatibility

This repository follows the common `SKILL.md` skill-folder shape: YAML frontmatter with `name` and `description`, followed by concise operational instructions. It should be portable to agents that support this style of skill. Agent-specific metadata is isolated under `agents/`.

## License

MIT
