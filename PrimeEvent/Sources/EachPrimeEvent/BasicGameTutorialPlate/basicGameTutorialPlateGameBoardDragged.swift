// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
@MainActor fileprivate let hapticFeedbackAgent = GlobalEntity.Agent.hapticFeedbackAgent

fileprivate let basicGameTutorialPlate = GlobalEntity.Plate.basicGameTutorialPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGameTutorialPlateGameBoardDragged: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGameTutorialPlateGameBoardDragged, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { primeEventDesignationWithPayload in
    guard case .basicGameTutorialPlateGameBoardDragged(let translation, let unitDistance) = primeEventDesignationWithPayload else {
        await logDirector.primeEventLog(
            .basicGameTutorialPlateGameBoardDragged,
            .error,
            "Designation mismatched. Received designation: \(primeEventDesignationWithPayload)"
        )
        return
    }

    let oldGridOffset = await basicGameTutorialPlate.getActiveBingletProcessData()?.accumulatedPlacingChoice.gridOffset
    await basicGameTutorialPlate.handleGameBoardDrag(
        translation: translation,
        unitDistance: unitDistance
    )
    let newGridOffset = await basicGameTutorialPlate.getActiveBingletProcessData()?.accumulatedPlacingChoice.gridOffset

    if oldGridOffset != nil
        && newGridOffset != nil
        && oldGridOffset != newGridOffset {
        let isHapticFeedbackOn = await appStateAgent.getIsHapticFeedbackOn()
        if isHapticFeedbackOn {
            await hapticFeedbackAgent.valueChangeByDragFeedback()
        }
    }
}
