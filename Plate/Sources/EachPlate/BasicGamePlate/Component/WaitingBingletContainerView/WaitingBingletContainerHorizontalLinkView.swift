// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct WaitingBingletContainerHorizontalLinkView: View {
    
    let simpleLinkPlaceState: SimpleLinkPlaceState
    
    var body: some View {
        Spacer()
            .frame(
                width: Constant.waitingBingletContainerUnitAreaLinearSize,
                height: Constant.waitingBingletContainerUnitAreaLinearSize
            )
            .overlay {
                switch simpleLinkPlaceState {
                case .empty:
                    EmptyView()
                case .occupied:
                    Rectangle()
                        .foregroundStyle(Constant.linkColor)
                        .clipShape(RoundedRectangle(
                            cornerRadius: Constant.waitingBingletLinkWidth / 2
                        ))
                        .frame(
                            width: Constant.waitingBingletContainerUnitAreaLinearSize,
                            height: Constant.waitingBingletLinkWidth
                        )
                }
            }
    }
}
