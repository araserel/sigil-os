#!/bin/bash
# verify-context-update.sh
# PostToolUse hook: Check if project-context.md should be updated after file writes
#
# Triggers on Write|Edit operations. Analyzes the modified file to determine
# if the change represents a workflow state transition that should be recorded.

set -e

# Hook receives tool arguments via environment or stdin
# CLAUDE_TOOL_ARG_FILE_PATH contains the file that was written/edited
MODIFIED_FILE="${CLAUDE_TOOL_ARG_FILE_PATH:-}"

# If we can't determine the file, skip
if [ -z "$MODIFIED_FILE" ]; then
    echo '{"needs_context_update": false, "reason": "no_file_path"}'
    exit 0
fi

PROJECT_ROOT="${CLAUDE_PROJECT_ROOT:-.}"
CONTEXT_FILE="$PROJECT_ROOT/.sigil/project-context.md"

# Extract file info
FILE_NAME=$(basename "$MODIFIED_FILE")
DIR_PATH=$(dirname "$MODIFIED_FILE")

NEEDS_UPDATE="false"
UPDATE_REASON=""
UPDATE_FIELD=""

# Check for workflow artifacts that indicate phase transitions
case "$FILE_NAME" in
    spec.md)
        NEEDS_UPDATE="true"
        UPDATE_REASON="Specification created/updated"
        UPDATE_FIELD="Current Phase: specify -> clarify"
        ;;
    clarifications.md)
        NEEDS_UPDATE="true"
        UPDATE_REASON="Clarifications completed"
        UPDATE_FIELD="Current Phase: clarify -> plan"
        ;;
    plan.md)
        NEEDS_UPDATE="true"
        UPDATE_REASON="Technical plan created"
        UPDATE_FIELD="Current Phase: plan -> tasks"
        ;;
    tasks.md)
        NEEDS_UPDATE="true"
        UPDATE_REASON="Tasks defined"
        UPDATE_FIELD="Current Phase: tasks -> implement"
        ;;
    constitution.md)
        if echo "$DIR_PATH" | grep -qF ".sigil"; then
            NEEDS_UPDATE="true"
            UPDATE_REASON="Constitution updated"
            UPDATE_FIELD="Constitution: modified"
        fi
        ;;
    project-context.md)
        # Already updating context, skip to avoid loops
        NEEDS_UPDATE="false"
        ;;
esac

# Check if file is in a specs directory (implementation file)
if [ "$NEEDS_UPDATE" = "false" ]; then
    if echo "$DIR_PATH" | grep -qE "(^|/)\.sigil/specs/[0-9]+-"; then
        case "$FILE_NAME" in
            *.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.rs|*.java|*.swift|*.kt)
                NEEDS_UPDATE="true"
                UPDATE_REASON="Implementation progress"
                UPDATE_FIELD="Implementation: file modified"
                ;;
        esac
    fi
fi

# Output result
cat << EOF
{
  "needs_context_update": $NEEDS_UPDATE,
  "reason": "$UPDATE_REASON",
  "suggested_update": "$UPDATE_FIELD",
  "modified_file": "$MODIFIED_FILE",
  "context_file": "$CONTEXT_FILE"
}
EOF
