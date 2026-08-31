#!/usr/bin/env bash
set -euo pipefail

WIKI_DIR="docs/wiki"
QMD_DIR=".qmd"
STATE_FILE="$QMD_DIR/wiki-sync.sha256"

# Nothing to synchronize until the wiki and the project-local QMD index exist.
[[ -d "$WIKI_DIR" ]] || exit 0
[[ -f "$QMD_DIR/index.yml" ]] || exit 0

# Fingerprint Markdown content and paths deterministically.
current_hash="$({
  find "$WIKI_DIR" -type f -name '*.md' -print0 \
    | sort -z \
    | xargs -0 -r sha256sum
} | sha256sum | awk '{print $1}')"

previous_hash=""
[[ -f "$STATE_FILE" ]] && previous_hash="$(cat "$STATE_FILE")"

[[ "$current_hash" != "$previous_hash" ]] || exit 0

# QMD operations are incremental: update the changed corpus, then generate
# only missing embeddings. Keep stdout empty because Codex Stop hooks parse
# stdout as structured hook output; send QMD diagnostics to stderr instead.
npx -y @tobilu/qmd update >&2
npx -y @tobilu/qmd embed >&2

# Record the fingerprint only after both operations succeed.
printf '%s\n' "$current_hash" > "$STATE_FILE"
