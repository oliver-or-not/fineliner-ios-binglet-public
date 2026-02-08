// MARK: - Module Dependency

import Foundation
import Universe
import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate let dateAgent = GlobalEntity.Agent.dateAgent
fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
fileprivate let gameCenterAgent = GlobalEntity.Agent.gameCenterAgent
@MainActor fileprivate let appStoreReviewAgent = GlobalEntity.Agent.appStoreReviewAgent
@MainActor fileprivate let hapticFeedbackAgent = GlobalEntity.Agent.hapticFeedbackAgent

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlatePlaceButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlatePlaceButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    let isHapticFeedbackOn = await appStateAgent.getIsHapticFeedbackOn()
    if isHapticFeedbackOn {
        await hapticFeedbackAgent.decisionFeedback()
    }
    let now = await dateAgent.getNowDate()
    let isPossibleToPlaceBingletSomewhere = await basicGamePlate.handlePlaceButtonTap()

    if isPossibleToPlaceBingletSomewhere {

        // MARK: - 스냅샷 저장

        let snapshot = await basicGamePlate.getSnapshot()
        await appStateAgent.setBasicGameSnapshot(snapshot)
    }

    if !isPossibleToPlaceBingletSomewhere {

        // MARK: - 점수 제출

        let finalScore = await basicGamePlate.getGameScore()
        if finalScore > 0 {
            do {
                try await gameCenterAgent.submitScore(finalScore, leaderboardKey: .basicGameGlobalAllTime)
            } catch {
                await logDirector.primeEventLog(.basicGamePlatePlaceButtonTapped, .error, "Failed to submit score; erorr: \(error)")
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

        // MARK: - 스냅샷 저장

        var snapshot = await basicGamePlate.getSnapshot()
        snapshot.gameState = .finished
        snapshot.isResultDialogShown = true
        await appStateAgent.setBasicGameSnapshot(snapshot)

        try? await Task.sleep(nanoseconds: TimeInterval(seconds: 3).nanosecondsUInt64)

        // MARK: - finish 처리

        await basicGamePlate.setGameState(.finished)
        await basicGamePlate.setIsResultDialogShown(true)

        // MARK: - 앱스토어 리뷰 요청

        let scoreSum = recentResultArrayOfBasicGame.reduce(0) { $0 + $1.finalScore }
        let recentAverageFinalScore: Double = recentResultArrayOfBasicGame.isEmpty
        ? 0
        : Double(scoreSum) / Double(recentResultArrayOfBasicGame.count)

        if AppLogic.isGoodToRequestReview(
            recentResultCount: recentResultArrayOfBasicGame.count,
            recentAverageFinalScore: recentAverageFinalScore,
            finalScore: finalScore
        ) {
            try? await Task.sleep(nanoseconds: TimeInterval(seconds: 1).nanosecondsUInt64)

            await appStoreReviewAgent.requestReview()
        }
    }
}
