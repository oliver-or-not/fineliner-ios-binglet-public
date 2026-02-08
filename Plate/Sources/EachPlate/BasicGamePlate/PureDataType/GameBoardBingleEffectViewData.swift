// MARK: - Module Dependency

import SwiftUI
import Universe

// MARK: - Body

struct GameBoardBingleEffectViewData: Hashable, Sendable {

    var nodePlaceViewDataMatrix: Matrix<NodePlaceViewData>
    var multiplicationValue: Int?
    var areNodesGathered: Bool

    enum NodePlaceViewData: Hashable, Sendable {

        case empty
        case bingled
    }
}
