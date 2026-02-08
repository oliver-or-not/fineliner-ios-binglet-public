// MARK: - Module Dependency

import Spectrum
import Agent
import PlateBase

// MARK: - Context

@MainActor fileprivate let viewModel = SettingsPlateViewModel.shared

// MARK: - Body

extension GlobalEntity.Plate {

    public static let settingsPlate: SettingsPlateInterface = SettingsPlate(
        isHapticFeedbackOn: false,
        colorScheme: .unspecified
    )
}

public protocol SettingsPlateInterface: GlobalEntity.Plate.Interface, Sendable {

    func getIsHapticFeedbackOn() async -> Bool
    func setIsHapticFeedbackOn(_ value: Bool) async

    func getColorScheme() async -> AppColorScheme
    func setColorScheme(_ value: AppColorScheme) async

    func reset() async
}

fileprivate final actor SettingsPlate: SettingsPlateInterface {

    // MARK: - Reference

    // MARK: - Constant

    nonisolated let designation: PlateDesignation = .settings

    // MARK: - State

    private var isHapticFeedbackOn: Bool
    private var colorScheme: AppColorScheme

    // MARK: - Lifecycle

    init(
        isHapticFeedbackOn: Bool,
        colorScheme: AppColorScheme
    ) {
        self.isHapticFeedbackOn = isHapticFeedbackOn
        self.colorScheme = colorScheme
    }

    // MARK: - SettingsPlateInterface

    func getIsHapticFeedbackOn() async -> Bool {
        isHapticFeedbackOn
    }

    func setIsHapticFeedbackOn(_ value: Bool) async {
        isHapticFeedbackOn = value
        await updateViewModel()
    }

    func getColorScheme() async -> AppColorScheme {
        colorScheme
    }

    func setColorScheme(_ value: AppColorScheme) async {
        colorScheme = value
        await updateViewModel()
    }

    func reset() async {
        isHapticFeedbackOn = false
        colorScheme = .unspecified
        await updateViewModel()
    }

    private func updateViewModel() async {
        let capturedIsHapticFeedbackOn = isHapticFeedbackOn
        let capturedColorScheme = colorScheme
        await MainActor.run {
            viewModel.hapticFeedbackToggleValue = capturedIsHapticFeedbackOn
            viewModel.colorScheme = capturedColorScheme
        }
    }
}
