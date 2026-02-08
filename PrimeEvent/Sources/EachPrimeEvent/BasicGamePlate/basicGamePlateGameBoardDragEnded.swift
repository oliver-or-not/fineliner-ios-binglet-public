// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateGameBoardDragEnded: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateGameBoardDragEnded, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    await basicGamePlate.handleGameBoardDragEnd()
}
