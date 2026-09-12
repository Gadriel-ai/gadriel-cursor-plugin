<!-- >>> gadriel-code-security >>> -->
## Gadriel code security (config v1)

This project uses Gadriel for code security via an MCP server named `gadriel`, which exposes these tools: validate_buffer, validate_file, findings_for_path, fix_finding, dismiss_false_positive.

Rules for the agent:
- Before writing or editing any source file, scan the proposed change with `validate_buffer`; do not introduce CRITICAL or HIGH findings.
- After editing, call `findings_for_path` to confirm the finding is resolved.
- To remediate, call `fix_finding` with the finding id. Never call `dismiss_false_positive` without explicit user confirmation.
- The full audit trail is written to `.security/` (OCSF findings, SBOMs, compliance).

<!-- <<< gadriel-code-security <<< -->
