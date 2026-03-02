// MARK: - Module Dependency

import SwiftUI
import Universe
import Spectrum

// MARK: - Body

struct GuideBingletContainerViewData: Hashable, Sendable {

    var nodeColor: Color
    var nodeMatrix: Matrix<NodePlaceState>
    var horizontalLinkMatrix: Matrix<SimpleLinkPlaceState>
    var verticalLinkMatrix: Matrix<SimpleLinkPlaceState>
    var diagonalLinkMatrix: Matrix<DiagonalLinkPlaceState>
    var accumulatedPlacingChoice: ActiveBingletProcessData.AccumulatedPlacingChoice
    var residualTranslation: CGSize
}
