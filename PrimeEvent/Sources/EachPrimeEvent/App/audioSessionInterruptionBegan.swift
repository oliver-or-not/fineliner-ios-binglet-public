// MARK: - Module Dependency

import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let soundAgent = GlobalEntity.Agent.soundAgent

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let audioSessionInterruptionBegan: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .audioSessionInterruptionBegan, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    await soundAgent.pauseBackgroundMusic()
}
