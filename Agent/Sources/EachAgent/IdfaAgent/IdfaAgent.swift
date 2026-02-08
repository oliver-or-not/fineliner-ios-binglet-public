// MARK: - Module Dependency

import UIKit
import AppTrackingTransparency
import AdSupport
import Universe
import Spectrum
import Director
import AgentBase

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent

// MARK: - Body

extension GlobalEntity.Agent {

    public static let idfaAgent: IdfaAgentInterface = IdfaAgent(
        activationLevel: .inactive
    )
}

public protocol IdfaAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func currentAuthorizationStatus() async -> ATTrackingManager.AuthorizationStatus

    /// 현재 상태가 .notDetermined 일 때만 호출해야 한다.
    ///
    /// @WaitingForUserInteraction
    func requestAuthorization() async
}

fileprivate final actor IdfaAgent: IdfaAgentInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .idfa

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel
    ) {
        self.activationLevel = activationLevel
    }

    // MARK: - IdfaAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func currentAuthorizationStatus() async -> ATTrackingManager.AuthorizationStatus {
        ATTrackingManager.trackingAuthorizationStatus
    }

    func requestAuthorization() async {
        let newStatus = await ATTrackingManager.requestTrackingAuthorization()
        if newStatus == .authorized {
            Task {
                await primeEventDirector.receive(.mainPlateIdfaAuthorizationGranted)
            }
        } else {
            Task {
                await primeEventDirector.receive(.mainPlateIdfaAuthorizationDenied)
            }
        }
    }
}
