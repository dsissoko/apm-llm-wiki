#!/usr/bin/env bash
set -euo pipefail

WIKI_DIR="docs/wiki"
QMD_DIR=".qmd"
STATE_FILE="$QMD_DIR/wiki-sync.sha256"

hook_success() {
  printf '%s\n' '{"continue":true}'
  exit 0
}

# Nothing to synchronize until the wiki and the project-local QMD index exist.
[[ -d "$WIKI_DIR" ]] || hook_success
[[ -f "$QMD_DIR/index.yml" ]] || hook_success

# Fingerprint Markdown content and paths deterministically.
current_hash="$({
  find "$WIKI_DIR" -type f -name '*.md' -print0 \
    | sort -z \
    | xargs -0 -r sha256sum
} | sha256sum | awk '{print $1}')"

previous_hash=""
[[ -f "$STATE_FILE" ]] && previous_hash="$(cat "$STATE_FILE")"

# No wiki change: succeed without running QMD.
[[ "$current_hash" != "$previous_hash" ]] || hook_success

# QMD operations are incremental. Keep stdout reserved for the hook protocol
# and send command output and diagnostics to stderr.
npx -y @tobilu/qmd update >&2
npx -y @tobilu/qmd embed >&2

# Record the fingerprint only after both operations succeed.
printf '%s\n' "$current_hash" > "$STATE_FILE"

hook_success
