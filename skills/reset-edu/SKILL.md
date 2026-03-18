---
name: reset-edu
description: Delete all saved education data — student profile, quiz history, topic progress, session logs, and saved docs. Fresh start.
---

# Reset Education Data

Wipe all education data for a clean start.

## Process

### Step 1: Confirm

Ask exactly this, nothing more:

```
This will permanently delete:
  · Your student profile (name, goals, learning style)
  · All quiz history and scores
  · All topic progress and misconceptions
  · All session logs
  · All saved explanations

Are you sure? Type YES to confirm.
```

Wait for the response. If anything other than `YES` (case-insensitive) — abort and say "Reset cancelled."

### Step 2: Delete

```bash
rm -rf ~/.local/share/claude-education/
```

### Step 3: Confirm deletion

```
Done. All education data has been deleted.

Run /init-edu to start fresh whenever you're ready.
```
