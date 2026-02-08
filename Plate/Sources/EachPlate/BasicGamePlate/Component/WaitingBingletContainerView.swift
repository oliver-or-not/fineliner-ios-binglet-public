// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct WaitingBingletContainerView: View {

    let viewData: WaitingBingletContainerViewData
    let index: Int

    var body: some View {
        let strokeOpacity: Double = switch index {
        case 0: 1
        case 1: 0.6
        case 2: 0.4
        default: 0.25
        }
        let strokeLineWidth: CGFloat = switch index {
        case 0: 2.5
        case 1: 3.2
        case 2: 4
        default: 5
        }
        RoundedRectangle(
            cornerSize: CGSize(
                width: Constant.waitingBingletNodeCircleLinearSize / 2
                + Constant.waitingBingletContainerPadding,
                height: Constant.waitingBingletNodeCircleLinearSize / 2
                + Constant.waitingBingletContainerPadding
            )
        )
        .stroke(
            Constant.waitingBingletContainerStrokeColor.opacity(strokeOpacity),
            style: StrokeStyle(lineWidth: strokeLineWidth)
        )
        .frame(
            width: CGFloat(Constant.bingletContainerHorizontalNodeCount) * Constant.waitingBingletContainerUnitAreaLinearSize
            + Constant.waitingBingletContainerPadding * 2,
            height: CGFloat(Constant.bingletContainerHorizontalNodeCount) * Constant.waitingBingletContainerUnitAreaLinearSize
            + Constant.waitingBingletContainerPadding * 2
        )
        .overlay {
            ZStack {
                waitingBingletContainerHorizontalLinkLayerView
                waitingBingletContainerVerticalLinkLayerView
                waitingBingletContainerDiagonalLinkLayerView
                waitingBingletContainerNodeLayerView
            }
        }
    }

    private var waitingBingletContainerHorizontalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.horizontalLinkMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.horizontalLinkMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let simpleLinkPlaceState = row[horizontalIndex]
                        WaitingBingletContainerHorizontalLinkView(
                            simpleLinkPlaceState: simpleLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var waitingBingletContainerVerticalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.verticalLinkMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.verticalLinkMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let simpleLinkPlaceState = row[horizontalIndex]
                        WaitingBingletContainerVerticalLinkView(
                            simpleLinkPlaceState: simpleLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var waitingBingletContainerDiagonalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.diagonalLinkMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.diagonalLinkMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let diagonalLinkPlaceState = row[horizontalIndex]
                        WaitingBingletContainerDiagonalLinkView(
                            diagonalLinkPlaceState: diagonalLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var waitingBingletContainerNodeLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.nodeMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.nodeMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let nodePlaceState = row[horizontalIndex]
                        WaitingBingletContainerNodeView(
                            nodeColor: viewData.nodeColor, nodePlaceState: nodePlaceState
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    WaitingBingletContainerView(
        viewData: .init(
            nodeColor: Binglet.crab.nodeColor,
            nodeMatrix: Binglet.crab.nodeMatrix,
            horizontalLinkMatrix: Binglet.crab.horizontalLinkMatrix,
            verticalLinkMatrix: Binglet.crab.verticalLinkMatrix,
            diagonalLinkMatrix: Binglet.crab.diagonalLinkMatrix
        ),
        index: 0
    )
}
