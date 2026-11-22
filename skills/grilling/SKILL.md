---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map the plan as a **design tree**: each decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are settled: the questions that you can ask now without a guess at an answer that you have not heard. Ask the whole frontier in one round, then wait for the answers. A question whose answer depends on another question in the same round belongs to a later round.

## A round

```markdown
**Q7. <title>**
<the decision, and the fact that makes it a real choice>
a) <option>
b) <option>
Recommend: b. <the reason in one sentence>

---

**Q8. <title>**
<a yes or no decision>
Recommend: yes. <the reason in one sentence>
```

- **Numbers never restart.** Round 2 continues from the last number of round 1. The user answers by number, many rounds later.
- **Letters for options.** The user answers "7: b".
- **A question is a decision.** It earns its place when two answers give two different designs. If one answer is the only sensible one, state it in the question body as a fact and ask the decision behind it.
- **The recommendation is your position.** Give the option that you would defend, also when the user leans the other way. Say the reason. When the user asks you to challenge an idea, the strongest case against it is the recommendation.
- When the user asks for the ask tool, put the frontier into `AskUserQuestion` calls, four questions for each call, with the recommended option first.

## The reply

The user answers in few words. Read the reply this way:

| The user writes | Meaning |
| --- | --- |
| `1,2,5: yes` or `yes to all` | Each recommendation is accepted as written. |
| `3: b` or `3: <text>` | That answer is the decision. Text overrides the options. |
| `yes to all except 4: ...` | 4 has the answer given. The others are accepted. |
| A number that is not in the reply | Still open. Ask it again in the next round. Do not assume the recommendation. |
| A question back ("9: why not yq?") | Not a decision. Answer it, give your recommendation again, and keep 9 open. |
| "Let me pull back on 9" | 9 is open again, and so is each decision below it in the tree. Say which ones. |
| A new fact or constraint | Add it to the tree. It can open new questions and close old ones. |

Each round the answers reshape the tree. Recompute the frontier, then ask the next round.

## Facts

Facts are your job. Decisions are the job of the user.

- When a question needs a fact from the environment (a file, a config, a ticket, a tool), find the fact before you ask. A question that the repo can answer does not go to the user.
- One lookup: do it now. A longer search: give it to a subagent and continue. Only the questions that depend on that search wait for it. Ask the rest of the frontier now.
- When the user states how something works, compare the statement with the code. A difference is a question for the next round: "The code does X. You said Y. Which one is correct?"

## The end

The session is complete when the frontier is empty: each branch of the tree visited, and nothing assumed in silence. Then print the decisions, in the order of the tree:

```markdown
## Decisions

- <decision>. Reason: <why>. Rejected: <the alternative, and why>.

## Open

- <a question that the user chose to defer, and what it blocks>.
```

Ask the user to confirm that this list is the shared understanding. Do not act on the plan until the user confirms.

## Worked example

Round 1, for "move the sizing data out of the Go binary":

```markdown
**Q1. Source format**
The data has comments that people and agents both read. JSON has no comments.
a) YAML, compiled to JSON at build time
b) JSON with a sidecar README
Recommend: a. The comments stay beside the values that they explain.

---

**Q2. Owner of the file**
Two repos read the data. One must own the source.
a) This repo owns it, the other repo consumes a release artifact
b) The other repo owns it
Recommend: a. This repo already runs the compile step.
```

Q3, "Which tool compiles the file?", depends on Q1, so it waits for round 2.

The user replies: `1: yes. 2: a, but how do earlier releases get the file?`

Reading: Q1 is settled as a. Q2 is settled as a. The question about earlier releases is a new branch of the tree. Find how the release branches are built first, because that is a fact. Then round 2 asks Q3 and the new Q4.
