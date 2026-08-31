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

# 2. Initialize the project-local QMD index
npx -y @tobilu/qmd init
npx -y @tobilu/qmd collection add docs/wiki --name wiki
npx -y @tobilu/qmd update
npx -y @tobilu/qmd embed

# 3. Launch your agent
```

Then, inside your agent:

```text
/llm-wiki-init
```

QMD does not need to be installed globally. APM configures the MCP integration and QMD is resolved through `npx` when needed.

You can verify the local QMD collection and embeddings with:

```bash
npx -y @tobilu/qmd status
```

The package provides:

- a reusable `llm-wiki` skill for INGEST / QUERY / LINT workflows;
- a `/llm-wiki-init` command that bootstraps the wiki structure in the current repository;
- project-wide wiki governance instructions so durable project knowledge is persisted through the wiki rather than scattered across ad-hoc documentation;
- QMD exposed through MCP as the retrieval/indexing layer used by the wiki;
- an APM-native `Stop` hook that automatically synchronizes QMD after agent activity when `docs/wiki/` actually changed;
- a project-local QMD index in `.qmd/`, with the `wiki` collection restricted to `docs/wiki/`. QMD may store an absolute local path in this configuration; `.qmd/` is machine-local state and should therefore be added to the consuming project's `.gitignore` rather than committed.

The automatic synchronization hook is available only on agent runtimes for which APM supports hooks. Runtimes without APM hook support can still use the wiki and QMD MCP, but do not receive automatic QMD synchronization.

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

QMD is initialized locally for each repository. `qmd init` creates `.qmd/index.yml` and `.qmd/index.sqlite`, and the `wiki` collection indexes only `docs/wiki/`.

The local `.qmd/` directory is disposable machine-local state. It is not canonical project knowledge and should not be committed to Git. Add `.qmd/` to the consuming project's `.gitignore`.

### Automatic synchronization

The package ships an APM-native `Stop` hook. At the end of agent activity, the hook computes a deterministic fingerprint of the Markdown files under `docs/wiki/` and compares it with the last successfully synchronized fingerprint stored in `.qmd/wiki-sync.sha256`.

If the wiki did not change, the hook exits without invoking QMD. If it changed, the hook runs:

```bash
npx -y @tobilu/qmd update
npx -y @tobilu/qmd embed
```

Both QMD operations are incremental. The new fingerprint is recorded only after both operations complete successfully.

The hook is distributed as an APM hook primitive rather than being implemented in the LLM prompt. Automatic synchronization therefore depends on the target runtime supporting APM hooks. OpenCode currently does not support APM hooks and is intentionally not given a runtime-specific workaround.

The `/llm-wiki-init` prompt does not create QMD collections or run indexing/embedding commands. Its responsibility is the Markdown wiki structure and project knowledge bootstrap.

QMD currently requires Node.js 22 or newer. If the MCP server fails to start, verify `node --version` before troubleshooting the agent runtime or APM configuration.

## Design principles

- Markdown remains canonical and versionable in Git.
- Input evidence is preserved.
- Durable knowledge is synthesized instead of duplicated.
- Provenance and uncertainty are explicit.
- `docs/wiki/index.md` remains the canonical navigation map.
- QMD indexes are derived and rebuildable.
- **QMD is runtime-managed, not globally installed.** APM configures the MCP integration; `npx` resolves and executes QMD on demand. QMD may be cached by npm, but no global `qmd` executable is required.
- **QMD state is repository-local and disposable.** `.qmd/` contains local configuration, the derived index and synchronization state, may contain machine-specific absolute paths, and should be gitignored.
- **QMD initialization is explicit.** Local initialization, collection creation, indexing and embedding are performed with the documented CLI commands before launching the agent runtime.
- **QMD synchronization is deterministic.** A supported APM runtime invokes the packaged `Stop` hook; the LLM is not responsible for deciding whether to update the QMD index.
- Wiki initialization is idempotent and must not destroy existing project knowledge.

## Status

Early public V1. The initial scope is intentionally small: bootstrap, wiki governance, lifecycle skill, QMD retrieval, and deterministic QMD synchronization on APM hook-capable runtimes.
