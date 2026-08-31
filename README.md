# APM LLM Wiki

Turn any existing repository into a persistent, agent-maintained knowledge wiki.

**Drop raw resources into `docs/input/`, then ask the agent to ingest the new inputs. The agent maintains `docs/wiki/` for you.** It synthesizes useful knowledge, preserves provenance, updates the wiki index, and records the ingestion. QMD indexing is automatic when the runtime supports the packaged `Stop` hook; on runtimes without hook support, `/llm-wiki-index` is the explicit synchronization fallback when slash prompts are supported.

```text
Drop or create resources in docs/input/
                ↓
         Ask agent to INGEST
                ↓
         Agent maintains wiki
                ↓
           QMD indexing
           ├─ Stop hook → automatic
           └─ No hook   → explicit index refresh
```

This project has two goals:

1. **Implement Andrej Karpathy's [LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)** as a ready-to-use set of agent instructions, skills and workflows.
2. **Make it straightforward to install** in an existing repository as a package using Microsoft's [APM (Agent Package Manager)](https://github.com/microsoft/apm).

> This project is an implementation and extension of the LLM Wiki pattern proposed by Andrej Karpathy. It is not affiliated with, endorsed by, or maintained by Andrej Karpathy.

## Install

Prerequisites:

- Microsoft APM;
- Node.js 22 or newer with npm/npx.

From the repository you want to equip with an LLM Wiki:

```bash
# 1. Install the APM package for Codex
apm install dsissoko/apm-llm-wiki --target codex
apm compile --target codex

# 2. Create the canonical wiki structure
mkdir -p docs/{input,ontology,wiki/runbooks} && touch docs/wiki/{index.md,log.md}

# 3. Initialize the project-local QMD index
npx -y @tobilu/qmd init
npx -y @tobilu/qmd collection add docs/wiki --name wiki
npx -y @tobilu/qmd update
npx -y @tobilu/qmd embed

# 4. Launch Codex
codex
```

The bootstrap is intentionally CLI-driven and deterministic. The agent is not responsible for creating the repository structure or initializing QMD.

After that, normal usage is simple:

```text
Create or drop resources in docs/input/
Ask the agent to ingest them
Query or lint the wiki in natural language
```

The package provides:

- a reusable `llm-wiki` skill for INGEST / QUERY / LINT workflows;
- project-wide wiki governance instructions;
- QMD exposed through MCP as the retrieval/indexing layer;
- an APM-native `Stop` hook that automatically synchronizes QMD after agent activity when `docs/wiki/` actually changed;
- a single optional `/llm-wiki-index` prompt for runtimes that support packaged slash prompts and do not run the Stop hook;
- a project-local QMD index in `.qmd/`, with the `wiki` collection restricted to `docs/wiki/`. `.qmd/` is machine-local state and should not be committed.

## What gets initialized

The deterministic bootstrap creates this structure:

```text
docs/
├── input/
├── ontology/
└── wiki/
    ├── index.md
    ├── log.md
    └── runbooks/
```

`docs/input/` is the normal intake area for raw resources. `docs/wiki/` is the persistent synthesized knowledge base maintained by the agent. `docs/ontology/ontology.md` is optional; when absent, the bundled default ontology is used.

## Command surface

Normal wiki operations use natural language through the `llm-wiki` skill:

- INGEST: ask the agent to ingest one or more resources from `docs/input/`;
- QUERY: ask a question that should use the wiki knowledge base;
- LINT: ask the agent to check wiki consistency.

`/llm-wiki-index` is the only optional slash prompt. It refreshes QMD explicitly on runtimes that support packaged prompts but do not execute the Stop hook. On Codex, the Stop hook normally makes this unnecessary.

## Design principles

- Markdown remains canonical and versionable in Git.
- The current filesystem is authoritative during normal wiki operations; Git history is not used to restore deleted or replaced wiki content unless explicitly requested.
- Input evidence is preserved.
- Durable knowledge is synthesized instead of duplicated.
- Provenance and uncertainty are explicit.
- `docs/wiki/index.md` remains the canonical navigation map.
- QMD is a derived, rebuildable search layer; its `.qmd/` state is local and disposable.
- QMD synchronization is deterministic: automatic through the APM `Stop` hook when supported, otherwise explicit through `/llm-wiki-index` or the equivalent QMD CLI refresh.
- Repository and QMD initialization are deterministic CLI bootstrap operations, not agent workflows.

## Status

Early public V1. The initial scope is intentionally small: deterministic bootstrap, wiki governance, lifecycle skill, QMD retrieval, and deterministic QMD synchronization.
