---
name: check-simplicity
description: >
  Automatically reviews plans and approaches for unnecessary complexity
  before implementation begins. Trigger whenever the user is planning or
  deciding how to approach a problem — even without an explicit review
  request. The goal is to catch over-engineering before it becomes code.
---

# check-simplicity

## Why

Complexity introduced at planning time is the most expensive kind — it
shapes every decision that follows and is rarely revisited once built.
The natural pull of planning is toward completeness: covering edge cases
that might appear, establishing patterns that might be useful, designing
for a future that might arrive. This pull feels responsible. It isn't.

A plan should solve what is actually required right now. Everything else
is a cost paid in advance for a benefit that may never arrive.

## Failure Modes

- **Speculative generalization**: abstractions or layers added for reuse
  that has no confirmed second use case yet.
- **Anticipated requirements**: complexity justified by "we might need
  this later" without a confirmed signal.
- **Elegance bias**: choosing a more sophisticated solution over a simpler
  one because it feels better, not because it solves more.
- **Premature extensibility**: plugin systems or configuration layers added
  before a concrete need for extension exists.

## Check

For each element of the plan:

1. Does this solve the stated problem and nothing more? If not → speculative generalization or anticipated requirements.
2. Is every abstraction justified by a present, confirmed requirement? If not → premature extensibility.
3. Is there a simpler plan that handles what is actually required right now? If yes → elegance bias or over-engineering.

When (3) is yes — propose the simpler alternative. Do not just flag the complexity.

## Report

If the plan is sound:
> Plan looks appropriately scoped — solves X with no speculative additions.

If violations exist:
> Simpler alternative: handle auth with a single middleware function.
> What it drops: the plugin system for future auth strategies.
> Why that's fine: only one auth strategy exists or is confirmed right now.

## Done When

Every element of the plan is either justified by a confirmed present
requirement, or a simpler alternative has been proposed and explained.
