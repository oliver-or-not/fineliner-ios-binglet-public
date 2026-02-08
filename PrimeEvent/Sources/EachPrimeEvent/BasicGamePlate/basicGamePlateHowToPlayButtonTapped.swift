// MARK: - Module Dependency

import Foundation
import Universe
import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let plateStackAgent = GlobalEntity.Agent.plateStackAgent

fileprivate let basicGameTutorialPlate = GlobalEntity.Plate.basicGameTutorialPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateHowToPlayButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateHowToPlayButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    await basicGameTutorialPlate.reset()
    await plateStackAgent.pushPlate(.basicGameTutorial, .fromBottom)
    try? await Task.sleep(nanoseconds: TimeInterval(milliseconds: 500).nanosecondsUInt64)
    await basicGameTutorialPlate.setTutorialState(.greeting)
}
