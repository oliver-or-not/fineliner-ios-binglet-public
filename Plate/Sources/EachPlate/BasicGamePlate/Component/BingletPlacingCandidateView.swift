// MARK: - Module Dependency

import SwiftUI
import Universe
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct BingletPlacingCandidateView: View {

    // MARK: - Reference

    @Environment(\.colorScheme) var colorScheme
    let viewData: BingletPlacingCandidateViewData

    // MARK: - Constant

    // MARK: - State

    @State var blinkTrigger = false

    // MARK: - Lifecycle

    // MARK: - View

    var body: some View {
        Spacer()
            .frame(
                width: CGFloat(Constant.gameBoardHorizontalNodeCount) * Constant.gameBoardUnitAreaLinearSize,
                height: CGFloat(Constant.gameBoardVerticalNodeCount) * Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                let rotationAngle: Double
                = Double(viewData.placingChoice.rotation.rawValue) * (-(.pi / 2))
                RoundedRectangle(
                    cornerRadius: Constant.gameBoardNodeCircleLinearSize / 2 + Constant.activeBingletContainerPadding
                )
                .fill(.clear)
                .stroke(
                    Constant.activeBingletContainerStrokeColor,
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        lineJoin: .miter,
                        miterLimit: 0,
                        dash: [10, 10.85],
                        dashPhase: 0
                    )
                )
                .frame(
                    width: CGFloat(Constant.bingletContainerHorizontalNodeCount) * Constant.gameBoardUnitAreaLinearSize
                    + Constant.activeBingletContainerPadding * 2,
                    height: CGFloat(Constant.bingletContainerVerticalNodeCount) * Constant.gameBoardUnitAreaLinearSize
                    + Constant.activeBingletContainerPadding * 2
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: Constant.gameBoardUnitAreaLinearSize / 2
                    )
                    .fill(viewData.nodeColor)
                    .blur(radius: 5)
                    .frame(
                        width: (CGFloat(Constant.bingletContainerHorizontalNodeCount) * Constant.gameBoardUnitAreaLinearSize) / 2,
                        height: (CGFloat(Constant.bingletContainerVerticalNodeCount) * Constant.gameBoardUnitAreaLinearSize) / 2

                    )
                }
                .rotationEffect(.radians(rotationAngle))
                .offset(
                    CGSize(
                        width: CGFloat(viewData.placingChoice.gridOffset.x) * Constant.gameBoardUnitAreaLinearSize,
                        height: CGFloat(viewData.placingChoice.gridOffset.y) * Constant.gameBoardUnitAreaLinearSize
                    )
                )
            }
            .compositingGroup()
            .opacity(blinkTrigger ? 0.35 : 0.07)
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: blinkTrigger)
            .onAppear {
                if !blinkTrigger {
                    blinkTrigger = true
                }
            }
    }
}

#Preview {
    BingletPlacingCandidateView(
        viewData: BingletPlacingCandidateViewData(
            nodeColor: Binglet.crab.nodeColor,
            nodeMatrix: Binglet.crab.nodeMatrix,
            horizontalLinkMatrix: Binglet.crab.horizontalLinkMatrix,
            verticalLinkMatrix: Binglet.crab.verticalLinkMatrix,
            diagonalLinkMatrix: Binglet.crab.diagonalLinkMatrix,
            placingChoice: ActiveBingletProcessData.PlacingChoice(rotation: .identity, gridOffset: GridVector(x: 0, y: 0))
        )
    )
}
