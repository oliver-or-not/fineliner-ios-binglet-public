// MARK: - Module Dependency

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

    public static let basicGameTutorialPlateCloseButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGameTutorialPlateCloseButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    // MARK: - Pop Plate

    await plateStackAgent.popPlate()

    // MARK: - Reset

    await basicGameTutorialPlate.reset()
}
