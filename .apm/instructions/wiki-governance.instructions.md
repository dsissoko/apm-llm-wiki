---
description: Persist durable project knowledge through the LLM Wiki instead of creating parallel ad-hoc documentation.
applyTo: "**"
---

# LLM Wiki Governance

The repository wiki is the canonical persistent knowledge system for durable project knowledge.

The normal workflow is input-first: users or agents place raw resources in `docs/input/`, then explicitly ask the agent to ingest the new inputs. The `llm-wiki` skill is responsible for maintaining `docs/wiki/`, including synthesis, provenance, cross-links, `docs/wiki/index.md`, and `docs/wiki/log.md`. Users should not normally need to edit `docs/wiki/` manually.

When work on this repository produces durable information, prefer putting the source material in `docs/input/` and ingesting it through the `llm-wiki` skill rather than creating parallel documentation structures by default.

Durable knowledge includes, for example:

- architectural and design decisions
- operational procedures and runbooks
- setup and maintenance instructions
- technical findings and constraints
- conventions and assumptions
- product or domain knowledge
- decisions that future agents or humans are likely to need again

Transient conversation, exploratory reasoning, temporary command output, scratch notes, and disposable work-in-progress do not need to be persisted.

Before creating a new documentation location, check whether the information belongs in the existing wiki. Prefer evolving the wiki over creating a second persistent knowledge system.

After an INGEST changes `docs/wiki/`, QMD synchronization is automatic when the current runtime supports the packaged APM `Stop` hook. On runtimes without hook support, run `/llm-wiki-index` explicitly.

QMD and other retrieval indexes are derived access layers. They do not replace the Markdown wiki or `docs/wiki/index.md` as the canonical navigation map.
