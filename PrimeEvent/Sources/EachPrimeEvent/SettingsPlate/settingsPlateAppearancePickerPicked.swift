// MARK: - Module Dependency

import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
fileprivate let appAppearanceAgent = GlobalEntity.Agent.appAppearanceAgent

fileprivate let settingsPlate = GlobalEntity.Plate.settingsPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let settingsPlateAppearancePickerPicked: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .settingsPlateAppearancePickerPicked, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { primeEventDesignationWithPayload in
    guard case .settingsPlateAppearancePickerPicked(let colorScheme) = primeEventDesignationWithPayload else {
        await logDirector.primeEventLog(
            .settingsPlateAppearancePickerPicked,
            .error,
            "Designation mismatched. Received designation: \(primeEventDesignationWithPayload)"
        )
        return
    }

    await appAppearanceAgent.setColorScheme(colorScheme)
    await settingsPlate.setColorScheme(colorScheme)
    await appStateAgent.setColorScheme(colorScheme)
}
