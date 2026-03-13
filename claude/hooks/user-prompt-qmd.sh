#!/bin/bash
# UserPromptSubmit hook — auto-query QMD and inject results into context.
# Reads user prompt from stdin JSON, runs QMD search, injects results if found.

# --- Configuration ---
# Set to true to run QMD on every prompt (requires GPU for good performance).
# When false, QMD only runs when the prompt contains the trigger sequence.
QMD_EVERY_PROMPT=false
# Trigger sequence to invoke QMD when QMD_EVERY_PROMPT is false.
QMD_TRIGGER="?qmd"

# Find QMD — works on Mac (PATH) and Windows (npm global dir)
if command -v qmd &>/dev/null; then
  QMD=qmd
elif [ -f "$APPDATA/npm/qmd" ]; then
  QMD="$APPDATA/npm/qmd"
else
  exit 0
fi

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null || \
         echo "$INPUT" | python -c "import sys,json; print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null)

if [ -z "$PROMPT" ]; then
  exit 0
fi

if [ "$QMD_EVERY_PROMPT" = true ]; then
  QUERY="$PROMPT"
else
  if ! echo "$PROMPT" | grep -q "$QMD_TRIGGER"; then
    exit 0
  fi
  QUERY=$(echo "$PROMPT" | sed "s/$QMD_TRIGGER//g" | xargs)
  if [ -z "$QUERY" ]; then
    exit 0
  fi
fi

QMD_STATUS="/tmp/.qmd-running"
touch "$QMD_STATUS"
trap 'rm -f "$QMD_STATUS"' EXIT

RESULTS=$("$QMD" query "$QUERY" -c convex -n 3 --min-score 0.4 2>/dev/null)

if [ -z "$RESULTS" ]; then
  exit 0
fi

cat << 'HEADER'
<knowledge-base>
The following results were automatically retrieved from the Convex knowledge vault.
Use this as your primary source. If it answers the question, prefer it over other context.

HEADER

echo "$RESULTS"

echo ""
echo "</knowledge-base>"
