// MARK: - Module Dependency

import SwiftUI
import GoogleMobileAds
import Spectrum
import Director
import Agent
import PlateBase

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent

// MARK: - Body

public struct MainPlateView: View {

    // MARK: - Reference

    @Bindable private var viewModel: MainPlateViewModel

    // MARK: - Constant

    // MARK: - State

    @State private var titleScaleEffectTrigger: Bool = false

    // MARK: - Lifecycle

    public init() {
        self.viewModel = .shared
    }

    init(viewModel: MainPlateViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            DS.SemanticColor.generalBackground
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer().frame(height: 40)
                titleSection
                Spacer().frame(height: 120)
                marathonButton
                    .padding()
                rankingsButton
                    .padding()
                settingsButton
                    .padding()
            }
            VStack(spacing: 0) {
                topAppBar
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
        }
        .onAppear {
            if !titleScaleEffectTrigger {
                titleScaleEffectTrigger = true
            }
        }
    }

    private var topAppBar: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer().frame(minWidth: 26)
                Button {
                    Task {
                        await primeEventDirector.receive(.mainPlateShareButtonTapped)
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(DS.SemanticColor.interactable)
                            .frame(width: 48, height: 48)
                        DS.SymbolImage.share
                            .font(.system(size: 20))
                            .foregroundStyle(DS.SemanticColor.generalText)
                            .offset(y: -2)
                    }
                }
                Spacer().frame(width: 16)
            }
        }
    }

    private var titleSection: some View {
        DS.GraphicImage.mainTitle
    }

    private var marathonButton: some View {
        Button {
            Task {
                await primeEventDirector.receive(.mainPlateMarathonButtonTapped)
            }
        } label: {
            Text(String(lKey: .mainPlateMarathonButtonTitle))
                .font(.system(size: 22))
                .foregroundStyle(DS.SemanticColor.generalText)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            .padding()
            .frame(width: 200)
            .background {
                Capsule().fill(DS.SemanticColor.interactable)
            }
        }
    }

    private var rankingsButton: some View {
        Button {
            Task {
                await primeEventDirector.receive(.mainPlateRankingsButtonTapped)
            }
        } label: {
            Text(String(lKey: .mainPlateRankingsButtonTitle))
                .font(.system(size: 22))
                .foregroundStyle(DS.SemanticColor.generalText)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            .padding()
            .frame(width: 200)
            .background {
                Capsule().fill(DS.SemanticColor.interactable)
            }
        }
    }

    private var settingsButton: some View {
        Button {
            Task {
                await primeEventDirector.receive(.mainPlateSettingsButtonTapped)
            }
        } label: {
            Text(String(lKey: .mainPlateSettingsButtonTitle))
                .font(.system(size: 22))
                .foregroundStyle(DS.SemanticColor.generalText)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            .padding()
            .frame(width: 200)
            .background {
                Capsule().fill(DS.SemanticColor.interactable)
            }
        }
    }
}

#Preview {
    MainPlateView(viewModel: MainPlateViewModel())
}

