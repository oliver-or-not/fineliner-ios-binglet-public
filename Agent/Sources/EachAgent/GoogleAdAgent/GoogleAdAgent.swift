// MARK: - Module Dependency

import UIKit
@preconcurrency import GoogleMobileAds
import Universe
import Spectrum
import Director
import AgentBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

// MARK: - Body

extension GlobalEntity.Agent {

    public static let googleAdAgent: GoogleAdAgentInterface = GoogleAdAgent(
        activationLevel: .inactive
    )
}

public protocol GoogleAdAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func start() async
}

fileprivate final actor GoogleAdAgent: NSObject, FullScreenContentDelegate, GoogleAdAgentInterface {

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .googleAd

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel
    ) {
        self.activationLevel = activationLevel
    }

    // MARK: - GoogleAdAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func start() async {
        await MobileAds.shared.start()
    }
}
