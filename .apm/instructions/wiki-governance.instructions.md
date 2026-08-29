---
description: Persist durable project knowledge through the LLM Wiki instead of creating parallel ad-hoc documentation.
applyTo: "**"
---

# LLM Wiki Governance

The repository wiki is the canonical persistent knowledge system for durable project knowledge.

When work on this repository produces durable information, integrate it into the wiki using the `llm-wiki` skill rather than creating parallel documentation structures by default.

Durable knowledge includes, for example:

- architectural and design decisions
- operational procedures and runbooks
- setup and maintenance instructions
- technical findings and constraints
- conventions and assumptions
- product or domain knowledge
- decisions that future agents or humans are likely to need again

Use `docs/input/` as an intake area when information is not yet synthesized. Then ingest it into `docs/wiki/`.

Transient conversation, exploratory reasoning, temporary command output, scratch notes, and disposable work-in-progress do not need to be persisted.

Before creating a new documentation location, check whether the information belongs in the existing wiki. Prefer evolving the wiki over creating a second persistent knowledge system.

QMD and other retrieval indexes are derived access layers. They do not replace the Markdown wiki or `docs/wiki/index.md` as the canonical navigation map.
