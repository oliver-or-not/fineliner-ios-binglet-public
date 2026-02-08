// MARK: - Module Dependency

import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let gameCenterAgent = GlobalEntity.Agent.gameCenterAgent

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let mainPlateRankingsButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .mainPlateRankingsButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    // MARK: - Present Settings Plate

    await gameCenterAgent.showGraphicInterface()
}
