// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Body

@MainActor @Observable public final class AppAppearanceStateModel {

    public static let shared = AppAppearanceStateModel(
        colorScheme: .unspecified
    )

    public var colorScheme: AppColorScheme

    private init(
        colorScheme: AppColorScheme
    ) {
        self.colorScheme = colorScheme
    }
}
