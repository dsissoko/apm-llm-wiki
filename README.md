# APM LLM Wiki

Turn any existing repository into a persistent, agent-maintained knowledge wiki.

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
apm install dsissoko/apm-llm-wiki

# 2. Initialize the QMD collection for this repository
# Replace <repo> with a stable name for the current repository.
npx -y @tobilu/qmd collection add docs/wiki --name <repo>-wiki \
  && npx -y @tobilu/qmd update \
  && npx -y @tobilu/qmd embed

# 3. Launch OpenCode
opencode
```

Then, inside OpenCode:

```text
/llm-wiki-init
```

QMD does not need to be installed globally. APM configures the MCP integration and QMD is resolved through `npx` when needed.

You can verify the MCP connection with:

```bash
opencode mcp list
```

QMD should appear as connected.

You can verify the local QMD collection and embeddings with:

```bash
npx -y @tobilu/qmd status
```

The package provides:

- a reusable `llm-wiki` skill for INGEST / QUERY / LINT workflows;
- a `/llm-wiki-init` command that bootstraps the wiki structure in the current repository;
- project-wide wiki governance instructions so durable project knowledge is persisted through the wiki rather than scattered across ad-hoc documentation;
- QMD exposed through MCP as the retrieval/indexing layer used by the wiki.

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

`docs/wiki/` is the persistent synthesized knowledge base. `docs/input/` is the intake area for material not yet integrated. `docs/ontology/ontology.md` is optional; when absent, the bundled default ontology is used.

## QMD

QMD is a derived retrieval/indexing layer over the Markdown wiki. It does not replace the wiki, `docs/wiki/index.md`, or the Markdown files as source of truth.

The APM package declares QMD as an MCP dependency and configures the runtime to launch it through `npx`. This makes QMD available without requiring a global `qmd` executable.

QMD initialization is intentionally explicit and deterministic. After installing the APM package, initialize the repository collection from the repository root:

```bash
npx -y @tobilu/qmd collection add docs/wiki --name <repo>-wiki \
  && npx -y @tobilu/qmd update \
  && npx -y @tobilu/qmd embed
```

Replace `<repo>` with a stable name for the current repository.

The `/llm-wiki-init` prompt does not create QMD collections or run indexing/embedding commands. Its responsibility is the Markdown wiki structure and project knowledge bootstrap.

QMD currently requires Node.js 22 or newer. If the MCP server fails to start, verify `node --version` before troubleshooting the OpenCode or APM configuration.

## Design principles

- Markdown remains canonical and versionable in Git.
- Input evidence is preserved.
- Durable knowledge is synthesized instead of duplicated.
- Provenance and uncertainty are explicit.
- `docs/wiki/index.md` remains the canonical navigation map.
- QMD indexes are derived and rebuildable.
- **QMD is runtime-managed, not globally installed.** APM configures the MCP integration; `npx` resolves and executes QMD on demand. QMD may be cached by npm, but no global `qmd` executable is required.
- **QMD initialization is explicit.** Collection creation, indexing and embedding are performed with the documented CLI command before launching the agent runtime.
- Initialization is idempotent and must not destroy existing project knowledge.

## Status

Early public V1. The initial scope is intentionally small: bootstrap, wiki governance, lifecycle skill, and QMD retrieval.
