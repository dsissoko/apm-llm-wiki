---
description: Refresh the local QMD index and embeddings for the LLM Wiki.
---

# Index LLM Wiki

Refresh the project-local QMD index for the LLM Wiki.

This command is the explicit synchronization mechanism for agent runtimes that do not support the packaged APM `Stop` hook.

Run these commands from the repository root, in order:

```bash
npx -y @tobilu/qmd update
npx -y @tobilu/qmd embed
```

Do not initialize QMD, create or rename collections, modify `.qmd/index.yml`, or change the wiki content as part of this command.

If either command fails, report the failure concisely and do not claim that synchronization completed successfully.

On success, report concisely that the local QMD index and embeddings are synchronized with `docs/wiki/`.
