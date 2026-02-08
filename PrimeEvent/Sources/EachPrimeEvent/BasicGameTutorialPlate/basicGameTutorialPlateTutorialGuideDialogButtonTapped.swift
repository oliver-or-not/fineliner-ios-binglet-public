// MARK: - Module Dependency

import Foundation
import Universe
import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let soundAgent = GlobalEntity.Agent.soundAgent
fileprivate let plateStackAgent = GlobalEntity.Agent.plateStackAgent

fileprivate let basicGameTutorialPlate = GlobalEntity.Plate.basicGameTutorialPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGameTutorialPlateTutorialGuideDialogButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGameTutorialPlateTutorialGuideDialogButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    // MARK: - Reset

    let currentTutorialState = await basicGameTutorialPlate.getTutorialState()
    let next = currentTutorialState.next
    if let next {
        await basicGameTutorialPlate.setTutorialState(next)
        try? await Task.sleep(nanoseconds: TimeInterval(seconds: 1).nanosecondsUInt64)
    } else {

        // MARK: - Pop Plate

        await plateStackAgent.popPlate()

        // MARK: - Reset

        await basicGameTutorialPlate.reset()
    }
}
