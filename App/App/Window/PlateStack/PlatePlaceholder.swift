// MARK: - Module Dependency

import SwiftUI
import Spectrum
import Plate

// MARK: - Body

struct PlatePlaceholder: View {

    var designation: PlateDesignation?

    var body: some View {
        Group {
            switch designation {
            case .restoration:
                RestorationPlateView()
            case .main:
                MainPlateView()
            case .basicGame:
                BasicGamePlateView()
            case .basicGameTutorial:
                BasicGameTutorialPlateView()
            case .settings:
                SettingsPlateView()
            case .none:
                EmptyView()
            }
        }
    }
}
