// MARK: - Module Dependency

import Universe
import Spectrum
import AgentBase

// MARK: - Context

@MainActor fileprivate let stateModel = AppAppearanceStateModel.shared

// MARK: - Body

extension GlobalEntity.Agent {

    public static let appAppearanceAgent: AppAppearanceAgentInterface = AppAppearanceAgent(
        activationLevel: .inactive,
        colorScheme: .unspecified
    )
}

public protocol AppAppearanceAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func getColorScheme() async -> AppColorScheme

    func setColorScheme(_ value: AppColorScheme) async
}

fileprivate final actor AppAppearanceAgent: AppAppearanceAgentInterface {

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .appAppearance

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel
    var colorScheme: AppColorScheme

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel,
        colorScheme: AppColorScheme
    ) {
        self.activationLevel = activationLevel
        self.colorScheme = colorScheme
    }

    // MARK: - AppAppearanceAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func getColorScheme() async -> AppColorScheme {
        colorScheme
    }

    func setColorScheme(_ value: AppColorScheme) async {
        colorScheme = value
        await MainActor.run {
            stateModel.colorScheme = value
        }
    }
}
