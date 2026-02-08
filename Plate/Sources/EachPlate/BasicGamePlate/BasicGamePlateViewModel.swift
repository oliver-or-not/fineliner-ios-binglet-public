// MARK: - Module Dependency

import SwiftUI
import Universe

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

@MainActor @Observable final class BasicGamePlateViewModel {

    static let shared = BasicGamePlateViewModel(
        gameScoreAboveGameBoard: Constant.initialGameScoreAboveGameBoard,
        gameBoardGridViewData: Constant.initialGameBoardGridViewData,
        gameBoardViewData: Constant.initialGameBoardViewData,
        gameBoardBingleEffectViewData: Constant.initialGameBoardBingleEffectViewData,
        activeBingletContainerViewData: Constant.initialActiveBingletContainerViewData,
        bingletActivationViewCount: Constant.initialBingletActivationViewCount,
        bingletPlacingViewCount: Constant.initialBingletPlacingViewCount,
        gameBoardHintViewData: Constant.initialGameBoardHintViewData,
        placeButtonViewData: Constant.initialPlaceButtonViewData,
        waitingBingletContainerViewDataArray: Constant.initialWaitingBingletContainerViewDataArray,
        resultDialogViewData: Constant.initialResultDialogViewData,
        isBeforeRestartDialogShown: Constant.initialIsBeforeRestartDialogShown,
        bannerAdUnitId: nil,
        isBannerAdShown: false
    )

    var gameScoreAboveGameBoard: Int?
    var gameBoardGridViewData: GameBoardGridViewData
    var gameBoardViewData: GameBoardViewData
    var gameBoardBingleEffectViewData: GameBoardBingleEffectViewData?
    var activeBingletContainerViewData: ActiveBingletContainerViewData?
    var bingletActivationViewCount: UInt
    var bingletPlacingViewCount: UInt
    var gameBoardHintViewData: GameBoardHintViewData?
    var placeButtonViewData: PlaceButtonViewData
    var waitingBingletContainerViewDataArray: [WaitingBingletContainerViewData]
    var resultDialogViewData: ResultDialogViewData?
    var isBeforeRestartDialogShown: Bool
    var bannerAdUnitId: String?
    var isBannerAdShown: Bool

    init(
        gameScoreAboveGameBoard: Int?,
        gameBoardGridViewData: GameBoardGridViewData,
        gameBoardViewData: GameBoardViewData,
        gameBoardBingleEffectViewData: GameBoardBingleEffectViewData?,
        activeBingletContainerViewData: ActiveBingletContainerViewData?,
        bingletActivationViewCount: UInt,
        bingletPlacingViewCount: UInt,
        gameBoardHintViewData: GameBoardHintViewData?,
        placeButtonViewData: PlaceButtonViewData,
        waitingBingletContainerViewDataArray: [WaitingBingletContainerViewData],
        resultDialogViewData: ResultDialogViewData?,
        isBeforeRestartDialogShown: Bool,
        bannerAdUnitId: String?,
        isBannerAdShown: Bool
    ) {
        self.gameScoreAboveGameBoard = gameScoreAboveGameBoard
        self.gameBoardGridViewData = gameBoardGridViewData
        self.gameBoardViewData = gameBoardViewData
        self.gameBoardBingleEffectViewData = gameBoardBingleEffectViewData
        self.activeBingletContainerViewData = activeBingletContainerViewData
        self.bingletActivationViewCount = bingletActivationViewCount
        self.bingletPlacingViewCount = bingletPlacingViewCount
        self.gameBoardHintViewData = gameBoardHintViewData
        self.placeButtonViewData = placeButtonViewData
        self.waitingBingletContainerViewDataArray = waitingBingletContainerViewDataArray
        self.resultDialogViewData = resultDialogViewData
        self.isBeforeRestartDialogShown = isBeforeRestartDialogShown
        self.bannerAdUnitId = bannerAdUnitId
        self.isBannerAdShown = isBannerAdShown
    }
}
