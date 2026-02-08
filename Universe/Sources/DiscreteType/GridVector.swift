// MARK: - Body

public struct GridVector: Codable, Hashable, Sendable {

    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    public static let zero: GridVector = GridVector(x: 0, y: 0)
}

public extension GridVector {

    static func + (lhs: GridVector, rhs: GridVector) -> GridVector {
        return GridVector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: GridVector, rhs: GridVector) -> GridVector {
        return GridVector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
