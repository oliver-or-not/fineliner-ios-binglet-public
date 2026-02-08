// MARK: - Module Dependency

import Spectrum

// MARK: - Body

public extension PlateDesignation {

    var interface: GlobalEntity.Plate.Interface {
        switch self {
        case .restoration:
            GlobalEntity.Plate.restorationPlate
        case .main:
            GlobalEntity.Plate.mainPlate
        case .basicGame:
            GlobalEntity.Plate.basicGamePlate
        case .basicGameTutorial:
            GlobalEntity.Plate.basicGameTutorialPlate
        case .settings:
            GlobalEntity.Plate.settingsPlate
        }
    }
}
