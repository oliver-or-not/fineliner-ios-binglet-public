// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct ActiveBingletContainerView: View {

    // MARK: - Reference

    @Environment(\.colorScheme) var colorScheme
    let viewData: ActiveBingletContainerViewData

    // MARK: - Constant

    // MARK: - State

    var body: some View {
        Spacer()
            .frame(
                width: CGFloat(Constant.gameBoardHorizontalNodeCount) * Constant.gameBoardUnitAreaLinearSize,
                height: CGFloat(Constant.gameBoardVerticalNodeCount) * Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                let rotationAngle: Double
                = Double(viewData.accumulatedPlacingChoice.tapCount) * (-(.pi / 2))
                RoundedRectangle(
                    cornerRadius: Constant.gameBoardNodeCircleLinearSize / 2 + Constant.activeBingletContainerPadding
                )
                .fill(Color(hex: "EDEDED").opacity(colorScheme == .dark ? 0.2 : 0.3))
                .stroke(
                    Constant.activeBingletContainerStrokeColor,
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        lineJoin: .miter,
                        miterLimit: 0,
                        dash: [10, 10.85],
                        dashPhase: 0
                    )
                )
                .frame(
                    width: CGFloat(Constant.bingletContainerHorizontalNodeCount) * Constant.gameBoardUnitAreaLinearSize
                    + Constant.activeBingletContainerPadding * 2,
                    height: CGFloat(Constant.bingletContainerVerticalNodeCount) * Constant.gameBoardUnitAreaLinearSize
                    + Constant.activeBingletContainerPadding * 2,
                )
                .overlay {
                    ZStack {
                        activeBingletContainerHorizontalLinkLayerView
                        activeBingletContainerVerticalLinkLayerView
                        activeBingletContainerDiagonalLinkLayerView
                        activeBingletContainerNodeLayerView
                    }
                }
                .rotationEffect(.radians(rotationAngle))
                .animation(.linear(duration: 0.1), value: rotationAngle)
                .offset(
                    CGSize(
                        width: CGFloat(viewData.accumulatedPlacingChoice.gridOffset.x) * Constant.gameBoardUnitAreaLinearSize,
                        height: CGFloat(viewData.accumulatedPlacingChoice.gridOffset.y) * Constant.gameBoardUnitAreaLinearSize
                    )
                )
                .offset(
                    CGSize(
                        width: min(
                            max(
                                -Constant.gameBoardUnitAreaLinearSize * Constant.gridOffsetPreservingRatio,
                                 viewData.residualTranslation.width
                                 * abs(viewData.residualTranslation.width)
                                 / Constant.gameBoardUnitAreaLinearSize * 0.4
                            ),
                            Constant.gameBoardUnitAreaLinearSize * Constant.gridOffsetPreservingRatio
                        ),
                        height: min(
                            max(
                                -Constant.gameBoardUnitAreaLinearSize * Constant.gridOffsetPreservingRatio,
                                 viewData.residualTranslation.height
                                 * abs(viewData.residualTranslation.height)
                                 / Constant.gameBoardUnitAreaLinearSize * 0.4
                            ),
                            Constant.gameBoardUnitAreaLinearSize * Constant.gridOffsetPreservingRatio
                        )
                    )
                )
            }
    }

    private var activeBingletContainerHorizontalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.horizontalLinkMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.horizontalLinkMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let simpleLinkPlaceState = row[horizontalIndex]
                        ActiveBingletContainerHorizontalLinkView(
                            simpleLinkPlaceState: simpleLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var activeBingletContainerVerticalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.verticalLinkMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.verticalLinkMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let simpleLinkPlaceState = row[horizontalIndex]
                        ActiveBingletContainerVerticalLinkView(
                            simpleLinkPlaceState: simpleLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var activeBingletContainerDiagonalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.diagonalLinkMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.diagonalLinkMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let diagonalLinkPlaceState = row[horizontalIndex]
                        ActiveBingletContainerDiagonalLinkView(
                            diagonalLinkPlaceState: diagonalLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var activeBingletContainerNodeLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.nodeMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.nodeMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let nodePlaceState = row[horizontalIndex]
                        ActiveBingletContainerNodeView(
                            nodeColor: viewData.nodeColor, nodePlaceState: nodePlaceState
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    ActiveBingletContainerView(
        viewData: .init(
            nodeColor: Binglet.crab.nodeColor,
            nodeMatrix: Binglet.crab.nodeMatrix,
            horizontalLinkMatrix: Binglet.crab.horizontalLinkMatrix,
            verticalLinkMatrix: Binglet.crab.verticalLinkMatrix,
            diagonalLinkMatrix: Binglet.crab.diagonalLinkMatrix,
            accumulatedPlacingChoice: .init(tapCount: 0, gridOffset: .zero),
            residualTranslation: .zero
        )
    )
}
