---
name: motivate
description: Use when the student seems frustrated, stuck, discouraged, or explicitly asks for motivation — fetches a real quote from an API and delivers a personalized motivational boost
---

# Motivate

Gives the student a motivational boost with a real quote from a famous thinker, plus personalized encouragement based on their progress.

## When to Trigger

- Student explicitly asks: `/motivate`
- Student shows frustration: "I don't get it", "this is too hard", "I'm stuck", "I give up"
- After multiple wrong quiz answers in a row (3+)
- After a failed challenge
- The tutor can proactively offer motivation when it detects struggle

## Process

### Step 1: Fetch a Real Quote

Fetch a quote from one of these free APIs using Bash with `curl`. Try them in order — use the first one that succeeds:

**Primary — ZenQuotes:**
```bash
curl -s "https://zenquotes.io/api/random" 2>/dev/null
```
Response: `[{"q": "quote text", "a": "Author Name", "h": "..."}]`
Extract: `q` = quote, `a` = author

**Fallback — Forismatic:**
```bash
curl -s "https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en" 2>/dev/null
```
Response: `{"quoteText": "...", "quoteAuthor": "..."}`
Extract: `quoteText` = quote, `quoteAuthor` = author

If both APIs fail (network error, timeout), use a quote from the hardcoded fallback list below.

### Step 2: Read Student Context

Read `~/.local/share/claude-education/student.json` and `~/.local/share/claude-education/dashboard.json` to understand:
- The student's **name** — always address them personally
- Their **interests** — connect the quote to something they care about
- Their **motivations** — frame encouragement in terms of what drives them
- How many topics they've mastered (for encouragement)
- Any recent progress to highlight
- Their current struggle (from conversation context)

### Step 3: Deliver the Motivation

Format:

```
╔══════════════════════════════════════════════════╗
║                                                  ║
║  "[Quote text here]"                             ║
║                                                  ║
║                        — Author Name             ║
║                                                  ║
╚══════════════════════════════════════════════════╝

[Personalized encouragement — 2-3 sentences max, connecting the quote
to what the student is going through RIGHT NOW. Reference their actual
progress from the DB.]
```

### Personalization Rules

**If frustrated / stuck:**
- Address them by name: "{name}, this is genuinely hard stuff."
- Acknowledge the difficulty is real — don't minimize it
- Point out something specific they've already conquered that was also hard
- "Remember when [topic] seemed impossible? You've got that at solid now."
- If they have interests, connect to `{interest1}` or `{interest2}`: "You didn't beat [hard game] on the first try either."

**If making mistakes:**
- Normalize it — mistakes are data, not failure
- Mention their misconception was recorded and will be addressed
- "Every misconception you catch now is one less bug in your understanding, {name}."

**If just needs energy:**
- Highlight progress stats: "{name}, you've gone from 0 to N solid topics in X days"
- Show trajectory, not just current state
- Connect to their goals: "You're X% of the way to {goal}"

**If after failed quiz/challenge:**
- Focus on what they DID get right
- Reframe: the quiz found a gap, which is exactly what it's for
- Connect to their motivations: if they want to "build real things", remind them that understanding this deeply will make their projects better

### Step 4: Log It

Append to `~/.local/share/claude-education/sessions/[date].jsonl`:
```jsonl
{"time": "[now]", "event": "motivate", "trigger": "explicit|frustration|failed_quiz|failed_challenge", "quote_author": "Author Name"}
```

## Hardcoded Fallback Quotes

Use ONLY if both APIs fail. These are verified, correctly attributed quotes:

**When struggling:**
- "If you can't solve a problem, then there is an easier problem you can solve: find it." — George Polya, *How to Solve It*
- "Life is not easy for any of us. But what of that? We must have perseverance and above all confidence in ourselves." — Marie Curie
- "Nearly every man who develops an idea works it up to the point where it looks impossible, and then he gets discouraged. That's not the place to become discouraged." — Thomas Edison
- "We can only see a short distance ahead, but we can see plenty there that needs to be done." — Alan Turing
- "Ever tried. Ever failed. No matter. Try again. Fail again. Fail better." — Samuel Beckett

**When making mistakes:**
- "The first principle is that you must not fool yourself — and you are the easiest person to fool." — Richard Feynman
- "The competent programmer is fully aware of the strictly limited size of his own skull; therefore he approaches the programming task in full humility." — Edsger Dijkstra
- "I have gotten a lot of results! I know several thousand things that won't work." — Thomas Edison

**About curiosity and learning:**
- "I have no special talent. I am only passionately curious." — Albert Einstein
- "I learned very early the difference between knowing the name of something and knowing something." — Richard Feynman
- "What I cannot create, I do not understand." — Richard Feynman
- "Learning without thought is labor lost; thought without learning is perilous." — Confucius
- "People think that computer science is the art of geniuses but the actual reality is the opposite, just many people doing things that build on each other, like a wall of mini stones." — Donald Knuth
- "The more I study, the more insatiable do I feel my genius for it to be." — Ada Lovelace

**About persistence:**
- "If you wish to learn swimming you have to go into the water, and if you wish to become a problem solver you have to solve problems." — George Polya
- "We must believe that we are gifted for something, and that this thing, at whatever cost, must be attained." — Marie Curie
- "Simplicity is prerequisite for reliability." — Edsger Dijkstra
- "Humans are allergic to change. They love to say, 'We've always done it this way.' I try to fight that." — Grace Hopper

## Rules

- Keep it SHORT. The student is struggling — don't lecture them.
- The quote box + 2-3 personalized sentences. That's it.
- ALWAYS use a real quote from the API first. Fallback list is last resort.
- NEVER make up quotes or misattribute them.
- Connect the quote to the student's ACTUAL situation — generic motivation is weak motivation.
- Don't be cheesy or patronizing. Be genuine.
