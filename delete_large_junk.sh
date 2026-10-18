#!/bin/bash
# Delete large old junk files from a report produced by find_large_junk.sh.
# Usage:
#   ./delete_large_junk.sh --from report.txt [--confirm]
#   ./delete_large_junk.sh --scan [--older-than DAYS] [--min-size SIZE] [--confirm]
#
# Without --confirm, prints what would be deleted and exits.
# With --confirm, prompts once and then deletes (use --yes to skip prompt).
# Use --only-under DIR to delete only paths under that directory (e.g. Downloads).

set -e
FROM=""
CONFIRM=""
SCAN=""
DAYS=90
MIN_SIZE="50M"
YES=""
ONLY_UNDER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --from)     FROM="$2"; shift 2 ;;
    --confirm) CONFIRM=1; shift ;;
    --yes)      YES=1; shift ;;
    --only-under) ONLY_UNDER="$2"; shift 2 ;;
    --scan)     SCAN=1; shift ;;
    --older-than) DAYS="$2"; shift 2 ;;
    --min-size)   MIN_SIZE="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [[ -n "$SCAN" ]]; then
  TMP_REPORT=$(mktemp)
  trap 'rm -f "$TMP_REPORT"' EXIT
  "$(dirname "$0")/find_large_junk.sh" --older-than "$DAYS" --min-size "$MIN_SIZE" --output "$TMP_REPORT" >/dev/null
  FROM="$TMP_REPORT"
fi

if [[ -z "$FROM" || ! -f "$FROM" ]]; then
  echo "Usage: $0 --from report.txt [--confirm]"
  echo "   or: $0 --scan [--older-than 90] [--min-size 50M] [--confirm]"
  echo "Use find_large_junk.sh --output report.txt first to generate a report to review."
  exit 1
fi

# Extract paths: lines that look like "NUMBER\tPATH" (tab-separated)
paths=()
while IFS= read -r line; do
  if [[ "$line" =~ ^[0-9]+[[:space:]]+ ]]; then
    path="${line#*$'\t'}"
    if [[ -n "$path" ]]; then
      if [[ -z "$ONLY_UNDER" ]] || [[ "$path" == "$ONLY_UNDER"/* ]]; then
        paths+=( "$path" )
      fi
    fi
  fi
done < <(grep -E '^[0-9]+[[:space:]]+' "$FROM" || true)

count=${#paths[@]}
if [[ $count -eq 0 ]]; then
  echo "No files to delete in report."
  exit 0
fi

echo "Files that would be deleted: $count"
echo "Preview (first 10):"
for i in "${paths[@]:0:10}"; do
  echo "  $i"
done
[[ $count -gt 10 ]] && echo "  ... and $((count - 10)) more."

if [[ -z "$CONFIRM" ]]; then
  echo ""
  echo "Run with --confirm to actually delete: $0 --from $FROM --confirm"
  exit 0
fi

if [[ -z "$YES" ]]; then
  echo ""
  read -p "Delete these $count files? (y/N) " -n 1 -r
  echo
  if [[ ! "$REPLY" =~ ^[yY]$ ]]; then
    echo "Aborted."
    exit 0
  fi
fi

deleted=0
for p in "${paths[@]}"; do
  if [[ -f "$p" ]]; then
    rm -f "$p" && ((deleted+=1)) || echo "Failed: $p"
  fi
done
echo "Deleted $deleted files."
