---
name: llm-wiki
description: "Build and maintain a persistent Markdown knowledge wiki inspired by Andrej Karpathy's LLM Wiki pattern. Use when ingesting input material, integrating knowledge into an existing wiki, querying accumulated knowledge, or linting the wiki for coherence."
version: 1.0.0
---

# llm-wiki

## Purpose

This skill defines the behavior for an LLM-maintained wiki: a persistent, human-readable knowledge base that accumulates synthesis over time instead of rediscovering the same input material on every query.

The normal workflow is simple: users or agents place raw resources in `docs/input/`, then ask the agent to ingest the new inputs. The agent maintains `docs/wiki/` by synthesizing useful knowledge, preserving provenance, updating the index, and recording the ingestion. Users should not normally need to edit wiki pages directly.

After the wiki changes, QMD synchronization is automatic when the current runtime supports the packaged `Stop` hook. On runtimes without hook support, `/llm-wiki-index` is the explicit synchronization fallback when slash prompts are supported; otherwise run the equivalent QMD CLI commands documented by the project.

Input material remains available as evidence, while the wiki stores durable synthesized knowledge, explicit relationships, provenance, a navigable index, and an append-only activity log.

The default conceptual model is defined in `references/default-ontology.md`.

## Core Principles

1. **Persistent synthesis** — integrate useful knowledge into durable Markdown pages.
2. **Input material remains evidence** — do not rewrite input material to make it fit the wiki.
3. **Synthesize before duplicating** — update an existing concept or topic when appropriate instead of creating near-duplicates.
4. **Preserve provenance** — important claims must remain traceable to one or more inputs.
5. **Prefer explicit relationships** — connect related concepts, claims, inputs, people, organizations, and topics.
6. **Human-readable first** — the wiki must remain understandable and editable without specialized tooling.
7. **Ontology is project-specific** — use the default ontology as a starting point, then respect any project-local ontology that supersedes it.
8. **Index first** — `docs/wiki/index.md` is the primary entry point into the accumulated wiki.
9. **Keep an activity trail** — record INGEST, QUERY, and LINT operations in `docs/wiki/log.md`.
10. **Current filesystem is authoritative** — operate on the files that currently exist in the working tree. Do not restore, reconstruct, or merge wiki content from Git history, `HEAD`, another branch, or deleted files unless the user explicitly asks for that recovery.

## Default Repository Structure

Unless explicitly overridden, use these paths relative to the repository root:

```text
docs/
├── input/
├── wiki/
│   ├── index.md
│   ├── log.md
│   └── ...
└── ontology/
    └── ontology.md
```

Default paths:

- `input_path`: `docs/input/`
- `wiki_path`: `docs/wiki/`
- `index_path`: `docs/wiki/index.md`
- `log_path`: `docs/wiki/log.md`
- `ontology_path`: `docs/ontology/`

`docs/input/` is the normal intake area for raw, external, or newly produced information that has not yet been synthesized into the wiki.

`docs/wiki/` contains persistent synthesized knowledge maintained by this skill. It is normally maintained by the agent, not manually by the user.

`docs/wiki/index.md` is the primary entry point. It must provide a concise catalog of wiki pages with links and short descriptions.

`docs/wiki/log.md` is an append-only chronological log of significant INGEST, QUERY, and LINT operations.

If `docs/ontology/ontology.md` exists, treat it as authoritative. Otherwise use `references/default-ontology.md`.

The repository structure and QMD index are expected to be bootstrapped deterministically before normal use. If required directories or `docs/wiki/index.md` / `docs/wiki/log.md` are missing, report the incomplete bootstrap instead of attempting to recover prior versions from Git history.

## Knowledge Discovery and Indexing

`docs/wiki/index.md` is part of the wiki itself. It is persistent, versioned, human-readable, and remains the canonical navigation map regardless of which retrieval tools are available.

External search/indexing tools may complement navigation. When appropriate, use them for discovery, then read the authoritative Markdown pages before synthesizing an answer.

QMD is one compatible retrieval tool. When QMD is available, it may be used for lexical, semantic, or hybrid discovery over the Markdown corpus. QMD configuration, collection management, indexing, and embedding are operational concerns separate from this lifecycle skill.

Any external search index must be treated as derived and rebuildable. It must not replace `docs/wiki/index.md` or become a source of truth.

## Operations

### INGEST

1. Verify that `docs/wiki/index.md` and `docs/wiki/log.md` exist in the current filesystem.
2. Read the active ontology.
3. Read the current `docs/wiki/index.md` first.
4. Inspect new or changed material currently present in `docs/input/` and identify the knowledge it contributes.
5. Locate currently existing wiki pages covering the same concepts or topics.
6. Integrate into existing pages whenever possible.
7. Create a new page only for genuinely new knowledge that deserves its own durable representation.
8. Record provenance for non-trivial claims.
9. Add/update cross-links only to pages and inputs that currently exist, unless a deliberately unresolved reference is clearly marked as such.
10. Update the current index.
11. Append a concise INGEST log entry to the current log.

Do not merely summarize each input into a new file.

Do not use `git show`, `git checkout`, `git restore`, another branch, a previous commit, or any other Git history source to repopulate the wiki during normal INGEST. A file deleted or replaced in the current working tree is absent by design unless the user explicitly requests recovery.

After INGEST changes `docs/wiki/`, do not manually run QMD synchronization when the current runtime supports the packaged `Stop` hook; the hook handles it automatically. If the runtime does not support the hook, use `/llm-wiki-index` when supported or run the equivalent documented QMD CLI refresh explicitly.

### QUERY

1. Start with the current `docs/wiki/index.md`.
2. Discover relevant knowledge using the index, links, repository search, and available retrieval tools.
3. Read authoritative Markdown pages rather than relying on search-result snippets or derived indexes.
4. Traverse related pages when needed.
5. Consult current `docs/input/` for provenance, ambiguity, or missing detail.
6. Distinguish established knowledge from inference or unresolved uncertainty.
7. Reuse accumulated synthesis rather than rebuilding it from scratch.
8. Append a concise QUERY log entry when the query materially uses or tests the wiki.

### LINT

Check the current wiki for duplicate/overlapping pages, contradictions, orphan pages, broken or weak links, unsupported claims, stale summaries, ontology drift, inconsistent naming, and missing/stale index entries.

Repair safe structural issues directly. Record unresolved semantic conflicts explicitly. Append a concise LINT log entry.

Do not restore deleted content from Git history as part of LINT unless explicitly asked.

### EVOLVE ONTOLOGY

Only evolve the ontology when the current model repeatedly fails to represent accumulated knowledge. Prefer the smallest extension, preserve compatibility where practical, document the reason, and migrate existing pages only when the semantic benefit is clear.

## Rules

- Never delete input evidence solely because its knowledge was synthesized.
- Never fabricate provenance.
- Never create a new page when an existing current page can be coherently extended.
- Never rewrite or truncate existing `docs/wiki/log.md` history that is present in the current filesystem.
- Never restore wiki content from Git history unless the user explicitly requests recovery.
- Keep `docs/wiki/index.md` concise and synchronized with the current filesystem.
- Treat external indexes as derived, disposable access layers.
- Do not make wiki validity depend on QMD or another retrieval engine.
- Keep ontology concepts few and composable.
- Treat uncertainty as first-class information.
- Prefer links and explicit relations over repeated prose.
- Keep implementation tooling separate from conceptual ontology.
- Do not ask for confirmation for routine granularity or organization choices when these principles determine a safe, reversible choice; proceed and record the decision. Ask only for genuinely ambiguous or structurally consequential choices.

## Specialization

This skill is domain-independent. Its core INGEST / QUERY / LINT behavior can operate against different project ontologies, including software delivery, scientific research, recipe discovery, investment research, and other knowledge-intensive domains.
