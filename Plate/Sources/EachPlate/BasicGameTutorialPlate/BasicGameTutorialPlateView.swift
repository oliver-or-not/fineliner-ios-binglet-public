// MARK: - Module Dependency

import SwiftUI
import UIKit
import Combine
import Spectrum
import Director
import Agent

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent
fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

public struct BasicGameTutorialPlateView: View {

    // MARK: - Reference

    @Environment(\.colorScheme) var colorScheme
    @Bindable private var viewModel: BasicGameTutorialPlateViewModel

    // MARK: - Constant

    private let tutorialHighlightColor: Color = DS.PaletteColor.yellow

    // MARK: - State

    @State var isScoreBouncing: Bool = false
    @State var waitingBingletArrayPullTrigger: Bool = false
    @State var activeBingletPullTrigger: Bool = false

    @State var tutorialGameBoardHighlightBlinkTrigger: Bool = false
    @State var tutorialPlaceButtonHighlightBlinkTrigger: Bool = false

    // MARK: - Lifecycle

    public init() {
        self.viewModel = .shared
    }

    init(viewModel: BasicGameTutorialPlateViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View

    public var body: some View {
        GeometryReader { geo in
            let idealSafeAreaWidth = Constant.idealHorizontalPadding
            + 15
            + Constant.gameBoardUnitAreaLinearSize * CGFloat(Constant.gameBoardHorizontalNodeCount)
            + 15
            + Constant.idealHorizontalPadding
            let idealSafeAreaHeight = Constant.idealVerticalPadding
            + 10 + 30 + 10
            + 30
            + 15
            + Constant.gameBoardUnitAreaLinearSize * CGFloat(Constant.gameBoardVerticalNodeCount)
            + 15
            + 69.3
            + 15
            + 60
            + Constant.idealVerticalPadding
            let horizontalScaleMax = geo.size.width / idealSafeAreaWidth
            let verticalScaleMax = geo.size.height / idealSafeAreaHeight
            let scaleMax = min(horizontalScaleMax, verticalScaleMax)
            let horizontalScaleGoal = (idealSafeAreaWidth + geo.size.width) / (2 * idealSafeAreaWidth)
            let scale = max(0.0001, min(scaleMax, horizontalScaleGoal))
            ZStack {
                DS.SemanticColor.generalBackground
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Text("No Score")
                        .font(.system(size: 30))
                        .fontWeight(.black)
                        .fontDesign(.rounded)
                        .foregroundStyle(.clear)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                        .padding()
                    Spacer().frame(height: 30)
                    ZStack {
                        if viewModel.tutorialHighlightState == .gameBoard {
                            GameBoardBackgroundView()
                                .background {
                                    RoundedRectangle(
                                        cornerRadius:
                                            CGFloat(Constant.gameBoardUnitAreaLinearSize) / 2 * CGFloat(sqrt(2)) + 10
                                    )
                                    .fill(tutorialHighlightColor)
                                    .blur(radius: 10)
                                    .opacity(tutorialGameBoardHighlightBlinkTrigger ? 0 : 1)
                                    .allowsHitTesting(false)
                                }
                                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: tutorialGameBoardHighlightBlinkTrigger)
                                .onAppear {
                                    if !tutorialGameBoardHighlightBlinkTrigger {
                                        tutorialGameBoardHighlightBlinkTrigger = true
                                    }
                                }
                        } else {
                            GameBoardBackgroundView()
                                .onAppear {
                                    if tutorialGameBoardHighlightBlinkTrigger {
                                        tutorialGameBoardHighlightBlinkTrigger = false
                                    }
                                }
                        }
                        GameBoardGridView(viewData: viewModel.gameBoardGridViewData)
                        GameBoardView(viewData: viewModel.gameBoardViewData)
                        if let gameBoardBingleEffectViewData = viewModel.gameBoardBingleEffectViewData {
                            GameBoardBingleEffectView(viewData: gameBoardBingleEffectViewData)
                        }
                        if let guideBingletContainerViewData = viewModel.guideBingletContainerViewData {
                            ActiveBingletContainerView(viewData: guideBingletContainerViewData)
                                .compositingGroup()
                                .opacity(colorScheme == .dark ? 0.6 : 0.4)
                                .allowsHitTesting(false)
                        }
                        if let activeBingletContainerViewData = viewModel.activeBingletContainerViewData {
                            ActiveBingletContainerView(viewData: activeBingletContainerViewData)
                                .scaleEffect(
                                    activeBingletPullTrigger
                                    ? Constant.waitingBingletContainerScale
                                    : 1
                                )
                                .offset(
                                    x: activeBingletPullTrigger
                                    ? -(CGFloat(Constant.bingletContainerHorizontalNodeCount) * Constant.waitingBingletContainerUnitAreaLinearSize
                                        + Constant.waitingBingletContainerPadding * 2) * 1.5
                                    - Constant.waitingBingletArraySpacing * 1.5
                                    : 0,
                                    y: activeBingletPullTrigger
                                    ? (CGFloat(Constant.gameBoardVerticalNodeCount) * Constant.gameBoardUnitAreaLinearSize) * 0.5
                                    + 15
                                    + (CGFloat(Constant.bingletContainerVerticalNodeCount) * Constant.waitingBingletContainerUnitAreaLinearSize
                                       + Constant.waitingBingletContainerPadding * 2) * 0.5
                                    : 0
                                )
                        }
                        if let gameBoardHintViewData = viewModel.gameBoardHintViewData {
                            GameBoardHintView(viewData: gameBoardHintViewData)
                        }
                    }
                    .onTapGesture {
                        Task { @MainActor in
                            await primeEventDirector.receive(.basicGameTutorialPlateGameBoardTapped)
                        }
                    }
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 4)
                            .onChanged { value in
                                Task { @MainActor in
                                    await primeEventDirector.receive(
                                        .basicGameTutorialPlateGameBoardDragged(
                                            translation: CGSize(
                                                width: value.translation.width / scale,
                                                height: value.translation.height / scale
                                            ),
                                            unitDistance: Constant.gameBoardUnitAreaLinearSize
                                        )
                                    )
                                }
                            }
                            .onEnded { value in
                                Task { @MainActor in
                                    await primeEventDirector.receive(
                                        .basicGameTutorialPlateGameBoardDragEnded
                                    )
                                }
                            }
                    )
                    Spacer().frame(height: 15)
                    HStack(spacing: Constant.waitingBingletArraySpacing) {
                        ForEach(viewModel.waitingBingletContainerViewDataArray.indices, id: \.self) { index in
                            WaitingBingletContainerView(
                                viewData: viewModel.waitingBingletContainerViewDataArray[index],
                                index: index
                            )
                        }
                    }
                    .offset(
                        x: waitingBingletArrayPullTrigger
                        ? Constant.waitingBingletContainerUnitAreaLinearSize
                        * CGFloat(Constant.bingletContainerHorizontalNodeCount)
                        + Constant.waitingBingletContainerPadding * 2
                        + Constant.waitingBingletArraySpacing
                        : 0
                    )
                    .onChange(of: viewModel.bingletActivationViewCount) {
                        activeBingletPullTrigger = true
                        waitingBingletArrayPullTrigger = true

                        withAnimation(.spring(duration: Constant.animationDurationOfWaitingBingletArrayPulling, bounce: 0.2, blendDuration: 0.05), {
                            activeBingletPullTrigger = false
                        })
                        withAnimation(.spring(duration: Constant.animationDurationOfWaitingBingletArrayPulling, bounce: 0.5, blendDuration: 0.05), {
                            waitingBingletArrayPullTrigger = false
                        })
                    }
                    Spacer().frame(height: 15)
                    if viewModel.tutorialHighlightState == .placeButton {
                        TutorialPlaceButtonSectionView(viewData: viewModel.placeButtonViewData, highlightState: viewModel.tutorialHighlightState)
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                .fill(tutorialHighlightColor)
                                .blur(radius: 10)
                                .opacity(tutorialPlaceButtonHighlightBlinkTrigger ? 0 : 1)
                                .allowsHitTesting(false)
                            }
                            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true), value: tutorialPlaceButtonHighlightBlinkTrigger)
                            .onAppear {
                                if !tutorialPlaceButtonHighlightBlinkTrigger {
                                    tutorialPlaceButtonHighlightBlinkTrigger = true
                                }
                            }
                    } else {
                        TutorialPlaceButtonSectionView(viewData: viewModel.placeButtonViewData, highlightState: viewModel.tutorialHighlightState)
                            .onAppear {
                                if tutorialPlaceButtonHighlightBlinkTrigger {
                                    tutorialPlaceButtonHighlightBlinkTrigger = false
                                }
                            }
                    }
                }
                .scaleEffect(scale)
                VStack(spacing: 0) {
                    topAppBar
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer().frame(height: 10)
                    tutorialCheckArrayView
                    Spacer().frame(height: 10)
                    tutorialGuideDialogSectionView
                    Spacer()
                }
            }
        }
    }

    private var topAppBar: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer().frame(minWidth: 26)
                Button {
                    Task {
                        await primeEventDirector.receive(.basicGameTutorialPlateCloseButtonTapped)
                    }
                } label: {
                    DS.SymbolImage.xmark
                        .font(.system(size: 25))
                        .frame(width: 48, height: 48)
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .background(Circle().fill(DS.SemanticColor.interactable))
                }
                Spacer().frame(width: 16)
            }
        }
    }

    private var tutorialCheckArrayView: some View {
        let maxCount = 3
        return HStack(spacing: 0) {
            ForEach(0..<viewModel.tutorialCheckArrayCount, id: \.self) { index in
                DS.SymbolImage.checkmarkCircleFill
                    .font(.system(size: 20))
                    .foregroundStyle(Color(hex: "9ACEE9"))
            }
            ForEach(viewModel.tutorialCheckArrayCount..<maxCount, id: \.self) { index in
                DS.SymbolImage.circleFill
                    .font(.system(size: 20))
                    .foregroundStyle(DS.SemanticColor.disabledText)
            }
        }
    }

    private var tutorialGuideDialogSectionView: some View {
        let isShown = viewModel.tutorialGuideDialogViewData != nil
        return ZStack {
            HStack(spacing: 0) {
                Spacer().frame(minWidth: 15)
                    .layoutPriority(-100)
                Text(viewModel.tutorialGuideDialogViewData?.text ?? "")
                    .font(.system(size: 17))
                    .foregroundStyle(DS.SemanticColor.generalText)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .padding()
                    .id(viewModel.tutorialGuideDialogViewData?.text)
                Spacer().frame(minWidth: 15)
                    .layoutPriority(-100)
                if let buttonVariety = viewModel.tutorialGuideDialogViewData?.buttonVariety {
                    Button {
                        Task {
                            await primeEventDirector.receive(
                                .basicGameTutorialPlateTutorialGuideDialogButtonTapped
                            )
                        }
                    } label: {
                        Text(buttonVariety.text)
                            .font(.system(size: 17))
                            .foregroundStyle(DS.SemanticColor.generalText)
                            .lineLimit(1)
                    }
                    .buttonBorderShape(.capsule)
                    .tint(DS.SemanticColor.dialogButtonBackground)
                    .buttonStyle(.borderedProminent)
                    .fixedSize()
                    Spacer().frame(width: 15)
                }
            }
        }
        .frame(width: 320)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .fill(DS.SemanticColor.dialogBackground)
            )
            .scaleEffect(isShown ? 1 : 0.9)
        .opacity(isShown ? 1 : 0)
        .allowsHitTesting(isShown)
        .animation(.smooth(duration: .init(seconds: 0.5)), value: isShown)
        .transition(.opacity.combined(with: .scale))
        .animation(.smooth(duration: .init(seconds: 0.5)),
                   value: viewModel.tutorialGuideDialogViewData?.text)
    }
}
