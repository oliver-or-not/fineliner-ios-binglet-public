// MARK: - Module Dependency

import SwiftUI
import Spectrum
import Agent

// MARK: - Body

@MainActor @Observable public final class SettingsPlateViewModel {

    public static let shared = SettingsPlateViewModel(
        isHapticFeedbackOn: false,
        colorScheme: .unspecified
    )

    public internal(set) var hapticFeedbackToggleValue: Bool
    public internal(set) var colorScheme: AppColorScheme

    init(
        isHapticFeedbackOn: Bool,
        colorScheme: AppColorScheme
    ) {
        self.hapticFeedbackToggleValue = isHapticFeedbackOn
        self.colorScheme = colorScheme
    }
}
