// MARK: - Body

public struct NodeData: Codable, Hashable, Sendable {

    public var origin: Binglet
    public var comboCount: UInt

    public init(origin: Binglet, comboCount: UInt) {
        self.origin = origin
        self.comboCount = comboCount
    }
}
