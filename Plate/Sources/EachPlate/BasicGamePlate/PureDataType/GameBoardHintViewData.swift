// MARK: - Module Dependency

import SwiftUI
import Universe

// MARK: - Body

struct GameBoardHintViewData: Hashable, Sendable {

    var nodePlaceViewDataMatrix: Matrix<NodePlaceViewData>
    var horizontalLinkPlaceViewDataMatrix: Matrix<SimpleLinkPlaceViewData>
    var verticalLinkPlaceViewDataMatrix: Matrix<SimpleLinkPlaceViewData>
    var diagonalLinkPlaceViewDataMatrix: Matrix<DiagonalLinkPlaceViewData>

    enum NodePlaceViewData: Hashable, Sendable {

        case empty
        case illegal
        case expectedToFormBingle(multiplicationValue: Int?, hasLeadingComboCount: Bool)
    }

    enum SimpleLinkPlaceViewData: Hashable, Sendable {

        case empty
        case expectedToFormBingle
    }

    enum DiagonalLinkPlaceViewData: Hashable, Sendable {

        case empty
        case expectedToFormBingleWithSlash
        case expectedToFormBingleWithBackslash
        case expectedToFormBingleWithCross
    }
}
