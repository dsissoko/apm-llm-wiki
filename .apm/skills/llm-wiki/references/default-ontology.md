# Default LLM Wiki Ontology

## Purpose

This is the minimal reference ontology for a general-purpose LLM-maintained knowledge wiki.

It intentionally models knowledge, not workflow. Projects may specialize it when their macro objective requires richer concepts or lifecycle semantics.

## Core Entities

### Source
An external piece of evidence ingested into the knowledge base.

Examples: paper, article, book, transcript, repository, dataset, note, conversation export.

### Topic
A broad area used to organize related knowledge.

### Concept
A distinct idea, mechanism, method, object, or abstraction worth representing independently.

### Claim
A meaningful proposition supported, contradicted, qualified, or discussed by sources.

### Actor
A person, organization, team, project, or other identifiable participant relevant to the knowledge base.

## Core Relations

```text
Source  --supports------> Claim
Source  --contradicts---> Claim
Source  --discusses-----> Concept
Claim   --about----------> Concept
Concept --belongs_to-----> Topic
Concept --related_to-----> Concept
Actor   --associated_with> Source | Claim | Concept | Topic
```

Relations may carry qualifiers such as confidence, date, scope, or context.

## Provenance

For important synthesized knowledge, preserve at minimum:

- source identity
- relationship to the knowledge
- relevant date when temporal context matters

Do not treat a generated wiki page as its own evidence source unless it contains genuinely new human-provided information.

## Uncertainty and Conflict

Conflicting sources are valid knowledge. Do not silently collapse disagreement into a single claim.

Prefer explicit support and contradiction relationships over unsupported synthesized certainty.

## Specialization

This ontology is deliberately small. Extend it when the objective of the knowledge base requires concepts with distinct semantics.

Possible domains include software delivery, scientific research, recipe discovery, investment research, legal analysis, or other knowledge-intensive processes. Specializations may introduce entities, relations, states, transitions, guards, and actions while retaining the generic knowledge concepts where useful.
