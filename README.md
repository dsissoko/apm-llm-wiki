# APM LLM Wiki

Turn any existing repository into a persistent, agent-maintained knowledge wiki.

**Drop raw resources into `docs/input/`, then ask the agent to ingest the new inputs. The agent maintains `docs/wiki/` for you.** It synthesizes useful knowledge, preserves provenance, updates the wiki index, and records the ingestion. QMD indexing is automatic when the runtime supports the packaged `Stop` hook; on runtimes without hook support, run `/llm-wiki-index` explicitly after ingestion.

```text
Drop or create resources in docs/input/
                ↓
         Ask agent to INGEST
                ↓
         Agent maintains wiki
                ↓
           QMD indexing
           ├─ Stop hook → automatic
           └─ No hook   → /llm-wiki-index
```

This project has two goals:

1. **Implement Andrej Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)** as a ready-to-use set of agent instructions, skills and workflows.
2. **Make it trivial to install** in an existing repository as a package using Microsoft's [APM (Agent Package Manager)](https://github.com/microsoft/apm).

> This project is an implementation and extension of the LLM Wiki pattern proposed by Andrej Karpathy. It is not affiliated with, endorsed by, or maintained by Andrej Karpathy.

## Install

Prerequisites:

- Microsoft APM;
- Node.js 22 or newer with npm/npx.

From the repository you want to equip with an LLM Wiki:

```bash
# 1. Install the APM package
apm install dsissoko/apm-llm-wiki#v1.0.0

# 2. Initialize the project-local QMD index
npx -y @tobilu/qmd init
npx -y @tobilu/qmd collection add docs/wiki --name wiki
npx -y @tobilu/qmd update
npx -y @tobilu/qmd embed

# 3. Launch your agent
```

After installation, initialize the wiki once from your agent:

```text
/llm-wiki-init
```

That's it. Enjoy your wiki by reading it directly or through your agent, which now has access to a fully organized and indexed knowledge base.

The package provides:

- a reusable `llm-wiki` skill for INGEST / QUERY / LINT workflows;
- a `/llm-wiki-init` command that bootstraps the wiki structure in the current repository;
- a `/llm-wiki-index` command that explicitly refreshes the QMD index and embeddings;
- project-wide wiki governance instructions so durable project knowledge is persisted through the wiki rather than scattered across ad-hoc documentation;
- QMD exposed through MCP as the retrieval/indexing layer used by the wiki;
- an APM-native `Stop` hook that automatically synchronizes QMD after agent activity when `docs/wiki/` actually changed; agent runtimes that do not support APM hooks can trigger the same QMD refresh explicitly with `/llm-wiki-index`;
- a project-local QMD index in `.qmd/`, with the `wiki` collection restricted to `docs/wiki/`. QMD may store an absolute local path in this configuration; `.qmd/` is machine-local state and should therefore be added to the consuming project's `.gitignore` rather than committed.

## What gets initialized

The `/llm-wiki-init` workflow creates or completes this structure without overwriting existing knowledge:

```text
docs/
├── input/
├── ontology/
└── wiki/
    ├── index.md
    ├── log.md
    └── runbooks/
        └── qmd.md
```

`docs/input/` is the normal intake area for raw resources. `docs/wiki/` is the persistent synthesized knowledge base maintained by the agent. `docs/ontology/ontology.md` is optional; when absent, the bundled default ontology is used.

## Design principles

- Markdown remains canonical and versionable in Git.
- Input evidence is preserved.
- Durable knowledge is synthesized instead of duplicated.
- Provenance and uncertainty are explicit.
- `docs/wiki/index.md` remains the canonical navigation map.
- QMD is a derived, rebuildable search layer; its `.qmd/` state is local and disposable.
- QMD synchronization is deterministic: automatic through the APM `Stop` hook when supported, otherwise explicit through `/llm-wiki-index`.
- Wiki initialization is idempotent and must not destroy existing project knowledge.

## Status

Early public V1. The initial scope is intentionally small: bootstrap, wiki governance, lifecycle skill, QMD retrieval, and deterministic QMD synchronization.
