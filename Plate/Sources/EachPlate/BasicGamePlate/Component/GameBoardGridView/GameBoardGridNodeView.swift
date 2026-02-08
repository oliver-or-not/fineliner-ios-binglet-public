// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardGridNodeView: View {
    
    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                Circle()
                    .foregroundStyle(Constant.gameBoardGridNodeColor)
                    .frame(
                        width: Constant.gameBoardGridNodeCircleLinearSize,
                        height: Constant.gameBoardGridNodeCircleLinearSize
                    )
            }
    }
}
