#!/usr/bin/env bash
# smoke.sh — Verify pal-council CLI headless calls work
# Run: bash tests/smoke.sh
# Each test sends a trivial prompt and checks for parseable output.
# Requires: at least one CLI installed and authenticated.

set -euo pipefail

PASS=0
FAIL=0
SKIP=0

green() { printf "\033[32m%s\033[0m\n" "$1"; }
red()   { printf "\033[31m%s\033[0m\n" "$1"; }
yellow(){ printf "\033[33m%s\033[0m\n" "$1"; }

test_cli() {
  local name="$1" cmd="$2" check="$3"

  if ! command -v "$(echo "$cmd" | awk '{print $1}')" &>/dev/null; then
    yellow "SKIP: $name — not installed"
    ((SKIP++))
    return
  fi

  printf "TEST: %-12s ... " "$name"

  local output
  if output=$(timeout 120 bash -c "$cmd" 2>&1); then
    if echo "$output" | grep -q "$check"; then
      green "PASS"
      ((PASS++))
    else
      red "FAIL — output did not contain expected pattern: $check"
      echo "  Output (first 200 chars): ${output:0:200}"
      ((FAIL++))
    fi
  else
    local exit_code=$?
    if [ $exit_code -eq 124 ]; then
      red "FAIL — timed out after 120s"
    else
      red "FAIL — exit code $exit_code"
      echo "  Output (first 200 chars): ${output:0:200}"
    fi
    ((FAIL++))
  fi
}

echo "=== pal-council Smoke Tests ==="
echo ""

# Claude Code: expects JSON with "result" field
test_cli "Claude Code" \
  'claude -p "Reply with exactly: OK" --permission-mode plan --output-format json --max-turns 1' \
  '"result"'

# Codex CLI: expects JSONL with "item.completed" or agent_message
test_cli "Codex CLI" \
  'codex exec -s read-only --json --ephemeral "Reply with exactly: OK"' \
  '"type"'

# Gemini CLI: expects JSON with "response" field
test_cli "Gemini CLI" \
  'gemini -p "Reply with exactly: OK" --output-format json' \
  '"response"'

# Oz CLI: expects NDJSON with type "agent"
test_cli "Oz CLI" \
  'oz agent run -p "Reply with exactly: OK" --output-format json' \
  '"type":"agent"'

echo ""
echo "=== Results ==="
echo "Pass: $PASS  Fail: $FAIL  Skip: $SKIP"
echo ""

if [ $FAIL -gt 0 ]; then
  echo "Some tests failed. Check CLI installation and authentication."
  exit 1
elif [ $PASS -eq 0 ]; then
  echo "No CLIs available to test. Install at least one."
  exit 1
else
  echo "All available CLIs passed."
  exit 0
fi
