import Universe

// MARK: - Body

public struct ScoreEarningProcessData: Codable, Hashable, Sendable {

    public var bingledNodeMatrix: Matrix<Bool>
    public var leadingComboCount: UInt
    public var earnedScore: Int
    public var areBingledNodesGathered: Bool

    public init(
        bingledNodeMatrix: Matrix<Bool>,
        leadingComboCount: UInt,
        earnedScore: Int,
        areBingledNodesGathered: Bool
    ) {
        self.bingledNodeMatrix = bingledNodeMatrix
        self.leadingComboCount = leadingComboCount
        self.earnedScore = earnedScore
        self.areBingledNodesGathered = areBingledNodesGathered
    }
}
