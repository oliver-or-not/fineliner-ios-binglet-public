// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let basicGameTutorialPlate = GlobalEntity.Plate.basicGameTutorialPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGameTutorialPlateGameBoardDragEnded: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGameTutorialPlateGameBoardDragEnded, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    await basicGameTutorialPlate.handleGameBoardDragEnd()
}
