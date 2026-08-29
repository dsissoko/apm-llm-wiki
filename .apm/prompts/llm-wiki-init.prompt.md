---
description: Initialize or repair the LLM Wiki and optional QMD retrieval layer in the current repository.
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
- existing QMD configuration or collections

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

## 3. Initialize QMD when available

Check whether the `qmd` executable is available.

If QMD is not installed:

- do not fail the wiki initialization;
- create the QMD runbook described below;
- explain that QMD is optional and can be installed with `npm install -g @tobilu/qmd` (Node.js >= 22 is required by current QMD releases).

If QMD is installed:

1. inspect `qmd collection list` before mutating configuration;
2. ensure there is a collection indexing `docs/wiki/` with a sensible repository-specific name;
3. avoid creating duplicate collections for the same path;
4. run `qmd update` after collection setup;
5. run `qmd embed` to create semantic embeddings when practical;
6. use `qmd status` or `qmd doctor` to verify the setup.

QMD is a derived local retrieval layer. Its index is disposable and must not become canonical project state.

## 4. Persist the QMD runbook in the wiki

Create or update `docs/wiki/runbooks/qmd.md` with project-specific operational knowledge covering:

- what QMD is used for in this repository;
- the exact indexed wiki path;
- installation prerequisites and command;
- how the collection is initialized;
- `qmd update`;
- `qmd embed`;
- `qmd status` and `qmd doctor` diagnostics;
- MCP usage through the installed APM package;
- the rule that Markdown and `docs/wiki/index.md` remain canonical;
- when reindexing is needed after INGEST or substantial wiki changes.

Keep this as wiki knowledge rather than creating a parallel `docs/how/` or unrelated runbook tree.

## 5. Finish coherently

Update `docs/wiki/index.md` so the QMD runbook is discoverable.

Append an INGEST or initialization entry to `docs/wiki/log.md` describing what was created, reused, or configured.

Report concisely:

- files created or reused;
- whether QMD was available;
- whether a QMD collection was created/reused;
- whether indexing/embedding succeeded;
- any remaining manual action.

Do not ask for confirmation for routine safe initialization choices. Ask only when an existing repository structure creates a genuinely ambiguous or destructive choice.
