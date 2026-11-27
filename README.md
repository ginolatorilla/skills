# Gino's Agent Skills

My collection of agent skills for software engineering. These are combined from:
- [Skills for Real Engineers](https://github.com/mattpocock/skills) by Matt Pocock
- [Writings Skills](https://github.com/surendranb/writing-skills) by Surendran B
- [Visual Explainer](https://github.com/nicobailon/visual-explainer) by Nico Bailon

Why? Because some agent harnesses like Claude do not allow for plugin skills to be disabled.

## How to use?

Run `./install.sh` and use them in your AI agent harndess.

## Layout

- `vendor/<plugin>/<skill>`: upstream skills, unchanged.
- `vendor-overrides/<plugin>/<skill>`: my modified copies of upstream skills. They replace the vendor skill with the same name.
- `skills/<skill>`: skills that I wrote.

## Skills changed

Stored in `vendor-overrides/`.

- `writing-skills/asd-ste100`
- `writing-skills/google-dev-docs`
- `mattpocock-skills/code-review`
- `mattpocock-skills/grilling`
- `mattpocock-skills/handoff`

## Skills added

Stored in `skills/`.

- `load-handoff`: loads the handoff file that `handoff` wrote for the current branch.
