# TrackChangesPrimitive

TrackChangesPrimitive provides the review model for insertions, deletions, format changes, and tracked-change navigation.

## Quick Start

```swift
import TrackChangesPrimitive

let tracker = ChangeTracker(currentAuthor: "author-1", isTracking: true)
let anchor = ChangeAnchor(blockID: "intro", offset: 12, length: 0)

tracker.recordInsertion(anchor: anchor, text: "clear ")

let current = tracker.nextChange(after: nil)
if let id = current?.id {
    tracker.accept(id)
}
```

## Key Types
- `TrackedChange`: A recorded insertion, deletion, or format change with author, timestamp, and anchor.
- `ChangeType`: `.insertion(text:)`, `.deletion(text:)`, or `.formatChange(from:to:)`.
- `ChangeAnchor`: Block ID plus offset and length.
- `ChangeVisibility`: `.showAll`, `.showOnlyMine`, `.final`, and `.original`.
- `ChangeTracker`: Observable tracker with recording, navigation, filtering, accept/reject, and observer APIs.

## Common Operations
- Set `tracker.isTracking = true` before recording changes.
- Use `visibleChanges` for UI lists after applying `showChanges`.
- Use `nextChange(after:)` and `previousChange(before:)` for review navigation.
- Register observers with `addObserver(_:)` when a host editor needs mutation callbacks.

## Testing

Run:

```bash
swift test
```
