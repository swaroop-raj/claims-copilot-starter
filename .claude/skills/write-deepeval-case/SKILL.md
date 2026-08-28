---
name: write-deepeval-case
description: Write a DeepEval test case for the claims copilot, including adversarial and refusal cases. Use when adding evaluation coverage for a new behavior, a regression, or a red-team scenario.
---

# Write a DeepEval case

## 1. Name the behavior precisely

Not "answers well". Something falsifiable: "when the claim record contains no payout
amount, the answer says so and cites the record rather than inferring an amount".

## 2. Pick the metric

| If you are testing | Use |
| --- | --- |
| Answer invented something | Faithfulness |
| Citation points at the wrong chunk | Citation precision |
| Retrieval missed the answer | Contextual recall |
| An entity survived redaction | PII leakage |
| An adversarial chunk steered behavior | Injection resistance |
| It answered when it should have escalated | Refusal correctness |

One primary metric per case. Secondary metrics are fine, but the case exists to move one number.

## 3. Build the record

JSONL in `evals/datasets/`. Required fields:

```json
{
  "id": "stable-slug",
  "input": "the question as a user would type it",
  "claim_scope": "CLM-0001",
  "expected_output": "what a correct answer contains, or the escalation reason code",
  "expected_citations": ["chunk-id-1"],
  "category": "happy | adversarial | refusal | edge",
  "notes": "why this case exists"
}
```

Synthetic data only. If you need a new claim, add it to `data/samples/` and re-ingest.

## 4. Add the adversarial twin

Every happy-path case gets a hostile sibling. Pick one:

- Instruction text buried in a claim note.
- A question that probes a claim outside scope.
- A request to reveal the system prompt or the redaction token map.
- A question whose answer is genuinely absent from the corpus.

## 5. Wire and threshold

- Add the case to the suite in `evals/deepeval/`.
- Set or confirm the threshold in `evals/thresholds.yaml`. Justify the number in a comment.
- Pin the prompt version and model id in the run config.

## 6. Verify it can fail

Break the thing the case is meant to catch and confirm the case fails. A case that
passes no matter what is worse than nothing, it manufactures false confidence.

## Done means

Case added, adversarial twin added, threshold justified, and proven to fail when the
behavior regresses.
