// MARK: - Module Dependency

import Foundation

// MARK: - Body

/// 게임의 결과.
public struct BasicGameResult: Codable, Sendable {

    public var finishedDate: Date
    public var finalScore: Int

    public init(
        finishedDate: Date,
        finalScore: Int
    ) {
        self.finishedDate = finishedDate
        self.finalScore = finalScore
    }
}
