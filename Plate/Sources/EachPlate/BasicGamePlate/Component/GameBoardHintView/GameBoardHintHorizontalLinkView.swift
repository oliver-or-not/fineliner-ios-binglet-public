// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardHintHorizontalLinkView: View {
    
    let simpleLinkPlaceViewData: GameBoardHintViewData.SimpleLinkPlaceViewData
    
    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                switch simpleLinkPlaceViewData {
                case .empty:
                    EmptyView()
                case .expectedToFormBingle:
                    Rectangle()
                        .foregroundStyle(Constant.gameBoardHintLinkColor)
                        .frame(
                            width: Constant.gameBoardUnitAreaLinearSize,
                            height: Constant.gameBoardHintLinkWidth
                        )
                }
            }
    }
}
