// MARK: - Module Dependency

import UIKit
import GameKit
import AppTrackingTransparency
import Universe
import Spectrum
import Director
import AgentBase

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent
fileprivate let logDirector = GlobalEntity.Director.log
@MainActor fileprivate let windowModel = GameCenterWindowModel.shared

// MARK: - Body

extension GlobalEntity.Agent {

    public static let gameCenterAgent: GameCenterAgentInterface = GameCenterAgent(
        activationLevel: .inactive,
        basicGameGlobalAllTimeLeaderboardId: nil
    )
}

public protocol GameCenterAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func setLeaderboardId(key: GameCenterLeaderboardKey, value: String?) async
    func getLeaderboardId(key: GameCenterLeaderboardKey) async -> String?

    func isAuthenticated() async -> Bool

    func submitScore(
        _ score: Int,
        leaderboardKey: GameCenterLeaderboardKey
    ) async throws

    func showGraphicInterface() async
}

fileprivate final actor GameCenterAgent: GameCenterAgentInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .gameCenter

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel
    var basicGameGlobalAllTimeLeaderboardId: String?

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel,
        basicGameGlobalAllTimeLeaderboardId: String?
    ) {
        self.activationLevel = activationLevel
        self.basicGameGlobalAllTimeLeaderboardId = basicGameGlobalAllTimeLeaderboardId
    }

    // MARK: - GameCenterAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntityTree.GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func setLeaderboardId(key: GameCenterLeaderboardKey, value: String?) async {
        switch key {
        case .basicGameGlobalAllTime:
            basicGameGlobalAllTimeLeaderboardId = value
        }
    }

    func getLeaderboardId(key: GameCenterLeaderboardKey) async -> String? {
        switch key {
        case .basicGameGlobalAllTime:
            basicGameGlobalAllTimeLeaderboardId
        }
    }

    func isAuthenticated() async -> Bool {
        GKLocalPlayer.local.isAuthenticated
    }

    func submitScore(
        _ score: Int,
        leaderboardKey: GameCenterLeaderboardKey
    ) async throws {
        // 인증 여부 확인
        guard GKLocalPlayer.local.isAuthenticated else {
            await logDirector.agentLog(.gameCenter, .error, "Submit score failed - not authenticated")
            throw GameCenterAgentError.notAuthenticated
        }

        let leaderboardId: String
        switch leaderboardKey {
        case .basicGameGlobalAllTime:
            if let basicGameGlobalAllTimeLeaderboardId {
                leaderboardId = basicGameGlobalAllTimeLeaderboardId
            } else {
                leaderboardId = ""
                await logDirector.agentLog(.gameCenter, .error, "basicGameGlobalAllTimeLeaderboardId is nil.")
            }
        }

        do {
            // 점수 제출
            try await GKLeaderboard.submitScore(
                score,
                context: 0,
                player: GKLocalPlayer.local,
                leaderboardIDs: [leaderboardId]
            )
        } catch {
            await logDirector.agentLog(.gameCenter, .error, "Submit score request failed - \(error)")
            throw GameCenterAgentError.submitScoreRequestFailed
        }
        await logDirector.agentLog(.gameCenter, .default, "Submit score request succeeded; score: \(score)")
    }

    func showGraphicInterface() async {
        await MainActor.run {
            windowModel.gameCenterGraphicInterfaceRequestSignal += 1
        }
    }
}
