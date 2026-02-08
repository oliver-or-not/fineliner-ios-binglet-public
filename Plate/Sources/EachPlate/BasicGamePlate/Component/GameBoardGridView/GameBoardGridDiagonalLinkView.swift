// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardGridDiagonalLinkView: View {
    
    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                Capsule()
                    .foregroundStyle(Constant.gameBoardGridLinkColor)
                    .frame(
                        width: Constant.gameBoardGridDiagonalLinkLength,
                        height: Constant.gameBoardGridLinkWidth
                    )
                    .rotationEffect(.radians(-(.pi / 4)))
                Capsule()
                    .foregroundStyle(Constant.gameBoardGridLinkColor)
                    .frame(
                        width: Constant.gameBoardGridDiagonalLinkLength,
                        height: Constant.gameBoardGridLinkWidth
                    )
                    .rotationEffect(.radians(.pi / 4))
            }
    }
}
