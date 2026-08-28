# Lessons

Things that went wrong, and the rule that stops them recurring. When the same lesson
shows up a third time, promote it into `.claude/rules/` or a hook.

---

## Template

```
### Short title
**What happened:** the symptom
**Root cause:** the actual reason
**Rule:** the one-line instruction that prevents it
**Promoted to:** rule file, hook, or still just a lesson
```

---

### Seeded lessons from prior projects

### Retrieved text treated as instructions
**What happened:** a claim note containing "ignore previous instructions" changed the answer.
**Root cause:** retrieved chunks were concatenated into the prompt with no delimiter or label.
**Rule:** retrieved content is always wrapped and labeled as untrusted data.
**Promoted to:** `.claude/rules/security-pii.md`

### Bloated instruction files get ignored
**What happened:** a clear rule in CLAUDE.md was skipped repeatedly.
**Root cause:** the file had grown past 400 lines and the rule got lost in the noise.
**Rule:** CLAUDE.md stays under 200 lines. Detail moves to path-scoped rules.
**Promoted to:** `CLAUDE.md`

### Silent partial embedding writes
**What happened:** an interrupted ingest left chunks with null embeddings that retrieval skipped.
**Root cause:** embedding batches were written per-record instead of per-batch transaction.
**Rule:** never partially write an embedding batch.
**Promoted to:** `.claude/rules/data-pipeline.md`
