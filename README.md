# APM LLM Wiki

Turn any existing repository into a persistent, agent-maintained knowledge wiki.

This project has two goals:

1. **Implement Andrej Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)** as a ready-to-use set of agent instructions, skills and workflows.
2. **Make it trivial to install** in an existing repository as a package using Microsoft's [APM (Agent Package Manager)](https://github.com/microsoft/apm).

> This project is an implementation and extension of the LLM Wiki pattern proposed by Andrej Karpathy. It is not affiliated with, endorsed by, or maintained by Andrej Karpathy.

## Install

Install Microsoft APM, then install this package in the repository you want to equip with an LLM Wiki:

```bash
# Install APM (macOS / Linux)
curl -sSL https://aka.ms/apm-unix | sh

# From your project repository
apm install dsissoko/apm-llm-wiki
```

On Windows, install APM with `irm https://aka.ms/apm-windows | iex`, then run the same `apm install dsissoko/apm-llm-wiki` command from your project repository.

## Example with OpenCode

Assuming OpenCode is already installed, open the project and initialize its wiki:

```bash
cd my-project
opencode

# Then, inside OpenCode:
/llm-wiki-init
```

The package provides:

- a reusable `llm-wiki` skill for INGEST / QUERY / LINT workflows;
- a `/llm-wiki-init` command that bootstraps the wiki in the current repository;
- project-wide wiki governance instructions so durable project knowledge is persisted through the wiki rather than scattered across ad-hoc documentation;
- QMD exposed through MCP as the retrieval/indexing layer used by the wiki.

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

QMD is a derived retrieval/indexing layer over the Markdown wiki. It does not replace the wiki, `docs/wiki/index.md`, or the Markdown files as source of truth.

The APM package declares QMD as an MCP dependency. QMD provisioning therefore belongs to the package/runtime setup, not to `/llm-wiki-init`.

The initialization command prepares QMD for the current wiki: it identifies `docs/wiki/` as the corpus, creates or reuses the corresponding collection when supported by the environment, refreshes the index and embeddings when appropriate, and records the operational procedure in `docs/wiki/runbooks/qmd.md`.

## Design principles

- Markdown remains canonical and versionable in Git.
- Input evidence is preserved.
- Durable knowledge is synthesized instead of duplicated.
- Provenance and uncertainty are explicit.
- `docs/wiki/index.md` remains the canonical navigation map.
- QMD indexes are derived and rebuildable.
- Initialization is idempotent and must not destroy existing project knowledge.

## Status

Early public V1. The initial scope is intentionally small: bootstrap, wiki governance, lifecycle skill, and QMD retrieval.
