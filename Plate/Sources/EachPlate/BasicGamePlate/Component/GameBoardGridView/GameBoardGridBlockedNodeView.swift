// MARK: - Module Dependency

import SwiftUI
import Spectrum

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
                        DS.SymbolImage.nosign
                            .font(.system(size: 30, weight: .black))
                            .foregroundStyle(Constant.gameBoardBackgroundColor)
                    }
                }
            }
    }
}
