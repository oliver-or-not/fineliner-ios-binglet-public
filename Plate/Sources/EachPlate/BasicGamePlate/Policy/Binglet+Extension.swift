// MARK: - Module Dependency

import SwiftUI
import Universe
import Spectrum

// MARK: - Body

extension Binglet {

    var nodeColor: Color {
        spec.nodeColor
    }
    var nodeMatrix: Matrix<NodePlaceState> {
        spec.nodeMatrix
    }
    var horizontalLinkMatrix: Matrix<SimpleLinkPlaceState> {
        spec.horizontalLinkMatrix
    }
    var verticalLinkMatrix: Matrix<SimpleLinkPlaceState> {
        spec.verticalLinkMatrix
    }
    var diagonalLinkMatrix: Matrix<DiagonalLinkPlaceState> {
        spec.diagonalLinkMatrix
    }
    var topEmptyRowCount: UInt {
        spec.topEmptyRowCount
    }
    var leftEmptyRowCount: UInt {
        spec.leftEmptyRowCount
    }
    var bottomEmptyRowCount: UInt {
        spec.bottomEmptyRowCount
    }
    var rightEmptyRowCount: UInt {
        spec.rightEmptyRowCount
    }
}

fileprivate extension Binglet {

    var spec: BingletSpec {
        switch self {
        case .s:
            BingletSpec(
                nodeColor: Color(
                    UIColor { trait in
                        trait.userInterfaceStyle == .dark
                        ? UIColor(Color(hex: "B57171"))
                        : UIColor(Color(hex: "F19696"))
                    }
                ),
                nodeMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.empty, .occupied, .occupied, .empty],
                    [.empty, .occupied, .occupied, .empty],
                    [.empty, .empty, .empty, .empty],
                ],
                horizontalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.empty, .occupied, .occupied],
                    [.occupied, .occupied, .empty],
                    [.empty, .empty, .empty],
                ],
                verticalLinkMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.empty, .empty, .empty, .empty],
                    [.empty, .empty, .empty, .empty],
                ],
                diagonalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.backslash, .backslash, .backslash],
                    [.empty, .empty, .empty],
                ],
                topEmptyRowCount: 1,
                leftEmptyRowCount: 1,
                bottomEmptyRowCount: 1,
                rightEmptyRowCount: 1
            )
        case .z:
            BingletSpec(
                nodeColor: Color(
                    UIColor { trait in
                        trait.userInterfaceStyle == .dark
                        ? UIColor(Color(hex: "808CB5"))
                        : UIColor(Color(hex: "A9B9EF"))
                    }
                ),
                nodeMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.empty, .occupied, .occupied, .empty],
                    [.empty, .occupied, .occupied, .empty],
                    [.empty, .empty, .empty, .empty],
                ],
                horizontalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.occupied, .occupied, .empty],
                    [.empty, .occupied, .occupied],
                    [.empty, .empty, .empty],
                ],
                verticalLinkMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.empty, .empty, .empty, .empty],
                    [.empty, .empty, .empty, .empty],
                ],
                diagonalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.slash, .slash, .slash],
                    [.empty, .empty, .empty],
                ],
                topEmptyRowCount: 1,
                leftEmptyRowCount: 1,
                bottomEmptyRowCount: 1,
                rightEmptyRowCount: 1
            )
        case .leftRunner:
            BingletSpec(
                nodeColor: Color(
                    UIColor { trait in
                        trait.userInterfaceStyle == .dark
                        ? UIColor(Color(hex: "71B593"))
                        : UIColor(Color(hex: "8DE2B7"))
                    }
                ),
                nodeMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .occupied, .occupied, .empty],
                ],
                horizontalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.empty, .occupied, .empty],
                    [.empty, .empty, .empty],
                    [.occupied, .occupied, .empty],
                ],
                verticalLinkMatrix: [
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .empty, .empty, .empty],
                ],
                diagonalLinkMatrix: [
                    [.empty, .slash, .empty],
                    [.empty, .empty, .empty],
                    [.empty, .backslash, .empty],
                ],
                topEmptyRowCount: 1,
                leftEmptyRowCount: 1,
                bottomEmptyRowCount: 0,
                rightEmptyRowCount: 1
            )
        case .rightRunner:
            BingletSpec(
                nodeColor: Color(
                    UIColor { trait in
                        trait.userInterfaceStyle == .dark
                        ? UIColor(Color(hex: "B589A6"))
                        : UIColor(Color(hex: "F1B6DD"))
                    }
                ),
                nodeMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.empty, .empty, .occupied, .empty],
                    [.empty, .empty, .occupied, .empty],
                    [.empty, .occupied, .occupied, .empty],
                ],
                horizontalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.empty, .occupied, .empty],
                    [.empty, .empty, .empty],
                    [.empty, .occupied, .occupied],
                ],
                verticalLinkMatrix: [
                    [.empty, .empty, .occupied, .empty],
                    [.empty, .empty, .occupied, .empty],
                    [.empty, .empty, .empty, .empty],
                ],
                diagonalLinkMatrix: [
                    [.empty, .backslash, .empty],
                    [.empty, .empty, .empty],
                    [.empty, .slash, .empty],
                ],
                topEmptyRowCount: 1,
                leftEmptyRowCount: 1,
                bottomEmptyRowCount: 0,
                rightEmptyRowCount: 1
            )
        case .leftTiltedBalance:
            BingletSpec(
                nodeColor: Color(
                    UIColor { trait in
                        trait.userInterfaceStyle == .dark
                        ? UIColor(Color(hex: "978BBD"))
                        : UIColor(Color(hex: "C1B1F1"))
                    }
                ),
                nodeMatrix: [
                    [.empty, .empty, .occupied, .empty],
                    [.empty, .occupied, .occupied, .empty],
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .empty, .empty, .empty],
                ],
                horizontalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.empty, .empty, .occupied],
                    [.occupied, .empty, .empty],
                    [.empty, .empty, .empty],
                ],
                verticalLinkMatrix: [
                    [.empty, .empty, .occupied, .empty],
                    [.empty, .occupied, .occupied, .empty],
                    [.empty, .occupied, .empty, .empty],
                ],
                diagonalLinkMatrix: [
                    [.empty, .slash, .empty],
                    [.empty, .empty, .empty],
                    [.empty, .empty, .empty],
                ],
                topEmptyRowCount: 0,
                leftEmptyRowCount: 1,
                bottomEmptyRowCount: 1,
                rightEmptyRowCount: 1
            )
        case .rightTiltedBalance:
            BingletSpec(
                nodeColor: Color(
                    UIColor { trait in
                        trait.userInterfaceStyle == .dark
                        ? UIColor(Color(hex: "82994F"))
                        : UIColor(Color(hex: "AECD6A"))
                    }
                ),
                nodeMatrix: [
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .occupied, .occupied, .empty],
                    [.empty, .empty, .occupied, .empty],
                    [.empty, .empty, .empty, .empty],
                ],
                horizontalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.occupied, .empty, .empty],
                    [.empty, .empty, .occupied],
                    [.empty, .empty, .empty],
                ],
                verticalLinkMatrix: [
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .occupied, .occupied, .empty],
                    [.empty, .empty, .occupied, .empty],
                ],
                diagonalLinkMatrix: [
                    [.empty, .backslash, .empty],
                    [.empty, .empty, .empty],
                    [.empty, .empty, .empty],
                ],
                topEmptyRowCount: 0,
                leftEmptyRowCount: 1,
                bottomEmptyRowCount: 1,
                rightEmptyRowCount: 1
            )
        case .leftStair:
            BingletSpec(
                nodeColor: Color(
                    UIColor { trait in
                        trait.userInterfaceStyle == .dark
                        ? UIColor(Color(hex: "B07F55"))
                        : UIColor(Color(hex: "EDAB72"))
                    }
                ),
                nodeMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.occupied, .occupied, .empty, .empty],
                    [.empty, .empty, .occupied, .occupied],
                    [.empty, .empty, .empty, .empty],
                ],
                horizontalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.occupied, .empty, .empty],
                    [.empty, .empty, .occupied],
                    [.empty, .empty, .empty],
                ],
                verticalLinkMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.occupied, .occupied, .occupied, .occupied],
                    [.empty, .empty, .empty, .empty],
                ],
                diagonalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.empty, .backslash, .empty],
                    [.empty, .empty, .empty],
                ],
                topEmptyRowCount: 1,
                leftEmptyRowCount: 0,
                bottomEmptyRowCount: 1,
                rightEmptyRowCount: 0
            )
        case .rightStair:
            BingletSpec(
                nodeColor: Color(
                    UIColor { trait in
                        trait.userInterfaceStyle == .dark
                        ? UIColor(Color(hex: "AB70A2"))
                        : UIColor(Color(hex: "E194D5"))
                    }
                ),
                nodeMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.empty, .empty, .occupied, .occupied],
                    [.occupied, .occupied, .empty, .empty],
                    [.empty, .empty, .empty, .empty],
                ],
                horizontalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.empty, .empty, .occupied],
                    [.occupied, .empty, .empty],
                    [.empty, .empty, .empty],
                ],
                verticalLinkMatrix: [
                    [.empty, .empty, .empty, .empty],
                    [.occupied, .occupied, .occupied, .occupied],
                    [.empty, .empty, .empty, .empty],
                ],
                diagonalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.empty, .slash, .empty],
                    [.empty, .empty, .empty],
                ],
                topEmptyRowCount: 1,
                leftEmptyRowCount: 0,
                bottomEmptyRowCount: 1,
                rightEmptyRowCount: 0
            )
        case .crab:
            BingletSpec(
                nodeColor: Color(
                    UIColor { trait in
                        trait.userInterfaceStyle == .dark
                        ? UIColor(Color(hex: "9C9533"))
                        : UIColor(Color(hex: "D0C744"))
                    }
                ),
                nodeMatrix: [
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .empty, .occupied, .occupied],
                    [.empty, .empty, .empty, .empty],
                ],
                horizontalLinkMatrix: [
                    [.empty, .occupied, .empty],
                    [.occupied, .empty, .empty],
                    [.empty, .empty, .occupied],
                    [.empty, .empty, .empty],
                ],
                verticalLinkMatrix: [
                    [.empty, .occupied, .empty, .empty],
                    [.empty, .empty, .empty, .occupied],
                    [.empty, .empty, .occupied, .empty],
                ],
                diagonalLinkMatrix: [
                    [.empty, .empty, .empty],
                    [.empty, .backslash, .empty],
                    [.empty, .empty, .empty],
                ],
                topEmptyRowCount: 0,
                leftEmptyRowCount: 1,
                bottomEmptyRowCount: 1,
                rightEmptyRowCount: 0
            )
        }
    }
}

fileprivate struct BingletSpec {

    var nodeColor: Color
    var nodeMatrix: Matrix<NodePlaceState>
    var horizontalLinkMatrix: Matrix<SimpleLinkPlaceState>
    var verticalLinkMatrix: Matrix<SimpleLinkPlaceState>
    var diagonalLinkMatrix: Matrix<DiagonalLinkPlaceState>
    var topEmptyRowCount: UInt
    var leftEmptyRowCount: UInt
    var bottomEmptyRowCount: UInt
    var rightEmptyRowCount: UInt
}
