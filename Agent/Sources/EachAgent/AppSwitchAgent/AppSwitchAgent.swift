// MARK: - Module Dependency

import UIKit
import Universe
import Spectrum
import Director
import AgentBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

// MARK: - Body

extension GlobalEntity.Agent {

    public static let appSwitchAgent: AppSwitchAgentInterface = AppSwitchAgent(
        activationLevel: .inactive,
        appStorePageOfThisAppLinkString: nil
    )
}

public protocol AppSwitchAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func setLinkString(key: AppSwitchKey, value: String?) async
    func getLinkString(key: AppSwitchKey) async -> String?
    func switchTo(_ key: AppSwitchKey) async throws
}

fileprivate final actor AppSwitchAgent: AppSwitchAgentInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .appSwitch

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel
    var appStorePageOfThisAppLinkString: String?

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel,
        appStorePageOfThisAppLinkString: String?
    ) {
        self.activationLevel = activationLevel
        self.appStorePageOfThisAppLinkString = appStorePageOfThisAppLinkString
    }

    // MARK: - AppSwitchAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func setLinkString(key: AppSwitchKey, value: String?) async {
        switch key {
        case .appStorePageOfThisApp:
            appStorePageOfThisAppLinkString = value
        }
    }
    func getLinkString(key: AppSwitchKey) async -> String? {
        switch key {
        case .appStorePageOfThisApp:
            appStorePageOfThisAppLinkString
        }
    }

    func switchTo(_ key: AppSwitchKey) async throws {
        let url: URL?
        switch key {
        case .appStorePageOfThisApp:
            if let appStorePageOfThisAppLinkString {
                url = URL(string: appStorePageOfThisAppLinkString)
            } else {
                url = nil
                await logDirector.agentLog(.appSwitch, .error, "appStorePageOfThisAppLinkString is nil.")
            }
        }
        if let url {
            await MainActor.run {
                UIApplication.shared.open(
                    url,
                    options: [:],
                    completionHandler: nil
                )
            }
        } else {
            await logDirector.agentLog(
                .appSwitch,
                .error,
                "URL for key `\(key)` is not found."
            )
        }
    }
}
