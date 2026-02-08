// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
@MainActor fileprivate let hapticFeedbackAgent = GlobalEntity.Agent.hapticFeedbackAgent

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateGameBoardDragged: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateGameBoardDragged, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { primeEventDesignationWithPayload in
    guard case .basicGamePlateGameBoardDragged(let translation, let unitDistance) = primeEventDesignationWithPayload else {
        await logDirector.primeEventLog(
            .basicGamePlateGameBoardDragged,
            .error,
            "Designation mismatched. Received designation: \(primeEventDesignationWithPayload)"
        )
        return
    }

    let oldGridOffset = await basicGamePlate.getActiveBingletProcessData()?.accumulatedPlacingChoice.gridOffset
    await basicGamePlate.handleGameBoardDrag(
        translation: translation,
        unitDistance: unitDistance
    )
    let newGridOffset = await basicGamePlate.getActiveBingletProcessData()?.accumulatedPlacingChoice.gridOffset

    if oldGridOffset != nil
        && newGridOffset != nil
        && oldGridOffset != newGridOffset {
        let isHapticFeedbackOn = await appStateAgent.getIsHapticFeedbackOn()
        if isHapticFeedbackOn {
            await hapticFeedbackAgent.valueChangeByDragFeedback()
        }
    }
}
