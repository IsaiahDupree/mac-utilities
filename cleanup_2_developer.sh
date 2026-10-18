#!/bin/bash
# (2) Developer: Delete old Xcode/CoreSimulator data, keep latest.
# - DerivedData: remove build caches older than 7 days (keeps recent builds).
# - Archives: remove archives older than 30 days (keeps latest).
# - CoreSimulator: remove device data for runtimes older than 90 days (keeps recent).
# Usage: ./cleanup_2_developer.sh [--dry-run]

set -e
DRY_RUN=""
[[ "$1" == "--dry-run" ]] && { DRY_RUN=1; shift; }

echo "=== 2. Developer: delete old, keep latest ==="

# DerivedData: delete project caches older than 7 days
DD="$HOME/Library/Developer/Xcode/DerivedData"
if [[ -d "$DD" ]]; then
  count=0
  while IFS= read -r -d '' d; do
    if [[ -n "$DRY_RUN" ]]; then echo "Would remove: $d"; ((count+=1)); else rm -rf "$d" && ((count+=1)); fi
  done < <(find "$DD" -mindepth 1 -maxdepth 1 -type d -mtime +7 -print0 2>/dev/null || true)
  echo "DerivedData: $count dirs $([[ -n "$DRY_RUN" ]] && echo 'would be ' )removed."
fi

# Archives: delete archives older than 30 days
ARCHIVES="$HOME/Library/Developer/Xcode/Archives"
if [[ -d "$ARCHIVES" ]]; then
  count=0
  while IFS= read -r -d '' d; do
    if [[ -n "$DRY_RUN" ]]; then echo "Would remove: $d"; ((count+=1)); else rm -rf "$d" && ((count+=1)); fi
  done < <(find "$ARCHIVES" -mindepth 1 -maxdepth 1 -type d -mtime +30 -print0 2>/dev/null || true)
  echo "Archives: $count dirs $([[ -n "$DRY_RUN" ]] && echo 'would be ' )removed."
fi

# CoreSimulator: delete device data not modified in 90 days (keeps recent)
CS="$HOME/Library/Developer/CoreSimulator/Devices"
if [[ -d "$CS" ]]; then
  count=0
  while IFS= read -r -d '' d; do
    if [[ -n "$DRY_RUN" ]]; then echo "Would remove: $d"; ((count+=1)); else rm -rf "$d" && ((count+=1)); fi
  done < <(find "$CS" -mindepth 1 -maxdepth 1 -type d -mtime +90 -print0 2>/dev/null || true)
  echo "CoreSimulator devices: $count dirs $([[ -n "$DRY_RUN" ]] && echo 'would be ' )removed."
fi

echo "Done."
