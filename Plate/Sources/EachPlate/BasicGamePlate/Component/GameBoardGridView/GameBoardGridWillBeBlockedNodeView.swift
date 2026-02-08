// MARK: - Module Dependency

import SwiftUI

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardGridWillBeBlockedNodeView: View {

    // MARK: - Reference

    // MARK: - Constant

    let blockCount: Int

    // MARK: - State

    @State var blinkTrigger = false

    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                ZStack {
                    Text("\(blockCount)")
                        .font(.system(size: 20))
                        .fontWeight(.black)
                        .fontDesign(.rounded)
                        .foregroundStyle(Constant.gameBoardGridBlockedNodeColor)
                        .lineLimit(1)
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
                    .compositingGroup()
                    .opacity(blinkTrigger ? 0.7 : 0)
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: blinkTrigger)
                    .onAppear {
                        if !blinkTrigger {
                            blinkTrigger = true
                        }
                    }
                }
            }
    }
}
