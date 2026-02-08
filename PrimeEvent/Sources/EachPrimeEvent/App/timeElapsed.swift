// MARK: - Module Dependency

import UIKit
import Spectrum
import Director
import Agent
import PrimeEventBase

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent
fileprivate let logDirector = GlobalEntity.Director.log

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let timeElapsed: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .timeElapsed, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { primeEventDesignationWithPayload in
    guard case .timeElapsed(let now) = primeEventDesignationWithPayload else {
        await logDirector.primeEventLog(
            .timeElapsed,
            .error,
            "Designation mismatched. Received designation: \(primeEventDesignationWithPayload)"
        )
        return
    }
    await primeEventDirector.timeElapsed(now: now)
}
