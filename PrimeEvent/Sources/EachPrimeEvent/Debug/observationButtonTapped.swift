#if DEBUG
// MARK: - Module Dependency

import Foundation
import Spectrum
import Director
import Agent
import PrimeEventBase

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent
fileprivate let logDirector = GlobalEntity.Director.log

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let observationButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .observationButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in
    let isPrimeEventWindowVisible = await primeEventDirector.getIsWindowVisible()
    let isLogWindowVisible = await logDirector.getIsWindowVisible()
    switch (isPrimeEventWindowVisible, isLogWindowVisible) {
    case (false, false):
        await primeEventDirector.setIsWindowVisible(false)
        await logDirector.setIsWindowVisible(true)
    case (false, true):
        await primeEventDirector.setIsWindowVisible(true)
        await logDirector.setIsWindowVisible(false)
    case (true, false):
        await primeEventDirector.setIsWindowVisible(true)
        await logDirector.setIsWindowVisible(true)
    case (true, true):
        await primeEventDirector.setIsWindowVisible(false)
        await logDirector.setIsWindowVisible(false)
    }
}
#endif
