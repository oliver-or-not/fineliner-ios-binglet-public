// MARK: - Module Dependency

import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let plateStackAgent = GlobalEntity.Agent.plateStackAgent
fileprivate let settingsPlate = GlobalEntity.Plate.settingsPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let settingsPlateCloseButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .settingsPlateCloseButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    // MARK: - Pop Plate

    await plateStackAgent.popPlate()

    // MARK: - Reset

    await settingsPlate.reset()
}
