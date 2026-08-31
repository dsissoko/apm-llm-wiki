---
name: llm-wiki
description: "Build and maintain a persistent Markdown knowledge wiki inspired by Andrej Karpathy's LLM Wiki pattern. Use when ingesting input material, integrating knowledge into an existing wiki, querying accumulated knowledge, or linting the wiki for coherence."
version: 1.0.0
---

# llm-wiki

## Purpose

This skill defines the behavior for an LLM-maintained wiki: a persistent, human-readable knowledge base that accumulates synthesis over time instead of rediscovering the same input material on every query.

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

`docs/input/` contains external or newly produced information that has not yet been integrated into the wiki ontology.

`docs/wiki/` contains persistent synthesized knowledge maintained by this skill.

`docs/wiki/index.md` is the primary entry point. It must provide a concise catalog of wiki pages with links and short descriptions.

`docs/wiki/log.md` is an append-only chronological log of significant INGEST, QUERY, and LINT operations.

If `docs/ontology/ontology.md` exists, treat it as authoritative. Otherwise use `references/default-ontology.md`.

If required directories or the index/log are missing, initialize them automatically before the first INGEST. Do not create a local ontology merely to initialize the wiki.

## Knowledge Discovery and Indexing

`docs/wiki/index.md` is part of the wiki itself. It is persistent, versioned, human-readable, and remains the canonical navigation map regardless of which retrieval tools are available.

External search/indexing tools may complement navigation. When appropriate, use them for discovery, then read the authoritative Markdown pages before synthesizing an answer.

QMD is one compatible retrieval tool. When QMD is available, it may be used for lexical, semantic, or hybrid discovery over the Markdown corpus. QMD configuration, collection management, indexing, and embedding are operational concerns separate from this lifecycle skill.

Any external search index must be treated as derived and rebuildable. It must not replace `docs/wiki/index.md` or become a source of truth.

## Operations

### INGEST

1. Ensure `docs/wiki/index.md` and `docs/wiki/log.md` exist.
2. Read the active ontology.
3. Read `docs/wiki/index.md` first.
4. Inspect new input and identify the knowledge it contributes.
5. Locate existing pages covering the same concepts or topics.
6. Integrate into existing pages whenever possible.
7. Create a new page only for genuinely new knowledge that deserves its own durable representation.
8. Record provenance for non-trivial claims.
9. Add/update cross-links.
10. Update the index.
11. Append a concise INGEST log entry.

Do not merely summarize each input into a new file.

### QUERY

1. Start with `docs/wiki/index.md`.
2. Discover relevant knowledge using the index, links, repository search, and available retrieval tools.
3. Read authoritative Markdown pages rather than relying on search-result snippets or derived indexes.
4. Traverse related pages when needed.
5. Consult `docs/input/` for provenance, ambiguity, or missing detail.
6. Distinguish established knowledge from inference or unresolved uncertainty.
7. Reuse accumulated synthesis rather than rebuilding it from scratch.
8. Append a concise QUERY log entry when the query materially uses or tests the wiki.

### LINT

Check for duplicate/overlapping pages, contradictions, orphan pages, broken or weak links, unsupported claims, stale summaries, ontology drift, inconsistent naming, and missing/stale index entries.

Repair safe structural issues directly. Record unresolved semantic conflicts explicitly. Append a concise LINT log entry.

### EVOLVE ONTOLOGY

Only evolve the ontology when the current model repeatedly fails to represent accumulated knowledge. Prefer the smallest extension, preserve compatibility where practical, document the reason, and migrate existing pages only when the semantic benefit is clear.

## Rules

- Never delete input evidence solely because its knowledge was synthesized.
- Never fabricate provenance.
- Never create a new page when an existing page can be coherently extended.
- Never rewrite or truncate existing `docs/wiki/log.md` history.
- Keep `docs/wiki/index.md` concise and synchronized.
- Treat external indexes as derived, disposable access layers.
- Do not make wiki validity depend on QMD or another retrieval engine.
- Keep ontology concepts few and composable.
- Treat uncertainty as first-class information.
- Prefer links and explicit relations over repeated prose.
- Keep implementation tooling separate from conceptual ontology.
- Do not ask for confirmation for routine granularity or organization choices when these principles determine a safe, reversible choice; proceed and record the decision. Ask only for genuinely ambiguous or structurally consequential choices.

## Specialization

This skill is domain-independent. Its core INGEST / QUERY / LINT behavior can operate against different project ontologies, including software delivery, scientific research, recipe discovery, investment research, and other knowledge-intensive domains.
