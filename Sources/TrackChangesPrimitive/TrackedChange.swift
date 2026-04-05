import Foundation

public struct ChangeID: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }

    public init() {
        self.rawValue = UUID().uuidString
    }
}

public struct AuthorID: RawRepresentable, Hashable, Codable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

public enum ChangeType: Codable, Sendable, Equatable {
    case insertion(text: String)
    case deletion(text: String)
    case formatChange(from: [String: String], to: [String: String])
}

public struct ChangeAnchor: Codable, Sendable, Equatable {
    public var blockID: String
    public var offset: Int
    public var length: Int

    public init(blockID: String, offset: Int, length: Int) {
        self.blockID = blockID
        self.offset = offset
        self.length = length
    }
}

public struct TrackedChange: Identifiable, Codable, Sendable, Equatable {
    public let id: ChangeID
    public var author: AuthorID
    public var timestamp: Date
    public var type: ChangeType
    public var anchor: ChangeAnchor

    public init(
        id: ChangeID = ChangeID(),
        author: AuthorID,
        timestamp: Date = Date(),
        type: ChangeType,
        anchor: ChangeAnchor
    ) {
        self.id = id
        self.author = author
        self.timestamp = timestamp
        self.type = type
        self.anchor = anchor
    }
}

public enum ChangeVisibility: String, Codable, Sendable {
    case showAll
    case showOnlyMine
    case final_
    case original

    public static var final: ChangeVisibility { .final_ }
}
