// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct ActiveBingletContainerNodeView: View {
    
    let nodeColor: Color
    let nodePlaceState: NodePlaceState
    
    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                switch nodePlaceState {
                case .empty:
                    EmptyView()
                case .occupied:
                    ZStack {
                        Circle()
                            .foregroundStyle(nodeColor)
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
                }
            }
    }
}
