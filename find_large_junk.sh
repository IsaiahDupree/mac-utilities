#!/bin/bash
# Find large old files in junk-prone locations (report only, no deletion).
# Usage: ./find_large_junk.sh [--older-than DAYS] [--min-size SIZE] [--output FILE]

set -e
DAYS=90
MIN_SIZE="50M"
OUTPUT=""
JUNK_BASES=(
  "$HOME/Downloads"
  "$HOME/Library/Caches"
  "$HOME/Library/Logs"
  "$HOME/Library/Application Support"
  "${TMPDIR:-/tmp}"
  "$HOME/.Trash"
)

while [[ $# -gt 0 ]]; do
  case "$1" in
    --older-than)  DAYS="$2"; shift 2 ;;
    --min-size)    MIN_SIZE="$2"; shift 2 ;;
    --output)      OUTPUT="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

[[ -n "$OUTPUT" ]] && : > "$OUTPUT"
report() {
  if [[ -n "$OUTPUT" ]]; then
    tee -a "$OUTPUT"
  else
    cat
  fi
}

echo "Scanning for files older than ${DAYS} days and larger than ${MIN_SIZE} in junk locations..." | report
echo "---" | report

total_size=0
count=0

for base in "${JUNK_BASES[@]}"; do
  [[ ! -d "$base" ]] && continue
  while IFS= read -r -d '' f; do
    size=$(stat -f%z "$f" 2>/dev/null || true)
    [[ -z "$size" ]] && continue
    echo "${size}	$f" | report
    ((count+=1)) || true
    ((total_size+=size)) || true
  done < <(find "$base" -type f -mtime +"$DAYS" -size +"$MIN_SIZE" -print0 2>/dev/null || true)
done

echo "---" | report
# Human-readable size (no numfmt on macOS)
if [[ $total_size -ge 1073741824 ]]; then
  total_hr="$(awk "BEGIN { printf \"%.2f GB\", $total_size/1073741824 }")"
elif [[ $total_size -ge 1048576 ]]; then
  total_hr="$(awk "BEGIN { printf \"%.2f MB\", $total_size/1048576 }")"
elif [[ $total_size -ge 1024 ]]; then
  total_hr="$(awk "BEGIN { printf \"%.2f KB\", $total_size/1024 }")"
else
  total_hr="${total_size} B"
fi
echo "Total: $count files, $total_hr" | report
if [[ -n "$OUTPUT" ]]; then
  echo "Report appended to: $OUTPUT"
fi
