// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardBingleEffectNodeView: View {

    let viewData: GameBoardBingleEffectViewData.NodePlaceViewData

    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                switch viewData {
                case .empty:
                    EmptyView()
                case .bingled:
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Constant.gameBoardBingleEffectNodeCenterColor,
                                    Constant.gameBoardBingleEffectNodeBoundaryColor,
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 20
                            )
                        )
                        .frame(
                            width: Constant.gameBoardBingleEffectNodeCircleLinearSize,
                            height: Constant.gameBoardBingleEffectNodeCircleLinearSize
                        )
                        .blur(radius: 2)
                }
            }
    }
}
