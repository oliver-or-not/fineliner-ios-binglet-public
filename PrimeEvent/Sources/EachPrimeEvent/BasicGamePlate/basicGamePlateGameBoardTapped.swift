// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
@MainActor fileprivate let hapticFeedbackAgent = GlobalEntity.Agent.hapticFeedbackAgent

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateGameBoardTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateGameBoardTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    let activeBingletProcessData = await basicGamePlate.getActiveBingletProcessData()
    if activeBingletProcessData != nil {
        let isHapticFeedbackOn = await appStateAgent.getIsHapticFeedbackOn()
        if isHapticFeedbackOn {
            await hapticFeedbackAgent.valueChangeByTapFeedback()
        }
        await basicGamePlate.handleGameBoardTap()
    }
}
