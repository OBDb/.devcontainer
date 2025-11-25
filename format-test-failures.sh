#!/bin/bash
# Script to format pytest test failures into markdown for PR comments

set -e

TEST_OUTPUT_FILE="${1:-test-output.txt}"
GITHUB_SERVER_URL="${GITHUB_SERVER_URL:-https://github.com}"
GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-unknown/repo}"
GITHUB_SHA="${GITHUB_SHA:-main}"
GITHUB_RUN_ID="${GITHUB_RUN_ID:-0}"

if [ ! -f "$TEST_OUTPUT_FILE" ]; then
  echo "Error: Test output file not found: $TEST_OUTPUT_FILE" >&2
  exit 1
fi

# Extract assertion errors
FAILURES=$(grep "AssertionError: Signal" "$TEST_OUTPUT_FILE" || echo "")

echo '## ❌ Response Tests Failed'
echo ''

if [ -n "$FAILURES" ]; then
  # Parse each failure line
  echo "$FAILURES" | while read -r line; do
    # Extract components from the error message
    SIGNAL=$(echo "$line" | sed -n 's/.*Signal \([^ ]*\) value mismatch.*/\1/p')
    FILE=$(echo "$line" | sed -n 's/.*defined in \([^:]*\):.*/\1/p')
    LINE=$(echo "$line" | sed -n 's/.*defined in [^:]*:\([^)]*\)).*/\1/p')
    GOT=$(echo "$line" | sed -n 's/.*got \([^,]*\),.*/\1/p')
    EXPECTED=$(echo "$line" | sed -n 's/.*expected \(.*\)/\1/p')

    if [ -n "$SIGNAL" ] && [ -n "$FILE" ]; then
      FILENAME=$(basename "$FILE")
      # Extract year from path: tests/test_cases/YYYY/commands/...
      YEAR=$(echo "$FILE" | sed -n 's|.*/test_cases/\([0-9]\{4\}\)/commands/.*|\1|p')

      echo "### Model year: ${YEAR}"
      echo ""
      echo "Command failed: [\`${FILENAME}:${LINE}\`](${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/blob/${GITHUB_SHA}/tests/test_cases/${YEAR}/commands/${FILENAME}#L${LINE})"
      echo ""
      echo '```'
      echo "Signal ${SIGNAL} value mismatch: got ${GOT}, expected ${EXPECTED}"
      echo '```'
      echo ""
    fi
  done
else
  # Fallback to last 100 lines
  echo '```'
  tail -100 "$TEST_OUTPUT_FILE"
  echo '```'
fi

echo ""
echo "[View full test output](${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID})"
echo ""
echo "### How to fix"
echo "To update the test expectations based on the current signalset values, run:"
echo '```bash'
echo "python3 tests/update_yaml_tests.py --verbose"
echo '```'
