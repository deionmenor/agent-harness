# PRD

## <PROJECT> — MVP Product Spec

Version 0.1 · <date> · Owner: <OWNER>

This file is the product's scope. Agents build what is here and flag what is not; a request that does not appear below is out of scope until it is added.

Two conventions make it work:

- **Feature IDs.** Every feature gets an ID (`F1`, `F2`, …) and every task in `agent/QUEUE.md` cites one. A reviewer can then check a diff against the product, not against vibes.
- **`[confirm]` items.** Mark anything you have not decided. An agent builds the stated default, says so in the PR, and flags it when it reaches one — rather than blocking the whole queue on a question you can answer later.

## 1. What <PROJECT> is

<A paragraph: the problem, the people, the shape of the product.>

**Core loop:** <one line, the shortest true description of what a user does repeatedly.>

## 2. Users

- <Who they are, how many, what device.>
- <How they sign in.>

## 3. MVP features

All are **must** for the MVP unless marked otherwise. IDs are used in task names, for example `T-004 (F7)`.

### F1. <Feature name>
- <Behaviour, as testable statements.>
- <Empty states, limits, error behaviour. `[confirm the limit]` where you are unsure.>

### F2. <Feature name>
- <Behaviour.>

## 4. Out of scope for the MVP

- <Things a reader would otherwise assume are included. Naming them is what keeps an agent from building them.>

## 5. Done means

The MVP ships when <the last meaningful gap is closed — a walkthrough a real person can complete, not a checklist of screens>. Anything still unverified on a device or in production belongs here, not in a summary.
