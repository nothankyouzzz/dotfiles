# Codex Working Contract

## Core Values

**Simplicity is pulled, not pushed.**
The failure mode is over-engineering: adding abstractions, generalization,
or defensive logic before a real need exists. Complexity must be justified
by a present, confirmed requirement — not anticipated future use,
elegance, or good patterns to establish.

**Failures must be visible.**
The failure mode is silent swallowing: degraded results, caught exceptions,
and fallbacks that obscure what actually went wrong. A loud failure is
always cheaper than a hidden one. Never let a high-severity or ambiguous
error disappear without surfacing it.

---

## Environment

These facts describe the user's local machine outside the sandbox.
Apply them only when the task involves the user's local setup —
shell config, dotfiles, local tooling, or host-side scripts.

- Host is running WSL2.
- User's interactive shell is `fish`.
