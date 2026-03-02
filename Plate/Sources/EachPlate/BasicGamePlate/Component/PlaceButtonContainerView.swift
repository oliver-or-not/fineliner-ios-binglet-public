// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

struct PlaceButtonContainerView: View {

    // MARK: - Reference

    @Environment(\.colorScheme) var colorScheme
    let viewData: PlaceButtonContainerViewData
    let tutorialHighlightState: TutorialHighlightState?
    let placeButtonAction: @MainActor () -> Void

    // MARK: - Constant

    // MARK: - State

    @State var placeButtonHighlightBlinkTrigger: Bool = false

    // MARK: - Lifecycle

    init(
        viewData: PlaceButtonContainerViewData,
        tutorialHighlightState: TutorialHighlightState?,
        placeButtonAction: @escaping @MainActor () -> Void
    ) {
        self.viewData = viewData
        self.tutorialHighlightState = tutorialHighlightState
        self.placeButtonAction = placeButtonAction
    }

    // MARK: - View

    var body: some View {
        Spacer()
            .frame(
                width: CGFloat(Constant.gameBoardHorizontalNodeCount) * Constant.gameBoardUnitAreaLinearSize,
                height: CGFloat(Constant.gameBoardVerticalNodeCount) * Constant.gameBoardUnitAreaLinearSize
            )
            .overlay {
                let rotationAngle: Double
                = Double(viewData.accumulatedPlacingChoice.rotationCount) * (-(.pi / 2))
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 11 + Constant.activeBingletContainerButtonLinearSize)
                    RoundedRectangle(
                        cornerRadius: Constant.gameBoardNodeCircleLinearSize / 2 + Constant.activeBingletContainerPadding
                    )
                    .fill(.clear)
                    .frame(
                        width: CGFloat(Constant.bingletContainerHorizontalNodeCount) * Constant.gameBoardUnitAreaLinearSize
                        + Constant.activeBingletContainerPadding * 2,
                        height: CGFloat(Constant.bingletContainerVerticalNodeCount) * Constant.gameBoardUnitAreaLinearSize
                        + Constant.activeBingletContainerPadding * 2,
                    )
                    Spacer()
                        .frame(height: 11)
                    if tutorialHighlightState == .placeButton {
                        placeButton
                            .background {
                                RoundedRectangle(cornerRadius: Constant.activeBingletContainerButtonLinearSize / 2)
                                    .fill(Constant.activeBingletContainerPlaceButtonHighlightColor)
                                .blur(radius: 10)
                                .opacity(placeButtonHighlightBlinkTrigger ? 0 : 1)
                                .allowsHitTesting(false)
                            }
                            .opacity(viewData.isPlaceButtonVivid ? 0.9 : 0.15)
                            .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: true), value: placeButtonHighlightBlinkTrigger)
                            .onAppear {
                                if !placeButtonHighlightBlinkTrigger {
                                    placeButtonHighlightBlinkTrigger = true
                                }
                            }
                    } else {
                        placeButton
                            .opacity(viewData.isPlaceButtonVivid ? 0.9 : 0.15)
                            .onAppear {
                                if placeButtonHighlightBlinkTrigger {
                                    placeButtonHighlightBlinkTrigger = false
                                }
                            }
                    }
                }
                .offset(
                    CGSize(
                        width: CGFloat(viewData.accumulatedPlacingChoice.gridOffset.x) * Constant.gameBoardUnitAreaLinearSize,
                        height: CGFloat(viewData.accumulatedPlacingChoice.gridOffset.y) * Constant.gameBoardUnitAreaLinearSize
                    )
                )
                .offset(
                    CGSize(
                        width: min(
                            max(
                                -Constant.gameBoardUnitAreaLinearSize * Constant.gridOffsetPreservingRatio,
                                 viewData.residualTranslation.width
                                 * abs(viewData.residualTranslation.width)
                                 / Constant.gameBoardUnitAreaLinearSize * 0.4
                            ),
                            Constant.gameBoardUnitAreaLinearSize * Constant.gridOffsetPreservingRatio
                        ),
                        height: min(
                            max(
                                -Constant.gameBoardUnitAreaLinearSize * Constant.gridOffsetPreservingRatio,
                                 viewData.residualTranslation.height
                                 * abs(viewData.residualTranslation.height)
                                 / Constant.gameBoardUnitAreaLinearSize * 0.4
                            ),
                            Constant.gameBoardUnitAreaLinearSize * Constant.gridOffsetPreservingRatio
                        )
                    )
                )
            }
    }

    private var placeButton: some View {
        Button(action: {
            placeButtonAction()
        }, label: {
            DS.SymbolImage.checkmark
                .font(.system(size: 20))
                .foregroundStyle(
                    viewData.isPlaceable
                    ? (colorScheme == .dark ? DS.PaletteColor.white : DS.PaletteColor.black)
                    : DS.SemanticColor.disabledText
                )
                .frame(
                    width: Constant.activeBingletContainerButtonLinearSize,
                    height: Constant.activeBingletContainerButtonLinearSize
                )
                .background(
                    Circle()
                        .fill(
                            viewData.isPlaceable
                            ? Constant.activeBingletContainerButtonColor
                            : DS.SemanticColor.disabledInteractable
                        )
                        .stroke(
                            viewData.isPlaceable
                            ? Constant.activeBingletContainerButtonStrokeColor
                            : DS.SemanticColor.disabledInteractable,
                            style: StrokeStyle(lineWidth: 2)
                        )
                )
        })
        .allowsHitTesting(viewData.isPlaceable && viewData.isPlaceButtonVivid)
    }
}

#Preview {
    PlaceButtonContainerView(
        viewData: PlaceButtonContainerViewData(
            accumulatedPlacingChoice: .init(rotationCount: 0, gridOffset: .zero),
            residualTranslation: .zero,
            isPlaceButtonVivid: true,
            isPlaceable: true
        ),
        tutorialHighlightState: nil,
        placeButtonAction: {}
    )
}
