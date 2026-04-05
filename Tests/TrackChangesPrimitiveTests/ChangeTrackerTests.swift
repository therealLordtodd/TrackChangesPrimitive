import Foundation
import Testing
@testable import TrackChangesPrimitive

@MainActor
@Suite("ChangeTracker Tests")
struct ChangeTrackerTests {
    let anchor = ChangeAnchor(blockID: "block-1", offset: 0, length: 5)

    @Test func recordingRequiresTrackingEnabled() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: false)
        tracker.recordInsertion(anchor: anchor, text: "hello")
        #expect(tracker.changes.isEmpty)
    }

    @Test func recordInsertion() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        tracker.recordInsertion(anchor: anchor, text: "hello")
        #expect(tracker.changes.count == 1)
        if case .insertion(let text) = tracker.changes[0].type {
            #expect(text == "hello")
        } else {
            #expect(Bool(false), "Expected insertion")
        }
    }

    @Test func recordDeletion() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        tracker.recordDeletion(anchor: anchor, text: "world")
        #expect(tracker.changes.count == 1)
        if case .deletion(let text) = tracker.changes[0].type {
            #expect(text == "world")
        } else {
            #expect(Bool(false), "Expected deletion")
        }
    }

    @Test func acceptRemovesChange() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        tracker.recordInsertion(anchor: anchor, text: "hello")
        let id = tracker.changes[0].id
        tracker.accept(id)
        #expect(tracker.changes.isEmpty)
    }

    @Test func rejectRemovesChange() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        tracker.recordInsertion(anchor: anchor, text: "hello")
        let id = tracker.changes[0].id
        tracker.reject(id)
        #expect(tracker.changes.isEmpty)
    }

    @Test func acceptAllClearsChanges() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        tracker.recordInsertion(anchor: anchor, text: "a")
        tracker.recordInsertion(anchor: anchor, text: "b")
        tracker.acceptAll()
        #expect(tracker.changes.isEmpty)
    }

    @Test func rejectAllClearsChanges() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        tracker.recordInsertion(anchor: anchor, text: "a")
        tracker.recordDeletion(anchor: anchor, text: "b")
        tracker.rejectAll()
        #expect(tracker.changes.isEmpty)
    }

    @Test func nextAndPreviousNavigation() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        tracker.recordInsertion(anchor: anchor, text: "a")
        tracker.recordInsertion(anchor: anchor, text: "b")
        tracker.recordInsertion(anchor: anchor, text: "c")
        let first = tracker.nextChange(after: nil)
        let second = tracker.nextChange(after: first?.id)
        let back = tracker.previousChange(before: second?.id)
        #expect(first != nil)
        #expect(second != nil)
        #expect(back?.id == first?.id)
    }

    @Test func visibleChangesFilteredByAuthor() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        tracker.recordInsertion(anchor: anchor, text: "mine")
        tracker.currentAuthor = "user2"
        tracker.recordInsertion(anchor: anchor, text: "theirs")
        tracker.currentAuthor = "user1"
        tracker.showChanges = .showOnlyMine
        #expect(tracker.visibleChanges.count == 1)
    }

    @Test func changesByAuthorFilter() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        tracker.recordInsertion(anchor: anchor, text: "a")
        tracker.currentAuthor = "user2"
        tracker.recordInsertion(anchor: anchor, text: "b")
        #expect(tracker.changes(by: "user1").count == 1)
        #expect(tracker.changes(by: "user2").count == 1)
    }

    @Test func observerNotified() {
        let tracker = ChangeTracker(currentAuthor: "user1", isTracking: true)
        var received: ChangeTrackerMutation?
        _ = tracker.addObserver { mutation in received = mutation }
        tracker.recordInsertion(anchor: anchor, text: "hello")

        if case .recorded = received {
            #expect(Bool(true))
        } else {
            #expect(Bool(false), "Expected .recorded mutation")
        }
    }
}
