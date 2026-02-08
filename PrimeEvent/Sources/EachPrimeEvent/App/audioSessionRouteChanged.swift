// MARK: - Module Dependency

import Spectrum
import Director
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate let soundAgent = GlobalEntity.Agent.soundAgent

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let audioSessionRouteChanged: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .audioSessionRouteChanged, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    do {
        try await Task.sleep(nanoseconds: 100_000)
    } catch {
        await logDirector.primeEventLog(
            .audioSessionRouteChanged,
            .error,
            "Failed to sleep. error: \(error)"
        )
    }
    await soundAgent.recover()
}
