# Gadriel — AI Security Harness for Cursor

Cursor writes code fast. Gadriel makes sure what it writes is safe.

This is the Cursor build of the [Gadriel](https://gadriel.ai) AI Security
Harness (siblings: [Claude Code](https://github.com/Gadriel-ai/gadriel-claude-plugin),
[Codex](https://github.com/Gadriel-ai/gadriel-codex-plugin)). It gives Cursor a
security MCP server, 17 rules, and a guardrail hook that re-scans files as the
agent edits them.

Gadriel covers SAST, secrets, dependencies (SCA/SBOM), containers and
configuration, including AI-specific risks such as prompt injection and the
OWASP LLM Top 10, with 3,000+ rules. Scanning runs on your machine.

## Install

**One-click (MCP server):** paste this into your browser (it opens Cursor and
asks you to approve the `gadriel` MCP server):

```
cursor://anysphere.cursor-deeplink/mcp/install?name=gadriel&config=eyJjb21tYW5kIjoibnB4IiwiYXJncyI6WyIteSIsImdhZHJpZWxAMS40LjAiLCJjb2RlIiwibWNwIl19
```

**Or per-project:** copy the `.cursor/` directory from this repo into your
project (`.cursor/mcp.json`, `.cursor/rules/`, `.cursor/hooks.json`,
`.cursor/gadriel-hook.sh`). Requires Node (for `npx`) — or install the CLI with
`npm install -g gadriel` and it will be used directly.

Then, in Cursor: **"Run a Gadriel security scan on this repo."**

## What you get

- **MCP server** `gadriel` (`.cursor/mcp.json`, run via `npx gadriel code mcp`):
  `validate_file`, `validate_buffer`, `findings_for_path`, `fix_finding`,
  `dismiss_false_positive`, and more.
- **17 rules** (`.cursor/rules/*.mdc`) that auto-attach by file type / topic:
  OWASP Web & LLM Top 10, AI secrets, AI config security, API patterns,
  Dockerfile best practices, SBOM, license compatibility, EU AI Act & NIST AI
  RMF mappers, and others.
- **Commands** (`.cursor/commands/`): `gadriel-scan`, `gadriel-fix`,
  `gadriel-status`, `gadriel-reports`, `gadriel-watch`.
- **Guardrail hook** (`.cursor/hooks.json` → `gadriel-hook.sh`): after the agent
  edits a file, Gadriel re-scans it and surfaces any High+ finding so the agent
  fixes it. Active only in a repo you have scanned (one with a `.security/`
  directory).

> The guardrail hook uses Cursor's `afterFileEdit` hook. Cursor's exact hook
> output schema was not verifiable outside a live Cursor, so the hook fails
> safe: it surfaces the finding as a message and never blocks. If your Cursor
> version expects a different shape, adjust `.cursor/gadriel-hook.sh`.

## Network and data

Code is scanned locally and not uploaded. On first run Gadriel registers an
anonymous device credential with `app.gadriel.ai` (a random device id — no
hostname/username/keys); set `GADRIEL_NO_ANONYMOUS_AUTH=1` to skip it. Rule and
vulnerability-database updates come from Gadriel servers and the public
[OSV](https://osv.dev) database. See the [privacy policy](https://gadriel.ai/privacy).

## License

This repository is [Apache-2.0](LICENSE). The `gadriel` scanner it runs is
proprietary, under the [Gadriel terms](https://gadriel.ai/terms).
