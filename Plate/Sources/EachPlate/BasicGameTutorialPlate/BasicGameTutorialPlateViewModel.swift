// MARK: - Module Dependency

import SwiftUI
import Universe

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

@MainActor @Observable final class BasicGameTutorialPlateViewModel {

    static let shared = BasicGameTutorialPlateViewModel(
        gameBoardGridViewData: Constant.initialGameBoardGridViewData,
        gameBoardViewData: Constant.initialGameBoardViewData,
        gameBoardBingleEffectViewData: Constant.initialGameBoardBingleEffectViewData,
        activeBingletContainerViewData: Constant.initialActiveBingletContainerViewData,
        guideBingletContainerViewData: nil,
        bingletActivationViewCount: Constant.initialBingletActivationViewCount,
        bingletPlacingViewCount: Constant.initialBingletPlacingViewCount,
        gameBoardHintViewData: Constant.initialGameBoardHintViewData,
        placeButtonViewData: Constant.initialPlaceButtonViewData,
        waitingBingletContainerViewDataArray: Constant.initialWaitingBingletContainerViewDataArray,
        tutorialCheckArrayCount: 0,
        tutorialGuideDialogViewData: nil,
        tutorialHighlightState: nil
    )

    var gameBoardGridViewData: GameBoardGridViewData
    var gameBoardViewData: GameBoardViewData
    var gameBoardBingleEffectViewData: GameBoardBingleEffectViewData?
    var activeBingletContainerViewData: ActiveBingletContainerViewData?
    var guideBingletContainerViewData: ActiveBingletContainerViewData?
    var bingletActivationViewCount: UInt
    var bingletPlacingViewCount: UInt
    var gameBoardHintViewData: GameBoardHintViewData?
    var placeButtonViewData: PlaceButtonViewData
    var waitingBingletContainerViewDataArray: [WaitingBingletContainerViewData]
    var tutorialCheckArrayCount: Int
    var tutorialGuideDialogViewData: TutorialGuideDialogViewData?
    var tutorialHighlightState: TutorialHighlightState?

    init(
        gameBoardGridViewData: GameBoardGridViewData,
        gameBoardViewData: GameBoardViewData,
        gameBoardBingleEffectViewData: GameBoardBingleEffectViewData?,
        activeBingletContainerViewData: ActiveBingletContainerViewData?,
        guideBingletContainerViewData: ActiveBingletContainerViewData?,
        bingletActivationViewCount: UInt,
        bingletPlacingViewCount: UInt,
        gameBoardHintViewData: GameBoardHintViewData?,
        placeButtonViewData: PlaceButtonViewData,
        waitingBingletContainerViewDataArray: [WaitingBingletContainerViewData],
        tutorialCheckArrayCount: Int,
        tutorialGuideDialogViewData: TutorialGuideDialogViewData?,
        tutorialHighlightState: TutorialHighlightState?
    ) {
        self.gameBoardGridViewData = gameBoardGridViewData
        self.gameBoardViewData = gameBoardViewData
        self.gameBoardBingleEffectViewData = gameBoardBingleEffectViewData
        self.activeBingletContainerViewData = activeBingletContainerViewData
        self.guideBingletContainerViewData = guideBingletContainerViewData
        self.bingletActivationViewCount = bingletActivationViewCount
        self.bingletPlacingViewCount = bingletPlacingViewCount
        self.gameBoardHintViewData = gameBoardHintViewData
        self.placeButtonViewData = placeButtonViewData
        self.waitingBingletContainerViewDataArray = waitingBingletContainerViewDataArray
        self.tutorialCheckArrayCount = tutorialCheckArrayCount
        self.tutorialGuideDialogViewData = tutorialGuideDialogViewData
        self.tutorialHighlightState = tutorialHighlightState
    }
}
