#!/usr/bin/env bash
# Capture orbital screenshots of the 3D logo scene from N angles.
# Usage: capture.sh [run_name]   (default: timestamped)
#
# Spins up python http.server on PORT, drives system Chrome in headless mode
# at index.html?yaw=Y&pitch=P&nobrand=1 for each angle, writes PNGs into
# _harness/workshop/runs/<run_name>/.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RUN_NAME="${1:-run_$(date +%Y%m%d_%H%M%S)}"
RUN_DIR="$ROOT/_harness/workshop/runs/$RUN_NAME"
PORT="${PORT:-8765}"
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

# yaw range in proto is roughly [-1.88, 1.88] rad; pitch [-0.78, 0.78].
# Positive pitch = camera above (looking down). Positive yaw = camera right.
ANGLES=(
  "00_front           0.00  0.00"
  "01_right-mid       1.00  0.00"
  "02_right-high      1.00  0.50"
  "03_left-mid       -1.00  0.00"
  "04_left-low       -1.00 -0.40"
  "05_top-quartering  0.70  0.70"
)

echo "Run dir: $RUN_DIR"
for entry in "${ANGLES[@]}"; do
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
done

# Manifest of this run for the reviewer
cat > "$RUN_DIR/manifest.txt" <<EOF
target: $TARGET
captured: $(date -u +%Y-%m-%dT%H:%M:%SZ)
viewport: 1440x900
angles:
$(printf '  %s\n' "${ANGLES[@]}")
EOF

echo "Done. $(ls "$RUN_DIR" | wc -l | tr -d ' ') files in $RUN_DIR"
