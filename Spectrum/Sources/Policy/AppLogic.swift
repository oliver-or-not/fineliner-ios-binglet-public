// MARK: - Module Dependency

// MARK: - Body

public enum AppLogic {

    public static let recentBasicGameResultMaxCount: Int = 100

    public static func isGoodToRequestReview(
        recentResultCount: Int,
        recentAverageFinalScore: Double,
        finalScore: Int
    ) -> Bool {
        if recentResultCount < 10 { return false }
        if Double(finalScore) < recentAverageFinalScore * 2 { return false }
        return true
    }
}
