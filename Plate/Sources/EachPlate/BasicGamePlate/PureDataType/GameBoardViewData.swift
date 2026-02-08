// MARK: - Module Dependency

import SwiftUI
import Universe
import Spectrum

// MARK: - Body

struct GameBoardViewData: Hashable, Sendable {

    var nodePlaceViewDataMatrix: Matrix<NodePlaceViewData>
    var horizontalLinkMatrix: Matrix<SimpleLinkPlaceState>
    var verticalLinkMatrix: Matrix<SimpleLinkPlaceState>
    var diagonalLinkMatrix: Matrix<DiagonalLinkPlaceState>

    struct NodePlaceViewData: Hashable, Sendable {

        var occupiedNodeViewData: OccupiedNodeViewData?

        struct OccupiedNodeViewData: Hashable, Sendable {

            var color: Color
            var effectViewData: EffectViewData?

            struct EffectViewData: Hashable, Sendable {

                var mainColor: Color
                var multiplicationValue: Int
                var isHighlighted: Bool
            }
        }
    }
}
