# TrackChangesPrimitive Working Guide

## Purpose
TrackChangesPrimitive owns portable tracked-change records, author identity, anchors, visibility modes, and the observable `ChangeTracker` used by review UI.

## Key Directories
- `Sources/TrackChangesPrimitive`: Change models and `ChangeTracker`.
- `Tests/TrackChangesPrimitiveTests`: Model and tracker behavior tests.

## Architecture Rules
- Route all user-facing review mutations through `ChangeTracker` so observers receive `ChangeTrackerMutation` events.
- Keep anchors string/range based. Consumers map `ChangeAnchor.blockID`, `offset`, and `length` to their own document model.
- Do not apply document mutations in this package. Accept/reject removes change records; consumers decide how text changes are materialized.
- Preserve `ChangeVisibility.final` as the public convenience for the encoded `.final_` case.

## Testing
- Run `swift test` before committing.
- Add `ChangeTrackerTests` coverage for recording, visibility, navigation, accept/reject, and observers.
- Add Codable/value coverage in `ModelTests` when changing model fields or enum cases.

---

## Family Membership — Document Editor

This primitive is a member of the Document Editor primitive family. It participates in shared conventions and consumes or publishes cross-primitive types used by the rich-text / document / editor stack.

**Before modifying public API, shared conventions, or cross-primitive types, consult:**
- `../RichTextEditorKit/docs/plans/2026-04-19-document-editor-dependency-audit.md` — who depends on whom, who uses which conventions
- `/Users/todd/Building - Apple/Packages/CONVENTIONS/` — shared patterns this primitive participates in
- `./MEMBERSHIP.md` in this primitive's root — specific list of conventions, shared types, and sibling consumers

**Changes that alter public API, shared type definitions, or convention contracts MUST include a ripple-analysis section in the commit or PR description** identifying which siblings could be affected and how.

Standalone consumers (apps just importing this primitive) are unaffected by this discipline — it applies only to modifications to the primitive itself.
