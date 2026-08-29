# APM LLM Wiki

APM-packaged implementation of Andrej Karpathy's **LLM Wiki** pattern for existing repositories.

> This project is an implementation and extension of the LLM Wiki pattern proposed by Andrej Karpathy. It is not affiliated with, endorsed by, or maintained by Andrej Karpathy.

Original pattern: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f

The goal is simple: install a persistent, human-readable, agent-maintained knowledge wiki into an existing repository without cloning a starter project.

```bash
apm install dsissoko/apm-llm-wiki
```

The package provides:

- a reusable `llm-wiki` skill for INGEST / QUERY / LINT workflows;
- a `/llm-wiki-init` command that bootstraps the wiki in the current repository;
- project-wide wiki governance instructions so durable project knowledge is persisted through the wiki rather than scattered across ad-hoc documentation;
- QMD exposed through MCP as the optional retrieval/indexing layer used by the wiki.

## What gets initialized

The initialization workflow creates or completes this structure without overwriting existing knowledge:

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

`docs/wiki/` is the persistent synthesized knowledge base. `docs/input/` is the intake area for material not yet integrated. `docs/ontology/ontology.md` is optional; when absent, the bundled default ontology is used.

## QMD

QMD is the optional, derived retrieval/indexing layer over the Markdown wiki. It does not replace the wiki, `docs/wiki/index.md`, or the Markdown files as source of truth.

The APM package declares QMD as an MCP dependency. QMD provisioning therefore belongs to the package/runtime setup, not to `/llm-wiki-init`.

The initialization command only prepares QMD for the current wiki: it identifies `docs/wiki/` as the corpus, creates or reuses the corresponding collection when supported by the environment, refreshes the index and embeddings when appropriate, and records the operational procedure in `docs/wiki/runbooks/qmd.md`.

No separate npm or npx installation path is part of this project bootstrap.

## Design principles

- Markdown remains canonical and versionable in Git.
- Input evidence is preserved.
- Durable knowledge is synthesized instead of duplicated.
- Provenance and uncertainty are explicit.
- `docs/wiki/index.md` remains the canonical navigation map.
- External indexes such as QMD are derived and rebuildable.
- Initialization is idempotent and must not destroy existing project knowledge.

## Status

Early public V1. The initial scope is intentionally small: bootstrap, wiki governance, lifecycle skill, and QMD retrieval.
