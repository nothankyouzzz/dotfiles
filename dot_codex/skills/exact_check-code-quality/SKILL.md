---
name: check-code-quality
description: >
  Automatically reviews code for error handling and comment quality during
  any review phase. Trigger whenever the user asks to review or check code
  that has just been written — including explicit /review commands. Runs
  both checks together as a single pass without waiting to be asked separately.
---

# check-code-quality

## Why

Two failure modes tend to survive code review because they are quiet.
Bad error handling doesn't look broken — it looks defensive. Missing
contracts don't look wrong — the code still compiles and reads cleanly.
Both degrade a codebase slowly: silent failures hide bugs until the worst
moment, and unmarked contracts leave the next reader without the context
they need to avoid breaking things.

This check exists because these patterns feel safe when written and only
reveal their cost later.

---

## Part I: Error Handling

### Failure Modes

- **Silent swallowing**: catching an exception and continuing as if
  nothing happened, with no log, metric, or signal to the caller.
- **Wrong layer recovery**: handling an error at a scope that lacks the
  context to resolve it correctly, hiding it from the layer that could.
- **Graceful degradation without visibility**: falling back to a default
  result without informing the caller the result may be degraded.
- **Optimistic assumptions**: no handling for missing keys, null values,
  or network failures in paths where they can realistically occur.

### Check

For each error handling site:

1. If this fails silently, who finds out and how? If nobody → silent swallowing.
2. Does this layer have the context to handle this correctly? If not → wrong layer recovery.
3. If a fallback is used, is it observable and is the caller informed? If not → graceful degradation without visibility.
4. Are there realistic failure paths — missing keys, null values, empty responses,
   network failures — with no handling at all? If yes → optimistic assumptions.

High severity + silent visibility is never acceptable. Flag it directly.

---

## Part II: Comment Contracts

### Failure Modes

- **Contract silence**: the dominant failure mode. A real contract exists —
  a non-obvious correctness boundary, a fragile invariant, a known workaround —
  but no comment marks it. The contract is invisible to the next reader.
- **Stale contracts**: a comment that once described a real contract but no
  longer matches the code. Looks authoritative and actively misleads.
- **Retrospective narration**: explaining what happened ("fixed X because Y")
  instead of what must continue to hold going forward.
- **Scatter**: placing a comment away from the exact boundary where the
  contract matters.

### Check

For each non-trivial code site:

1. Is there a contract the code cannot express on its own? If yes and unmarked → contract silence.
2. If a comment exists — does it still match the current code? If not → stale contract.
3. If a comment exists — is it forward-looking and at the exact boundary? If not → retrospective narration or scatter.

---

## Report

Present findings in a single pass. Flag only real violations.

If code is sound:
> Error handling and comments look clean — failures surface explicitly and contracts are marked where needed.

If violations exist:
> **Error Handling** — `fetchUser()` line 42
> Problem: exception caught and swallowed, caller receives stale data silently.
> Risk: upstream code assumes fresh data; bug surfaces only under load.
> Fix: propagate the error or mark the result as degraded before returning.

> **Comments** — `processQueue()` line 87
> Problem: WARN: comment describes the old retry logic, removed in last refactor.
> Risk: reader trusts the warning and avoids a change that is now safe.
> Fix: update or remove the comment to reflect current behavior.

## Done When

Every error handling site either surfaces failures visibly or uses an
observable fallback. Every real contract is marked at the exact boundary
where it matters, and no existing comment misrepresents current behavior.
