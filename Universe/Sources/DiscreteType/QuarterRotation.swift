// MARK: - Body

public enum QuarterRotation: Int, Codable, CaseIterable, Hashable, Sendable {

    case identity = 0
    case quarter = 1
    case half = 2
    case threeQuarters = 3

    public var next: QuarterRotation {
        Self(rawValue: (rawValue + 1) % Self.allCases.count)!
    }

    public var prev: QuarterRotation {
        Self(rawValue: (rawValue - 1 + Self.allCases.count) % Self.allCases.count)!
    }
}
