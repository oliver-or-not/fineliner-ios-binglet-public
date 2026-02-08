// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct ActiveBingletContainerDiagonalLinkView: View {

    let diagonalLinkPlaceState: DiagonalLinkPlaceState

    var body: some View {
        Spacer()
            .frame(
                width: Constant.gameBoardUnitAreaLinearSize,
                height: Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                switch diagonalLinkPlaceState {
                case .empty:
                    EmptyView()
                case .slash:
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
                            width: Constant.gameBoardDiagonalLinkLength,
                            height: Constant.gameBoardLinkWidth
                        )
                        .rotationEffect(.radians(-(.pi / 4)))
                case .backslash:
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
                            width: Constant.gameBoardDiagonalLinkLength,
                            height: Constant.gameBoardLinkWidth
                        )
                        .rotationEffect(.radians(.pi / 4))
                case .cross:
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
                            width: Constant.gameBoardDiagonalLinkLength,
                            height: Constant.gameBoardLinkWidth
                        )
                        .rotationEffect(.radians(-(.pi / 4)))
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
                            width: Constant.gameBoardDiagonalLinkLength,
                            height: Constant.gameBoardLinkWidth
                        )
                        .rotationEffect(.radians(.pi / 4))
                }
            }
            .clipped()
    }
}
