// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateResetButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateResetButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    await basicGamePlate.setIsBeforeRestartDialogShown(true)
}
