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
        placeButtonContainerViewData: Constant.initialPlaceButtonContainerViewData,
        guideBingletContainerViewData: nil,
        bingletActivationViewCount: Constant.initialBingletActivationViewCount,
        bingletPlacingViewCount: Constant.initialBingletPlacingViewCount,
        gameBoardHintViewData: Constant.initialGameBoardHintViewData,
        waitingBingletContainerViewDataArray: Constant.initialWaitingBingletContainerViewDataArray,
        tutorialCheckArrayCount: 0,
        tutorialGuideDialogViewData: nil,
        tutorialHighlightState: nil
    )

    var gameBoardGridViewData: GameBoardGridViewData
    var gameBoardViewData: GameBoardViewData
    var gameBoardBingleEffectViewData: GameBoardBingleEffectViewData?
    var activeBingletContainerViewData: ActiveBingletContainerViewData?
    var placeButtonContainerViewData: PlaceButtonContainerViewData?
    var guideBingletContainerViewData: GuideBingletContainerViewData?
    var bingletActivationViewCount: UInt
    var bingletPlacingViewCount: UInt
    var gameBoardHintViewData: GameBoardHintViewData?
    var waitingBingletContainerViewDataArray: [WaitingBingletContainerViewData]
    var tutorialCheckArrayCount: Int
    var tutorialGuideDialogViewData: TutorialGuideDialogViewData?
    var tutorialHighlightState: TutorialHighlightState?

    init(
        gameBoardGridViewData: GameBoardGridViewData,
        gameBoardViewData: GameBoardViewData,
        gameBoardBingleEffectViewData: GameBoardBingleEffectViewData?,
        activeBingletContainerViewData: ActiveBingletContainerViewData?,
        placeButtonContainerViewData: PlaceButtonContainerViewData?,
        guideBingletContainerViewData: GuideBingletContainerViewData?,
        bingletActivationViewCount: UInt,
        bingletPlacingViewCount: UInt,
        gameBoardHintViewData: GameBoardHintViewData?,
        waitingBingletContainerViewDataArray: [WaitingBingletContainerViewData],
        tutorialCheckArrayCount: Int,
        tutorialGuideDialogViewData: TutorialGuideDialogViewData?,
        tutorialHighlightState: TutorialHighlightState?
    ) {
        self.gameBoardGridViewData = gameBoardGridViewData
        self.gameBoardViewData = gameBoardViewData
        self.gameBoardBingleEffectViewData = gameBoardBingleEffectViewData
        self.activeBingletContainerViewData = activeBingletContainerViewData
        self.placeButtonContainerViewData = placeButtonContainerViewData
        self.guideBingletContainerViewData = guideBingletContainerViewData
        self.bingletActivationViewCount = bingletActivationViewCount
        self.bingletPlacingViewCount = bingletPlacingViewCount
        self.gameBoardHintViewData = gameBoardHintViewData
        self.waitingBingletContainerViewDataArray = waitingBingletContainerViewDataArray
        self.tutorialCheckArrayCount = tutorialCheckArrayCount
        self.tutorialGuideDialogViewData = tutorialGuideDialogViewData
        self.tutorialHighlightState = tutorialHighlightState
    }
}
