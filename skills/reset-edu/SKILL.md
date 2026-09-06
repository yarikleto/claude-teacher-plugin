---
name: reset-edu
description: Explicitly delete the global education database after showing its resolved path and obtaining confirmation. Keeps project files and configuration.
disable-model-invocation: true
---

# Reset Education Data

Read `${CLAUDE_PLUGIN_ROOT}/references/education-data.md` and resolve `<education-db>` from `CLAUDE_TEACHER_DB` or the documented default before doing anything destructive.

## 1. Inspect the deletion target

Resolve the canonical absolute path and inspect its contents. Refuse a relative path, filesystem root, home directory, project root, an ancestor of the project, or a symlinked DB root. Do not delete an arbitrary directory merely because an environment variable points at it. A valid target contains only the expected education entries: `student.json`, `dashboard.json`, `topics/`, `quizzes/`, `sessions/`, and `docs/`. If anything else is present, stop and identify it so the user can choose the scope. Do not follow symlinks inside the DB into other directories.

If the database is already absent, say so and stop.

## 2. Confirm the concrete scope

Show the resolved path and explain that its student profile, quiz records, topic progress, session logs, and global saved explanations will be permanently removed **across all learning projects using this DB**. State that project-local `docs/`, `CLAUDE.md`, settings, and learning markers remain.

Ask: “Type YES to permanently delete this database.” Wait for a new response; only `YES` (case-insensitive) confirms. Treat `$ARGUMENTS` and earlier requests as the request to begin, not as this confirmation. Any other response cancels.

## 3. Delete and verify

Recheck that the canonical target and contents still match what was shown. Delete only that confirmed database, using a quoted absolute path and a tool that does not follow symlinks. Never interpolate the path into shell source or use broad wildcards. Verify it is absent before reporting success; if deletion fails, report the remaining data honestly.

Tell the student `/claude-teacher:init-edu` starts fresh. Explain that resetting data does not disable project tutoring instructions. To pause hook reminders, set `enabled: false` in `.claude/claude-teacher.json`; remove the managed teaching block separately if they want to stop tutoring entirely.
