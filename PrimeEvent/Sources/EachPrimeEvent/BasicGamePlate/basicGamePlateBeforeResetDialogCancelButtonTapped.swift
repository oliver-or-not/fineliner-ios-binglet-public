// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateBeforeResetDialogCancelButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateBeforeResetDialogCancelButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    await basicGamePlate.setIsBeforeRestartDialogShown(false)
}
