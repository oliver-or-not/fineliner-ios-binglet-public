// MARK: - Body

public struct BasicGameSnapshot: Codable, Hashable, Sendable {

    public var gameState: GameState
    public var gameScore: Int
    public var gameBoardData: GameBoardData
    public var waitingBingletArray: [Binglet]
    public var isResultDialogShown: Bool
    public var isBeforeRestartDialogShown: Bool

    public var activeBingletProcessData: ActiveBingletProcessData?
    public var bingletActivationCount: UInt
    public var bingletPlacingCount: UInt
    public var scoreEarningProcessData: ScoreEarningProcessData?

    public init(
        gameState: GameState,
        gameScore: Int,
        gameBoardData: GameBoardData,
        waitingBingletArray: [Binglet],
        isResultDialogShown: Bool,
        isBeforeRestartDialogShown: Bool,
        activeBingletProcessData: ActiveBingletProcessData? = nil,
        bingletActivationCount: UInt,
        bingletPlacingCount: UInt,
        scoreEarningProcessData: ScoreEarningProcessData? = nil
    ) {
        self.gameState = gameState
        self.gameScore = gameScore
        self.gameBoardData = gameBoardData
        self.waitingBingletArray = waitingBingletArray
        self.isResultDialogShown = isResultDialogShown
        self.isBeforeRestartDialogShown = isBeforeRestartDialogShown
        self.activeBingletProcessData = activeBingletProcessData
        self.bingletActivationCount = bingletActivationCount
        self.bingletPlacingCount = bingletPlacingCount
        self.scoreEarningProcessData = scoreEarningProcessData
    }
}
