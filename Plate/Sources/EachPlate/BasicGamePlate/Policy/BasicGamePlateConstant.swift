// MARK: - Module Dependency

import SwiftUI
import Universe
import Spectrum

// MARK: - Body

enum BasicGamePlateConstant {

    // MARK: - Logical

    static let bingletContainerHorizontalNodeCount: Int = 4
    static let bingletContainerVerticalNodeCount: Int = 4

    static let gameBoardHorizontalNodeCount: Int = 10
    static let gameBoardVerticalNodeCount: Int = 10

    static let waitingBingletArrayCount: Int = 4

    /// 0.5보다 커야 한다.
    static let gridOffsetPreservingRatio: CGFloat = 0.55

    static let earnedScorePerNode: Int = 1

    static let nodePlaceBlockPeriod: UInt = 10
    static let nodePlaceBlockStartCount: UInt = 3

    // MARK: - Initial Value

    static let initialGameState: GameState = .playing
    static let initialGameScore: Int = 0
    static let initialGameBoardData: GameBoardData = GameBoardData(
        nodePlaceDataMatrix:  Array(
            repeating: Array(
                repeating: GameBoardData.NodePlaceData(
                    blockState: .notBlocked,
                    occupiedNodeData: nil
                ),
                count: gameBoardHorizontalNodeCount
            ),
            count: gameBoardVerticalNodeCount
        ),
        horizontalLinkMatrix: Array(
            repeating: Array(
                repeating: .empty,
                count: gameBoardHorizontalNodeCount - 1
            ),
            count: gameBoardVerticalNodeCount
        ),
        verticalLinkMatrix: Array(
            repeating: Array(
                repeating: .empty,
                count: gameBoardHorizontalNodeCount
            ),
            count: gameBoardVerticalNodeCount - 1
        ),
        diagonalLinkMatrix: Array(
            repeating: Array(
                repeating: .empty,
                count: gameBoardHorizontalNodeCount - 1
            ),
            count: gameBoardVerticalNodeCount - 1
        )
    )
    static let initialActiveBingletProcessData: ActiveBingletProcessData? = nil
    static let initialBingletActivationCount: UInt = 0
    static let initialBingletPlacingCount: UInt = 0
    static let initialWaitingBingletArray: [Binglet] = []
    static let initialIsResultDialogShown: Bool = false
    static let initialIsBeforeRestartDialogShown: Bool = false
    static let initialScoreEarningProcessData: ScoreEarningProcessData? = nil

    static let initialGameScoreAboveGameBoard: Int? = 0
    static let initialGameBoardGridViewData: GameBoardGridViewData = GameBoardGridViewData(
        nodePlaceViewStateMatrix: Array(
            repeating: Array(
                repeating: GameBoardGridViewData.NodePlaceViewState.notBlocked,
                count: gameBoardHorizontalNodeCount
            ),
            count: gameBoardVerticalNodeCount
        ),
    )
    static let initialGameBoardViewData: GameBoardViewData = GameBoardViewData(
        nodePlaceViewDataMatrix: Array(
            repeating: Array(
                repeating: GameBoardViewData.NodePlaceViewData(occupiedNodeViewData: nil),
                count: gameBoardHorizontalNodeCount
            ),
            count: gameBoardVerticalNodeCount
        ),
        horizontalLinkMatrix: Array(
            repeating: Array(
                repeating: .empty,
                count: gameBoardHorizontalNodeCount - 1
            ),
            count: gameBoardVerticalNodeCount
        ),
        verticalLinkMatrix: Array(
            repeating: Array(
                repeating: .empty,
                count: gameBoardHorizontalNodeCount
            ),
            count: gameBoardVerticalNodeCount - 1
        ),
        diagonalLinkMatrix: Array(
            repeating: Array(
                repeating: .empty,
                count: gameBoardHorizontalNodeCount - 1
            ),
            count: gameBoardVerticalNodeCount - 1
        )
    )
    static let initialGameBoardBingleEffectViewData: GameBoardBingleEffectViewData? = nil
    static let initialActiveBingletContainerViewData: ActiveBingletContainerViewData? = nil
    static let initialBingletActivationViewCount: UInt = 0
    static let initialBingletPlacingViewCount: UInt = 0
    static let initialGameBoardHintViewData: GameBoardHintViewData? = nil
    static let initialPlaceButtonViewData: PlaceButtonViewData = .disabled
    static let initialWaitingBingletContainerViewDataArray: [WaitingBingletContainerViewData] = []
    static let initialResultDialogViewData: ResultDialogViewData? = nil

    // MARK: - Visual

    static let delayBeforeBingletActivation: TimeInterval = TimeInterval(milliseconds: 420)
    static let delayBeforeBingledNodeGathering: TimeInterval = TimeInterval(milliseconds: 200)
    static let animationDurationOfBingledNodeGathering: TimeInterval = TimeInterval(milliseconds: 1200)
    static let animationDurationOfGameScoreChanging: TimeInterval = TimeInterval(milliseconds: 200)
    static let deleyBeforeGameFinish: TimeInterval = TimeInterval(milliseconds: 5000)
    static let deleyBeforeShowingResultDialog: TimeInterval = TimeInterval(milliseconds: 2000)

    static let idealHorizontalPadding: CGFloat = 10
    static let idealVerticalPadding: CGFloat = 80

    static let gameBoardUnitAreaLinearSize: CGFloat = 36
    static let gameBoardNodeCircleLinearSize: CGFloat = 26
    static let gameBoardLinkWidth: CGFloat = 10
    static var gameBoardDiagonalLinkLength: CGFloat {
        gameBoardUnitAreaLinearSize * 1.414 - gameBoardLinkWidth
    }
    static let gameBoardBackgroundColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(DS.PaletteColor.black)
            : UIColor(DS.PaletteColor.white)
        }
    )

    static let gameBoardGridCornerRadius: CGFloat = 7
    static let gameBoardGridNodeColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "2B2B2B"))
            : UIColor(Color(hex: "EFEFEF"))
        }
    )

    static let gameBoardGridNodeCircleLinearSize: CGFloat = 6
    static let gameBoardGridLinkColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "181818"))
            : UIColor(Color(hex: "F9F9F9"))
        }
    )

    static let gameBoardGridLinkWidth: CGFloat = 2
    static var gameBoardGridSimpleLinkLength: CGFloat {
        gameBoardUnitAreaLinearSize - gameBoardGridNodeCircleLinearSize - 18
    }
    static var gameBoardGridDiagonalLinkLength: CGFloat {
        gameBoardUnitAreaLinearSize * 1.414 - gameBoardGridNodeCircleLinearSize - 18
    }

    static let gameBoardGridBlockedNodeColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "323232"))
            : UIColor(Color(hex: "D2D2D2"))
        }
    )
    static let gameBoardGridBlockedNodeLinearSize: CGFloat = 36.1
    static let gameBoardGridBlockedNodeCrossMarkLineLength: CGFloat = 40
    static let gameBoardGridBlockedNodeCrossMarkLineWidth: CGFloat = 5

    static let linkColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "73A5BF"))
            : UIColor(Color(hex: "9ADCFF"))
        }
    )
    static let linkShadeColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "7096AB"))
            : UIColor(Color(hex: "9DD2EF"))
        }
    )
    static let gameBoardNodeMultiplicationValueTextColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(DS.PaletteColor.white)
            : UIColor(DS.PaletteColor.black)
        }
    )

    static let gameBoardHintNodeColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "73A5BF"))
            : UIColor(Color(hex: "9ADCFF"))
        }
    )
    static let gameBoardHintNodeCircleLinearSize: CGFloat = 32
    static let gameBoardHintNodeMultiplicationValueTextColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "D9E6FF"))
            : UIColor(Color(hex: "4069B4"))
        }
    )
    static let gameBoardHintIllegalCrossMarkColor: Color = Color(hex: "EA8181")
    static let gameBoardHintIllegalCrossMarkLineLength: CGFloat = 44
    static let gameBoardHintIllegalCrossMarkLineWidth: CGFloat = 6
    static let gameBoardHintLinkColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "73A5BF"))
            : UIColor(Color(hex: "9ADCFF"))
        }
    )
    static let gameBoardHintLinkWidth: CGFloat = 16
    static var gameBoardHintDiagonalLinkLength: CGFloat {
        gameBoardUnitAreaLinearSize * 1.414
    }

    static let gameBoardBingleEffectNodeCenterColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "7BB0CC"))
            : UIColor(Color(hex: "D0ECFB"))
        }
    )
    static let gameBoardBingleEffectNodeBoundaryColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "73A5BF"))
            : UIColor(Color(hex: "9ADCFF"))
        }
    )
    static let gameBoardBingleEffectNodeCircleLinearSize: CGFloat = 34
    static let gameBoardBingleEffectMultiplicationValueTextColor: Color = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "5389EB"))
            : UIColor(Color(hex: "4069B4"))
        }
    )
    static let animationDurationOfGameBoardBingleEffectMultiplicationValueAppearing: TimeInterval
    = TimeInterval(milliseconds: 200)

    static let activeBingletContainerPadding: CGFloat = 5
    static let activeBingletContainerStrokeColor: Color  = Color(hex: "828282")

    static let waitingBingletContainerStrokeColor: Color  = Color(
        UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(Color(hex: "808080"))
            : UIColor(Color(hex: "B2B2B2"))
        }
    )
    static let waitingBingletContainerScale: CGFloat = 0.45
    static var waitingBingletContainerUnitAreaLinearSize: CGFloat {
        gameBoardUnitAreaLinearSize * waitingBingletContainerScale
    }
    static var waitingBingletContainerPadding: CGFloat {
        activeBingletContainerPadding * waitingBingletContainerScale
    }
    static var waitingBingletNodeCircleLinearSize: CGFloat {
        gameBoardNodeCircleLinearSize * waitingBingletContainerScale
    }
    static var waitingBingletLinkWidth: CGFloat {
        gameBoardLinkWidth * waitingBingletContainerScale
    }
    static var waitingBingletDiagonalLinkLength: CGFloat {
        (waitingBingletContainerUnitAreaLinearSize * 1.414 - waitingBingletLinkWidth)
    }
    static let animationDurationOfWaitingBingletArrayPulling: TimeInterval = TimeInterval(milliseconds: 300)
    static let waitingBingletArraySpacing: CGFloat = 20
}
