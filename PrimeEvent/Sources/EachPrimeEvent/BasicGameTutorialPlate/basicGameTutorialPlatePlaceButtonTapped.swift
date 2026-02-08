// MARK: - Module Dependency

import Foundation
import Universe
import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
fileprivate let plateStackAgent = GlobalEntity.Agent.plateStackAgent
@MainActor fileprivate let hapticFeedbackAgent = GlobalEntity.Agent.hapticFeedbackAgent

fileprivate let basicGameTutorialPlate = GlobalEntity.Plate.basicGameTutorialPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGameTutorialPlatePlaceButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGameTutorialPlatePlaceButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    let isHapticFeedbackOn = await appStateAgent.getIsHapticFeedbackOn()
    if isHapticFeedbackOn {
        await hapticFeedbackAgent.decisionFeedback()
    }
    let currentTutorialState = await basicGameTutorialPlate.getTutorialState()
    let next = currentTutorialState.next
    if let next {
        await basicGameTutorialPlate.setTutorialState(next)

        _ = await basicGameTutorialPlate.handlePlaceButtonTap()
    } else {

        // MARK: - Pop Plate

        await plateStackAgent.popPlate()

        // MARK: - Reset

        await basicGameTutorialPlate.reset()
    }
}
