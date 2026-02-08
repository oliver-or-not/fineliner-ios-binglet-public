// MARK: - Module Dependency

import Foundation
import Universe
import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let appInfoAgent = GlobalEntity.Agent.appInfoAgent
fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent
fileprivate let dateAgent = GlobalEntity.Agent.dateAgent
fileprivate let soundAgent = GlobalEntity.Agent.soundAgent
fileprivate let plateStackAgent = GlobalEntity.Agent.plateStackAgent
fileprivate let googleAdAgent = GlobalEntity.Agent.googleAdAgent

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate
fileprivate let basicGameTutorialPlate = GlobalEntity.Plate.basicGameTutorialPlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let mainPlateMarathonButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .mainPlateMarathonButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    let now = await dateAgent.getNowDate()

    let snapshotFromAppState = await appStateAgent.getBasicGameSnapshot()
    if let snapshotFromAppState {
        await basicGamePlate.setBySnapshot(snapshotFromAppState)
    } else {
        await basicGamePlate.resetGame()
        let snapshot = await basicGamePlate.getSnapshot()
        await appStateAgent.setBasicGameSnapshot(snapshot)
    }

    // MARK: - Present Basic Game Plate

    await plateStackAgent.pushPlate(.basicGame, .fadeIn)

    // MARK: - Present Tutorial

    if snapshotFromAppState == nil {
        await basicGameTutorialPlate.reset()
        try? await Task.sleep(nanoseconds: TimeInterval(milliseconds: 500).nanosecondsUInt64)

        await plateStackAgent.pushPlate(.basicGameTutorial, .fromBottom)
        try? await Task.sleep(nanoseconds: TimeInterval(milliseconds: 500).nanosecondsUInt64)
        await basicGameTutorialPlate.setTutorialState(.greeting)
    }
}
