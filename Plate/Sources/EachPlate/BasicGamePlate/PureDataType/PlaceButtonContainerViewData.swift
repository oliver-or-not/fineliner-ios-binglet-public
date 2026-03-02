// MARK: - Module Dependency

import SwiftUI
import Universe
import Spectrum

// MARK: - Body

struct PlaceButtonContainerViewData: Hashable, Sendable {

    var accumulatedPlacingChoice: ActiveBingletProcessData.AccumulatedPlacingChoice
    var residualTranslation: CGSize
    var isPlaceButtonVivid: Bool
    var isPlaceable: Bool
}
