---
name: code-review
description: "Review the changes since a fixed point (commit, branch, tag, or PR base) along two axes: Standards (does the code follow this repo's documented standards?) and Spec (does the code do what the ticket or spec asked for?). Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to \"review since X\"."
argument-hint: "[PR number | fixed point] [spec path or ticket key]"
---

# Two-axis code review

Review the diff between a **fixed point** and `HEAD` on two axes. Each axis runs in its own subagent, so one axis does not colour the other.

- **Standards:** does the code follow the documented standards of this repo?
- **Spec:** does the code do what the ticket or spec asked for?

The output is a list of numbered **findings**. A finding is a claim with a location and evidence. It is not a fix.

## Steps

1. **Target and fixed point.**
   - A PR number or URL: read the PR, then review it in a worktree, as the CLAUDE.md Defaults say. The fixed point is `origin/<baseRefName>`.

     ```bash
     gh pr view <number> --json number,title,body,baseRefName,headRefName,headRefOid
     git fetch origin <baseRefName>
     git fetch origin pull/<number>/head
     git worktree add --detach <scratch dir>/review-<number> <headRefOid>
     ```

   - A ref from the user (SHA, branch, tag, `HEAD~5`): that ref is the fixed point. Review in the current checkout.
   - Nothing: use the base of the PR of the current branch. If the branch has no PR, use the default branch. Name the fixed point in the report.

   The diff command is `git diff <fixed point>...HEAD` (three dots: the comparison is against the merge base). The commit list is `git log --oneline <fixed point>..HEAD`. To include uncommitted work, use `git diff $(git merge-base <fixed point> HEAD)`. Leave lock files, generated files, and vendored code out with pathspecs.

   Done when `git rev-parse <fixed point>` resolves and the diff command prints changes. A bad ref or an empty diff stops the review here.

2. **Spec source.** The first source that exists wins:
   1. A path or a ticket key from the user.
   2. A ticket key in the branch name, the PR title, or a commit subject. Read a Jira key with the Atlassian MCP tools. Read `#123` with `gh issue view 123`.
   3. A spec or design file that the ticket or the PR body names, or one under `docs/` or `specs/` that matches the branch.
   4. The PR body, as the statement of intent from the author. Label the axis `Spec (PR body only)`.

   If none exists, ask the user one time. If the user has no spec, skip the Spec axis and say so in the report.

3. **Standards sources.** List each file that says how code is written here: `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `CODING_STANDARDS.md`, and the files they point to. Note which rules a linter, a formatter, or CI enforces: the reviewers skip those. The smell baseline at the end of this file applies in every repo.

4. **Start both reviewers in parallel.** Follow the model set for reviewer subagents. A reviewer sees only its brief, so each brief contains:
   - The directory to work in, the diff command, and the commit list.
   - Its sources: the standards files and the smell baseline in full, or the spec text or path.
   - The "Rules of evidence" below, in full.
   - Its task:
     - **Standards:** report each place where the diff breaks a documented standard, with the file and the rule, as `hard`. Report each baseline smell, by name, as `judgement`. A documented standard of the repo overrides the baseline.
     - **Spec:** report three things, and quote the spec line for each:
       - a requirement that is missing or partial
       - a behaviour in the diff that the spec did not ask for
       - a requirement that the diff implements incorrectly

5. **Check each finding.** A finding from a reviewer is a claim. Open its `path:line`. Keep the finding when that line shows what the claim says and the evidence is real. Drop it when the line does not. When both reviewers report the same line and the same claim, keep it one time, under Spec.

   Done when you have opened the line of each finding that you keep.

6. **Report** in the form below, then stop. Remove the worktree: `git worktree remove <scratch dir>/review-<number>`.

## Rules of evidence

Give this block to each reviewer.

```text
- Report only what the diff changed. Code that the diff did not touch is in scope only when the change makes it wrong.
- Each finding has one location: path:line in the new version of the file. For a removed line, give the line in the base version and add "(removed)".
- Each finding has evidence: the rule and where it is written, the spec line in quotation marks, or the input that fails. No evidence, no finding.
- Each finding is one sentence that says what is wrong and what happens because of it.
- Mark each finding hard or judgement. hard: a documented rule or a spec line decides it. judgement: a reasonable reviewer can disagree.
- Give no fix and no rewrite.
- Skip what a linter, a formatter, or CI enforces. Skip praise and personal style.
- Zero findings is a valid result. Say what you checked.
- Output one line for each finding: path:line | hard or judgement | claim | Evidence: ...
```

## Report

```text
Review: <PR or branch>, <fixed point>..<short head SHA>, <n> commits, <n> files
Spec source: <key, path, "PR body only", or "none: Spec axis skipped">

## Standards
1. `path:line` [hard] <claim>. Evidence: <file and rule>.
2. `path:line` [judgement] Possible <smell>: <claim>. Evidence: <what the hunk shows>.

## Spec
3. `path:line` [hard] <claim>. Evidence: "<spec line>".

Summary: Standards <n> hard, <n> judgement. Spec <n> hard, <n> judgement. Dropped <n> after the check.
Worst in Standards: <number>. Worst in Spec: <number>.
```

- Numbers run through both axes and do not restart. Within an axis, `hard` comes first. A number keeps its finding for the rest of the conversation, because the user refers to findings by number.
- The two axes stay in two sections. Name the worst finding in each axis. Do not rank one axis against the other.
- With zero findings, write `No findings.` under the heading and say what the reviewer checked.

## What a finding is

| | Example | Why |
| --- | --- | --- |
| Weak | `pkg/server/server.go`: error handling could be improved. | No line, no evidence, and it points at a fix. |
| Strong, Standards | `pkg/server/server.go:88` [hard] `compile` drops the error from `os.WriteFile`, so a failed write reports success. Evidence: `AGENTS.md`, "Return every error to the caller". | A line, a consequence, a written rule. |
| Strong, Spec | `cmd/cli/main.go:41` [hard] `--strict` defaults to false, so drift passes the build unless the caller sets the flag. Evidence: JIRA-1234, "Drift fails the build by default". | The spec line and the behaviour that differs. |
| Judgement | `pkg/server/server.go:120` [judgement] Possible Data Clumps: `cpu`, `memory`, and `disk` travel together through four signatures. Evidence: lines 120, 141, 163, 190. | A smell is a label on a heuristic, never a violation. |

Some claims have no line, for example a file that the spec requires and the diff does not contain. Put each such claim in the summary as one sentence.

## After the report

- **Fix** only when the user asks, and only the findings that the user names ("fix findings 1, 3, and 4"). Each number keeps its meaning.
- **Explain a fix** when the user asks how to fix a finding. Until then, the report contains no fix.
- **Post** the findings with the `inline-comments` skill. It takes the finding numbers.

## Smell baseline

A fixed set of code smells from Fowler, _Refactoring_, chapter 3. Each one is a `judgement` finding, written as "Possible <name>".

- **Mysterious Name:** a function, variable, or type whose name does not say what it does or holds.
- **Duplicated Code:** the same logic appears in more than one hunk or file of the change.
- **Feature Envy:** a method that uses the data of another object more than its own.
- **Data Clumps:** the same few fields or parameters travel together.
- **Primitive Obsession:** a primitive or a string stands in for a domain concept.
- **Repeated Switches:** the same `switch` or `if` cascade on the same type appears in several places.
- **Shotgun Surgery:** one logical change needs edits in many files.
- **Divergent Change:** one file changes for several unrelated reasons.
- **Speculative Generality:** an abstraction, a parameter, or a hook for a need that the spec does not have.
- **Message Chains:** a long `a.b().c().d()` walk that the caller depends on.
- **Middle Man:** a class or function that only delegates.
- **Refused Bequest:** a subclass that ignores or overrides most of what it inherits.
