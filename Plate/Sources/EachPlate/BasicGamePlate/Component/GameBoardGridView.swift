// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardGridView: View {

    let viewData: GameBoardGridViewData

    var body: some View {
        ZStack {
            gameBoardGridHorizontalLinkLayerView
            gameBoardGridVerticalLinkLayerView
            gameBoardGridDiagonalLinkLayerView
            gameBoardGridNodeLayerView
        }
        .clipShape(RoundedRectangle(cornerRadius: Constant.gameBoardGridCornerRadius))
    }

    private var gameBoardGridHorizontalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(0..<Constant.gameBoardVerticalNodeCount, id: \.self) { _ in
                HStack(spacing: 0) {
                    ForEach(0..<Constant.gameBoardHorizontalNodeCount - 1, id: \.self) { _ in
                        GameBoardGridHorizontalLinkView()
                    }
                }
            }
        }
    }

    private var gameBoardGridVerticalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(0..<Constant.gameBoardVerticalNodeCount - 1, id: \.self) { _ in
                HStack(spacing: 0) {
                    ForEach(0..<Constant.gameBoardHorizontalNodeCount, id: \.self) { _ in
                        GameBoardGridVeticalLinkView()
                    }
                }
            }
        }
    }

    private var gameBoardGridDiagonalLinkLayerView: some View {
        VStack(spacing: 0) {
            ForEach(0..<Constant.gameBoardVerticalNodeCount - 1, id: \.self) { _ in
                HStack(spacing: 0) {
                    ForEach(0..<Constant.gameBoardHorizontalNodeCount - 1, id: \.self) { _ in
                        GameBoardGridDiagonalLinkView()
                    }
                }
            }
        }
    }

    private var gameBoardGridNodeLayerView: some View {
        VStack(spacing: 0) {
            ForEach(0..<Constant.gameBoardVerticalNodeCount, id: \.self) { y in
                HStack(spacing: 0) {
                    ForEach(0..<Constant.gameBoardHorizontalNodeCount, id: \.self) { x in
                        switch viewData.nodePlaceViewStateMatrix[y][x] {
                        case .notBlocked:
                            GameBoardGridNodeView()
                        case .willBeBlocked(let blockCount):
                            GameBoardGridWillBeBlockedNodeView(blockCount: Int(blockCount))
                        case .blocked:
                            GameBoardGridBlockedNodeView()
                        }
                    }
                }
            }
        }
    }

}
