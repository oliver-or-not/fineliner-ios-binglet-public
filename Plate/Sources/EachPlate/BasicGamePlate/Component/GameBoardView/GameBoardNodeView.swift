// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardNodeView: View {

    // MARK: - Reference

    @Environment(\.colorScheme) var colorScheme
    let nodePlaceViewData: GameBoardViewData.NodePlaceViewData

    // MARK: - Constant

    // MARK: - State

    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                if let occupiedNodeViewData = nodePlaceViewData.occupiedNodeViewData {
                    if let effectViewData = occupiedNodeViewData.effectViewData {
                        ZStack {
                            PolarWaveView(color: effectViewData.mainColor, phaseAngle: 0)
                                .opacity(colorScheme == .dark ? 0.35 : 0.12)
                            PolarWaveView(color: effectViewData.mainColor, phaseAngle: .pi)
                                .opacity(colorScheme == .dark ? 0.5 : 0.18)
                        }
                    } else {
                        EmptyView()
                    }
                    ZStack {
                        Circle()
                            .foregroundStyle(occupiedNodeViewData.color)
                            .frame(
                                width: Constant.gameBoardNodeCircleLinearSize,
                                height: Constant.gameBoardNodeCircleLinearSize
                            )
                        DS.GraphicImage.gameBoardNodeShade
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: Constant.gameBoardNodeCircleLinearSize,
                                height: Constant.gameBoardNodeCircleLinearSize
                            )
                    }
                    if let effectViewData = occupiedNodeViewData.effectViewData {
                        Text("x\(effectViewData.multiplicationValue)")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .fontDesign(.rounded)
                            .foregroundStyle(Constant.gameBoardNodeMultiplicationValueTextColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .frame(
                                maxWidth: Constant.gameBoardNodeCircleLinearSize,
                                maxHeight: Constant.gameBoardNodeCircleLinearSize
                            )
                    } else {
                        EmptyView()
                    }
                } else {
                    EmptyView()
                }
            }
    }
}

fileprivate struct PolarWaveView: View {

    let color: Color
    let phaseAngle: CGFloat

    @State var waveTrigger = false

    var body: some View {
        PolarWaveShape(
            c: CGFloat(Constant.gameBoardNodeCircleLinearSize) / 2 + 5,
            amplitude: 3,
            n: 5,
            phaseAngle: phaseAngle,
            resolution: 200
        )
        .foregroundStyle(color)
        .frame(
            width: Constant.gameBoardUnitAreaLinearSize,
            height: Constant.gameBoardUnitAreaLinearSize
        )
        .rotationEffect(.degrees(waveTrigger ? 360 : 0))
        .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false), value: waveTrigger)
        .onAppear {
            if !waveTrigger {
                waveTrigger = true
            }
        }
    }
}
