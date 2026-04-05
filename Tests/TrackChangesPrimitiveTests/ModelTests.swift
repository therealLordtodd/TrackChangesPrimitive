import Foundation
import Testing
@testable import TrackChangesPrimitive

@Suite("TrackChangesPrimitive Model Tests")
struct ModelTests {
    @Test func changeIDExpressibleByStringLiteral() {
        let id: ChangeID = "change-1"
        #expect(id.rawValue == "change-1")
    }

    @Test func trackedChangeCodableRoundTrip() throws {
        let change = TrackedChange(
            author: "user1",
            type: .insertion(text: "hello"),
            anchor: ChangeAnchor(blockID: "block-1", offset: 0, length: 5)
        )
        let data = try JSONEncoder().encode(change)
        let decoded = try JSONDecoder().decode(TrackedChange.self, from: data)
        #expect(decoded.type == change.type)
        #expect(decoded.anchor == change.anchor)
    }

    @Test func changeTypeEquality() {
        let ins1 = ChangeType.insertion(text: "hello")
        let ins2 = ChangeType.insertion(text: "hello")
        let del = ChangeType.deletion(text: "hello")
        #expect(ins1 == ins2)
        #expect(ins1 != del)
    }

    @Test func changeVisibilityRawValues() {
        #expect(ChangeVisibility.showAll.rawValue == "showAll")
        #expect(ChangeVisibility.showOnlyMine.rawValue == "showOnlyMine")
    }
}
