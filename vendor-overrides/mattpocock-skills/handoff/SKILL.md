---
name: handoff
description: Write a handoff file so a fresh session can resume the work without this conversation. Use when the user says handoff or hand off, or asks to create or update a handoff file.
argument-hint: "[path] [what the next session will do]"
---

# Handoff

A handoff is a **cold start** document. Its reader is a fresh agent that has this file, the repo, and nothing else. Write every line for that reader.

## Steps

1. **Target.** Find the path with `references/LOCATION.md`.
   - If no source gives a path (detached HEAD), ask the user for a file name in `.agents/handoffs/`.
   - Create the folder of the path. If the path is in `.agents/handoffs/` and `.agents/handoffs/.gitignore` does not exist, create that file with one line: `*`.
   - Run the ignore check in `references/LOCATION.md`. If the exit code is 1, tell the user that git does not ignore the path. Ask before you continue.
   - If the file exists, replace all of it with the current state.

   Done when you have one absolute path that git ignores, or that the user approved.

2. **Read the state from the repo.** Memory of the session is a second source; the repo is the first.

   ```bash
   date +%F
   git rev-parse --show-toplevel
   git branch --show-current
   git status --short
   git worktree list
   git log --oneline -15
   gh pr view --json number,url,state,isDraft,baseRefName 2>/dev/null
   ```

   Done when you can name the repo path, the branch, the worktree, the PR, and every uncommitted file.

3. **Collect the rest from the conversation:** each finished result and its proof, each decision and its reason, each open task, each action the user wants to approve first, each claim that nobody checked.

   If you are a subagent, the brief you received is the conversation. A statement in the brief that has no proof goes under "Not verified".

4. **Write the file** with the template below. Keep every heading, in this order. Write `None.` under a heading that has no content.

5. **Cold start check.** Read the file as its reader. It passes when the file alone answers all four questions:
   - Where do I start? (path, branch, first action)
   - What is finished, and what proves it?
   - What is decided, and why?
   - What must the user approve before I do it?

   Fix each question that fails, then check again.

6. **Report** the file path and the first of the next tasks in two lines. Then end the turn. The next session does the next task.

## Template

```markdown
# Handoff: <topic> (<Jira key or PR number, if any>)

Written <YYYY-MM-DD>. Goal of the next session: <one sentence>.

## Start here

- Repo: `<absolute path>`. Branch: `<branch>`. Worktree: `<path>` or main checkout.
- PR: <URL and state> or none. Jira: <key> or none.
- Uncommitted: <files> or clean.
- First action: <one command to run, or one `path:line` to open>.

## Done (do not redo)

- <result>. Proof: <commit SHA, PR number, or the command that passed>.

## Decisions (settled)

- <decision>. Reason: <why>. Rejected: <the alternative, and why>.

## Next tasks

1. <task>. Files: `<path:line>`. Done when: <a check the reader can run>.
<N>. Delete `<path of this file>`. Ask the user first. Done when: the file does not exist.

## Needs approval

- <action the user must approve first: Jira write, push, PR comment, merge, Jenkins trigger>.
- Delete `<path of this file>` when all other tasks are complete.

## Not verified

- <claim>. Check with: <command or file>.

## Suggested skills

- `<skill name>`: <the next task that uses it>.

## References

- `<path or URL>`: <what it contains>.
```

## Rules

- **Proof decides the section.** Proof is a commit SHA, a PR number, or a command together with the result that the session saw. A result with proof goes under "Done". A result without proof goes under "Not verified" with the command that checks it.
- **Record the session.** "Not verified" holds claims from the session that a next task depends on. A new problem that you see while you write goes under "Next tasks" as one line that starts with `Found during handoff:`. Leave the review of the code to the next session.
- **Point, do not copy.** Specs, plans, ADRs, issues, and commits stay where they are. Give the path or URL under "References". Copy a plan into "Next tasks" only when the user asks you to include it.
- **Order the next tasks** in the sequence the reader must do them. Give each task a "Done when" check.
- **Delete task:** the last task is always the delete task in the template. Put the same action under "Needs approval".
- **Suggested skills:** name each skill that a next task needs. The `load-handoff` skill loads them before the work starts.
- **Style:** the style that the CLAUDE.md Defaults name for handoffs. Load that writing skill before you write.
- **Secrets:** write the name of a credential, never its value.
- **Git:** the handoff file is session scratch. Leave it uncommitted unless the user asks for a commit.

## Delegation

When you give this skill to a subagent, put the finished results, the decisions with their reasons, and the open tasks in its prompt. A subagent cannot see this conversation.
