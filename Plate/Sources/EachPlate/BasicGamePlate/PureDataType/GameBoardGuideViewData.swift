// MARK: - Module Dependency

import SwiftUI
import Universe

// MARK: - Body

struct GameBoardGridViewData: Hashable, Sendable {

    var nodePlaceViewStateMatrix: Matrix<NodePlaceViewState>

    enum NodePlaceViewState: Hashable, Sendable {

        case notBlocked
        case willBeBlocked(blockCount: UInt)
        case blocked
    }
}
