// MARK: - Module Dependency

import SwiftUI
import Universe

// MARK: - Body

public struct GameBoardData: Codable, Hashable, Sendable {

    public var nodePlaceDataMatrix: Matrix<NodePlaceData>
    public var horizontalLinkMatrix: Matrix<SimpleLinkPlaceState>
    public var verticalLinkMatrix: Matrix<SimpleLinkPlaceState>
    public var diagonalLinkMatrix: Matrix<DiagonalLinkPlaceState>

    public init(
        nodePlaceDataMatrix: Matrix<NodePlaceData>,
        horizontalLinkMatrix: Matrix<SimpleLinkPlaceState>,
        verticalLinkMatrix: Matrix<SimpleLinkPlaceState>,
        diagonalLinkMatrix: Matrix<DiagonalLinkPlaceState>
    ) {
        self.nodePlaceDataMatrix = nodePlaceDataMatrix
        self.horizontalLinkMatrix = horizontalLinkMatrix
        self.verticalLinkMatrix = verticalLinkMatrix
        self.diagonalLinkMatrix = diagonalLinkMatrix
    }

    public struct NodePlaceData: Codable, Hashable, Sendable {

        public var blockState: BlockState
        public var occupiedNodeData: NodeData?

        public init(
            blockState: BlockState,
            occupiedNodeData: NodeData?
        ) {
            self.blockState = blockState
            self.occupiedNodeData = occupiedNodeData
        }

        public enum BlockState: Codable, Hashable, Sendable {

            case notBlocked
            case willBeBlocked(bingletPlacingCountToBeBlocked: UInt)
            case blocked
        }
    }
}
