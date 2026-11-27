---
name: load-handoff
description: Find and load the handoff file for the current branch, then report where the work stopped.
argument-hint: "[path]"
disable-model-invocation: true
---

# Load handoff

A handoff file is a summary of an earlier session. The `handoff` skill writes it. This skill loads the file and reports. The user decides if the work continues.

## Steps

1. **Find the file.** Read `../handoff/references/LOCATION.md` from the base directory of this skill. Find the path with it.
   - If the path does not exist, or no source gives a path (detached HEAD), list the handoff files, newest first:

     ```bash
     find <main checkout>/.agents/handoffs -type f -name '*.md' -exec ls -t {} +
     ```

   - If the list has files, ask the user which file to load. Recommend the first file.
   - If the list is empty or the folder does not exist, tell the user that no handoff file exists. Then end the turn.

   Done when you have one path that exists.

2. **Read the file** from the start to the end.

3. **Load the skills** under "Suggested skills" with the Skill tool. If the file has no "Suggested skills" section, go to step 4.

   Done when each skill is loaded, or you told the user which skill is not available.

4. **Report** these items, then end the turn:
   - The topic, from the first heading.
   - The "Written" date.
   - The first action, from "Start here".
