// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate let dateAgent = GlobalEntity.Agent.dateAgent
fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
fileprivate let gameCenterAgent = GlobalEntity.Agent.gameCenterAgent

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateBeforeResetDialogResetButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateBeforeResetDialogResetButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    let now = await dateAgent.getNowDate()

    // MARK: - 점수 제출

    let finalScore = await basicGamePlate.getGameScore()
    if finalScore > 0 {
        do {
            try await gameCenterAgent.submitScore(finalScore, leaderboardKey: .basicGameGlobalAllTime)
        } catch {
            await logDirector.primeEventLog(.basicGamePlateBeforeResetDialogResetButtonTapped, .error, "Failed to submit score; erorr: \(error)")
        }
    }

    // MARK: - recentResultArray 갱신

    var recentResultArrayOfBasicGame = await appStateAgent.getRecentResultArrayOfBasicGame()
    recentResultArrayOfBasicGame.append(
        BasicGameResult(
            finishedDate: now,
            finalScore: finalScore
        )
    )
    recentResultArrayOfBasicGame = recentResultArrayOfBasicGame.suffix(
        AppLogic.recentBasicGameResultMaxCount
    )
    await appStateAgent.setRecentResultArrayOfBasicGame(recentResultArrayOfBasicGame)

    await basicGamePlate.resetGame()

    // MARK: - 스냅샷 저장

    let snapshot = await basicGamePlate.getSnapshot()
    await appStateAgent.setBasicGameSnapshot(snapshot)
}
