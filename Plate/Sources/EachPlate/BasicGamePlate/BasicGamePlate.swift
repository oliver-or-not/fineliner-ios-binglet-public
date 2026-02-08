// MARK: - Module Dependency

import SwiftUI
import Universe
import Spectrum
import Agent
import PlateBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate typealias Constant = BasicGamePlateConstant
fileprivate typealias Logic = BasicGamePlateLogic
@MainActor fileprivate let viewModel = BasicGamePlateViewModel.shared

// MARK: - Body

extension GlobalEntity.Plate {

    public static let basicGamePlate: BasicGamePlateInterface = BasicGamePlate(
        gameState: Constant.initialGameState,
        gameScore: Constant.initialGameScore,
        gameBoardData: Constant.initialGameBoardData,
        waitingBingletArray: Constant.initialWaitingBingletArray,
        isResultDialogShown: Constant.initialIsResultDialogShown,
        isBeforeRestartDialogShown: Constant.initialIsBeforeRestartDialogShown,
        activeBingletProcessData: Constant.initialActiveBingletProcessData,
        bingletActivationCount: Constant.initialBingletActivationCount,
        bingletPlacingCount: Constant.initialBingletPlacingCount,
        scoreEarningProcessData: Constant.initialScoreEarningProcessData,
        bannerAdUnitId: nil,
        isBannerAdShown: false
    )
}

public protocol BasicGamePlateInterface: GlobalEntity.Plate.Interface, Sendable {

    func handleGameBoardDrag(translation: CGSize, unitDistance: CGFloat) async

    func handleGameBoardDragEnd() async

    func handleGameBoardTap() async

    /// - Returns: 활성화된 빙글렛을 배치할 방법이 있는지.
    func handlePlaceButtonTap() async -> Bool

    func getGameState() async -> GameState

    func setGameState(_ value: GameState) async

    func getGameScore() async -> Int

    func getIsResultDialogShown() async -> Bool

    func setIsResultDialogShown(_ value: Bool) async

    func getIsBeforeRestartDialogShown() async -> Bool

    func setIsBeforeRestartDialogShown(_ value: Bool) async

    func getActiveBingletProcessData() async -> ActiveBingletProcessData?

    func setActiveBingletProcessData(_ value: ActiveBingletProcessData?) async

    func getSnapshot() async -> BasicGameSnapshot

    func setBySnapshot(_ value: BasicGameSnapshot) async

    func resetGame() async

    func setBannerAdUnitId(_ bannerAdUnitId: String?) async

    func setIsBannerAdShown(_ isBannerAdShown: Bool) async

    func resetAd() async
}

fileprivate final actor BasicGamePlate: NSObject, BasicGamePlateInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: PlateDesignation = .basicGame

    // MARK: - State

    private var gameState: GameState
    private var gameScore: Int
    private var gameBoardData: GameBoardData
    private var waitingBingletArray: [Binglet]
    private var isResultDialogShown: Bool
    private var isBeforeRestartDialogShown: Bool

    private var activeBingletProcessData: ActiveBingletProcessData?
    private var bingletActivationCount: UInt
    private var bingletPlacingCount: UInt
    private var scoreEarningProcessData: ScoreEarningProcessData?

    private var bannerAdUnitId: String?
    private var isBannerAdShown: Bool

    // MARK: - Lifecycle

    fileprivate init(
        gameState: GameState,
        gameScore: Int,
        gameBoardData: GameBoardData,
        waitingBingletArray: [Binglet],
        isResultDialogShown: Bool,
        isBeforeRestartDialogShown: Bool,
        activeBingletProcessData: ActiveBingletProcessData?,
        bingletActivationCount: UInt,
        bingletPlacingCount: UInt,
        scoreEarningProcessData: ScoreEarningProcessData?,
        bannerAdUnitId: String?,
        isBannerAdShown: Bool
    ) {
        self.gameState = gameState
        self.gameScore = gameScore
        self.gameBoardData = gameBoardData
        self.waitingBingletArray = waitingBingletArray
        self.isResultDialogShown = isResultDialogShown
        self.isBeforeRestartDialogShown = isBeforeRestartDialogShown
        self.activeBingletProcessData = activeBingletProcessData
        self.bingletActivationCount = bingletActivationCount
        self.bingletPlacingCount = bingletPlacingCount
        self.scoreEarningProcessData = scoreEarningProcessData
        self.bannerAdUnitId = bannerAdUnitId
        self.isBannerAdShown = isBannerAdShown
    }


    // MARK: - Update View Model

    private func updateViewModel() async {
        let capturedGameState = gameState
        let capturedGameScore = gameScore
        let capturedGameBoardData = gameBoardData
        let capturedWaitingBingletArray = waitingBingletArray
        let capturedIsResultDialogShown = isResultDialogShown
        let capturedIsBeforeRestartDialogShown = isBeforeRestartDialogShown
        let capturedActiveBingletProcessData = activeBingletProcessData
        let capturedBingletActivationCount = bingletActivationCount
        let capturedBingletPlacingCount = bingletPlacingCount
        let capturedScoreEarningProcessData = scoreEarningProcessData
        let capturedIsBannerAdShown = isBannerAdShown
        let capturedBannerAdUnitId = bannerAdUnitId

        let gameScoreAboveGameBoard: Int?
        let gameBoardGridViewData: GameBoardGridViewData
        let gameBoardViewData: GameBoardViewData
        let gameBoardBingleEffectViewData: GameBoardBingleEffectViewData?
        let activeBingletContainerViewData: ActiveBingletContainerViewData?
        let bingletActivationViewCount: UInt
        let bingletPlacingViewCount: UInt
        let gameBoardHintViewData: GameBoardHintViewData?
        let placeButtonViewData: PlaceButtonViewData
        let waitingBingletContainerViewDataArray: [WaitingBingletContainerViewData]
        let resultDialogViewData: ResultDialogViewData?
        let isBeforeRestartDialogShown: Bool

        bingletActivationViewCount = capturedBingletActivationCount
        bingletPlacingViewCount = capturedBingletPlacingCount

        gameScoreAboveGameBoard = switch capturedGameState {
        case .playing: capturedGameScore
        case .finished: nil
        }

        var nodePlaceViewStateMatrix: Matrix<GameBoardGridViewData.NodePlaceViewState> = Array(
            repeating: Array(
                repeating: GameBoardGridViewData.NodePlaceViewState.notBlocked,
                count: Constant.gameBoardHorizontalNodeCount
            ),
            count: Constant.gameBoardVerticalNodeCount
        )
        for y in 0..<Constant.gameBoardVerticalNodeCount {
            for x in 0..<Constant.gameBoardHorizontalNodeCount {
                switch capturedGameBoardData.nodePlaceDataMatrix[y][x].blockState {
                case .notBlocked:
                    nodePlaceViewStateMatrix[y][x] = .notBlocked
                case .willBeBlocked(let bingletPlacingCountToBeBlocked):
                    nodePlaceViewStateMatrix[y][x] = .willBeBlocked(
                        blockCount: bingletPlacingCountToBeBlocked - capturedBingletPlacingCount
                    )
                case .blocked:
                    nodePlaceViewStateMatrix[y][x] = .blocked
                }
            }
        }
        gameBoardGridViewData = GameBoardGridViewData(
            nodePlaceViewStateMatrix: nodePlaceViewStateMatrix
        )

        if let capturedScoreEarningProcessData {
            let nodePlaceViewDataMatrix: Matrix<GameBoardBingleEffectViewData.NodePlaceViewData> = capturedScoreEarningProcessData.bingledNodeMatrix.map { row in
                row.map { (isBingled: Bool) -> GameBoardBingleEffectViewData.NodePlaceViewData in
                    isBingled ? .bingled : .empty
                }
            }
            let visualMultiplicationValue = Logic.getVisualMultiplicationValue(
                comboCount: capturedScoreEarningProcessData.leadingComboCount
            )
            gameBoardBingleEffectViewData = GameBoardBingleEffectViewData(
                nodePlaceViewDataMatrix: nodePlaceViewDataMatrix,
                multiplicationValue: visualMultiplicationValue,
                areNodesGathered: capturedScoreEarningProcessData.areBingledNodesGathered
            )
        } else {
            gameBoardBingleEffectViewData = nil
        }

        if let capturedActiveBingletProcessData {
            if let dragProcessData = capturedActiveBingletProcessData.dragProcessData {
                activeBingletContainerViewData = ActiveBingletContainerViewData(
                    nodeColor: capturedActiveBingletProcessData.binglet.nodeColor,
                    nodeMatrix: capturedActiveBingletProcessData.binglet.nodeMatrix,
                    horizontalLinkMatrix: capturedActiveBingletProcessData.binglet.horizontalLinkMatrix,
                    verticalLinkMatrix: capturedActiveBingletProcessData.binglet.verticalLinkMatrix,
                    diagonalLinkMatrix: capturedActiveBingletProcessData.binglet.diagonalLinkMatrix,
                    accumulatedPlacingChoice: capturedActiveBingletProcessData.accumulatedPlacingChoice,
                    residualTranslation: dragProcessData.residualTranslation
                )
            } else {
                activeBingletContainerViewData = ActiveBingletContainerViewData(
                    nodeColor: capturedActiveBingletProcessData.binglet.nodeColor,
                    nodeMatrix: capturedActiveBingletProcessData.binglet.nodeMatrix,
                    horizontalLinkMatrix: capturedActiveBingletProcessData.binglet.horizontalLinkMatrix,
                    verticalLinkMatrix: capturedActiveBingletProcessData.binglet.verticalLinkMatrix,
                    diagonalLinkMatrix: capturedActiveBingletProcessData.binglet.diagonalLinkMatrix,
                    accumulatedPlacingChoice: capturedActiveBingletProcessData.accumulatedPlacingChoice,
                    residualTranslation: .zero
                )
            }
        } else {
            activeBingletContainerViewData = nil
        }

        waitingBingletContainerViewDataArray = capturedWaitingBingletArray.map { waitingBinglet in
            WaitingBingletContainerViewData(
                nodeColor: waitingBinglet.nodeColor,
                nodeMatrix: waitingBinglet.nodeMatrix,
                horizontalLinkMatrix: waitingBinglet.horizontalLinkMatrix,
                verticalLinkMatrix: waitingBinglet.verticalLinkMatrix,
                diagonalLinkMatrix: waitingBinglet.diagonalLinkMatrix
            )
        }

        if capturedIsResultDialogShown {
            resultDialogViewData = ResultDialogViewData(finalGameScore: capturedGameScore)
        } else {
            resultDialogViewData = nil
        }

        isBeforeRestartDialogShown = capturedIsBeforeRestartDialogShown

        if let capturedActiveBingletProcessData {
            guard let gameBoardHintData = capturedActiveBingletProcessData
                .gameBoardHintDataCacheMap[capturedActiveBingletProcessData.accumulatedPlacingChoice.toPlacingChoice()] else {
                await logDirector.plateLog(.basicGame, .error, "On active binglet process but required data missing.")
                return
            }
            switch gameBoardHintData {
            case .notPlaceable(let notPlaceableGameBoardHintData): // 배치 불가능.
                var nodePlaceViewDataMatrix: Matrix<GameBoardViewData.NodePlaceViewData>
                = Array(
                    repeating: Array(
                        repeating: GameBoardViewData.NodePlaceViewData(occupiedNodeViewData: nil),
                        count: Constant.gameBoardHorizontalNodeCount
                    ),
                    count: Constant.gameBoardVerticalNodeCount
                )
                for y in 0..<Constant.gameBoardVerticalNodeCount {
                    for x in 0..<Constant.gameBoardHorizontalNodeCount {
                        let occupiedNodeData = capturedGameBoardData.nodePlaceDataMatrix[y][x].occupiedNodeData
                        let occupiedNodeViewData: GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData?
                        if let occupiedNodeData {
                            let effectViewData: GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData.EffectViewData?
                            if let visualMultiplicationValue = Logic.getVisualMultiplicationValue(comboCount: occupiedNodeData.comboCount) {
                                effectViewData = GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData.EffectViewData(
                                    mainColor: Logic.getNodeEffectMainColor(comboCount: occupiedNodeData.comboCount),
                                    multiplicationValue: visualMultiplicationValue,
                                    isHighlighted: false
                                )
                            } else {
                                effectViewData = nil
                            }
                            occupiedNodeViewData = GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData(
                                color: occupiedNodeData.origin.nodeColor,
                                effectViewData: effectViewData
                            )
                        } else {
                            occupiedNodeViewData = nil
                        }
                        nodePlaceViewDataMatrix[y][x] = GameBoardViewData.NodePlaceViewData(
                            occupiedNodeViewData: occupiedNodeViewData
                        )
                    }
                }
                gameBoardViewData = GameBoardViewData(
                    nodePlaceViewDataMatrix: nodePlaceViewDataMatrix,
                    horizontalLinkMatrix: capturedGameBoardData.horizontalLinkMatrix,
                    verticalLinkMatrix: capturedGameBoardData.verticalLinkMatrix,
                    diagonalLinkMatrix: capturedGameBoardData.diagonalLinkMatrix
                )
                if capturedActiveBingletProcessData.isHintVisible {
                    var hintNodePlaceViewDataMatrix: Matrix<GameBoardHintViewData.NodePlaceViewData>
                    hintNodePlaceViewDataMatrix = Array(
                        repeating: Array(
                            repeating: .empty,
                            count: Constant.gameBoardHorizontalNodeCount
                        ),
                        count: Constant.gameBoardVerticalNodeCount
                    )
                    for y in 0..<Constant.gameBoardVerticalNodeCount {
                        for x in 0..<Constant.gameBoardHorizontalNodeCount {
                            let hintNodePlaceData = notPlaceableGameBoardHintData.nodePlaceDataMatrix[y][x]
                            switch hintNodePlaceData {
                            case .empty:
                                hintNodePlaceViewDataMatrix[y][x] = .empty
                            case .illegal:
                                hintNodePlaceViewDataMatrix[y][x] = .illegal
                            }
                        }
                    }
                    let hintHorizontalLinkPlaceViewDataMatrix: Matrix<GameBoardHintViewData.SimpleLinkPlaceViewData> = Array(
                        repeating: Array(
                            repeating: .empty,
                            count: Constant.gameBoardHorizontalNodeCount - 1
                        ),
                        count: Constant.gameBoardVerticalNodeCount
                    )
                    let hintVerticalLinkPlaceViewDataMatrix: Matrix<GameBoardHintViewData.SimpleLinkPlaceViewData> = Array(
                        repeating: Array(
                            repeating: .empty,
                            count: Constant.gameBoardHorizontalNodeCount
                        ),
                        count: Constant.gameBoardVerticalNodeCount - 1
                    )
                    let hintDiagonalLinkPlaceViewDataMatrix: Matrix<GameBoardHintViewData.DiagonalLinkPlaceViewData> = Array(
                        repeating: Array(
                            repeating: .empty,
                            count: Constant.gameBoardHorizontalNodeCount - 1
                        ),
                        count: Constant.gameBoardVerticalNodeCount - 1
                    )
                    gameBoardHintViewData = GameBoardHintViewData(
                        nodePlaceViewDataMatrix: hintNodePlaceViewDataMatrix,
                        horizontalLinkPlaceViewDataMatrix: hintHorizontalLinkPlaceViewDataMatrix,
                        verticalLinkPlaceViewDataMatrix: hintVerticalLinkPlaceViewDataMatrix,
                        diagonalLinkPlaceViewDataMatrix: hintDiagonalLinkPlaceViewDataMatrix
                    )
                } else {
                    gameBoardHintViewData = nil
                }

                placeButtonViewData = .disabled
            case .placeable(let placeableGameBoardHintData): // 배치 가능.
                guard let duplicatableGameBoardDataWithPlacedBinglet = capturedActiveBingletProcessData
                    .duplicatableGameBoardDataWithPlacedBingletCacheMap[capturedActiveBingletProcessData.accumulatedPlacingChoice.toPlacingChoice()],
                   let resolvedGameBoardData = capturedActiveBingletProcessData
                    .resolvedGameBoardDataCacheMap[capturedActiveBingletProcessData.accumulatedPlacingChoice.toPlacingChoice()] else {
                    await logDirector.plateLog(.basicGame, .error, "Placeable but required data missing.")
                    return
                }
                var nodePlaceViewDataMatrix: Matrix<GameBoardViewData.NodePlaceViewData>
                = Array(
                    repeating: Array(
                        repeating: GameBoardViewData.NodePlaceViewData(occupiedNodeViewData: nil),
                        count: Constant.gameBoardHorizontalNodeCount
                    ),
                    count: Constant.gameBoardVerticalNodeCount
                )
                var leadingComboCount: UInt = 0
                for y in 0..<Constant.gameBoardVerticalNodeCount {
                    for x in 0..<Constant.gameBoardHorizontalNodeCount {
                        switch placeableGameBoardHintData.nodePlaceDataMatrix[y][x] {
                        case .expectedToFormBingle(_, let hasLeadingComboCount):
                            if hasLeadingComboCount {
                                switch duplicatableGameBoardDataWithPlacedBinglet.nodePlaceDataMatrix[y][x] {
                                case .singleOccupied(let nodeData):
                                    leadingComboCount = nodeData.comboCount
                                default:
                                    _ = 0
                                }
                            }
                        default:
                            _ = 0
                        }
                    }
                }
                for y in 0..<Constant.gameBoardVerticalNodeCount {
                    for x in 0..<Constant.gameBoardHorizontalNodeCount {
                        let occupiedNodeData = capturedGameBoardData.nodePlaceDataMatrix[y][x].occupiedNodeData
                        let occupiedNodeViewData: GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData?
                        if let occupiedNodeData {
                            let isHighlighted: Bool
                            if leadingComboCount > 0
                                && leadingComboCount == occupiedNodeData.comboCount {
                                isHighlighted = true
                            } else {
                                isHighlighted = false
                            }
                            let effectViewData: GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData.EffectViewData?
                            if let visualMultiplicationValue = Logic.getVisualMultiplicationValue(comboCount: occupiedNodeData.comboCount) {
                                effectViewData = GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData.EffectViewData(
                                    mainColor: Logic.getNodeEffectMainColor(comboCount: occupiedNodeData.comboCount),
                                    multiplicationValue: visualMultiplicationValue,
                                    isHighlighted: isHighlighted
                                )
                            } else {
                                effectViewData = nil
                            }
                            occupiedNodeViewData = GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData(
                                color: occupiedNodeData.origin.nodeColor,
                                effectViewData: effectViewData
                            )
                        } else {
                            occupiedNodeViewData = nil
                        }
                        nodePlaceViewDataMatrix[y][x] = GameBoardViewData.NodePlaceViewData(
                            occupiedNodeViewData: occupiedNodeViewData
                        )
                    }
                }
                gameBoardViewData = GameBoardViewData(
                    nodePlaceViewDataMatrix: nodePlaceViewDataMatrix,
                    horizontalLinkMatrix: capturedGameBoardData.horizontalLinkMatrix,
                    verticalLinkMatrix: capturedGameBoardData.verticalLinkMatrix,
                    diagonalLinkMatrix: capturedGameBoardData.diagonalLinkMatrix
                )

                if capturedActiveBingletProcessData.isHintVisible {
                    var hintNodePlaceViewDataMatrix: Matrix<GameBoardHintViewData.NodePlaceViewData> = Array(
                        repeating: Array(
                            repeating: .empty,
                            count: Constant.gameBoardHorizontalNodeCount
                        ),
                        count: Constant.gameBoardVerticalNodeCount
                    )
                    for y in 0..<Constant.gameBoardVerticalNodeCount {
                        for x in 0..<Constant.gameBoardHorizontalNodeCount {
                            let hintNodePlaceData = placeableGameBoardHintData.nodePlaceDataMatrix[y][x]
                            switch hintNodePlaceData {
                            case .empty, .insideBingleRegion:
                                hintNodePlaceViewDataMatrix[y][x] = .empty
                            case .expectedToFormBingle(let comboCount, let hasLeadingComboCount):
                                hintNodePlaceViewDataMatrix[y][x] = .expectedToFormBingle(
                                    multiplicationValue: Logic.getVisualMultiplicationValue(comboCount: comboCount),
                                    hasLeadingComboCount: hasLeadingComboCount
                                )
                            }
                        }
                    }
                    var hintHorizontalLinkPlaceViewDataMatrix: Matrix<GameBoardHintViewData.SimpleLinkPlaceViewData> = Array(
                        repeating: Array(
                            repeating: .empty,
                            count: Constant.gameBoardHorizontalNodeCount - 1
                        ),
                        count: Constant.gameBoardVerticalNodeCount
                    )
                    for y in 0..<Constant.gameBoardVerticalNodeCount {
                        for x in 0..<Constant.gameBoardHorizontalNodeCount - 1 {
                            let hintHorizontalLinkPlaceData = placeableGameBoardHintData.horizontalLinkPlaceDataMatrix[y][x]
                            switch hintHorizontalLinkPlaceData {
                            case .empty:
                                hintHorizontalLinkPlaceViewDataMatrix[y][x] = .empty
                            case .expectedToFormBingle:
                                hintHorizontalLinkPlaceViewDataMatrix[y][x] = .expectedToFormBingle
                            }
                        }
                    }
                    var hintVerticalLinkPlaceViewDataMatrix: Matrix<GameBoardHintViewData.SimpleLinkPlaceViewData> = Array(
                        repeating: Array(
                            repeating: .empty,
                            count: Constant.gameBoardHorizontalNodeCount
                        ),
                        count: Constant.gameBoardVerticalNodeCount - 1
                    )
                    for y in 0..<Constant.gameBoardVerticalNodeCount - 1 {
                        for x in 0..<Constant.gameBoardHorizontalNodeCount {
                            let hintVerticalLinkPlaceData = placeableGameBoardHintData.verticalLinkPlaceDataMatrix[y][x]
                            switch hintVerticalLinkPlaceData {
                            case .empty:
                                hintVerticalLinkPlaceViewDataMatrix[y][x] = .empty
                            case .expectedToFormBingle:
                                hintVerticalLinkPlaceViewDataMatrix[y][x] = .expectedToFormBingle
                            }
                        }
                    }
                    var hintDiagonalLinkPlaceViewDataMatrix: Matrix<GameBoardHintViewData.DiagonalLinkPlaceViewData> = Array(
                        repeating: Array(
                            repeating: .empty,
                            count: Constant.gameBoardHorizontalNodeCount - 1
                        ),
                        count: Constant.gameBoardVerticalNodeCount - 1
                    )
                    for y in 0..<Constant.gameBoardVerticalNodeCount - 1 {
                        for x in 0..<Constant.gameBoardHorizontalNodeCount - 1 {
                            let hintDiagonalLinkPlaceData = placeableGameBoardHintData.diagonalLinkPlaceDataMatrix[y][x]
                            switch hintDiagonalLinkPlaceData {
                            case .empty:
                                hintDiagonalLinkPlaceViewDataMatrix[y][x] = .empty
                            case .expectedToFormBingleWithSlash:
                                hintDiagonalLinkPlaceViewDataMatrix[y][x] = .expectedToFormBingleWithSlash
                            case .expectedToFormBingleWithBackslash:
                                hintDiagonalLinkPlaceViewDataMatrix[y][x] = .expectedToFormBingleWithBackslash
                            case .expectedToFormBingleWithCross:
                                hintDiagonalLinkPlaceViewDataMatrix[y][x] = .expectedToFormBingleWithCross
                            }
                        }
                    }
                    gameBoardHintViewData = GameBoardHintViewData(
                        nodePlaceViewDataMatrix: hintNodePlaceViewDataMatrix,
                        horizontalLinkPlaceViewDataMatrix: hintHorizontalLinkPlaceViewDataMatrix,
                        verticalLinkPlaceViewDataMatrix: hintVerticalLinkPlaceViewDataMatrix,
                        diagonalLinkPlaceViewDataMatrix: hintDiagonalLinkPlaceViewDataMatrix
                    )
                } else {
                    gameBoardHintViewData = nil
                }

                placeButtonViewData = .enabled
            }
        } else { // active binglet 프로세스가 진행 중이지 않은 경우.
            var nodePlaceViewDataMatrix: Matrix<GameBoardViewData.NodePlaceViewData>
            = Array(
                repeating: Array(
                    repeating: GameBoardViewData.NodePlaceViewData(occupiedNodeViewData: nil),
                    count: Constant.gameBoardHorizontalNodeCount
                ),
                count: Constant.gameBoardVerticalNodeCount
            )
            for y in 0..<Constant.gameBoardVerticalNodeCount {
                for x in 0..<Constant.gameBoardHorizontalNodeCount {
                    let occupiedNodeData = capturedGameBoardData.nodePlaceDataMatrix[y][x].occupiedNodeData
                    let occupiedNodeViewData: GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData?
                    if let occupiedNodeData {
                        let effectViewData: GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData.EffectViewData?
                        if let visualMultiplicationValue = Logic.getVisualMultiplicationValue(comboCount: occupiedNodeData.comboCount) {
                            effectViewData = GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData.EffectViewData(
                                mainColor: Logic.getNodeEffectMainColor(comboCount: occupiedNodeData.comboCount),
                                multiplicationValue: visualMultiplicationValue,
                                isHighlighted: false
                            )
                        } else {
                            effectViewData = nil
                        }
                        occupiedNodeViewData = GameBoardViewData.NodePlaceViewData.OccupiedNodeViewData(
                            color: occupiedNodeData.origin.nodeColor,
                            effectViewData: effectViewData
                        )
                    } else {
                        occupiedNodeViewData = nil
                    }
                    nodePlaceViewDataMatrix[y][x] = GameBoardViewData.NodePlaceViewData(
                        occupiedNodeViewData: occupiedNodeViewData
                    )
                }
            }
            gameBoardViewData = GameBoardViewData(
                nodePlaceViewDataMatrix: nodePlaceViewDataMatrix,
                horizontalLinkMatrix: capturedGameBoardData.horizontalLinkMatrix,
                verticalLinkMatrix: capturedGameBoardData.verticalLinkMatrix,
                diagonalLinkMatrix: capturedGameBoardData.diagonalLinkMatrix
            )

            gameBoardHintViewData = nil

            placeButtonViewData = .disabled
        }

        await MainActor.run {
            viewModel.gameScoreAboveGameBoard = gameScoreAboveGameBoard
            viewModel.gameBoardGridViewData = gameBoardGridViewData
            viewModel.gameBoardViewData = gameBoardViewData
            viewModel.gameBoardBingleEffectViewData = gameBoardBingleEffectViewData
            viewModel.activeBingletContainerViewData = activeBingletContainerViewData
            viewModel.bingletActivationViewCount = bingletActivationViewCount
            viewModel.bingletPlacingViewCount = bingletPlacingViewCount
            viewModel.gameBoardHintViewData = gameBoardHintViewData
            viewModel.placeButtonViewData = placeButtonViewData
            viewModel.waitingBingletContainerViewDataArray = waitingBingletContainerViewDataArray
            viewModel.resultDialogViewData = resultDialogViewData
            viewModel.isBeforeRestartDialogShown = isBeforeRestartDialogShown
            viewModel.isBannerAdShown = capturedIsBannerAdShown
            viewModel.bannerAdUnitId = capturedBannerAdUnitId
        }
    }

    // MARK: - BasicGamePlateInterface

    func handleGameBoardDrag(translation: CGSize, unitDistance: CGFloat) async {
        guard let activeBingletProcessData else { return }
        guard let dragProcessData = activeBingletProcessData.dragProcessData else {
            // 드래그의 시작이므로 필요한 정보를 저장하고 반환한다.
            self.activeBingletProcessData?.dragProcessData = ActiveBingletProcessData.DragProcessData(
                gridOffsetWhenDragBegan: activeBingletProcessData.accumulatedPlacingChoice.gridOffset,
                residualTranslation: .zero
            )
            return
        }
        let newGridOffset = Logic.getNewGridOffset(
            translation: translation,
            gridOffsetWhenDragBegan: dragProcessData.gridOffsetWhenDragBegan,
            currentGridOffset: activeBingletProcessData.accumulatedPlacingChoice.gridOffset,
            binglet: activeBingletProcessData.binglet,
            rotation: activeBingletProcessData.accumulatedPlacingChoice.rotation,
            unitDistance: unitDistance
        )
        self.activeBingletProcessData?.accumulatedPlacingChoice.gridOffset = newGridOffset
        var residualTranslation: CGSize = .zero
        residualTranslation.width = translation.width - CGFloat(
            newGridOffset.x - dragProcessData.gridOffsetWhenDragBegan.x
        ) * unitDistance
        residualTranslation.height = translation.height - CGFloat(
            newGridOffset.y - dragProcessData.gridOffsetWhenDragBegan.y
        ) * unitDistance
        self.activeBingletProcessData?.dragProcessData?.residualTranslation = residualTranslation
        await updateViewModel()
    }

    func handleGameBoardDragEnd() async {
        // 드래그의 끝이므로 프로세스 데이터를 초기화한다.
        activeBingletProcessData?.dragProcessData = nil
        await updateViewModel()
    }

    func handleGameBoardTap() async {
        self.activeBingletProcessData?.accumulatedPlacingChoice.tapCount += 1
        guard let capturedActiveBingletProcessData = activeBingletProcessData else { return }
        let minimalGridOffsetX = Logic.getMinimalGridOffsetX(
            binglet: capturedActiveBingletProcessData.binglet,
            rotation: capturedActiveBingletProcessData.accumulatedPlacingChoice.rotation
        )
        let maximalGridOffsetX = Logic.getMaximalGridOffsetX(
            binglet: capturedActiveBingletProcessData.binglet,
            rotation: capturedActiveBingletProcessData.accumulatedPlacingChoice.rotation
        )
        let minimalGridOffsetY = Logic.getMinimalGridOffsetY(
            binglet: capturedActiveBingletProcessData.binglet,
            rotation: capturedActiveBingletProcessData.accumulatedPlacingChoice.rotation
        )
        let maximalGridOffsetY = Logic.getMaximalGridOffsetY(
            binglet: capturedActiveBingletProcessData.binglet,
            rotation: capturedActiveBingletProcessData.accumulatedPlacingChoice.rotation
        )
        if capturedActiveBingletProcessData.accumulatedPlacingChoice.gridOffset.x < minimalGridOffsetX {
            self.activeBingletProcessData?.accumulatedPlacingChoice.gridOffset.x = minimalGridOffsetX
        }
        if maximalGridOffsetX < capturedActiveBingletProcessData.accumulatedPlacingChoice.gridOffset.x {
            self.activeBingletProcessData?.accumulatedPlacingChoice.gridOffset.x = maximalGridOffsetX
        }
        if capturedActiveBingletProcessData.accumulatedPlacingChoice.gridOffset.y < minimalGridOffsetY {
            self.activeBingletProcessData?.accumulatedPlacingChoice.gridOffset.y = minimalGridOffsetY
        }
        if maximalGridOffsetY < capturedActiveBingletProcessData.accumulatedPlacingChoice.gridOffset.y {
            self.activeBingletProcessData?.accumulatedPlacingChoice.gridOffset.y = maximalGridOffsetY
        }
        await updateViewModel()
    }

    func handlePlaceButtonTap() async -> Bool {
        /*
         activeBingletProcessData 안의 캐시 맵에서 정보를 가져온다:
             duplicatableGameBoardDataWithPlacedBingletFromCache
             placeableGameBoardHintDataFromCache
             resolvedGameBoardDataFromCache
             가져오는 과정에 문제가 있으면 에러 로그 찍고 true 반환.
         activeBingletProcessData를 초기화한다.
         bingled node가 없는 경우:
             gameBoardData를 업데이트한다.
             updateViewModel.
         bingled node가 있는 경우:
             scoreEarningProcessData를 업데이트한다.
             gameBoardData를 업데이트한다.
             updateViewModel.
             잠깐 sleep.
             areBingledNodesGathered를 true로 한다.
             updateViewModel.
             잠깐 sleep.
             게임 스코어에 earnedScore를 더한다.
             scoreEarningProcessData를 초기화한다.
             updateViewModel.
         잠깐 sleep.
         빙글렛 하나를 waitingBingletArray에서 꺼낸다(removeFirst).
         랜덤 빙글렛을 하나 만들어서 waitingBingletArray에 추가한다(append).
         꺼낸 빙글렛의 모든 accumulatedPlacingChoice에 대해 계산해서 캐시 맵을 얻는다.
         activeBingletProcessData를 업데이트한다.
         캐시 맵 계산할 때 같이 계산한 isPossibleToPlaceBingletSomewhere를 반환한다.
         */

        guard let capturedActiveBingletProcessData = activeBingletProcessData else {
            await logDirector.plateLog(.basicGame, .error, "Active binglet process is not ongoing.")
            return true
        }
        guard let duplicatableGameBoardDataWithPlacedBingletFromCache = capturedActiveBingletProcessData.duplicatableGameBoardDataWithPlacedBingletCacheMap[capturedActiveBingletProcessData.accumulatedPlacingChoice.toPlacingChoice()] else {
            await logDirector.plateLog(.basicGame, .error, "duplicatableGameBoardDataWithPlacedBinglet is nil.")
            return true
        }
        guard let gameBoardHintDataFromCache = capturedActiveBingletProcessData.gameBoardHintDataCacheMap[capturedActiveBingletProcessData.accumulatedPlacingChoice.toPlacingChoice()] else {
            await logDirector.plateLog(.basicGame, .error, "gameBoardHintData is nil.")
            return true
        }
        guard case .placeable(let placeableGameBoardHintDataFromCache) = gameBoardHintDataFromCache else {
            await logDirector.plateLog(.basicGame, .error, "Not placeable hint.")
            return true
        }
        guard let resolvedGameBoardDataFromCache = capturedActiveBingletProcessData.resolvedGameBoardDataCacheMap[capturedActiveBingletProcessData.accumulatedPlacingChoice.toPlacingChoice()] else {
            await logDirector.plateLog(.basicGame, .error, "resolvedGameBoardData is nil.")
            return true
        }

        activeBingletProcessData = nil

        var isThereAnyBingledNode = false
        for row in placeableGameBoardHintDataFromCache.nodePlaceDataMatrix {
            for nodePlaceHint in row {
                switch nodePlaceHint {
                case .expectedToFormBingle:
                    isThereAnyBingledNode = true
                default:
                    _ = 0
                }
            }
        }

        if !isThereAnyBingledNode {
            gameBoardData = resolvedGameBoardDataFromCache
            bingletPlacingCount += 1
            gameBoardData = Logic.getBlockUpdatedGameBoardData(
                gameBoardDataBeforeBlockUpdate: gameBoardData,
                bingletPlacingCount: bingletPlacingCount
            )
            await updateViewModel()
        } else {
            var bingledNodeMatrix: Matrix<Bool> = Array(
                repeating: Array(
                    repeating: false,
                    count: Constant.gameBoardHorizontalNodeCount
                ),
                count: Constant.gameBoardVerticalNodeCount
            )
            var bingledNodeCount: UInt = 0
            var leadingComboCount: UInt = 0
            for y in 0..<Constant.gameBoardVerticalNodeCount {
                for x in 0..<Constant.gameBoardHorizontalNodeCount {
                    switch placeableGameBoardHintDataFromCache.nodePlaceDataMatrix[y][x] {
                    case .expectedToFormBingle(_, let hasLeadingComboCount):
                        bingledNodeMatrix[y][x] = true
                        bingledNodeCount += 1
                        if hasLeadingComboCount {
                            switch duplicatableGameBoardDataWithPlacedBingletFromCache.nodePlaceDataMatrix[y][x] {
                            case .singleOccupied(let nodeData):
                                leadingComboCount = nodeData.comboCount
                            default:
                                _ = 0
                            }
                        }
                    default:
                        _ = 0
                    }
                }
            }
            let earnedScore = Logic.getEarnedScore(
                bingledNodeCount: bingledNodeCount,
                leadingComboCount: leadingComboCount
            )
            scoreEarningProcessData = ScoreEarningProcessData(
                bingledNodeMatrix: bingledNodeMatrix,
                leadingComboCount: leadingComboCount,
                earnedScore: earnedScore,
                areBingledNodesGathered: false
            )
            gameBoardData = resolvedGameBoardDataFromCache
            bingletPlacingCount += 1
            gameBoardData = Logic.getBlockUpdatedGameBoardData(
                gameBoardDataBeforeBlockUpdate: gameBoardData,
                bingletPlacingCount: bingletPlacingCount
            )
            await updateViewModel()
            try? await Task.sleep(nanoseconds: Constant.delayBeforeBingledNodeGathering.nanosecondsUInt64)
            scoreEarningProcessData?.areBingledNodesGathered = true
            await updateViewModel()
            try? await Task.sleep(nanoseconds: Constant.animationDurationOfBingledNodeGathering.nanosecondsUInt64)
            gameScore += scoreEarningProcessData?.earnedScore ?? 0
            scoreEarningProcessData = nil
            await updateViewModel()
        }
        try? await Task.sleep(nanoseconds: Constant.delayBeforeBingletActivation.nanosecondsUInt64)
        let dequeuedBinglet = waitingBingletArray.removeFirst()
        let randomBinglet = Binglet(rawValue: Int.random(in: 0..<9)) ?? .s
        waitingBingletArray.append(randomBinglet)
        let dateBeforeCacheCalculation = Date()
        var duplicatableGameBoardDataWithPlacedBingletCacheMap: [ActiveBingletProcessData.PlacingChoice: DuplicatableGameBoardData] = [:]
        var gameBoardHintDataCacheMap: [ActiveBingletProcessData.PlacingChoice: GameBoardHintData] = [:]
        var resolvedGameBoardDataCacheMap: [ActiveBingletProcessData.PlacingChoice: GameBoardData] = [:]
        var isPossibleToPlaceBingletSomewhere: Bool = false
        for rotation in QuarterRotation.allCases {
            for gridOffsetX in Logic.getMinimalGridOffsetX(
                binglet: dequeuedBinglet,
                rotation: rotation
            )...Logic.getMaximalGridOffsetX(
                binglet: dequeuedBinglet,
                rotation: rotation
            ) {
                for gridOffsetY in Logic.getMinimalGridOffsetY(
                    binglet: dequeuedBinglet,
                    rotation: rotation
                )...Logic.getMaximalGridOffsetY(
                    binglet: dequeuedBinglet,
                    rotation: rotation
                ) {
                    let activeBingletPlacingChoice = ActiveBingletProcessData.PlacingChoice(
                        rotation: rotation,
                        gridOffset: GridVector(x: gridOffsetX, y: gridOffsetY)
                    )
                    let duplicatableGameBoardDataWithPlacedBinglet = Logic.getDuplicatableGameBoardDataWithPlacedBinglet(
                        gameBoardData: gameBoardData,
                        binglet: dequeuedBinglet,
                        placingChoice: activeBingletPlacingChoice
                    )
                    duplicatableGameBoardDataWithPlacedBingletCacheMap[activeBingletPlacingChoice] = duplicatableGameBoardDataWithPlacedBinglet
                    let gameBoardHintData = Logic.getGameBoardHintData(
                        gameBoardData: gameBoardData,
                        binglet: dequeuedBinglet,
                        placingChoice: activeBingletPlacingChoice,
                        duplicatableGameBoardDataWithPlacedBinglet: duplicatableGameBoardDataWithPlacedBinglet
                    )
                    gameBoardHintDataCacheMap[activeBingletPlacingChoice] = gameBoardHintData
                    if case .placeable = gameBoardHintData {
                        isPossibleToPlaceBingletSomewhere = true
                    }
                    resolvedGameBoardDataCacheMap[activeBingletPlacingChoice] = Logic.getResolvedGameBoardData(
                        gameBoardData: gameBoardData,
                        binglet: dequeuedBinglet,
                        placingChoice: activeBingletPlacingChoice,
                        duplicatableGameBoardDataWithPlacedBinglet: duplicatableGameBoardDataWithPlacedBinglet,
                        gameBoardHintData: gameBoardHintData
                    )
                }
            }
        }
        let dateAfterCacheCalculation = Date()
        await logDirector.plateLog(.basicGame, .debug, "Cache calculation time: \(dateAfterCacheCalculation.timeIntervalSince(dateBeforeCacheCalculation))")
        activeBingletProcessData = ActiveBingletProcessData(
            binglet: dequeuedBinglet,
            accumulatedPlacingChoice: ActiveBingletProcessData.AccumulatedPlacingChoice(
                tapCount: 0,
                gridOffset: .zero
            ),
            isHintVisible: false,
            dragProcessData: nil,
            duplicatableGameBoardDataWithPlacedBingletCacheMap: duplicatableGameBoardDataWithPlacedBingletCacheMap,
            gameBoardHintDataCacheMap: gameBoardHintDataCacheMap,
            resolvedGameBoardDataCacheMap: resolvedGameBoardDataCacheMap
        )
        bingletActivationCount += 1
        await updateViewModel()
        try? await Task.sleep(nanoseconds: Constant.animationDurationOfWaitingBingletArrayPulling.nanosecondsUInt64)
        activeBingletProcessData?.isHintVisible = true
        await updateViewModel()
        return isPossibleToPlaceBingletSomewhere
    }

    func getGameState() async -> GameState {
        gameState
    }

    func setGameState(_ value: GameState) async {
        gameState = value
        await updateViewModel()
    }

    func getGameScore() async -> Int {
        gameScore
    }

    func getIsResultDialogShown() async -> Bool {
        isResultDialogShown
    }

    func setIsResultDialogShown(_ value: Bool) async {
        isResultDialogShown = value
        await updateViewModel()
    }

    func getIsBeforeRestartDialogShown() async -> Bool {
        isBeforeRestartDialogShown
    }

    func setIsBeforeRestartDialogShown(_ value: Bool) async {
        isBeforeRestartDialogShown = value
        await updateViewModel()
    }

    func getActiveBingletProcessData() async -> ActiveBingletProcessData? {
        activeBingletProcessData
    }

    func setActiveBingletProcessData(_ value: ActiveBingletProcessData?) async {
        activeBingletProcessData = value
        await updateViewModel()
    }

    func getSnapshot() async -> BasicGameSnapshot {
        BasicGameSnapshot(
            gameState: gameState,
            gameScore: gameScore,
            gameBoardData: gameBoardData,
            waitingBingletArray: waitingBingletArray,
            isResultDialogShown: isResultDialogShown,
            isBeforeRestartDialogShown: isBeforeRestartDialogShown,
            activeBingletProcessData: activeBingletProcessData,
            bingletActivationCount: bingletActivationCount,
            bingletPlacingCount: bingletPlacingCount,
            scoreEarningProcessData: scoreEarningProcessData
        )
    }

    func setBySnapshot(_ value: BasicGameSnapshot) async {
        gameState = value.gameState
        gameScore = value.gameScore
        gameBoardData = value.gameBoardData
        waitingBingletArray = value.waitingBingletArray
        isResultDialogShown = value.isResultDialogShown
        isBeforeRestartDialogShown = value.isBeforeRestartDialogShown
        activeBingletProcessData = value.activeBingletProcessData
        bingletActivationCount = value.bingletActivationCount
        bingletPlacingCount = value.bingletPlacingCount
        scoreEarningProcessData = value.scoreEarningProcessData
        await updateViewModel()
    }

    func resetGame() async {
        gameState = Constant.initialGameState
        gameScore = Constant.initialGameScore
        gameBoardData = Constant.initialGameBoardData
        waitingBingletArray = Constant.initialWaitingBingletArray
        isResultDialogShown = Constant.initialIsResultDialogShown
        isBeforeRestartDialogShown = Constant.initialIsBeforeRestartDialogShown
        activeBingletProcessData = Constant.initialActiveBingletProcessData
        bingletActivationCount = Constant.initialBingletActivationCount
        bingletPlacingCount = Constant.initialBingletPlacingCount
        scoreEarningProcessData = Constant.initialScoreEarningProcessData

        gameBoardData = Logic.getBlockUpdatedGameBoardData(
            gameBoardDataBeforeBlockUpdate: gameBoardData,
            bingletPlacingCount: bingletPlacingCount
        )

        let bingletToBeActivated = Binglet(rawValue: Int.random(in: 0..<9)) ?? .s
        waitingBingletArray = []
        for _ in 0..<Constant.waitingBingletArrayCount {
            waitingBingletArray.append(Binglet(rawValue: Int.random(in: 0..<9)) ?? .s)
        }
        let dateBeforeCacheCalculation = Date()
        var duplicatableGameBoardDataWithPlacedBingletCacheMap: [ActiveBingletProcessData.PlacingChoice: DuplicatableGameBoardData] = [:]
        var gameBoardHintDataCacheMap: [ActiveBingletProcessData.PlacingChoice: GameBoardHintData] = [:]
        var resolvedGameBoardDataCacheMap: [ActiveBingletProcessData.PlacingChoice: GameBoardData] = [:]
        for rotation in QuarterRotation.allCases {
            for gridOffsetX in Logic.getMinimalGridOffsetX(
                binglet: bingletToBeActivated,
                rotation: rotation
            )...Logic.getMaximalGridOffsetX(
                binglet: bingletToBeActivated,
                rotation: rotation
            ) {
                for gridOffsetY in Logic.getMinimalGridOffsetY(
                    binglet: bingletToBeActivated,
                    rotation: rotation
                )...Logic.getMaximalGridOffsetY(
                    binglet: bingletToBeActivated,
                    rotation: rotation
                ) {
                    let activeBingletPlacingChoice = ActiveBingletProcessData.PlacingChoice(
                        rotation: rotation,
                        gridOffset: GridVector(x: gridOffsetX, y: gridOffsetY)
                    )
                    let duplicatableGameBoardDataWithPlacedBinglet = Logic.getDuplicatableGameBoardDataWithPlacedBinglet(
                        gameBoardData: gameBoardData,
                        binglet: bingletToBeActivated,
                        placingChoice: activeBingletPlacingChoice
                    )
                    duplicatableGameBoardDataWithPlacedBingletCacheMap[activeBingletPlacingChoice] = duplicatableGameBoardDataWithPlacedBinglet
                    let gameBoardHintData = Logic.getGameBoardHintData(
                        gameBoardData: gameBoardData,
                        binglet: bingletToBeActivated,
                        placingChoice: activeBingletPlacingChoice,
                        duplicatableGameBoardDataWithPlacedBinglet: duplicatableGameBoardDataWithPlacedBinglet
                    )
                    gameBoardHintDataCacheMap[activeBingletPlacingChoice] = gameBoardHintData
                    resolvedGameBoardDataCacheMap[activeBingletPlacingChoice] = Logic.getResolvedGameBoardData(
                        gameBoardData: gameBoardData,
                        binglet: bingletToBeActivated,
                        placingChoice: activeBingletPlacingChoice,
                        duplicatableGameBoardDataWithPlacedBinglet: duplicatableGameBoardDataWithPlacedBinglet,
                        gameBoardHintData: gameBoardHintData
                    )
                }
            }
        }
        let dateAfterCacheCalculation = Date()
        await logDirector.plateLog(.basicGame, .debug, "Cache calculation time: \(dateAfterCacheCalculation.timeIntervalSince(dateBeforeCacheCalculation))")
        activeBingletProcessData = ActiveBingletProcessData(
            binglet: bingletToBeActivated,
            accumulatedPlacingChoice: ActiveBingletProcessData.AccumulatedPlacingChoice(
                tapCount: 0,
                gridOffset: .zero
            ),
            isHintVisible: false,
            dragProcessData: nil,
            duplicatableGameBoardDataWithPlacedBingletCacheMap: duplicatableGameBoardDataWithPlacedBingletCacheMap,
            gameBoardHintDataCacheMap: gameBoardHintDataCacheMap,
            resolvedGameBoardDataCacheMap: resolvedGameBoardDataCacheMap
        )
        bingletActivationCount += 1
        await updateViewModel()
        try? await Task.sleep(nanoseconds: Constant.animationDurationOfWaitingBingletArrayPulling.nanosecondsUInt64)
        activeBingletProcessData?.isHintVisible = true

        await updateViewModel()
    }

    func setBannerAdUnitId(_ bannerAdUnitId: String?) async {
        self.bannerAdUnitId = bannerAdUnitId
        await updateViewModel()
    }

    func setIsBannerAdShown(_ isBannerAdShown: Bool) async {
        self.isBannerAdShown = isBannerAdShown
        await updateViewModel()
    }

    func resetAd() async {
        bannerAdUnitId = nil
        isBannerAdShown = false
        await updateViewModel()
    }
}
