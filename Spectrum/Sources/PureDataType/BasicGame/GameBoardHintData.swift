// MARK: - Module Dependency

import SwiftUI
import Universe

// MARK: - Body

public enum GameBoardHintData: Codable, Hashable, Sendable {

    case placeable(PlaceableData)
    case notPlaceable(NotPlaceableData)

    public struct PlaceableData: Codable, Hashable, Sendable {

        public var nodePlaceDataMatrix: Matrix<NodePlaceData>
        public var horizontalLinkPlaceDataMatrix: Matrix<SimpleLinkPlaceData>
        public var verticalLinkPlaceDataMatrix: Matrix<SimpleLinkPlaceData>
        public var diagonalLinkPlaceDataMatrix: Matrix<DiagonalLinkPlaceData>

        public init(
            nodePlaceDataMatrix: Matrix<NodePlaceData>,
            horizontalLinkPlaceDataMatrix: Matrix<SimpleLinkPlaceData>,
            verticalLinkPlaceDataMatrix: Matrix<SimpleLinkPlaceData>,
            diagonalLinkPlaceDataMatrix: Matrix<DiagonalLinkPlaceData>
        ) {
            self.nodePlaceDataMatrix = nodePlaceDataMatrix
            self.horizontalLinkPlaceDataMatrix = horizontalLinkPlaceDataMatrix
            self.verticalLinkPlaceDataMatrix = verticalLinkPlaceDataMatrix
            self.diagonalLinkPlaceDataMatrix = diagonalLinkPlaceDataMatrix
        }

        public enum NodePlaceData: Codable, Hashable, Sendable {

            case empty
            case insideBingleRegion
            case expectedToFormBingle(comboCount: UInt, hasLeadingComboCount: Bool)
        }

        public enum SimpleLinkPlaceData: Codable, Hashable, Sendable {

            case empty
            case expectedToFormBingle
        }

        public enum DiagonalLinkPlaceData: Codable, Hashable, Sendable {

            case empty
            case expectedToFormBingleWithSlash
            case expectedToFormBingleWithBackslash
            case expectedToFormBingleWithCross

            public func plus(_ state: DiagonalLinkPlaceData) -> DiagonalLinkPlaceData {
                switch (self, state) {
                case (.empty, .empty):
                        .empty
                case (.empty, .expectedToFormBingleWithSlash):
                        .expectedToFormBingleWithSlash
                case (.empty, .expectedToFormBingleWithBackslash):
                        .expectedToFormBingleWithBackslash
                case (.empty, .expectedToFormBingleWithCross):
                        .expectedToFormBingleWithCross
                case (.expectedToFormBingleWithSlash, .empty):
                        .expectedToFormBingleWithSlash
                case (.expectedToFormBingleWithSlash, .expectedToFormBingleWithSlash):
                        .expectedToFormBingleWithSlash
                case (.expectedToFormBingleWithSlash, .expectedToFormBingleWithBackslash):
                        .expectedToFormBingleWithCross
                case (.expectedToFormBingleWithSlash, .expectedToFormBingleWithCross):
                        .expectedToFormBingleWithCross
                case (.expectedToFormBingleWithBackslash, .empty):
                        .expectedToFormBingleWithBackslash
                case (.expectedToFormBingleWithBackslash, .expectedToFormBingleWithSlash):
                        .expectedToFormBingleWithCross
                case (.expectedToFormBingleWithBackslash, .expectedToFormBingleWithBackslash):
                        .expectedToFormBingleWithBackslash
                case (.expectedToFormBingleWithBackslash, .expectedToFormBingleWithCross):
                        .expectedToFormBingleWithCross
                case (.expectedToFormBingleWithCross, .empty):
                        .expectedToFormBingleWithCross
                case (.expectedToFormBingleWithCross, .expectedToFormBingleWithSlash):
                        .expectedToFormBingleWithCross
                case (.expectedToFormBingleWithCross, .expectedToFormBingleWithBackslash):
                        .expectedToFormBingleWithCross
                case (.expectedToFormBingleWithCross, .expectedToFormBingleWithCross):
                        .expectedToFormBingleWithCross
                }
            }

            public func minus(_ state: DiagonalLinkPlaceData) -> DiagonalLinkPlaceData {
                switch (self, state) {
                case (.empty, .empty):
                        .empty
                case (.empty, .expectedToFormBingleWithSlash):
                        .empty
                case (.empty, .expectedToFormBingleWithBackslash):
                        .empty
                case (.empty, .expectedToFormBingleWithCross):
                        .empty
                case (.expectedToFormBingleWithSlash, .empty):
                        .expectedToFormBingleWithSlash
                case (.expectedToFormBingleWithSlash, .expectedToFormBingleWithSlash):
                        .empty
                case (.expectedToFormBingleWithSlash, .expectedToFormBingleWithBackslash):
                        .expectedToFormBingleWithSlash
                case (.expectedToFormBingleWithSlash, .expectedToFormBingleWithCross):
                        .empty
                case (.expectedToFormBingleWithBackslash, .empty):
                        .expectedToFormBingleWithBackslash
                case (.expectedToFormBingleWithBackslash, .expectedToFormBingleWithSlash):
                        .expectedToFormBingleWithBackslash
                case (.expectedToFormBingleWithBackslash, .expectedToFormBingleWithBackslash):
                        .empty
                case (.expectedToFormBingleWithBackslash, .expectedToFormBingleWithCross):
                        .empty
                case (.expectedToFormBingleWithCross, .empty):
                        .expectedToFormBingleWithCross
                case (.expectedToFormBingleWithCross, .expectedToFormBingleWithSlash):
                        .expectedToFormBingleWithBackslash
                case (.expectedToFormBingleWithCross, .expectedToFormBingleWithBackslash):
                        .expectedToFormBingleWithSlash
                case (.expectedToFormBingleWithCross, .expectedToFormBingleWithCross):
                        .empty
                }
            }
        }
    }

    public struct NotPlaceableData: Codable, Hashable, Sendable {

        public var nodePlaceDataMatrix: Matrix<NodePlaceData>

        public init(nodePlaceDataMatrix: Matrix<NodePlaceData>) {
            self.nodePlaceDataMatrix = nodePlaceDataMatrix
        }

        public enum NodePlaceData: Codable, Hashable, Sendable {

            case empty
            case illegal
        }
    }
}
