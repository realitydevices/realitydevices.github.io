#!/usr/bin/env bash
# Build-loop capture — variant of _harness/workshop/capture.sh tuned for
# item-shaped reviews. Captures angles relevant to the items currently on
# the sphere (per the active slice ticket), not the angles the workshop
# uses for logo silhouette review.
#
# Output: _harness/build/runs/<run_name>/angle_*.png
# Usage:  _harness/build/capture.sh [run_name]
#
# Per-pass angles can be overridden by setting BUILD_ANGLES to a multi-line
# string of "name yaw pitch" rows; otherwise the defaults below run.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RUN_NAME="${1:-run_$(date +%Y%m%d_%H%M%S)}"
RUN_DIR="$ROOT/_harness/build/runs/$RUN_NAME"
PORT="${PORT:-8766}"
TARGET="${TARGET:-index.html}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

if [[ ! -x "$CHROME" ]]; then
  echo "Chrome not found at: $CHROME" >&2
  exit 1
fi

mkdir -p "$RUN_DIR"

cd "$ROOT"
python3 -m http.server "$PORT" >/dev/null 2>&1 &
SERVER_PID=$!
trap 'kill $SERVER_PID 2>/dev/null || true' EXIT
sleep 0.7

# Capture angles, in priority order:
#   1. $BUILD_ANGLES env var (multi-line "name yaw pitch" rows)
#   2. _harness/build/runs/<run>/angles.txt (per-pass override; same format)
#   3. The default below — front view only.
# Slice tickets that need item-relevant angles should write angles.txt
# into the run dir (or set BUILD_ANGLES) so this script stays generic.
DEFAULT_ANGLES="00_front 0.00 0.00"

if [[ -n "${BUILD_ANGLES:-}" ]]; then
  ANGLES_RAW="$BUILD_ANGLES"
elif [[ -f "$RUN_DIR/angles.txt" ]]; then
  ANGLES_RAW="$(cat "$RUN_DIR/angles.txt")"
else
  ANGLES_RAW="$DEFAULT_ANGLES"
fi

echo "Run dir: $RUN_DIR"
while IFS= read -r entry; do
  [[ -z "$entry" ]] && continue
  read -r name yaw pitch <<< "$entry"
  url="http://localhost:$PORT/$TARGET?yaw=$yaw&pitch=$pitch&nobrand=1&capture=180"
  out="$RUN_DIR/angle_$name.png"
  echo "  → $name (yaw=$yaw pitch=$pitch)"
  timeout 30 "$CHROME" \
    --headless=new \
    --hide-scrollbars \
    --no-sandbox \
    --window-size=1440,900 \
    --virtual-time-budget=8000 \
    --screenshot="$out" \
    "$url" >/dev/null 2>&1 || echo "    (timeout or error on $name)"
done <<< "$ANGLES_RAW"

cat > "$RUN_DIR/manifest.txt" <<EOF
target: $TARGET
captured: $(date -u +%Y-%m-%dT%H:%M:%SZ)
viewport: 1440x900
angles:
$(echo "$ANGLES_RAW" | sed 's/^/  /')
EOF

echo "Done. $(ls "$RUN_DIR" | wc -l | tr -d ' ') files in $RUN_DIR"
