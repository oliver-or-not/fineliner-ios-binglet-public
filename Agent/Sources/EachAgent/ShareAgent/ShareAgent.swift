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
@MainActor fileprivate let windowModel = ShareWindowModel.shared

// MARK: - Body

extension GlobalEntity.Agent {

    public static let shareAgent: ShareAgentInterface = ShareAgent(
        activationLevel: .inactive,
        linkString: nil
    )
}

public protocol ShareAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func setLinkString(value: String?) async
    func getLinkString() async -> String?

    func showDefaultShareSheet() async
    func showShareSheetWithScore(score: Int) async
}

fileprivate final actor ShareAgent: ShareAgentInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .share

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel
    var linkString: String?

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel,
        linkString: String?
    ) {
        self.activationLevel = activationLevel
        self.linkString = linkString
    }

    // MARK: - ShareAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntityTree.GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
    }

    func setLinkString(value: String?) async {
        linkString = value
    }
    func getLinkString() async -> String? {
        linkString
    }

    func showDefaultShareSheet() async {
        let capturedLinkString = linkString
        await MainActor.run {
            windowModel.linkString = capturedLinkString
            windowModel.shareSheetPresentationDefaultRequestSignal += 1
        }
    }

    func showShareSheetWithScore(score: Int) async {
        let capturedLinkString = linkString
        await MainActor.run {
            windowModel.linkString = capturedLinkString
            let signalCounter = windowModel.shareSheetPresentationRequestWithScoreSignal.0
            windowModel.shareSheetPresentationRequestWithScoreSignal = (signalCounter + 1, score)
        }
    }
}
