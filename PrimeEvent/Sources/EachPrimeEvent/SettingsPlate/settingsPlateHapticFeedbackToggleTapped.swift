// MARK: - Module Dependency

import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
fileprivate let settingsPlate = GlobalEntity.Plate.settingsPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let settingsPlateHapticFeedbackToggleTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .settingsPlateHapticFeedbackToggleTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    let currentValue = await appStateAgent.getIsHapticFeedbackOn()

    await settingsPlate.setIsHapticFeedbackOn(!currentValue)
    await appStateAgent.setIsHapticFeedbackOn(!currentValue)
}
