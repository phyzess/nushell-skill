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
├── README.md
├── LICENSE
└── skills/
    └── nushell/
        ├── SKILL.md                 # Required skill instructions and trigger policy
        ├── references/
        │   └── cookbook.md          # Optional detailed Nushell examples
        ├── scripts/
        │   └── nu_probe.nu          # Optional Nu self-report script
        └── agents/
            └── openai.yaml          # Optional OpenAI/Codex UI metadata
```

The portable skill is `skills/nushell/`. Its `SKILL.md` name matches the parent directory, which keeps it compatible with the Agent Skills specification and GitHub CLI skill discovery. `agents/openai.yaml` is optional product-specific metadata and can be ignored by agents that do not use it.

## Installation

### Codex Skill Installer

In Codex, ask the built-in `$skill-installer` to install the skill from this GitHub directory URL:

```text
$skill-installer install https://github.com/phyzess/nushell-skill/tree/main/skills/nushell
```

The installer copies the skill into Codex's user skill directory. Restart Codex if the skill does not appear immediately.

### GitHub CLI

If your GitHub CLI includes `gh skill`, this is the most convenient cross-agent install path.

```sh
gh skill install phyzess/nushell-skill nushell --agent codex --scope user
```

For Claude Code:

```sh
gh skill install phyzess/nushell-skill nushell --agent claude-code --scope user
```

Use `--scope project` instead of `--scope user` to install into the current repository.

### Skills CLI

The open `skills` CLI can install this skill across many compatible agents.

```sh
npx skills add phyzess/nushell-skill --skill nushell
```

Install globally for Codex:

```sh
npx skills add phyzess/nushell-skill --skill nushell --agent codex --global --yes
```

Install globally for Claude Code:

```sh
npx skills add phyzess/nushell-skill --skill nushell --agent claude-code --global --yes
```

List skills without installing:

```sh
npx skills add phyzess/nushell-skill --list
```

### Codex Manual Install

Codex discovers user skills under `~/.agents/skills/` and project skills under `.agents/skills/`.

```sh
git clone https://github.com/phyzess/nushell-skill.git /tmp/nushell-skill
mkdir -p ~/.agents/skills
cp -R /tmp/nushell-skill/skills/nushell ~/.agents/skills/nushell
```

For project-local use:

```sh
mkdir -p .agents/skills
cp -R /tmp/nushell-skill/skills/nushell .agents/skills/nushell
```

### Claude Code Manual Install

Claude Code discovers personal skills under `~/.claude/skills/` and project skills under `.claude/skills/`.

```sh
git clone https://github.com/phyzess/nushell-skill.git /tmp/nushell-skill
mkdir -p ~/.claude/skills
cp -R /tmp/nushell-skill/skills/nushell ~/.claude/skills/nushell
```

For project-local use:

```sh
mkdir -p .claude/skills
cp -R /tmp/nushell-skill/skills/nushell .claude/skills/nushell
```

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

The repository also includes `.codex-plugin/plugin.json`, which lets the same skill folder be packaged as a Codex plugin. Direct skill installation is still the simplest path for most users. Use a Codex plugin marketplace when you want Codex app/plugin-directory installation, workspace sharing, or a bundle that grows beyond one skill.

## License

MIT
