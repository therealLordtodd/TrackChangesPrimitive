# TrackChangesPrimitive — Document Editor Family Membership

This primitive is a member of the Document Editor primitive family. It provides a change-tracking model and observable tracker for author-aware review workflows.

**Note:** TrackChangesPrimitive is one of three primitives (with CommentPrimitive and BookmarkPrimitive) that independently implement an **anchor pattern**. See [family-level convergence question](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md#6-pending-coordinated-changes).

## Conventions This Primitive Participates In

- [x] [shared-types](../CONVENTIONS/shared-types-convention.md) — defines own anchor model (parallel to Comment/Bookmark)
- [ ] [typed-static-constants](../CONVENTIONS/typed-static-constants-convention.md) — not participating
- [x] [document-editor-family-membership](../CONVENTIONS/document-editor-family-membership.md)

## Shared Types This Primitive Defines

- Typed anchors + quote selectors for change-tracking pin points
- Change-tracking model, per-author tracker, observable mutations
- Consumed by: `DocumentPrimitive`, `RichTextEditorKit`, hosts

## Shared Types This Primitive Imports

- (none from the family — Foundation only)

## Siblings That Hard-Depend on This Primitive

- `DocumentPrimitive` — composes track-changes into the document review surface
- `RichTextEditorKit` — re-exports track-changes surface

## Ripple-Analysis Checklist Before Modifying Public API

1. **Anchor model changes**: also consider whether the change should unify with CommentPrimitive's and BookmarkPrimitive's anchor models (family convergence question — §6 of dep audit).
2. Changes to per-author tracking / mutation observability: affects DocumentPrimitive's review surface + any host watching for edits.
3. Consult [dependency audit](../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md).
4. Document ripple impact in the commit/PR.

## Scope of Membership

Applies to modifications of TrackChangesPrimitive's own code. Consumers just importing for their own app are unaffected.
