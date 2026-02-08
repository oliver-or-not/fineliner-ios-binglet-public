// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct ActiveBingletContainerHorizontalLinkView: View {
    
    let simpleLinkPlaceState: SimpleLinkPlaceState
    
    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                switch simpleLinkPlaceState {
                case .empty:
                    EmptyView()
                case .occupied:
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Constant.linkShadeColor,
                                    Constant.linkColor,
                                    Constant.linkColor,
                                    Constant.linkColor,
                                    Constant.linkShadeColor,
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(
                            width: Constant.gameBoardUnitAreaLinearSize,
                            height: Constant.gameBoardLinkWidth
                        )
                }
            }
    }
}
