// MARK: - Module Dependency

import Foundation
import Universe
import Spectrum
import Agent
import Plate
import PrimeEventBase

// MARK: - Context

fileprivate let appStateAgent = GlobalEntity.Agent.appStateAgent

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateResultDialogRestartButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateResultDialogRestartButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    await basicGamePlate.setIsResultDialogShown(false)
    // BasicGamePlate에서의 result dialog 사라지는 애니메이션의 duration과 값을 맞춘 것이다.
    try? await Task.sleep(nanoseconds: TimeInterval(seconds: 0.5).nanosecondsUInt64)
    await basicGamePlate.resetGame()

    // MARK: - 스냅샷 저장

    let snapshot = await basicGamePlate.getSnapshot()
    await appStateAgent.setBasicGameSnapshot(snapshot)
}
