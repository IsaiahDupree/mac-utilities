#!/bin/bash
# (4) Caches: Delete old cache files, keep latest (e.g. last 30 days).
# - Homebrew: brew cleanup (keeps current, removes old formulae/cache).
# - pnpm: pnpm store prune.
# - Per-cache dirs: remove files/dirs older than 30 days inside known cache dirs.
# Usage: ./cleanup_4_caches.sh [--dry-run] [--days 30]

set -e
DRY_RUN=""
DAYS=30
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --days)    DAYS="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echo "=== 4. Caches: delete old, keep latest (keep last ${DAYS} days) ==="

# Homebrew
if command -v brew &>/dev/null; then
  echo "Running brew cleanup..."
  [[ -z "$DRY_RUN" ]] && brew cleanup -s 2>/dev/null || echo "[dry-run] would run: brew cleanup -s"
fi

# pnpm
if command -v pnpm &>/dev/null; then
  echo "Running pnpm store prune..."
  [[ -z "$DRY_RUN" ]] && pnpm store prune 2>/dev/null || echo "[dry-run] would run: pnpm store prune"
fi

# Large cache dirs: delete contents older than DAYS
CACHE_BASES=(
  "$HOME/Library/Caches/ms-playwright"
  "$HOME/Library/Caches/Homebrew"
  "$HOME/Library/Caches/com.todesktop.230313mzl4w4u92.ShipIt"
  "$HOME/Library/Caches/Google"
  "$HOME/Library/Caches/com.openai.atlas"
  "$HOME/Library/Caches/com.exafunction.windsurf.ShipIt"
  "$HOME/Library/Caches/CocoaPods"
  "$HOME/Library/Caches/Cypress"
  "$HOME/Library/Caches/com.anthropic.claudefordesktop.ShipIt"
  "$HOME/Library/Caches/SiriTTS"
  "$HOME/Library/Caches/pnpm"
  "$HOME/Library/Caches/typescript"
  "$HOME/Library/Caches/electron"
  "$HOME/Library/Caches/node-gyp"
  "$HOME/Library/Caches/ms-playwright-go"
)

for base in "${CACHE_BASES[@]}"; do
  [[ ! -d "$base" ]] && continue
  echo "Cleaning $base (older than $DAYS days)..."
  while IFS= read -r -d '' f; do
    if [[ -z "$DRY_RUN" ]]; then
      rm -rf "$f" 2>/dev/null || true
    else
      echo "  Would remove: $f"
    fi
  done < <(find "$base" -mindepth 1 -maxdepth 3 -mtime +"$DAYS" -print0 2>/dev/null || true)
done

echo "Done."
