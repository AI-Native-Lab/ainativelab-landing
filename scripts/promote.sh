#!/usr/bin/env bash
set -euo pipefail

# Promote the approved STAGING page to LIVE — local file copy only.
# Netlify deploys on push, so after promoting: commit + push to publish to ainativelab.org.
# Each environment keeps its own netlify.toml (root = production, staging/ = staging), so
# those are never copied across.
#
# Usage:
#   bash scripts/promote.sh            # promote for real
#   bash scripts/promote.sh --dry-run  # preview what would change

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
STAGING="$REPO_ROOT/staging"
LIVE="$REPO_ROOT/live"

if [[ ! -d "$STAGING" ]]; then
  echo "Missing staging directory: $STAGING" >&2
  exit 1
fi

DRY=""
if [[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]]; then DRY="--dry-run"; fi

echo "Promoting staging -> live ${DRY:+(dry run)}"
echo "  staging: $STAGING"
echo "  live:    $LIVE"

# Copy page content; never carry netlify.toml across environments.
rsync -a --delete $DRY --exclude '._*' --exclude 'netlify.toml' "$STAGING/" "$LIVE/"

if [[ -n "$DRY" ]]; then
  echo "Dry run only — nothing changed."
else
  echo "Done. Review live/, then publish:  git add -A && git commit -m 'promote staging -> live' && git push"
fi
