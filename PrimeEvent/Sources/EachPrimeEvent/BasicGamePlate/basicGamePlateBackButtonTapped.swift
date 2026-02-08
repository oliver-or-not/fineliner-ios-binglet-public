// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let soundAgent = GlobalEntity.Agent.soundAgent
fileprivate let plateStackAgent = GlobalEntity.Agent.plateStackAgent
fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateBackButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateBackButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    // MARK: - Pop Plate

    await plateStackAgent.popPlate()
}
