// MARK: - Module Dependency

import SwiftUI
import Spectrum
import Director
import Agent
import PlateBase

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent
fileprivate typealias Constant = SettingsPlateConstant

// MARK: - Body

public struct SettingsPlateView: View {

    // MARK: - Reference

    @Bindable private var viewModel: SettingsPlateViewModel

    // MARK: - Constant

    // MARK: - State

    // MARK: - Lifecycle

    public init() {
        self.viewModel = .shared
    }

    init(viewModel: SettingsPlateViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            DS.SemanticColor.generalBackground
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 0) {
                Spacer().frame(height: 80)
                titleSection
                    .padding([.horizontal, .bottom])
                Spacer().frame(height: 20)
                hapticFeedbackSection
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.horizontal])
                Spacer().frame(height: 20)
                appearanceSection
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.horizontal])
                Spacer()
            }
            VStack(spacing: 0) {
                topAppBar
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
        }
    }

    private var topAppBar: some View {
        ZStack {
            HStack(spacing: 0) {
                Spacer().frame(minWidth: 26)
                Button {
                    Task {
                        await primeEventDirector.receive(.settingsPlateCloseButtonTapped)
                    }
                } label: {
                    DS.SymbolImage.xmark
                        .font(.system(size: 20))
                        .frame(width: 48, height: 48)
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .background(Circle().fill(DS.SemanticColor.interactable))
                }
                Spacer().frame(width: 16)
            }
        }
    }

    private var titleSection: some View {
        HStack(spacing: 0) {
            Text(String(lKey: .settingsPlateTitle))
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundStyle(DS.SemanticColor.generalText)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            Spacer()
        }
    }

    private var hapticFeedbackSection: some View {
        ZStack {
            Spacer().frame(idealWidth: .infinity)
            VStack(alignment: .center, spacing: 0) {
                Toggle(isOn: Binding(
                    get: { viewModel.hapticFeedbackToggleValue },
                    set: { _, _ in
                        Task {
                            await primeEventDirector.receive(.settingsPlateHapticFeedbackToggleTapped)
                        }
                    }
                ), label: {
                    Text(String(lKey: .settingsPlateHapticFeedbackSectionTitle))
                        .font(.system(size: 22))
                        .foregroundStyle(DS.SemanticColor.generalText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                })
                .tint(DS.SemanticColor.sectionInteractable)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(DS.SemanticColor.sectionBackground)
        }
    }

    private var appearanceSection: some View {
        ZStack {
            Spacer().frame(idealWidth: .infinity)
            VStack(alignment: .center, spacing: 12) {

                HStack {
                    Text(String(lKey: .settingsPlateAppearanceSectionTitle))
                        .font(.system(size: 22))
                        .foregroundStyle(DS.SemanticColor.generalText)
                    Spacer()
                }

                Picker(
                    "",
                    selection: Binding(
                        get: { viewModel.colorScheme },
                        set: { newValue in
                            Task {
                                await primeEventDirector.receive(
                                    .settingsPlateAppearancePickerPicked(value: newValue)
                                )
                            }
                        }
                    )
                ) {
                    Text(String(lKey: .settingsPlateAppearanceSectionSystemItemTitle)).tag(AppColorScheme.unspecified)
                    Text(String(lKey: .settingsPlateAppearanceSectionLightItemTitle)).tag(AppColorScheme.light)
                    Text(String(lKey: .settingsPlateAppearanceSectionDarkItemTitle)).tag(AppColorScheme.dark)
                }
                .pickerStyle(.segmented)
                .tint(DS.SemanticColor.sectionInteractable)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(DS.SemanticColor.sectionBackground)
        }
    }
}

#Preview {
    SettingsPlateView(viewModel: SettingsPlateViewModel(
        isHapticFeedbackOn: false,
        colorScheme: .unspecified
    ))
}
