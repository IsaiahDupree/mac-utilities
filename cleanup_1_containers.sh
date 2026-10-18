#!/bin/bash
# (1) Containers: Delete old Docker data, keep what's in use / latest.
# - Prunes unused images (keeps images used by running containers).
# - Prunes stopped containers.
# - Optional: prune unused volumes (--volumes).
# Usage: ./cleanup_1_containers.sh [--volumes]

set -e
PRUNE_VOLUMES=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --volumes) PRUNE_VOLUMES="--volumes"; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

echo "=== 1. Containers (Docker): delete old, keep latest ==="
if ! command -v docker &>/dev/null; then
  echo "Docker not found. Skipping."
  exit 0
fi

echo "Before:"
docker system df 2>/dev/null || true

echo ""
echo "Pruning unused images and stopped containers..."
docker system prune -a -f $PRUNE_VOLUMES

echo ""
echo "After:"
docker system df 2>/dev/null || true
echo "Done. (Safari/other containers left as-is.)"
