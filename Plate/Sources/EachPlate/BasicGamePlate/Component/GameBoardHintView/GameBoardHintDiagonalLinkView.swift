// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardHintDiagonalLinkView: View {
    
    let diagonalLinkPlaceState: GameBoardHintViewData.DiagonalLinkPlaceViewData
    
    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                switch diagonalLinkPlaceState {
                case .empty:
                    EmptyView()
                case .expectedToFormBingleWithSlash:
                    Rectangle()
                        .foregroundStyle(Constant.gameBoardHintLinkColor)
                        .frame(
                            width: Constant.gameBoardHintDiagonalLinkLength,
                            height: Constant.gameBoardHintLinkWidth
                        )
                        .rotationEffect(.radians(-(.pi / 4)))
                case .expectedToFormBingleWithBackslash:
                    Rectangle()
                        .foregroundStyle(Constant.gameBoardHintLinkColor)
                        .frame(
                            width: Constant.gameBoardHintDiagonalLinkLength,
                            height: Constant.gameBoardHintLinkWidth
                        )
                        .rotationEffect(.radians(.pi / 4))
                case .expectedToFormBingleWithCross:
                    Rectangle()
                        .foregroundStyle(Constant.gameBoardHintLinkColor)
                        .frame(
                            width: Constant.gameBoardHintDiagonalLinkLength,
                            height: Constant.gameBoardHintLinkWidth
                        )
                        .rotationEffect(.radians(-(.pi / 4)))
                    Rectangle()
                        .foregroundStyle(Constant.gameBoardHintLinkColor)
                        .frame(
                            width: Constant.gameBoardHintDiagonalLinkLength,
                            height: Constant.gameBoardHintLinkWidth
                        )
                        .rotationEffect(.radians(.pi / 4))
                }
            }
            .clipped()
    }
}
