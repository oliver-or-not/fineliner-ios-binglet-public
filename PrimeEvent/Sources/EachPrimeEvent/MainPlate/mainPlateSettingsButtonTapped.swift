// MARK: - Module Dependency

import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let plateStackAgent = GlobalEntity.Agent.plateStackAgent
fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent

fileprivate let settingsPlate = GlobalEntity.Plate.settingsPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let mainPlateSettingsButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .mainPlateSettingsButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    // MARK: - Set Data into Settings Plate

    let isHapticFeedbackOn = await appStateAgent.getIsHapticFeedbackOn()
    await settingsPlate.setIsHapticFeedbackOn(isHapticFeedbackOn)
    let colorScheme = await appStateAgent.getColorScheme()
    await settingsPlate.setColorScheme(colorScheme)

    // MARK: - Present Settings Plate

    await plateStackAgent.pushPlate(.settings, .fromBottom)
}
