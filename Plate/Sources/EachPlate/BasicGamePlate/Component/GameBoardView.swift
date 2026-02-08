// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardView: View {

    let viewData: GameBoardViewData

    var body: some View {
        ZStack {
            gameBoardHorizontalLinkLayerView
            gameBoardVerticalLinkLayerView
            gameBoardDiagonalLinkLayerView
            gameBoardNodeLayerView
        }
    }

    private var gameBoardHorizontalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.horizontalLinkMatrix.indices, id: \.self) { verticalIindex in
                let row = viewData.horizontalLinkMatrix[verticalIindex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let simpleLinkPlaceState = row[horizontalIndex]
                        GameBoardHorizontalLinkView(
                            simpleLinkPlaceState: simpleLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var gameBoardVerticalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.verticalLinkMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.verticalLinkMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let simpleLinkPlaceState = row[horizontalIndex]
                        GameBoardVerticalLinkView(
                            simpleLinkPlaceState: simpleLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var gameBoardDiagonalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.diagonalLinkMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.diagonalLinkMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let diagonalLinkPlaceState = row[horizontalIndex]
                        GameBoardDiagonalLinkView(
                            diagonalLinkPlaceState: diagonalLinkPlaceState
                        )
                    }
                }
            }
        }
    }

    private var gameBoardNodeLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.nodePlaceViewDataMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.nodePlaceViewDataMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let nodePlaceViewData = row[horizontalIndex]
                        GameBoardNodeView(
                            nodePlaceViewData: nodePlaceViewData
                        )
                    }
                }
            }
        }
    }

}
