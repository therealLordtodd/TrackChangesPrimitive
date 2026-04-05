import Foundation
import Observation

public enum ChangeTrackerMutation: Sendable, Equatable {
    case recorded(ChangeID)
    case accepted(ChangeID)
    case rejected(ChangeID)
    case acceptedAll
    case rejectedAll
}

@MainActor
@Observable
public final class ChangeTracker {
    public var isTracking: Bool
    public var showChanges: ChangeVisibility
    public private(set) var changes: [TrackedChange]
    public var currentAuthor: AuthorID

    private var observers: [UUID: @MainActor (ChangeTrackerMutation) -> Void] = [:]

    public init(
        currentAuthor: AuthorID,
        isTracking: Bool = false,
        showChanges: ChangeVisibility = .showAll
    ) {
        self.currentAuthor = currentAuthor
        self.isTracking = isTracking
        self.showChanges = showChanges
        self.changes = []
    }

    public func recordInsertion(anchor: ChangeAnchor, text: String) {
        guard isTracking else { return }
        let change = TrackedChange(author: currentAuthor, type: .insertion(text: text), anchor: anchor)
        changes.append(change)
        notify(.recorded(change.id))
    }

    public func recordDeletion(anchor: ChangeAnchor, text: String) {
        guard isTracking else { return }
        let change = TrackedChange(author: currentAuthor, type: .deletion(text: text), anchor: anchor)
        changes.append(change)
        notify(.recorded(change.id))
    }

    public func recordFormatChange(anchor: ChangeAnchor, from: [String: String], to: [String: String]) {
        guard isTracking else { return }
        let change = TrackedChange(author: currentAuthor, type: .formatChange(from: from, to: to), anchor: anchor)
        changes.append(change)
        notify(.recorded(change.id))
    }

    public func accept(_ id: ChangeID) {
        changes.removeAll { $0.id == id }
        notify(.accepted(id))
    }

    public func reject(_ id: ChangeID) {
        changes.removeAll { $0.id == id }
        notify(.rejected(id))
    }

    public func acceptAll() {
        changes.removeAll()
        notify(.acceptedAll)
    }

    public func rejectAll() {
        changes.removeAll()
        notify(.rejectedAll)
    }

    public func nextChange(after id: ChangeID?) -> TrackedChange? {
        guard !changes.isEmpty else { return nil }
        guard let id,
              let currentIndex = changes.firstIndex(where: { $0.id == id }),
              currentIndex + 1 < changes.count
        else {
            return changes.first
        }

        return changes[currentIndex + 1]
    }

    public func previousChange(before id: ChangeID?) -> TrackedChange? {
        guard !changes.isEmpty else { return nil }
        guard let id,
              let currentIndex = changes.firstIndex(where: { $0.id == id }),
              currentIndex > 0
        else {
            return changes.last
        }

        return changes[currentIndex - 1]
    }

    public var visibleChanges: [TrackedChange] {
        switch showChanges {
        case .showAll:
            changes
        case .showOnlyMine:
            changes.filter { $0.author == currentAuthor }
        case .final_, .original:
            []
        }
    }

    public func changes(by author: AuthorID) -> [TrackedChange] {
        changes.filter { $0.author == author }
    }

    public func addObserver(_ observer: @escaping @MainActor (ChangeTrackerMutation) -> Void) -> UUID {
        let id = UUID()
        observers[id] = observer
        return id
    }

    public func removeObserver(_ id: UUID) {
        observers.removeValue(forKey: id)
    }

    private func notify(_ mutation: ChangeTrackerMutation) {
        for observer in observers.values {
            observer(mutation)
        }
    }
}
