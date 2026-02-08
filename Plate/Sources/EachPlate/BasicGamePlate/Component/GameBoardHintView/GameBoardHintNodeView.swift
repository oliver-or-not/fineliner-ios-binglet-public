// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardHintNodeView: View {

    let nodePlaceViewData: GameBoardHintViewData.NodePlaceViewData

    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                switch nodePlaceViewData {
                case .empty:
                    EmptyView()
                case .illegal:
                    ZStack {
                        Capsule()
                            .foregroundStyle(Constant.gameBoardHintIllegalCrossMarkColor)
                            .frame(
                                width: Constant.gameBoardHintIllegalCrossMarkLineLength,
                                height: Constant.gameBoardHintIllegalCrossMarkLineWidth
                            )
                            .rotationEffect(.radians(-(.pi / 4)))
                        Capsule()
                            .foregroundStyle(Constant.gameBoardHintIllegalCrossMarkColor)
                            .frame(
                                width: Constant.gameBoardHintIllegalCrossMarkLineLength,
                                height: Constant.gameBoardHintIllegalCrossMarkLineWidth
                            )
                            .rotationEffect(.radians(.pi / 4))
                    }
                case .expectedToFormBingle(let multiplicationValue, let hasLeadingComboCount):
                    Circle()
                        .foregroundStyle(Constant.gameBoardHintNodeColor)
                        .frame(
                            width: Constant.gameBoardHintNodeCircleLinearSize,
                            height: Constant.gameBoardHintNodeCircleLinearSize
                        )
                    if let multiplicationValue, hasLeadingComboCount {
                        Text("x\(multiplicationValue)")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .foregroundStyle(Constant.gameBoardHintNodeMultiplicationValueTextColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .frame(
                                maxWidth: Constant.gameBoardNodeCircleLinearSize,
                                maxHeight: Constant.gameBoardNodeCircleLinearSize
                            )
                    }
                }
            }
    }
}
