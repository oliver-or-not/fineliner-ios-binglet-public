// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardBackgroundView: View {

    var body: some View {
        Spacer()
            .frame(
                width: CGFloat(Constant.gameBoardHorizontalNodeCount) * CGFloat(Constant.gameBoardUnitAreaLinearSize),
                height: CGFloat(Constant.gameBoardVerticalNodeCount) * CGFloat(Constant.gameBoardUnitAreaLinearSize)
            )
            .padding(
                CGFloat(Constant.gameBoardUnitAreaLinearSize) / 2 * CGFloat(sqrt(2) - 1)
            )
            .background(
                RoundedRectangle(cornerRadius: CGFloat(Constant.gameBoardUnitAreaLinearSize) / 2 * CGFloat(sqrt(2))
                )
                .fill(Constant.gameBoardBackgroundColor)
            )
    }
}
