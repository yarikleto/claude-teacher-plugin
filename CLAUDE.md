# Claude Teacher Plugin — Developer Guide

## Versioning

**Always bump the version in `.claude-plugin/plugin.json` when making changes.**

Versioning follows semver (`MAJOR.MINOR.PATCH`):
- `PATCH` — bug fixes, wording tweaks, small skill improvements
- `MINOR` — new skills, new hooks, new features
- `MAJOR` — breaking changes, full rewrites

## How to Update the Plugin (for users)

Users update the plugin by running this command in the project where it's installed:

```bash
claude plugins update claude-teacher@claude-teacher-marketplace --scope project
```

Use the same `--scope` that was used during install (`project`, `user`, or `local`). After updating, the user must restart the Claude Code session for changes to take effect.

## Repository Structure

```
.claude-plugin/
  plugin.json         Plugin metadata and version — bump this on every change
skills/               (15 skills — keep README badge in sync!)
  init-edu/           Onboarding + project setup
  quiz-me/            Adaptive quizzes with spaced repetition
  excalidraw/         Excalidraw interactive diagrams
    references/       Color palette, element templates, JSON schema
  ascii/              ASCII diagrams for visual explanations
  demo/               Animated interactive HTML visualizations
  progress/           Knowledge dashboard
  challenge/          Mini-tasks for hands-on practice
  motivate/           Motivation boost with real quotes
  summary/            End-of-session recap and DB flush
  save-progress/      Mid-session checkpoint
  research/           Study plan generator with resources
  compare/            Side-by-side concept comparisons
  flashcards/         Anki-style flashcard generation (Markdown + CSV)
  roadmap/            Visual learning path diagram via Excalidraw
  reset-edu/          Wipe all education data
hooks/                (5 hooks — keep README badge in sync!)
  hooks.json                  Registers every hook against ${CLAUDE_PLUGIN_ROOT}
  lib/teach-guard.sh          Shared guard + context emitter, sourced by all hooks
  session-start-load-db.sh    Loads student profile on session start
  inject-teach-context.sh     Injects teaching-mode rules into every user prompt
  stop-save-progress.sh       Auto-saves progress on session end
  post-code-review.sh         Triggers pedagogical questions after code edits
  post-quiz-motivate.sh       Suggests encouragement after failed commands
assets/
  banner.svg          README banner
LICENSE
```

## Hook Rules

Two invariants, both learned from bugs:

1. **Every hook guards on `teach_is_learning_project`.** Hooks in `hooks.json` fire in every
   project where the plugin is enabled, and the default install scope is `user`. Without the
   guard, tutor mode leaks into unrelated repos.
2. **Never write hook output with a bare `echo`.** Plain stdout on exit 0 reaches Claude only
   for `UserPromptSubmit` and `SessionStart`; on every other event it goes to the debug log
   and is silently discarded. Use `teach_emit_context <EventName> "<text>"`.

A failing Bash command raises `PostToolUseFailure`, not `PostToolUse`, and that payload carries
a top-level `error` string with no `tool_response` object.

Test a hook by piping a payload into it:

```bash
echo '{"cwd":"/tmp/x","tool_input":{"file_path":"/tmp/x/main.py"}}' \
  | CLAUDE_PROJECT_DIR=/tmp/x bash hooks/post-code-review.sh
```

Validate the whole plugin before committing:

```bash
claude plugin validate .          # marketplace manifest
claude --plugin-dir . plugin details claude-teacher   # confirms hook + skill counts
```

## Making Changes

1. Edit the relevant skill (`skills/<name>/SKILL.md`) or hook (`hooks/<name>.sh`)
2. Bump the version in `.claude-plugin/plugin.json`
3. If you added or removed a skill or hook, update the badge counts in `README.md`:
   - Find the line with `skills-N-orange` and `hooks-N-purple` and update the numbers
   - Also update the comment in the Repository Structure section above
4. Commit and push — the marketplace picks up the new version from the git tag or latest commit
