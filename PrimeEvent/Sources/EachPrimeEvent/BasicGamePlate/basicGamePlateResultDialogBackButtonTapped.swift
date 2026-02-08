// MARK: - Module Dependency

import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let plateStackAgent = GlobalEntity.Agent.plateStackAgent
fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateResultDialogBackButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateResultDialogBackButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    await plateStackAgent.popPlate()

    await basicGamePlate.resetGame()

    // MARK: - 스냅샷 저장

    let snapshot = await basicGamePlate.getSnapshot()
    await appStateAgent.setBasicGameSnapshot(snapshot)
}
