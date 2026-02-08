// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardGridBlockedNodeView: View {

    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                ZStack {
                    Rectangle()
                        .foregroundStyle(Constant.gameBoardGridBlockedNodeColor)
                        .frame(
                            width: Constant.gameBoardGridBlockedNodeLinearSize,
                            height: Constant.gameBoardGridBlockedNodeLinearSize
                        )
                    ZStack {
                        Capsule()
                            .foregroundStyle(Constant.gameBoardBackgroundColor)
                            .frame(
                                width: Constant.gameBoardGridBlockedNodeCrossMarkLineLength,
                                height: Constant.gameBoardGridBlockedNodeCrossMarkLineWidth
                            )
                            .rotationEffect(.radians(-(.pi / 4)))
                        Capsule()
                            .foregroundStyle(Constant.gameBoardBackgroundColor)
                            .frame(
                                width: Constant.gameBoardGridBlockedNodeCrossMarkLineLength,
                                height: Constant.gameBoardGridBlockedNodeCrossMarkLineWidth
                            )
                            .rotationEffect(.radians(.pi / 4))
                    }
                }
            }
    }
}
