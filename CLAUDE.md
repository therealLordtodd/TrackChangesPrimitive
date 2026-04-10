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
