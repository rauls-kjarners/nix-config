#!/usr/bin/env bash
set -euo pipefail

cmd=$(jq -r '.tool_input.command // empty')

if [[ "$cmd" == *"git commit"* || "$cmd" == *"git push"* ]]; then
  jq -n --arg cmd "$cmd" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: ("Git Rule — Allow: " + $cmd + "?")
    }
  }'
fi
