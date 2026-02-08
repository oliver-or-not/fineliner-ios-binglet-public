// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
@MainActor fileprivate let hapticFeedbackAgent = GlobalEntity.Agent.hapticFeedbackAgent

fileprivate let basicGameTutorialPlate = GlobalEntity.Plate.basicGameTutorialPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGameTutorialPlateGameBoardTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGameTutorialPlateGameBoardTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    let activeBingletProcessData = await basicGameTutorialPlate.getActiveBingletProcessData()
    if activeBingletProcessData != nil {
        let isHapticFeedbackOn = await appStateAgent.getIsHapticFeedbackOn()
        if isHapticFeedbackOn {
            await hapticFeedbackAgent.valueChangeByTapFeedback()
        }
        await basicGameTutorialPlate.handleGameBoardTap()
    }
}
