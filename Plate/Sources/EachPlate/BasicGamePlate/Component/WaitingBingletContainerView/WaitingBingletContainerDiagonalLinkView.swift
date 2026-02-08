// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct WaitingBingletContainerDiagonalLinkView: View {

    let diagonalLinkPlaceState: DiagonalLinkPlaceState

    var body: some View {
        Spacer()
            .frame(
                width: Constant.waitingBingletContainerUnitAreaLinearSize,
                height: Constant.waitingBingletContainerUnitAreaLinearSize
            )
            .overlay {
                switch diagonalLinkPlaceState {
                case .empty:
                    EmptyView()
                case .slash:
                    Rectangle()
                        .foregroundStyle(Constant.linkColor)
                        .frame(
                            width: Constant.waitingBingletDiagonalLinkLength,
                            height: Constant.waitingBingletLinkWidth
                        )
                        .rotationEffect(.radians(-(.pi / 4)))
                case .backslash:
                    Rectangle()
                        .foregroundStyle(Constant.linkColor)
                        .frame(
                            width: Constant.waitingBingletDiagonalLinkLength,
                            height: Constant.waitingBingletLinkWidth
                        )
                        .rotationEffect(.radians(.pi / 4))
                case .cross:
                    Rectangle()
                        .foregroundStyle(Constant.linkColor)
                        .frame(
                            width: Constant.waitingBingletDiagonalLinkLength,
                            height: Constant.waitingBingletLinkWidth
                        )
                        .rotationEffect(.radians(-(.pi / 4)))
                    Rectangle()
                        .foregroundStyle(Constant.linkColor)
                        .frame(
                            width: Constant.waitingBingletDiagonalLinkLength,
                            height: Constant.waitingBingletLinkWidth
                        )
                        .rotationEffect(.radians(.pi / 4))
                }
            }
            .clipped()
    }
}
