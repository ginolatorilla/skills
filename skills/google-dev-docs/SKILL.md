---
name: google-dev-docs
description: Write developer-facing text in the Google developer documentation style. Use for PR descriptions, Jira issues and epics, review comments, READMEs, reference docs, tutorials, and error messages.
---

# Google developer documentation style

**Say what the reader needs in the order the reader needs it. Second person, present tense, active voice.**

The first sentence carries the result. A reader who stops after it knows what changed, or what to do, and why.

## Who decides what

- **Which style a text gets:** the CLAUDE.md Defaults, or the style that the user names in the request. This skill does not decide that.
- **The shape of the text:** the skill that produces it. `pr` owns the PR body. `inline-comments` owns the review comment. When no skill gives a shape, use "Shapes" below.
- **The sentences and the words:** this skill, always.

## Sentences and words

1. **Second person.** The reader is "you". The product, the job, or the change is the subject of everything else: "The `release` job publishes the chart."
2. **Active voice, with the actor.** "The server rejects the token", not "The token is rejected".
3. **Present tense** for what software does: "returns", not "will return".
4. **Condition before instruction.** "To publish a snapshot, run `make snapshot`", not "Run `make snapshot` to publish a snapshot".
5. **Name the thing.** Each "this", "that", and "it" points to one noun in the same sentence or the one before.
6. **One term for one thing** across the text, the code, and the UI.
7. **Code font** for identifiers, commands, paths, and values. **Bold** for UI labels.
8. **Numbered list** for a sequence. **Bulleted list** for everything else. Serial commas.
9. **Link text names the target:** "see the [release runbook](...)", not "see [here](...)".
10. **Start with the content.** Delete "This PR", "This document describes", "In this section", "Note that", "simply", "just", and "easily".

## Headings

Sentence case for every heading and title.

- A task heading starts with a bare infinitive: "Create an instance", not "Creating an instance".
- A concept heading is a noun phrase that does not start with an `-ing` verb: "Migration to Helm 4", not "Migrating to Helm 4".

## Concise

The limit on length is the number of decisions that the reader makes, not the amount of work that was done.

- Keep what the reader cannot get from the diff, the ticket, or the code: the reason, the proof, and the action that the reader must do next.
- Delete what repeats the diff, the history of how you got there, and each sentence that the reader can remove without a question.
- When the user says "concise", the text has one paragraph or one short list for each decision. Do not add a section to hold one sentence.
- Add a diagram only when the user asks for one.

## Shapes

Use these when no other skill gives the shape.

| Text | Shape |
| --- | --- |
| Jira epic | One paragraph: the problem, the result when the epic is complete, and the boundary (what is out). Links to the design. No task list: the child issues are the task list. |
| Jira issue | `Summary`: one or two sentences, what and why. `Acceptance criteria`: a list where each line is a check that a person can run or see. |
| README or how-to | Title that states the goal. Prerequisites. Numbered steps, each with its command. A last step that shows the result. |
| Reference | One entry for each item, all entries in the same order: what it is, type and default, one example. |
| Error message | What went wrong, then what the user does to fix it. No apology, no blame. |

## Worked examples

**PR description.** The draft tells the story of the work. The reviewer needs the change, the reason, and the proof.

> This PR is a follow-up to the investigation we did last week into why PR builds were failing. After looking into it we found that the CI wasn't authenticating properly, so I've gone ahead and added a login step which should hopefully fix the issue going forward.

```markdown
PR builds failed at `helm dependency build` because the PR stage did not authenticate against `helm-snapshots`. The stage now logs in with the same credential as the release stage.

Verified: PR build #212 passes the dependency stage.
```

**Jira epic.** One paragraph. The reader decides whether to fund it and what is out.

```markdown
The sizing table and `config.yaml` hold the same values in two places, and they drift between releases. This epic gives the sizing data one source that each release compiles into both files. Changes to how the sizer uses the data are out of scope. Design: DSN-0001.
```

**Jira issue.** Each criterion is a check, not an activity.

```markdown
Summary: The release job fails when the sizing source and `config.yaml` differ, so drift cannot reach a release.

Acceptance criteria:
- The release job has a stage that compares the two files.
- A difference fails the build and prints the keys that differ.
- The stage passes on the current `main`.
```

Weak criterion: "Investigate the drift." It has no result that a person can check.

**Error message.**

> Error: invalid configuration detected, please check your settings and try again.

```text
`sizing.yaml` has no `platform.memory` key. Add the key, or run `make sizing-defaults` to generate the file.
```

## Verify

The text is complete when each line below is true.

- The first sentence states the result or the goal.
- Each sentence that describes software is in the present tense and has an actor.
- Each instruction puts its condition first.
- Each heading is in sentence case, and no heading starts with an `-ing` verb.
- Each code identifier is in code font, and each name matches the code.
- Each sentence that you can delete without a question from the reader is deleted.

## Reference

For numbers, units, ranges, and abbreviations, read `references/REFERENCE.md` when the draft contains one of these.
