// MARK: - Module Dependency

import UIKit
import Universe
import Spectrum
import AgentBase

// MARK: - Body

extension GlobalEntity.Agent {

    @MainActor public static let hapticFeedbackAgent: HapticFeedbackAgentInterface = HapticFeedbackAgent(
        activationLevel: .inactive
    )
}

public protocol HapticFeedbackAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func valueChangeByDragFeedback() async

    func valueChangeByTapFeedback() async

    func decisionFeedback() async

    func warningFeedback() async
}

@MainActor fileprivate final class HapticFeedbackAgent: HapticFeedbackAgentInterface {

    // MARK: - Reference

    private let softImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let heavyImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .hapticFeedback

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel
    ) {
        self.activationLevel = activationLevel
    }

    // MARK: - HapticFeedbackAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func valueChangeByDragFeedback() async {
        softImpactFeedbackGenerator.prepare()
        softImpactFeedbackGenerator.impactOccurred(intensity: 0.65)
    }

    func valueChangeByTapFeedback() async {
        softImpactFeedbackGenerator.prepare()
        softImpactFeedbackGenerator.impactOccurred(intensity: 0.85)
    }

    func decisionFeedback() async {
        heavyImpactFeedbackGenerator.prepare()
        heavyImpactFeedbackGenerator.impactOccurred(intensity: 0.75)
    }

    func warningFeedback() async {
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.error)
    }
}
