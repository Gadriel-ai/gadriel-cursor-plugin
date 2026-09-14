#!/bin/sh
# Cursor agent hook shim for Gadriel.
#
# Cursor hooks (Cursor 1.7+, .cursor/hooks.json) are processes that talk JSON
# over stdio and can observe/warn/block the agent. This shim runs Gadriel's
# guardrail on the file Cursor just edited and surfaces any finding back to the
# agent.
#
# Cursor hooks pass the event context to the hook as JSON on stdin, and the
# hook surfaces a message back via JSON on stdout. Per the Cursor hooks docs the
# field is snake_case `agent_message`. This shim fails SAFE — it emits the
# finding as `agent_message` and exits 0 (never blocks), so it can only add
# context, never wedge the agent. GADRIEL_GUARDRAIL=off disables it. The event
# name is also read from stdin by Cursor; the positional arg here is only this
# shim's own hint.
set -eu

phase=${1:-afterFileEdit}
payload=$(cat 2>/dev/null || true)

# Only act in a repo Gadriel already tracks (a `.security/` dir from a scan).
project=${PWD}
[ -d "$project/.security" ] || exit 0
[ "$phase" = afterFileEdit ] || exit 0

# Resolve gadriel: on PATH, else via npx (Cursor users generally have Node).
if command -v gadriel >/dev/null 2>&1; then
  run() { gadriel "$@"; }
elif command -v npx >/dev/null 2>&1; then
  run() { npx -y gadriel@1.4.0 "$@"; }
else
  exit 0
fi

export GADRIEL_GUARDRAIL=${GADRIEL_GUARDRAIL:-high}
export RUST_LOG=${RUST_LOG:-error}

set +e
reason=$(printf '%s' "$payload" | run hooks adapt --platform cursor --event post-tool-use 2>&1)
rc=$?
set -e
if [ "$rc" -eq 2 ]; then
  esc=$(printf '%s' "$reason" | tr '\t\r\n' '   ' | tr -d '\000-\037' | sed 's/\\/\\\\/g; s/"/\\"/g')
  printf '{"agent_message":"%s Fix this before continuing."}\n' "$esc"
fi
exit 0
