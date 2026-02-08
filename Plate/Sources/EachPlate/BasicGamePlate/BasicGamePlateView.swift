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

public struct BasicGamePlateView: View {

    // MARK: - Reference

    @Bindable private var viewModel: BasicGamePlateViewModel

    // MARK: - Constant

    // MARK: - State

    @State var isScoreBouncing: Bool = false
    @State var waitingBingletArrayPullTrigger: Bool = false
    @State var activeBingletPullTrigger: Bool = false

    // MARK: - Lifecycle

    public init() {
        self.viewModel = .shared
    }

    init(viewModel: BasicGamePlateViewModel) {
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
                    if let gameScoreAboveGameBoard = viewModel.gameScoreAboveGameBoard {
                        Text("\(gameScoreAboveGameBoard)")
                            .font(.system(size: 30))
                            .fontWeight(.black)
                            .fontDesign(.rounded)
                            .foregroundStyle(DS.SemanticColor.generalText)
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                            .padding()
                            .scaleEffect(isScoreBouncing ? 1.18 : 1.0)
                            .animation(.spring(response: 0.25, dampingFraction: 0.35), value: isScoreBouncing)
                            .onChange(of: viewModel.gameScoreAboveGameBoard) {
                                isScoreBouncing = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                                    isScoreBouncing = false
                                }
                            }
                    } else {
                        Text("No Score")
                            .font(.system(size: 30))
                            .fontWeight(.black)
                            .fontDesign(.rounded)
                            .foregroundStyle(.clear)
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                            .padding()
                    }
                    Spacer().frame(height: 30)
                    ZStack {
                        GameBoardBackgroundView()
                        GameBoardGridView(viewData: viewModel.gameBoardGridViewData)
                        GameBoardView(viewData: viewModel.gameBoardViewData)
                        if let gameBoardBingleEffectViewData = viewModel.gameBoardBingleEffectViewData {
                            GameBoardBingleEffectView(viewData: gameBoardBingleEffectViewData)
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
                            await primeEventDirector.receive(.basicGamePlateGameBoardTapped)
                        }
                    }
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 4)
                            .onChanged { value in
                                Task { @MainActor in
                                    await primeEventDirector.receive(
                                        .basicGamePlateGameBoardDragged(
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
                                        .basicGamePlateGameBoardDragEnded
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
                    PlaceButtonSectionView(viewData: viewModel.placeButtonViewData)
                }
                .scaleEffect(scale)
                VStack(spacing: 0) {
                    topAppBar
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                if viewModel.isBannerAdShown,
                   let bannerAdUnitId = viewModel.bannerAdUnitId {
                    VStack(spacing: 0) {
                        Spacer()
                        BasicGamePlateBannerAdView(unitId: bannerAdUnitId)
                    }
                } else {
                    EmptyView()
                }
                beforeResetDialog
                resultDialog
            }
        }
    }

    private var topAppBar: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer().frame(width: 16)
                Button {
                    Task {
                        await primeEventDirector.receive(.basicGamePlateBackButtonTapped)
                    }
                } label: {
                    DS.SymbolImage.chevronBackward
                        .font(.system(size: 20))
                        .frame(width: 48, height: 48)
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .background(Circle().fill(DS.SemanticColor.interactable))
                }
                Spacer()
                Button {
                    Task {
                        await primeEventDirector.receive(.basicGamePlateHowToPlayButtonTapped)
                    }
                } label: {
                    DS.SymbolImage.questionmark
                        .font(.system(size: 20))
                        .frame(width: 48, height: 48)
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .background(Circle().fill(DS.SemanticColor.interactable))
                }
                Spacer().frame(width: 10)
                Button {
                    Task {
                        await primeEventDirector.receive(.basicGamePlateResetButtonTapped)
                    }
                } label: {
                    DS.SymbolImage.arrowCounterclockwiseCircle
                        .font(.system(size: 25))
                        .frame(width: 48, height: 48)
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .background(Circle().fill(DS.SemanticColor.interactable))
                }
                Spacer().frame(width: 16)
            }
        }
    }

    private var beforeResetDialog: some View {
        let isShown = viewModel.isBeforeRestartDialogShown
        return ZStack {
            DS.SemanticColor.dim
                .ignoresSafeArea()
            ZStack {
                VStack(spacing: 0) {
                    Spacer().frame(height: 40)
                    Text(String(lKey: .basicGamePlateBeforeResetDialogContent))
                        .font(.system(size: 17))
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer().frame(height: 40)
                    HStack(spacing: 0) {
                        Button {
                            Task {
                                await primeEventDirector.receive(
                                    .basicGamePlateBeforeResetDialogCancelButtonTapped
                                )
                            }
                        } label: {
                            Text(String(lKey: .basicGamePlateBeforeResetDialogCancelButtonTitle))
                                .font(.system(size: 17))
                                .foregroundStyle(DS.SemanticColor.generalText)
                                .frame(width: 80)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                        }
                        .buttonBorderShape(.capsule)
                        .tint(DS.SemanticColor.dialogButtonBackground)
                        .buttonStyle(.borderedProminent)
                        Spacer()
                            .frame(width: 15)
                        Button {
                            Task {
                                await primeEventDirector.receive(
                                    .basicGamePlateBeforeResetDialogResetButtonTapped
                                )
                            }
                        } label: {
                            Text(String(lKey: .basicGamePlateBeforeResetDialogResetButtonTitle))
                                .font(.system(size: 17))
                                .foregroundStyle(DS.SemanticColor.generalText)
                                .frame(width: 80)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                        }
                        .buttonBorderShape(.capsule)
                        .tint(DS.SemanticColor.dialogButtonBackground)
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                        .frame(height: 30)
                }
            }
            .frame(width: 280)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .fill(DS.SemanticColor.dialogBackground)
            )
            .scaleEffect(isShown ? 1 : 0.9)
        }
        .opacity(isShown ? 1 : 0)
        .allowsHitTesting(isShown)
        .animation(.smooth(duration: .init(seconds: 0.5)), value: isShown)
    }

    private var resultDialog: some View {
        let isShown = viewModel.resultDialogViewData != nil
        return ZStack {
            DS.SemanticColor.dim
                .ignoresSafeArea()
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 40)
                    Text(String(lKey: .basicGamePlateResultDialogTitle))
                        .font(.system(size: 22))
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.2)
                    Spacer()
                }
                VStack(spacing: 0) {
                    Spacer()
                    Text((viewModel.resultDialogViewData?.finalGameScore).flatMap { "\($0)" } ?? "")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                        .padding()
                    Spacer()
                }
                VStack(spacing: 0) {
                    Spacer()
                    HStack(spacing: 0) {
                        Button {
                            Task {
                                await primeEventDirector.receive(
                                    .basicGamePlateResultDialogBackButtonTapped
                                )
                            }
                        } label: {
                            Text(String(lKey: .basicGamePlateResultDialogBackButtonTitle))
                                .font(.system(size: 17))
                                .foregroundStyle(DS.SemanticColor.generalText)
                                .frame(width: 80)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                        }
                        .buttonBorderShape(.capsule)
                        .tint(DS.SemanticColor.dialogButtonBackground)
                        .buttonStyle(.borderedProminent)
                        Spacer()
                            .frame(width: 15)
                        Button {
                            Task {
                                await primeEventDirector.receive(
                                    .basicGamePlateResultDialogRestartButtonTapped
                                )
                            }
                        } label: {
                            Text(String(lKey: .basicGamePlateResultDialogRestartButtonTitle))
                                .font(.system(size: 17))
                                .foregroundStyle(DS.SemanticColor.generalText)
                                .frame(width: 80)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                        }
                        .buttonBorderShape(.capsule)
                        .tint(DS.SemanticColor.dialogButtonBackground)
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                        .frame(height: 30)
                }
            }
            .frame(width: 280, height: 230)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .fill(DS.SemanticColor.dialogBackground)
            )
            .scaleEffect(isShown ? 1 : 0.9)
        }
        .opacity(isShown ? 1 : 0)
        .allowsHitTesting(isShown)
        .animation(.smooth(duration: .init(seconds: 0.5)), value: isShown)
    }
}
