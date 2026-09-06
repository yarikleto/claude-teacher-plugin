# Claude Teacher Plugin — Developer Guide

This file is repository guidance, not shipped tutoring context. Runtime instructions come from skills and hooks; setup uses `skills/init-edu/references/project-context.md`.

## Versioning

Always bump `.claude-plugin/plugin.json` when changing the plugin. Use semver: patch for fixes/wording, minor for new skills/hooks/features, major for breaking changes. Keep one version source in `plugin.json`.

## Structure

- `.claude-plugin/plugin.json`: plugin manifest
- `.claude-plugin/marketplace.json`: marketplace for this repository
- `skills/`: 15 skills; supporting templates and Excalidraw references live beside their skill
- `references/education-data.md`: shared database, assessment, persistence, and research contract
- `hooks/hooks.json`: 5 hook registrations, using exec-form `command` + `args`
- `hooks/lib/teach-guard.sh`: project opt-in, JSON input validation, DB path, context output
- `hooks/lib/review-context.jq`: portable calendar dates and bounded review queues
- `tests/`: focused hook and demo regression checks

Keep skill/hook counts in README badges and this guide in sync if components change. Plugin files are read-only inputs at runtime; student data lives outside the cache.

## Invariants

1. Every hook calls `teach_is_learning_project` before emitting context. Respect `enabled: false`, keep legacy `memory/knowledge_gaps.md` support, and skip subagent activity.
2. Use structured `hookSpecificOutput` through `teach_emit_context`. Do not use bare stdout for context outside SessionStart/UserPromptSubmit.
3. Keep exec-form path placeholders in `args`; no shell interpolation or unquoted plugin paths. The plugin must load from cache paths containing spaces and apostrophes.
4. `PostToolUseFailure` has a top-level `error` and `is_interrupt`; no successful `tool_response`. Claude's tool calls do not observe edits in the student's editor.
5. `Stop` fires after each response. Its `additionalContext` continues the conversation under the documented loop protections. Check `stop_hook_active`, request only an idempotent checkpoint, and never manufacture `session_end` on every turn.
6. Never replace unrelated project settings/hooks or the whole project CLAUDE.md during onboarding. Setup/reset are manual-only skills.
7. All skills honor `CLAUDE_TEACHER_DB` using the shared contract. Quiz IDs are stable per attempt; passive engagement and repeated saves must not reschedule assessments.
8. Reference bundled files with `${CLAUDE_PLUGIN_ROOT}` or `${CLAUDE_SKILL_DIR}`. Use namespaced `/claude-teacher:<skill>` commands to avoid collisions.

## Validation

Run from the repository root:

```bash
python3 -m unittest discover -s tests -v
node --test tests/demo.test.cjs
claude plugin validate .claude-plugin/plugin.json --strict
claude plugin validate . --strict
```

The explicit plugin manifest validation checks plugin contents. Validating `.` alone chooses the marketplace and does not establish that its plugin passed validation.

For interactive smoke testing, use `claude --plugin-dir /absolute/path/to/claude-teacher-plugin` from a disposable project. Check `/help`, `/hooks`, setup, an assessment, and a checkpoint. Keep real student data out of tests. `/reload-plugins` refreshes installed components; restart if an old session retains teaching context.

## Documentation references

Check current official docs when changing integration behavior:

- https://code.claude.com/docs/en/plugins-reference
- https://code.claude.com/docs/en/hooks
- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/plugin-marketplaces

Do not remove a currently documented feature based on older examples. In particular, exec-form `args` and Stop `additionalContext` are supported by current Claude Code.
