// MARK: - Body

public enum OctaDirection: Int, CaseIterable, Hashable, Sendable {

    case right = 0
    case upRight = 1
    case up = 2
    case upLeft = 3
    case left = 4
    case downLeft = 5
    case down = 6
    case downRight = 7

    public var unitVector: GridVector {
        switch self {
        case .right: return GridVector(x: 1, y: 0)
        case .upRight: return GridVector(x: 1, y: -1)
        case .up: return GridVector(x: 0, y: -1)
        case .upLeft: return GridVector(x: -1, y: -1)
        case .left: return GridVector(x: -1, y: 0)
        case .downLeft: return GridVector(x: -1, y: 1)
        case .down: return GridVector(x: 0, y: 1)
        case .downRight: return GridVector(x: 1, y: 1)
        }
    }

    public var next: OctaDirection {
        Self(rawValue: (rawValue + 1) % Self.allCases.count)!
    }

    public var prev: OctaDirection {
        Self(rawValue: (rawValue - 1 + Self.allCases.count) % Self.allCases.count)!
    }
}
