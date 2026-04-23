# TrackChangesPrimitive — Project Constitution

**Created:** 2026-04-16
**Authors:** Todd Cowing + Claude (Opus 4.7)

This document records the *why* behind foundational decisions. It is written for future collaborators — human and AI — who weren't in the room when these choices were made. The development plan tells you what we're building. AGENTS.md tells you how to build it. This document tells you why we made the decisions we made, and where we believe this is going.

Fill in the project-specific sections as decisions are made. The **Founding Principles** apply to every project in the portfolio without exception — they are the intent behind the work. The **Portfolio-Wide Decisions** are pre-filled conventional choices that follow from those principles; they apply unless explicitly overridden here with a documented reason.

---

## What TrackChangesPrimitive Is Trying to Be

TrackChangesPrimitive is a tracked-changes record layer for editors. It models insertions, deletions, and format changes as explicit records, then provides a small review engine on top — filtering by visibility, navigating next/previous changes, accepting or rejecting individual changes, and observing tracker mutations. The defining boundary is that the package does not edit documents itself — it tracks review records, and the host editor owns the actual text or formatting mutations. The central insight is that separating "what changed and who reviewed it" from "how the document is edited" lets any editor adopt a review layer without forcing a specific document model on it.

---

## Foundational Decisions

### Shared Portfolio Doctrine

The shared founding principles and portfolio-wide defaults now live in the Foundation Libraries wiki:

- `/Users/todd/Library/CloudStorage/GoogleDrive-todd@cowingfamily.com/My Drive/The Commons/Libraries/Foundation Libraries/operations/portfolio-doctrine.md`

Use this local constitution for project-specific decisions, not copied portfolio boilerplate.

---

### Project-Specific Decisions

*Add an entry here for every significant architectural, tooling, or directional decision made for this project. Write it at decision time, not retroactively. Future collaborators need to understand the reasoning, not just the outcome.*

*Initial decisions summarized from CLAUDE.md:*

#### Package Does Not Apply Document Mutations

**Decision:** `accept` and `reject` remove change records; they do not rewrite the host document. Text or format mutations are owned by the host editor.

**Why:** Applying document mutations would require TrackChangesPrimitive to know the shape of every host's document model, which would force a specific editor shape onto consumers. Keeping the package as a record-tracking layer lets rich text editors, block editors, and structured document tools all adopt it without having to conform to a preset model.

**Trade-offs accepted:** Host editors must implement the mutation semantics (reject-insertion removes inserted text, reject-deletion restores it, etc.). Apps without block-ID-plus-offset anchors cannot adopt this primitive directly.

---

#### Anchors Are String/Range-Based

**Decision:** `ChangeAnchor` uses `blockID`, `offset`, and `length`. Consumers map these to their own document model.

**Why:** A portable anchor shape is what lets different document models interoperate with the same review layer. Harder-coded anchors (AST nodes, rich text attributes) would tie the package to specific editor internals.

**Trade-offs accepted:** Consumers must maintain the mapping from their model to `ChangeAnchor` and keep it stable across edits.

---

#### All Review Mutations Route Through `ChangeTracker`

**Decision:** User-facing review operations flow through `ChangeTracker` so observers receive `ChangeTrackerMutation` events for every relevant mutation.

**Why:** Observers power collaboration, audit trails, and side effects. If some review operations bypassed the tracker, those consumers would see a partial picture of review activity.

**Trade-offs accepted:** Contributors must resist "direct" mutations to the change list. Every mutation pays the cost of emitting a mutation event.

---

*Add more entries as decisions are made.*

---

## Tech Stack and Platform Choices

**Platform:** macOS 15+ and iOS 17+ (cross-platform Swift package)
**Primary language:** Swift 6.0
**UI framework:** SwiftUI-friendly (`ChangeTracker` is `@Observable` and `@MainActor`)
**Data layer:** In-memory tracker with Codable change records; durable persistence is owned by the host

**Why this stack:** Review records are small, portable model objects. A focused Swift package with no extra dependencies keeps the primitive cheap to adopt across the portfolio's editor stack while still being SwiftUI-observable out of the box.

---

## Who This Is Built For

*Who are the primary users or operators of this software? Humans, AI agents, or both? This shapes everything from UI density to conductorship defaults.*

[ ] Primarily humans
[ ] Primarily AI agents
[ ] Both, roughly equally
[ ] Both — humans build it, AIs operate it
[X] Both — AIs build it, humans operate it

**Notes:** Foundation primitive. Human reviewers accept and reject changes through host editor UI; AIs build and maintain the package itself and can record or review changes through the same tracker in AI-collaborative editors.

---

## Where This Is Going

[To be filled in as project direction crystallizes.]

---

## Open Questions

*None recorded yet.*

---

## Amendment Process

Use this process whenever a foundational decision changes or a new decision is added.

1. Update the relevant section in this constitution in the same change as the code/docs that motivated the update.
2. For each new or changed decision entry, include:
   - **Decision**
   - **Why**
   - **Trade-offs accepted**
   - **Revisit trigger** (what condition should cause reconsideration)
3. Add a matching row in the **Decision Log** with date and a concise summary.
4. If the amendment changes implementation rules, update `AGENTS.md` and any affected style guide files in the same change.
5. Record who approved the amendment (human + AI collaborator when applicable).

Minor wording clarifications that do not change meaning do not require a new decision entry, but should still be noted in the Decision Log.

---

## Decision Log

*Brief chronological record of significant decisions. Add an entry whenever a non-trivial decision is made that isn't already captured in the sections above.*

| Date | Decision | Decided by |
|------|----------|------------|
| 2026-04-16 | Constitution created and Founding Principles established | Both |
