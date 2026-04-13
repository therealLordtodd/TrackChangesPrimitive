# TrackChangesPrimitive

TrackChangesPrimitive is a tracked-changes record layer for editors.

It models insertions, deletions, and format changes as explicit records, then gives you a small review engine on top:

- record changes
- filter by visibility
- step through changes
- accept or reject individual changes
- observe tracker mutations

The important boundary is this:

TrackChangesPrimitive does not edit your document for you.

It tracks review records. Your editor owns the actual text or formatting mutations.

## What It Is Good At

- representing tracked changes in a portable, app-owned format
- keeping review state separate from document rendering logic
- filtering by author or review mode
- driving “next change / previous change” review UI
- giving host editors mutation callbacks for collaboration or side effects

## When To Use It

Use TrackChangesPrimitive when your editor already has its own document model and needs a review layer on top.

Good fits:

- rich text editors
- block editors
- structured document tools
- collaborative editing tools that need author-aware change records

## When Not To Use It

- Do not use it if you want a full document engine. This package does not apply changes to your model.
- Do not use it if your editor cannot map content back to anchors like block ID plus offset.
- Do not expect `.accept` or `.reject` to automatically rewrite the document. They only update tracked-change records.

## Installation

Inside this local packages workspace:

```swift
.package(path: "../TrackChangesPrimitive")
```

Then add the library to your target:

```swift
.target(
    name: "MyEditor",
    dependencies: ["TrackChangesPrimitive"]
)
```

## The Main Pieces

| Type | Role |
|---|---|
| `TrackedChange` | One recorded insertion, deletion, or format change |
| `ChangeType` | The kind of change and its payload |
| `ChangeAnchor` | Where the change belongs in your document model |
| `ChangeTracker` | Main `@MainActor` observable tracker |
| `ChangeVisibility` | Review mode: all, mine, final, original |
| `ChangeTrackerMutation` | Mutation callback payload for observers |
| `ChangeID` | Stable string-backed change identity |
| `AuthorID` | String-backed author identity |

## Quick Start

### Record changes

```swift
import TrackChangesPrimitive

let tracker = ChangeTracker(
    currentAuthor: "author-1",
    isTracking: true
)

tracker.recordInsertion(
    anchor: ChangeAnchor(blockID: "para-1", offset: 12, length: 0),
    text: "clear "
)

tracker.recordDeletion(
    anchor: ChangeAnchor(blockID: "para-1", offset: 5, length: 3),
    text: "old"
)

tracker.recordFormatChange(
    anchor: ChangeAnchor(blockID: "para-2", offset: 0, length: 20),
    from: ["font-weight": "normal"],
    to: ["font-weight": "bold"]
)
```

### Navigate through changes

```swift
let first = tracker.nextChange(after: nil)
let second = tracker.nextChange(after: first?.id)
let previous = tracker.previousChange(before: second?.id)
```

### Accept or reject one change

```swift
if let change = tracker.nextChange(after: nil) {
    tracker.accept(change.id)
}
```

### Bulk review

```swift
tracker.acceptAll()
tracker.rejectAll()
```

### Filter by author or visibility mode

```swift
tracker.showChanges = .showOnlyMine
let mine = tracker.visibleChanges

let otherAuthorChanges = tracker.changes(by: "author-2")
```

### Observe tracker mutations

```swift
let observerID = tracker.addObserver { mutation in
    switch mutation {
    case .recorded(let id):
        print("Recorded:", id.rawValue)
    case .accepted(let id):
        print("Accepted:", id.rawValue)
    case .rejected(let id):
        print("Rejected:", id.rawValue)
    case .acceptedAll:
        print("Accepted all")
    case .rejectedAll:
        print("Rejected all")
    }
}

tracker.removeObserver(observerID)
```

## The Host-App Contract

This is the part that matters most.

### Recording flow

1. Your editor detects a user change.
2. Your editor records the corresponding tracked change in `ChangeTracker`.
3. Your editor applies the actual text or format mutation in its own document model.

The tracker does not perform step 3.

### Accept / reject flow

1. A reviewer accepts or rejects a tracked change.
2. `ChangeTracker` removes the record.
3. Your editor decides how that should change the real document.

Examples:

- rejecting an insertion usually means removing that inserted text from the document
- rejecting a deletion usually means restoring deleted text
- accepting a deletion usually means keeping the document as currently rendered and dropping the markup

The package leaves those decisions to the host editor on purpose.

## Visibility Modes

| Mode | `visibleChanges` |
|---|---|
| `.showAll` | All tracked changes |
| `.showOnlyMine` | Only changes for `currentAuthor` |
| `.final` | Empty list |
| `.original` | Empty list |

That looks strange at first, but it is intentional.

For `.final` and `.original`, the host editor is expected to render the document as accepted-all or rejected-all. The visibility mode drives rendering policy, not just the list sidebar.

## How To Wire It Into Host Apps

### Rich text or block editors

- Map your document positions into `ChangeAnchor(blockID:offset:length:)`.
- Use `visibleChanges` for sidebars and review panels.
- Keep rendering logic in your editor, not in the tracker.

### Collaboration features

- Use `AuthorID` consistently across local and remote edits.
- Use `addObserver` to broadcast accept/reject events or audit change activity.

### SwiftUI integration

`ChangeTracker` is `@Observable` and `@MainActor`, so SwiftUI can react directly to tracked changes.

```swift
struct ReviewSidebar: View {
    let tracker: ChangeTracker

    var body: some View {
        List(tracker.visibleChanges) { change in
            Text(change.id.rawValue)
        }
    }
}
```

## Practical Constraints

- `ChangeTracker` is main-actor isolated.
- `isTracking == false` makes record calls no-ops.
- Changes are stored in insertion order.
- Accepting or rejecting a change removes it from the tracker immediately.

## Build

```bash
swift build
swift test
```

Platforms:

- macOS 15+
- iOS 17+
