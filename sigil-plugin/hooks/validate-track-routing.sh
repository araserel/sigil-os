#!/bin/bash
# validate-track-routing.sh
# SubagentStart hook: Validate that the subagent type matches the expected agent for current phase
#
# This hook helps enforce proper workflow routing by warning when an unexpected
# agent is being invoked for the current workflow phase.

set -e

# CLAUDE_SUBAGENT_TYPE contains the subagent_type being started
SUBAGENT_TYPE="${CLAUDE_SUBAGENT_TYPE:-}"

# If no subagent type, skip validation
if [ -z "$SUBAGENT_TYPE" ]; then
    echo '{"valid": true, "reason": "no_subagent_type"}'
    exit 0
fi

PROJECT_ROOT="${CLAUDE_PROJECT_ROOT:-.}"
CONTEXT_FILE="$PROJECT_ROOT/.sigil/project-context.md"

# If no context file, allow any agent (no active workflow)
if [ ! -f "$CONTEXT_FILE" ]; then
    echo '{"valid": true, "reason": "no_context_file"}'
    exit 0
fi

# Extract current phase from project-context.md
# Looking for pattern: **Current Phase:** specify
CURRENT_PHASE=$(grep -oE '\*\*Current Phase:\*\* [a-z]+' "$CONTEXT_FILE" 2>/dev/null | head -1 | sed 's/\*\*Current Phase:\*\* //' || echo "")

# If no phase detected, allow any agent
if [ -z "$CURRENT_PHASE" ]; then
    echo '{"valid": true, "reason": "no_phase_detected"}'
    exit 0
fi

# Phase to expected agent mapping
# These mappings align with the workflow chain definitions
get_expected_agent() {
    case "$1" in
        specify)    echo "business-analyst" ;;
        clarify)    echo "business-analyst" ;;
        plan)       echo "architect" ;;
        tasks)      echo "task-planner" ;;
        implement)  echo "developer" ;;
        validate)   echo "qa-engineer" ;;
        review)     echo "security" ;;
        *)          echo "" ;;
    esac
}

EXPECTED_AGENT=$(get_expected_agent "$CURRENT_PHASE")

# If phase doesn't map to an agent, allow any
if [ -z "$EXPECTED_AGENT" ]; then
    echo "{\"valid\": true, \"reason\": \"phase_not_mapped\", \"phase\": \"$CURRENT_PHASE\"}"
    exit 0
fi

# Check if the subagent matches expected
if [ "$SUBAGENT_TYPE" = "$EXPECTED_AGENT" ]; then
    echo '{"valid": true}'
else
    # Output warning but don't block (non-blocking validation)
    cat << EOF
{
  "valid": false,
  "warning": true,
  "current_phase": "$CURRENT_PHASE",
  "expected_agent": "$EXPECTED_AGENT",
  "actual_agent": "$SUBAGENT_TYPE",
  "message": "Agent '$SUBAGENT_TYPE' invoked during '$CURRENT_PHASE' phase (expected: '$EXPECTED_AGENT'). This may indicate workflow deviation."
}
EOF
fi
