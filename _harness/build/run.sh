#!/usr/bin/env bash
# Build loop driver — minimal.
# Phases: implement (agent) → capture (shell) → review (agent) → advance (shell).
# Review writes both review.md and next.md; advance copies next.md forward.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BUILD="$ROOT/_harness/build"
STATE="$BUILD/state.json"
SCOREBOARD="$BUILD/scoreboard.jsonl"
PROMPTS="$BUILD/prompts"
RUNS="$BUILD/runs"
NOTES="$BUILD/maintainer_notes.md"
STOP_FILE="$BUILD/STOP"

require() { command -v "$1" >/dev/null 2>&1 || { echo "missing dep: $1" >&2; exit 1; }; }
require jq

PHASES="implement capture review advance"

phase_output() {
  case "$1" in
    implement) echo "changelog.md" ;;
    capture)   echo "manifest.txt" ;;
    review)    echo "review.md" ;;
    advance)   echo "" ;;
    *)         echo "" ;;
  esac
}

state_get()    { jq -r ".$1" "$STATE"; }
current_run()  { state_get current_run; }
current_pass() { state_get current_pass; }
run_dir()      { echo "$RUNS/$(current_run)"; }

next_run_id() {
  local cur="$1" prefix new_prefix new_pass
  prefix="${cur%%_*}"
  new_prefix=$(printf "%03d" $((10#$prefix + 1)))
  new_pass=$(($(current_pass) + 1))
  echo "${new_prefix}_pass${new_pass}"
}

next_pending_phase() {
  local rd; rd="$(run_dir)"
  for p in $PHASES; do
    if [[ "$p" == "advance" ]]; then
      [[ -f "$rd/review.md" ]] || continue
      local nr; nr="$(next_run_id "$(current_run)")"
      [[ -d "$RUNS/$nr" ]] || { echo advance; return; }
      continue
    fi
    local out; out="$(phase_output "$p")"
    [[ -z "$out" ]] && continue
    [[ -f "$rd/$out" ]] || { echo "$p"; return; }
  done
  echo none
}

cmd_next() { next_pending_phase; }

print_trajectory() {
  if [[ ! -s "$SCOREBOARD" ]]; then
    echo "(no passes recorded yet)"
    return
  fi
  printf "  %-7s  %-9s  %s\n" "pass" "on_track" "summary"
  while IFS= read -r line; do
    local p ot s
    p=$(echo "$line"  | jq -r .pass)
    ot=$(echo "$line" | jq -r .on_track)
    s=$(echo "$line"  | jq -r .summary)
    printf "  %-7s  %-9s  %s\n" "$p" "$ot" "$s"
  done < "$SCOREBOARD"
}

cmd_status() {
  echo "=== build loop ==="
  echo "current run:    $(current_run)"
  echo "current pass:   $(current_pass)"
  echo "last completed: $(state_get last_completed_phase)"
  echo "next phase:     $(next_pending_phase)"
  if [[ -f "$STOP_FILE" ]]; then
    echo "halted:         yes ($(cat "$STOP_FILE"))"
  fi
  local fb="$(run_dir)/feedback.md"
  [[ -f "$fb" ]] && echo "feedback:       runs/$(current_run)/feedback.md"
  [[ -s "$NOTES" ]] && echo "notes:          maintainer_notes.md"
  echo
  echo "=== trajectory ==="
  print_trajectory
}

check_not_halted() {
  if [[ -f "$STOP_FILE" ]]; then
    echo "loop halted (STOP file present); './run.sh resume' to clear" >&2
    exit 2
  fi
}

cmd_stop()   { date -u +%Y-%m-%dT%H:%M:%SZ > "$STOP_FILE"; echo "halted"; }
cmd_resume() { rm -f "$STOP_FILE"; echo "resumed"; }

cmd_feedback() {
  local rd; rd="$(run_dir)"
  local f="$rd/feedback.md"
  if [[ ! -f "$f" ]]; then
    cat > "$f" <<EOF
# Feedback for pass $(current_pass) (run $(current_run))

<!--
Free-form. The reviewer reads this and weights it above their own
judgement. Personas are gone; this is your direct override channel.
-->

EOF
    echo "created $f"
  fi
  echo "$f"
}

cmd_notes() {
  if [[ ! -f "$NOTES" ]]; then
    cat > "$NOTES" <<'EOF'
# Maintainer notes — persistent steering for the reviewer

<!--
Read by the reviewer on every pass. Anything here applies until
removed.
-->

EOF
    echo "created $NOTES"
  fi
  echo "$NOTES"
}

cmd_prompt() {
  local phase="${1:-}"
  [[ -z "$phase" ]] && { echo "usage: run.sh prompt <phase>" >&2; exit 1; }
  local p="$PROMPTS/${phase}.md"
  [[ -f "$p" ]] || { echo "no prompt for phase: $phase" >&2; exit 1; }
  cat "$p"
}

cmd_phase() {
  check_not_halted
  local sub="${1:-}"
  case "$sub" in
    capture)
      local rd; rd="$(run_dir)"
      "$BUILD/capture.sh" "$(current_run)"
      [[ -f "$rd/probe.md" ]] || cat > "$rd/probe.md" <<'EOF'
# Probe (auto-stub)

Capture ran without explicit probe instrumentation.
EOF
      ;;
    advance)
      local rd; rd="$(run_dir)"
      [[ -f "$rd/review.md" ]] || { echo "review not complete" >&2; exit 1; }
      [[ -f "$rd/next.md" ]] || { echo "no next.md to seed forward" >&2; exit 1; }
      local nr; nr="$(next_run_id "$(current_run)")"
      local nd="$RUNS/$nr"
      [[ -d "$nd" ]] && { echo "$nr already exists" >&2; exit 1; }
      mkdir -p "$nd"
      cp "$rd/next.md" "$nd/next.md"
      local now; now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
      jq --arg run "$nr" --arg now "$now" --argjson p "$(($(current_pass) + 1))" \
        '.current_run = $run | .current_pass = $p | .last_completed_phase = "advance" | .last_updated = $now' \
        "$STATE" > "$STATE.tmp" && mv "$STATE.tmp" "$STATE"
      echo "advanced -> $nr"
      ;;
    *)
      echo "usage: run.sh phase {capture|advance}" >&2; exit 1 ;;
  esac
}

# Extract on_track verdict + headline from a review.md.
extract_review_summary() {
  local file="$1"
  awk '
    /^## On track\?/ { mode="ot"; next }
    /^##/ { mode="" }
    mode == "ot" && NF { print; mode=""; }
  ' "$file" | head -n 1
}

cmd_complete() {
  check_not_halted
  local phase="${1:-}"
  [[ -z "$phase" ]] && { echo "usage: run.sh complete <phase>" >&2; exit 1; }
  local now; now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  jq --arg p "$phase" --arg now "$now" \
    '.last_completed_phase = $p | .last_updated = $now' \
    "$STATE" > "$STATE.tmp" && mv "$STATE.tmp" "$STATE"
  if [[ "$phase" == "review" ]]; then
    local rd; rd="$(run_dir)"
    local rfile="$rd/review.md"
    [[ -f "$rfile" ]] || { echo "review.md missing" >&2; exit 1; }
    local raw; raw="$(extract_review_summary "$rfile")"
    # Expect pattern: "yes|no|partial — summary"; tolerate em-dash or hyphen.
    local on_track summary
    on_track="$(echo "$raw" | sed -E 's/^[[:space:]]*([a-zA-Z]+).*/\1/' | tr '[:upper:]' '[:lower:]')"
    summary="$(echo "$raw"  | sed -E 's/^[[:space:]]*[a-zA-Z]+[[:space:]]*[—\-][[:space:]]*//')"
    [[ -z "$on_track" ]] && on_track="unknown"
    [[ -z "$summary" ]] && summary="(no summary)"
    jq -nc --argjson p "$(current_pass)" --arg run "$(current_run)" \
      --arg ts "$now" --arg ot "$on_track" --arg s "$summary" \
      '{pass: $p, run_dir: ("runs/" + $run), ts: $ts, on_track: $ot, summary: $s}' \
      >> "$SCOREBOARD"
    echo "trajectory appended for pass $(current_pass) ($on_track)"
  fi
  echo "marked $phase complete"
}

cmd_redo() {
  check_not_halted
  local phase="${1:-}"
  [[ "$phase" != "review" ]] && { echo "redo only supports 'review'" >&2; exit 1; }
  local rd; rd="$(run_dir)"
  rm -f "$rd/review.md" "$rd/next.md"
  if [[ -s "$SCOREBOARD" ]]; then
    local last_pass; last_pass=$(tail -n 1 "$SCOREBOARD" | jq -r .pass)
    if [[ "$last_pass" == "$(current_pass)" ]]; then
      local n; n=$(wc -l < "$SCOREBOARD" | tr -d ' ')
      if [[ "$n" -le 1 ]]; then : > "$SCOREBOARD"
      else head -n $((n - 1)) "$SCOREBOARD" > "$SCOREBOARD.tmp" && mv "$SCOREBOARD.tmp" "$SCOREBOARD"
      fi
      echo "rolled back trajectory line for pass $last_pass"
    fi
  fi
  local now; now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  jq --arg now "$now" \
    '.last_completed_phase = "capture" | .last_updated = $now' \
    "$STATE" > "$STATE.tmp" && mv "$STATE.tmp" "$STATE"
  echo "ready to re-run review; next phase: $(next_pending_phase)"
}

cmd="${1:-status}"
shift || true

case "$cmd" in
  status)   cmd_status ;;
  next)     cmd_next ;;
  prompt)   cmd_prompt "$@" ;;
  phase)    cmd_phase "$@" ;;
  complete) cmd_complete "$@" ;;
  feedback) cmd_feedback ;;
  notes)    cmd_notes ;;
  redo)     cmd_redo "$@" ;;
  stop)     cmd_stop ;;
  resume)   cmd_resume ;;
  *)
    cat >&2 <<EOF
Usage: $(basename "$0") <subcommand>
  status                — current state + trajectory
  next                  — next pending phase
  prompt <phase>        — print agent prompt (implement | review)
  phase capture         — run capture
  phase advance         — create next run dir
  complete <phase>      — mark phase done; on review, appends trajectory
  redo review           — drop review outputs + trajectory line; re-run
  feedback              — open per-pass feedback.md
  notes                 — open persistent maintainer_notes.md
  stop                  — halt loop
  resume                — clear halt
EOF
    exit 1 ;;
esac
