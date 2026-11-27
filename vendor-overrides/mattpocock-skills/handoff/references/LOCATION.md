# Handoff location

The `handoff` skill writes a handoff file and the `load-handoff` skill reads it. Both skills find the path with this file, so they always agree.

## Path

Use the first source that gives a path:

1. The path that the user gives.
2. A path that a rule gives: `AGENTS.md` or `CLAUDE.md`, in the repo or global.
3. The default path: `<main checkout>/.agents/handoffs/<branch>.md`.

## Default path

- `<main checkout>` is the path on the first line of `git worktree list`. If that line ends with `(bare)`, use `git rev-parse --show-toplevel`.
- `<branch>` is the output of `git branch --show-current`. Each `/` in the name makes a subfolder: `feature/PTK-1-x` gives `.agents/handoffs/feature/PTK-1-x.md`.
- If `git branch --show-current` prints nothing (detached HEAD), there is no default path. The skill that reads this file says what to do.

The main checkout holds the files of all worktrees. A file there stays after `git worktree remove`. Two worktrees never share a branch, so they never share a file.

## Ignore file

`.agents/handoffs/.gitignore` contains one line: `*`. The folder ignores itself and all of its subfolders. Other folders in `.agents/`, such as `skills/` and `rules/`, stay tracked.

To check one path, run `git check-ignore` from the folder of that path. A run from a linked worktree on a path in the main checkout fails with exit code 128.

```bash
git -C <folder> check-ignore -q <path>
```

| Exit code | Meaning |
| --- | --- |
| 0 | Git ignores the path. |
| 1 | Git does not ignore the path. |
| 128 | The path is not in a git repo. |
