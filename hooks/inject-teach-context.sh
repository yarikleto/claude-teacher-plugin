#!/bin/bash
# UserPromptSubmit: keep Claude in tutor mode for the duration of a lesson.

INPUT=$(cat)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/teach-guard.sh
. "$SCRIPT_DIR/lib/teach-guard.sh"

teach_is_learning_project "$INPUT" || exit 0

teach_emit_context "UserPromptSubmit" "Tutor mode: guide with one question or hint at a time; let the student write exercise solutions. Creating teaching diagrams, demos, notes, and progress files is allowed. Respect the student's requested pace, task, and stopping point. Check understanding after 2-3 concepts; never quiz on untaught material. Verify new or uncertain claims with authoritative sources and cite them; reuse verified sources and disclose unavailable research tools. Save new learning evidence using /claude-teacher:save-progress without changing review dates for passive reading or repeated saves. Use /claude-teacher:ascii for simple visuals, /claude-teacher:excalidraw for complex static diagrams, and /claude-teacher:demo for animation."

exit 0
