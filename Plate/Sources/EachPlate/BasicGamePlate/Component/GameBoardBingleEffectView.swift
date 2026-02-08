// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct GameBoardBingleEffectView: View {

    // MARK: - Reference

    // MARK: - Constant

    let viewData: GameBoardBingleEffectViewData

    // MARK: - State

    @State var isMultiplicationValueVisible = false

    // MARK: - Lifecycle

    var body: some View {
        ZStack {
            gameBoardBingleEffectNodeLayerView
            gameBoardBingleEffectMultiplicationValueLayerView
        }
    }

    private var gameBoardBingleEffectNodeLayerView: some View {
        VStack(spacing: 0) {
            ForEach(viewData.nodePlaceViewDataMatrix.indices, id: \.self) { verticalIndex in
                let row = viewData.nodePlaceViewDataMatrix[verticalIndex]
                HStack(spacing: 0) {
                    ForEach(row.indices, id: \.self) { horizontalIndex in
                        let nodePlaceViewData = row[horizontalIndex]
                        GameBoardBingleEffectNodeView(
                            viewData: nodePlaceViewData
                        )
                        .offset(y: viewData.areNodesGathered ? -100 : 0)
                        .opacity(viewData.areNodesGathered ? 0 : 1)
                        .animation(
                            .easeInOut(duration: Constant.animationDurationOfBingledNodeGathering),
                            value: viewData.areNodesGathered
                        )
                    }
                }
            }
        }
    }

    private var gameBoardBingleEffectMultiplicationValueLayerView: some View {
        Group {
            if let multiplicationValue = viewData.multiplicationValue {
                Text("x \(multiplicationValue)")
                    .font(.system(size: 100))
                    .fontWeight(.black)
                    .fontDesign(.rounded)
                    .foregroundStyle(Constant.gameBoardBingleEffectMultiplicationValueTextColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
                    .opacity(isMultiplicationValueVisible ? 1 : 0)
                    .animation(.easeInOut(duration: Constant.animationDurationOfGameBoardBingleEffectMultiplicationValueAppearing), value: isMultiplicationValueVisible)
                    .onAppear {
                        if !isMultiplicationValueVisible {
                            isMultiplicationValueVisible = true
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + (
                                    Constant.animationDurationOfBingledNodeGathering
                                    - 2 * Constant.animationDurationOfGameBoardBingleEffectMultiplicationValueAppearing
                                )
                            ) {
                                isMultiplicationValueVisible = false
                            }
                        }
                    }
            } else {
                EmptyView()
            }
        }
    }
}
