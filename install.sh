#!/bin/bash
set -euo pipefail


SKILL_FOLDERS=(
    "vendor/mattpocock-skills/ask-matt"
    "vendor/mattpocock-skills/code-review"
    "vendor/mattpocock-skills/codebase-design"
    "vendor/mattpocock-skills/diagnosing-bugs"
    "vendor/mattpocock-skills/domain-modeling"
    "vendor/mattpocock-skills/grill-me"
    "vendor/mattpocock-skills/grill-with-docs"
    "vendor/mattpocock-skills/grilling"
    "vendor/mattpocock-skills/handoff"
    "vendor/mattpocock-skills/implement"
    "vendor/mattpocock-skills/improve-codebase-architecture"
    "vendor/mattpocock-skills/prototype"
    "vendor/mattpocock-skills/research"
    "vendor/mattpocock-skills/resolving-merge-conflicts"
    "vendor/mattpocock-skills/setup-matt-pocock-skills"
    "vendor/mattpocock-skills/tdd"
    "vendor/mattpocock-skills/teach"
    "vendor/mattpocock-skills/to-questionnaire"
    "vendor/mattpocock-skills/to-spec"
    "vendor/mattpocock-skills/to-tickets"
    "vendor/mattpocock-skills/triage"
    "vendor/mattpocock-skills/wait-what"
    "vendor/mattpocock-skills/wayfinder"
    "vendor/mattpocock-skills/wizard"
    "vendor/mattpocock-skills/writing-for-agents"
    "vendor/writing-skills/asd-ste100"
    # "vendor/writing-skills/bob-ross"
    # "vendor/writing-skills/business-writing"
    # "vendor/writing-skills/corporate-communication"
    "vendor/writing-skills/google-dev-docs"
    # "vendor/writing-skills/gov-uk-style"
    # "vendor/writing-skills/jack-sparrow"
    # "vendor/writing-skills/journalism-ap"
    # "vendor/writing-skills/orwells-rules"
    # "vendor/writing-skills/paddington"
    # "vendor/writing-skills/plain-language"
    # "vendor/writing-skills/scott-adams"
    # "vendor/writing-skills/shrek"
    # "vendor/writing-skills/ted-lasso"
    # "vendor/writing-skills/winnie-the-pooh"
    # "vendor/writing-skills/yoda"
    "vendor/visual-explainer"
    # Always put skills/ at the bottom so they override the vendors
    "skills/asd-ste100"
    "skills/code-review"
    "skills/google-dev-docs"
    "skills/grilling"
    "skills/handoff"
    "skills/load-handoff"
    "skills/my-writing-style"
)

HARNESSES=(
    # .agents
    .claude
)

for harness in "${HARNESSES[@]}"; do
    mkdir -p "$HOME/$harness/skills"
    for skill_folder in "${SKILL_FOLDERS[@]}"; do
        if [ -d "$skill_folder" ]; then
            echo "Creating symlink for $skill_folder..."
            ln -sf "$PWD/$skill_folder" "$HOME/$harness/skills/"
        else
            echo "Warning: $skill_folder directory not found"
        fi
    done
    echo "Skills are now available in ~/$harness/skills/"
done

echo "Installation complete!"