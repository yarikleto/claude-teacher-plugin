---
name: init-edu
description: Set up a learning project and student profile, preserving existing project instructions and settings. Run explicitly to onboard or update preferences.
disable-model-invocation: true
---

# Initialize Educational Environment

Before accessing education data, read `${CLAUDE_PLUGIN_ROOT}/references/education-data.md`. Resolve `<education-db>` using that contract. Current session ID: `${CLAUDE_SESSION_ID}`.

## 1. Inspect before changing files

Read the project `CLAUDE.md`, `.claude/CLAUDE.md`, `.claude/settings.json`, `.claude/claude-teacher.json`, and existing `<education-db>/student.json` and `dashboard.json`, when present.

- Preserve all unrelated instructions, settings, hooks, and student work. If a JSON file is invalid, report it and recover it before updating.
- Do not write setup files until the student has supplied the required onboarding and project answers. Honor supplied answers; do not ask again.
- If a profile exists, greet the student and ask whether to set up this project using it or update selected profile fields. Never delete the profile to edit it.
- If they want a full reset, direct them to `/claude-teacher:reset-edu`. Do not invoke or reproduce that manual-only skill automatically.

## 2. Onboard a new student

Ask one question at a time and wait for the answer. The student may skip personal questions; save unknown values as `null` or empty arrays. Do not require an age or infer one.

1. What should I call you?
2. How old are you, or would you prefer to skip that?
3. What is your current level: beginner, some experience, intermediate, or advanced?
4. What subjects or skills do you already know well?
5. Which learning approaches do you prefer: diagrams, examples first, analogies, theory first, hands-on practice, or a mix?
6. What frustrates you when learning?
7. What are your goals and any deadlines?
8. What interests or hobbies could I use for examples?
9. How would you describe your ideal teacher's tone and approach?

Save an object in `<education-db>/student.json` after collecting the answers:

```json
{
  "name": "preferred name",
  "age": null,
  "level": "beginner",
  "known_subjects": [],
  "learning_style": [],
  "frustrations": [],
  "goals": [{"goal": "student's goal", "deadline": null}],
  "interests": [],
  "teacher_persona": "student's own description"
}
```

Use a number for an age supplied by the student and real `YYYY-MM-DD` dates for known deadlines. Adapt tone to their expressed preferences first. Store the personal profile in the global DB; do not copy personal information into a shared project file without their request.

## 3. Choose the project focus

Ask the learning type, then the topic, one question at a time if not already known:

- `project`: building something
- `subject`: studying a subject or field
- `exam-prep`: preparing for an exam, interview, or certification
- `mixed`: a mix or not sure yet

## 4. Initialize storage and the project marker

Create missing `<education-db>/{docs,topics,quizzes,sessions}`, project `.claude/`, and project `docs/` directories. Use quoted resolved paths, not a literal `<education-db>` shell token.

Merge `.claude/claude-teacher.json`, preserving unknown fields:

```json
{
  "schema_version": 1,
  "enabled": true,
  "learning_type": "subject",
  "topic": "the chosen topic",
  "initialized": "YYYY-MM-DD"
}
```

Keep the original `initialized` date on repeat setup. This marker activates hooks only in this project. Setting `enabled: false` pauses hook reminders.

## 5. Merge settings and migrate only owned hooks

If `.claude/settings.json` has no `outputStyle`, add `"outputStyle": "Explanatory"`. Preserve an existing output style and every other setting. Never add project hook registrations: the plugin already ships them.

For installations from 1.8.0 or earlier, inspect each handler in the existing `hooks` object. Remove a handler only when its command or args clearly reference this plugin's cache directory **and** one of these scripts:

- `session-start-load-db.sh`
- `inject-teach-context.sh`
- `stop-save-progress.sh`
- `post-code-review.sh`
- `post-quiz-motivate.sh`

Preserve other handlers in the same group, other groups/events, and all non-hook settings. Remove a group/event only if it became empty from removing owned handlers. Never remove the entire `hooks` block wholesale. Leave ambiguous entries unchanged and explain them.

## 6. Merge project instructions

Read `${CLAUDE_SKILL_DIR}/references/project-context.md`. Adapt it to the chosen type/topic and write it inside these exact markers in project `CLAUDE.md`:

```markdown
<!-- claude-teacher:start -->
[adapted project-context content]
<!-- claude-teacher:end -->
```

- If the file is absent, create it with that block.
- If one complete block exists, replace only that block. Preserve everything outside it byte-for-byte.
- If no block exists, append one after the existing content. For legacy teaching instructions, identify the old teaching section and merge without duplicating or removing unrelated guidance.
- If markers are duplicated or unbalanced, do not guess at a replacement boundary; report the ambiguity first.
- Respect project rules outside the block. The plugin's own developer guide is not runtime tutoring context.

## 7. Initialize the dashboard without resetting history

For a new DB, create `<education-db>/dashboard.json`:

```json
{
  "last_session": "YYYY-MM-DD",
  "current_topic": "the chosen topic",
  "total_quizzes": 0,
  "average_score": 0,
  "stats": {"new": 0, "weak": 0, "learned": 0, "solid": 0},
  "topics": {}
}
```

For an existing DB, merge only `last_session` and `current_topic`; preserve records and recalculate aggregates if necessary. Do not create a topic as learned merely because it was selected for study.

If project `memory/knowledge_gaps.md` already exists, preserve it and sync known states from the global DB. Do not create or overwrite an auto-memory index; this legacy mirror is optional.

Append one `session_start` setup event with a unique `event_id`, current time, `${CLAUDE_SESSION_ID}`, project path, topic, and learning type. Do not duplicate the event when retrying a save.

## 8. Confirm actual changes

Briefly report the chosen focus, resolved DB path, and files created/updated. Mention any settings preserved or migration entries needing attention. Do not claim hooks saved data or loaded settings that have not been verified.

Offer the first learning step. Explain that `/claude-teacher:progress` shows tracked knowledge and `/claude-teacher:summary` ends a lesson with a recap. If newly installed plugin components are not loaded, use `/reload-plugins` or restart Claude Code.
