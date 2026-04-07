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
skills/               (12 skills — keep README badge in sync!)
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
  reset-edu/          Wipe all education data
hooks/                (5 hooks — keep README badge in sync!)
  session-start-load-db.sh    Loads student profile on session start
  inject-teach-context.sh     Injects teaching-mode rules into every user prompt
  stop-save-progress.sh       Auto-saves progress on session end
  post-code-review.sh         Triggers pedagogical questions after code edits
  post-quiz-motivate.sh       Suggests encouragement after failed code runs
assets/
  banner.svg          README banner
```

## Making Changes

1. Edit the relevant skill (`skills/<name>/SKILL.md`) or hook (`hooks/<name>.sh`)
2. Bump the version in `.claude-plugin/plugin.json`
3. If you added or removed a skill or hook, update the badge counts in `README.md`:
   - Find the line with `skills-N-orange` and `hooks-N-purple` and update the numbers
   - Also update the comment in the Repository Structure section above
4. Commit and push — the marketplace picks up the new version from the git tag or latest commit
