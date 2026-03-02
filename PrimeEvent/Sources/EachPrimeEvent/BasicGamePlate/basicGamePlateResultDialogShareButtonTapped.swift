// MARK: - Module Dependency

import Spectrum
import Agent
import PrimeEventBase

// MARK: - Context

fileprivate let shareAgent = GlobalEntity.Agent.shareAgent

fileprivate let basicGamePlate = GlobalEntity.Plate.basicGamePlate

// MARK: - Body

extension GlobalEntity.PrimeEvent {

    public static let basicGamePlateResultDialogShareButtonTapped: GlobalEntity.PrimeEvent.Interface
    = BasePrimeEvent(designation: .basicGamePlateResultDialogShareButtonTapped, task: task)
}

fileprivate let task: BasePrimeEvent.Task = { _ in

    let finalScore = await basicGamePlate.getGameScore()

    // MARK: - Present Settings Plate

    await shareAgent.showShareSheetWithScore(score: finalScore)
}
