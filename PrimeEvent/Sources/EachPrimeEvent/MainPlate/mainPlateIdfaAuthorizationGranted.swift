// MARK: - Module Dependency

import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let mainPlateIdfaAuthorizationGranted: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .mainPlateIdfaAuthorizationGranted, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    await basicGamePlate.setIsBannerAdShown(true)
}
