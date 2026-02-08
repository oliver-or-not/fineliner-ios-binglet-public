// MARK: - Module Dependency

import SwiftUI
import Universe

// MARK: - Body

public struct DuplicatableGameBoardData: Codable, Hashable, Sendable {

    public var nodePlaceDataMatrix: Matrix<NodePlaceState>
    public var horizontalLinkMatrix: Matrix<SimpleLinkPlaceState>
    public var verticalLinkMatrix: Matrix<SimpleLinkPlaceState>
    public var diagonalLinkMatrix: Matrix<DiagonalLinkPlaceState>

    public init(
        nodePlaceDataMatrix: Matrix<NodePlaceState>,
        horizontalLinkMatrix: Matrix<SimpleLinkPlaceState>,
        verticalLinkMatrix: Matrix<SimpleLinkPlaceState>,
        diagonalLinkMatrix: Matrix<DiagonalLinkPlaceState>
    ) {
        self.nodePlaceDataMatrix = nodePlaceDataMatrix
        self.horizontalLinkMatrix = horizontalLinkMatrix
        self.verticalLinkMatrix = verticalLinkMatrix
        self.diagonalLinkMatrix = diagonalLinkMatrix
    }

    public enum NodePlaceState: Codable, Hashable, Sendable {

        case empty
        case singleOccupied(NodeData)
        case duplicated
    }
}
