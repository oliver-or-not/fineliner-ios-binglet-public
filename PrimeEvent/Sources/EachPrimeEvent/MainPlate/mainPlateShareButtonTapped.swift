// MARK: - Module Dependency

import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let shareAgent = GlobalEntity.Agent.shareAgent

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let mainPlateShareButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .mainPlateShareButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    // MARK: - Present Settings Plate

    await shareAgent.showShareSheet()
}
