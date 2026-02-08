// MARK: - Module Dependency

import UIKit
import StoreKit
import Universe
import Spectrum
import Director
import AgentBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

// MARK: - Body

extension GlobalEntity.Agent {

    @MainActor public static let appStoreReviewAgent: AppStoreReviewAgentInterface = AppStoreReviewAgent(
        activationLevel: .inactive
    )
}

public protocol AppStoreReviewAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func requestReview() async
}

@MainActor fileprivate final class AppStoreReviewAgent: AppStoreReviewAgentInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .appStoreReview

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel
    ) {
        self.activationLevel = activationLevel
    }

    // MARK: - AppStoreReviewAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func requestReview() async {
        guard activationLevel == .active else {
            await logDirector.agentLog(.appStoreReview, .default, "Agent is inactive.")
            return
        }
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else {
            await logDirector.agentLog(.appStoreReview, .error, "Scene is not found.")
            return
        }

        AppStore.requestReview(in: scene)
    }
}
