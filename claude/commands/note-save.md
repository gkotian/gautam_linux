Save or update a note in the Convex knowledge vault. Determine the vault path by running `qmd collection list` and using the path for the `convex` collection.

## Rules

- **FACTS ONLY** — only write what is verified from vault content, user statements, or files you directly read. Do NOT infer, speculate, or use "likely", "probably", "typically".
- Incomplete notes are better than wrong notes.
- Improve structure and clarity only where facts support it.
- Ensure `[[wikilinks]]` to related notes are present and correct.

## Frontmatter — required on every note

```yaml
---
title: <note title>
tags: [<tag1>, <tag2>]
updated: YYYY-MM-DD
---
```

- `updated` always matches the date of the most recent changelog entry.
- Titles containing a colon must be quoted: `title: "Runbook: Some Title"`.
- No `changelog` field in frontmatter — the changelog lives in the note body.

## Note structure

```markdown
---
title: ...
tags: [...]
updated: YYYY-MM-DD
---

# Note Title

> One-line summary blockquote.

## Changelog

| Date | Change |
|------|--------|
| YYYY-MM-DD | What changed (source: user-stated \| <URL> \| <filepath>) |

## Rest of content...
```

- Changelog is a markdown table with two columns: `Date` and `Change`.
- Append a new row on every change — never edit or remove existing rows.
- If the note has no changelog section yet, add it after the summary blockquote.
- New notes: first changelog row is `Initial note created (source: ...)`.

## Steps

1. If updating an existing note: read the current file first with `qmd get "filename.md" -c convex` or directly from the vault path.
2. Apply the change with all facts sourced.
3. Append a new row to the `## Changelog` table with today's date and a description.
4. Update `updated:` in frontmatter to today's date.
5. Write the updated file back to the vault path determined above.
6. Confirm what was changed and why.
7. Run `qmd update && qmd embed` to re-index the vault.
