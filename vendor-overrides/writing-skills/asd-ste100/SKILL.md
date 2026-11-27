---
name: asd-ste100
description: Write in ASD-STE100 Simplified Technical English, where each word has one meaning and each sentence has one job. Use for AGENTS.md, runbooks, handoffs, skills, procedures, warnings, and any text that a reader must follow exactly.
---

# ASD-STE100 Simplified Technical English

**One word, one meaning. One instruction for each sentence. 20 words for an instruction, 25 words for a description.**

STE removes the second reading of a sentence. It does not add length. If a draft is longer after you apply STE, delete sentences and keep the grammar.

## 1. Sort each block

STE has different rules for text that the reader does and text that the reader only reads. Sort each block before you write it.

| Block | The reader | Write |
| --- | --- | --- |
| Procedure | does the steps: runbook, handoff tasks, skill steps, AGENTS.md rules | Commands in the imperative. 20 words or fewer. One action for each step. |
| Description | learns or decides: summary, PR body, Jira description, review comment, design note | Statements in the present tense. 25 words or fewer. 6 sentences or fewer in a paragraph. |
| Safety | must know a risk before a step | `CAUTION:` or `WARNING:` before the step. See "Safety text". |

A description that is written as commands reads like an instruction manual. When the user asks for STE on a PR body, a Jira epic, or a review comment, use the description rules: say what is true and what changed. Keep commands for the steps that a person must do, for example the steps after a merge.

## 2. Words

- **One term for one thing.** Choose the term at first use, then repeat it. If the first sentence says "build", the same object is not "run", "job", or "pipeline" later.
- **Technical names stay exact.** Identifiers, commands, paths, product names, and the terms in the repo glossary (`CONTEXT.md`) are technical names. Do not translate them or shorten them. Put code in backticks. One backtick span counts as one word.
- **Technical verbs keep the meaning that the tool gives them:** commit, push, merge, rebase, deploy, cherry-pick.
- **For all other words, use the plainest word that has one meaning.** Write "start", not "begin", "commence", or "initiate". Write "use", not "utilize" or "leverage".
- **A command has no "should".** Write "Run the tests", not "You should run the tests". An option is "You can ...".
- **Each pronoun has one possible noun.** If "it", "this", or "they" can point to two nouns, repeat the noun.
- **3 nouns in a cluster at most.** Change "the PR CI authentication step failure" to "the failure of the authentication step in PR CI".
- No contractions. No idioms. No words left out to make a sentence shorter: keep "the", "a", and "that".

## 3. Sentences

- **Condition first, then the action:** "If the build fails, read the end of the log."
- **One instruction for each sentence.** Two actions share a sentence only when the reader does them at the same time.
- **Active voice, with the actor:** "Jenkins inspects the agent image", not "The agent image is inspected".
- **Present tense** for states and for what a tool does: "The script prints the base branch".
- **Put the result in its own sentence:** "Run the script. It prints one branch name."
- **A sentence that is over the limit usually contains a list.** Make it a vertical list. The colon before the list ends the word count.
- No semicolons. Use two sentences.

## 4. Markdown

- A heading is a noun phrase or a command, without an `-ing` verb: "Rollback" or "Find the failing stage", not "Rolling back".
- A command that the reader runs goes in a code block on its own line, not inside a sentence.
- Three or more items or conditions become a vertical list. A mapping becomes a table.
- Each step says how the reader knows that the step is complete, when that is not obvious.
- Quoted text stays exact: log lines, error messages, UI labels, code. The STE rules stop at the quotation marks and the backticks.

## Safety text

Put safety text before the step it applies to. Start with the command or the condition, then give the reason.

- `WARNING:` a risk to a person.
- `CAUTION:` a risk of damage. In software text, use it for an action that destroys data or that you cannot undo: a force push, a delete, a history rewrite, a write to production.
- `NOTE:` information only. A note contains no command.

```markdown
CAUTION: Make sure that the branch has no open PR before you delete it. The delete closes the PR.
```

## Worked examples

**Procedure (runbook).** The draft hides three actions and one condition in one sentence.

> Once the chart has been bumped you'll want to kick off the staging pipeline and keep an eye on it, since it sometimes times out pulling images.

```markdown
1. Push the chart change.
2. Start the `staging-image` job.
3. Monitor the job until the image pull stage is complete.
4. If the image pull stage stops with a timeout, start the job again.
```

**Procedure (handoff).** "Should be good" is a claim without proof. Split what is proved from what is not.

> Fixed the flaky sizing test, should be good now, just needs a rerun to confirm.

```markdown
- The sizing test uses a fixed seed. Proof: commit `3f2a91c`.
- Not verified: the test is stable in Jenkins. Check with: three builds of `delivery/ptk/release/main`.
```

**Procedure (AGENTS.md rule).** State the action that you want, then the reason. One term: "generated file" each time.

> We generally try to avoid touching generated stuff directly since it gets clobbered; better to tweak the template instead.

```markdown
To change a generated file, change its template in `templates/`. The build replaces each generated file.
```

**Description (Jira epic).** The first draft is correct STE for a procedure, but an epic is a description. The reader of an epic decides. The reader does not do steps.

> 1. Read the sizing table. 2. Compare the sizing table with `config.yaml`. 3. Correct each difference.

```markdown
The sizing table and `config.yaml` contain the same values, and each file has its own source. The two files drift. This epic gives the sizing data one source. Each release compiles that source into the two files.
```

## Verify

The draft is complete when each line below is true. Check the three longest sentences by count, not by eye.

- Each instruction has 20 words or fewer. Each description sentence has 25 words or fewer. A backtick span, a hyphenated word, and text in parentheses each count as one word.
- Each step starts with a verb or a condition.
- Each thing has one term in the full text.
- Each pronoun has one possible noun.
- The text has no contraction, no semicolon, and no idiom.
- Each description block contains statements. Commands are only in step lists.
- Each sentence gives a fact, an action, or a risk. Delete each sentence that gives none.

## Reference

For the exact limits, the punctuation rules, and the structure of safety text, read `references/REFERENCE.md` when a sentence is at a limit. The ASD dictionary is not in this skill. Apply its principle: the plainest word, with one meaning.
