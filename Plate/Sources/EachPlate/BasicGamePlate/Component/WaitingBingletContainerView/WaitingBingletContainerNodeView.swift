// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct WaitingBingletContainerNodeView: View {
    
    let nodeColor: Color
    let nodePlaceState: NodePlaceState
    
    var body: some View {
        Spacer()
            .frame(
                width: Constant.waitingBingletContainerUnitAreaLinearSize,
                height: Constant.waitingBingletContainerUnitAreaLinearSize
            )
            .overlay {
                switch nodePlaceState {
                case .empty:
                    EmptyView()
                case .occupied:
                    Circle()
                        .foregroundStyle(nodeColor)
                        .frame(
                            width: Constant.waitingBingletNodeCircleLinearSize,
                            height: Constant.waitingBingletNodeCircleLinearSize
                        )
                }
            }
    }
}
