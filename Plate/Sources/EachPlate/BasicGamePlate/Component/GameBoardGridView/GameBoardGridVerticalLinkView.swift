// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardGridVeticalLinkView: View {
    
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
                        width: Constant.gameBoardGridLinkWidth,
                        height: Constant.gameBoardGridSimpleLinkLength
                    )
            }
    }
}
