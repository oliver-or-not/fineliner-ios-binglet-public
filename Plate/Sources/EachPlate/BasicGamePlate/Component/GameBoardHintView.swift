// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardHintView: View {

    let viewData: GameBoardHintViewData

    var body: some View {
        ZStack {
            gameBoardHintHorizontalLinkLayerView
            gameBoardHintVerticalLinkLayerView
            gameBoardHintDiagonalLinkLayerView
            gameBoardHintNodeLayerView
        }
        .compositingGroup()
        .opacity(0.75)
    }

    private var gameBoardHintHorizontalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.horizontalLinkPlaceViewDataMatrix.indices, id: \.self) { verticalIindex in
                let row = viewData.horizontalLinkPlaceViewDataMatrix[verticalIindex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let simpleLinkPlaceViewData = row[horizontalIndex]
                        GameBoardHintHorizontalLinkView(
                            simpleLinkPlaceViewData: simpleLinkPlaceViewData
                        )
                    }
                }
            }
        }
    }

    private var gameBoardHintVerticalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.verticalLinkPlaceViewDataMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.verticalLinkPlaceViewDataMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let simpleLinkPlaceViewData = row[horizontalIndex]
                        GameBoardHintVerticalLinkView(
                            simpleLinkPlaceViewData: simpleLinkPlaceViewData
                        )
                    }
                }
            }
        }
    }

    private var gameBoardHintDiagonalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.diagonalLinkPlaceViewDataMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.diagonalLinkPlaceViewDataMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let diagonalLinkPlaceState = row[horizontalIndex]
                        GameBoardHintDiagonalLinkView(
                            diagonalLinkPlaceState: diagonalLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var gameBoardHintNodeLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.nodePlaceViewDataMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.nodePlaceViewDataMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let nodePlaceViewData = row[horizontalIndex]
                        GameBoardHintNodeView(
                            nodePlaceViewData: nodePlaceViewData
                        )
                    }
                }
            }
        }
    }

}
