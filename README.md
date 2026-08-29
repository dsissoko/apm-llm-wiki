# APM LLM Wiki

APM-packaged implementation of Andrej Karpathy's **LLM Wiki** pattern for existing repositories.

The goal is simple: install a persistent, human-readable, agent-maintained knowledge wiki into a repository without cloning a starter project.

```bash
apm install dsissoko/apm-llm-wiki
```

The package provides:

- a reusable `llm-wiki` skill for INGEST / QUERY / LINT workflows;
- a `/llm-wiki-init` command that bootstraps the wiki in the current repository;
- project-wide wiki governance instructions so durable project knowledge is persisted through the wiki rather than scattered across ad-hoc documentation;
- QMD as an optional local retrieval layer exposed through MCP.

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

QMD is an optional, local, derived search index over the Markdown corpus. It does not replace the wiki, `docs/wiki/index.md`, or the Markdown files as source of truth.

The package declares the QMD MCP server. The initialization workflow detects whether `qmd` is available and, when possible, configures a collection for `docs/wiki/`, updates the index, generates embeddings, and records the operational procedure in `docs/wiki/runbooks/qmd.md`.

QMD itself can be installed with:

```bash
npm install -g @tobilu/qmd
```

## Design principles

- Markdown remains canonical and versionable in Git.
- Input evidence is preserved.
- Durable knowledge is synthesized instead of duplicated.
- Provenance and uncertainty are explicit.
- `docs/wiki/index.md` remains the canonical navigation map.
- External indexes such as QMD are derived and rebuildable.
- Initialization is idempotent and must not destroy existing project knowledge.

## Origin

This project is an implementation and extension of the LLM Wiki pattern proposed by Andrej Karpathy. It is not affiliated with or maintained by Andrej Karpathy.

Original pattern: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f

## Status

Early public V1. The initial scope is intentionally small: bootstrap, wiki governance, lifecycle skill, and optional QMD retrieval.
