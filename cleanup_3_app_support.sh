#!/bin/bash
# (3) Application Support: Be careful. Only remove obvious cache/temp subdirs
#     that are safe to delete (e.g. "Cache", "cache", "tmp", "temp" inside apps),
#     and only items older than 60 days.
# Usage: ./cleanup_3_app_support.sh [--dry-run] [--days 60]

set -e
DRY_RUN=""
DAYS=60
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --days)    DAYS="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echo "=== 3. Application Support: careful cleanup (cache/temp only, older than ${DAYS} days) ==="

BASE="$HOME/Library/Application Support"
# Only touch these known cache/temp subdir names (no main app data)
SAFE_NAMES=("Cache" "cache" "Caches" "CachedData" "tmp" "temp" "Temp" "Logs" "logs")

for name in "${SAFE_NAMES[@]}"; do
  while IFS= read -r -d '' d; do
    # Only delete if older than DAYS
    if [[ -d "$d" ]]; then
      if [[ -z "$DRY_RUN" ]]; then
        rm -rf "$d" 2>/dev/null && echo "Removed: $d" || true
      else
        echo "Would remove: $d"
      fi
    fi
  done < <(find "$BASE" -maxdepth 2 -type d -name "$name" -mtime +"$DAYS" -print0 2>/dev/null || true)
done

echo "Done. (No main app data touched.)"
