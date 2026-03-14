---
name: challenge
description: Use when the student wants a mini-task or practice exercise on the current topic — generates short focused challenges adapted to learning type (code, conceptual, or scenario-based)
---

# Challenge — Mini-Tasks

Generates a short, focused exercise on the current topic. Adapts to the learning type.

## Invocation

`/challenge` — picks topic from current context or weak areas
`/challenge [topic]` — specific topic

## Process

1. Read `memory/knowledge_gaps.md` — prefer topics from Weak or Learned
2. Check CLAUDE.md for learning type (project / technology / theory)
3. Generate ONE challenge appropriate to the type
4. Wait for the student's answer
5. Evaluate, explain, update knowledge tracking

## Challenge Types by Learning Type

### Project (code challenges)
```
CHALLENGE: Write a function that...

  Difficulty: [easy / medium / hard]
  Time: ~5-10 minutes
  Hint available: yes (ask if stuck)

  [Clear problem statement]
  [Expected input/output if applicable]
```

Examples:
- "Write a function that creates a TCP socket, binds to port 0, and prints the assigned port"
- "Modify your server loop to handle SIGINT gracefully"

### Technology (scenario challenges)
```
CHALLENGE: You are designing...

  Difficulty: [easy / medium / hard]
  Time: ~5 minutes

  [Real-world scenario description]
  [Question: what would you do / choose / configure?]
```

Examples:
- "Your Kafka consumer group has 6 consumers but only 4 partitions. What happens and how would you fix it?"
- "Your Docker container keeps restarting. Walk me through your debugging steps."

### Theory (conceptual challenges)
```
CHALLENGE: Explain / prove / trace...

  Difficulty: [easy / medium / hard]
  Time: ~5 minutes

  [Problem statement]
```

Examples:
- "Trace quicksort on this array: [3, 6, 1, 8, 2]. Show each partition step."
- "What is the time complexity of finding an element in a balanced BST? Explain why."

## Rules

- ONE challenge per invocation. Keep it focused.
- Always state difficulty and estimated time.
- If the student gets it right — promote topic toward Solid in tracking.
- If wrong — explain, then offer a simpler version of the same concept.
- Never give the answer immediately. Wait for their attempt.
- Offer hints on request, not proactively.
- After completing a challenge, suggest: "Want another? Or continue learning?"
