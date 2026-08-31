---
description: Initialize or repair the LLM Wiki structure in the current repository.
---

# Initialize LLM Wiki

Initialize the LLM Wiki in the current repository using the installed `llm-wiki` skill.

The workflow must be idempotent and non-destructive.

## 1. Inspect before writing

Inspect the repository for:

- existing `docs/input/`
- existing `docs/wiki/`
- existing `docs/ontology/`
- existing `docs/wiki/index.md`
- existing `docs/wiki/log.md`
- existing `docs/wiki/runbooks/qmd.md`

Do not overwrite existing project knowledge.

## 2. Initialize the wiki structure

Create missing directories as needed:

```text
docs/
├── input/
├── ontology/
└── wiki/
    ├── index.md
    ├── log.md
    └── runbooks/
```

If `docs/wiki/index.md` is missing, create a concise initial index explaining that it is the canonical navigation map of the wiki.

If `docs/wiki/log.md` is missing, create it as an append-only activity log and record the initialization.

Do not create `docs/ontology/ontology.md` merely to initialize the project. The bundled default ontology remains active until the project genuinely needs a specialization.

## 3. Persist the QMD runbook in the wiki

Create or update `docs/wiki/runbooks/qmd.md` with project-specific operational knowledge covering:

- what QMD is used for in this repository;
- the indexed wiki path (`docs/wiki/`);
- that QMD is exposed through the APM/MCP setup;
- that QMD collection creation, initial indexing and embedding are initialized explicitly from the CLI before launching the agent runtime;
- how retrieval availability can be verified;
- the rule that Markdown and `docs/wiki/index.md` remain canonical;
- the normal user workflow: place or create raw resources in `docs/input/`, then explicitly ask the agent to ingest the new inputs; the agent maintains `docs/wiki/`;
- that after an INGEST changes `docs/wiki/`, QMD synchronization is automatic on runtimes that support the packaged APM `Stop` hook;
- that runtimes without hook support must use `/llm-wiki-index` explicitly after INGEST.

Do not describe manual editing of `docs/wiki/` as the normal workflow. Users should normally manage input material and let the agent maintain the wiki.

Do not create, modify, update or embed QMD collections as part of this prompt. QMD operational initialization is intentionally handled outside the agent prompt.

Keep this as wiki knowledge rather than creating a parallel `docs/how/` or unrelated runbook tree.

## 4. Verify retrieval if available

If QMD retrieval is already exposed through the current MCP environment, verify non-destructively that the wiki is discoverable.

If QMD retrieval is unavailable, report that fact concisely. Do not attempt to install QMD, create collections, run indexing, or generate embeddings.

## 5. Finish coherently

Update `docs/wiki/index.md` so the QMD runbook is discoverable.

Append an initialization entry to `docs/wiki/log.md` describing what was created or reused.

Report concisely:

- files created or reused;
- whether QMD retrieval is available through the configured MCP;
- any remaining operational limitation.

Do not ask for confirmation for routine safe initialization choices. Ask only when an existing repository structure creates a genuinely ambiguous or destructive choice.
