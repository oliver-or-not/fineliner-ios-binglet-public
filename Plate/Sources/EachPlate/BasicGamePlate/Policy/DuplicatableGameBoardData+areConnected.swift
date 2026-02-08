// MARK: - Module Dependency

import Universe
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

extension DuplicatableGameBoardData {

    public func areConnected(_ nodeLinearIndex1: Int, nodeLinearIndex2: Int) -> Bool {
        guard 0 <= nodeLinearIndex1
                && nodeLinearIndex1 < Constant.gameBoardVerticalNodeCount * Constant.gameBoardHorizontalNodeCount else {
            return false
        }
        guard 0 <= nodeLinearIndex2
                && nodeLinearIndex2 < Constant.gameBoardVerticalNodeCount * Constant.gameBoardHorizontalNodeCount else {
            return false
        }
        let nodePoint1 = nodeLinearIndex1.toGridVector()
        let nodePoint2 = nodeLinearIndex2.toGridVector()
        let x1 = nodePoint1.x
        let y1 = nodePoint1.y

        let direction: OctaDirection? = unitDirection(from: nodePoint1, to: nodePoint2)
        switch direction {
        case .right:
            return horizontalLinkMatrix[y1][x1] == .occupied
        case .upRight:
            let diagonalLink = diagonalLinkMatrix[y1 - 1][x1]
            return diagonalLink == .slash || diagonalLink == .cross
        case .up:
            return verticalLinkMatrix[y1 - 1][x1] == .occupied
        case .upLeft:
            let diagonalLink = diagonalLinkMatrix[y1 - 1][x1 - 1]
            return diagonalLink == .backslash || diagonalLink == .cross
        case .left:
            return horizontalLinkMatrix[y1][x1 - 1] == .occupied
        case .downLeft:
            let diagonalLink = diagonalLinkMatrix[y1][x1 - 1]
            return diagonalLink == .slash || diagonalLink == .cross
        case .down:
            return verticalLinkMatrix[y1][x1] == .occupied
        case .downRight:
            let diagonalLink = diagonalLinkMatrix[y1][x1]
            return diagonalLink == .backslash || diagonalLink == .cross
        case nil:
            return false
        }
    }
}

fileprivate func unitDirection(from startVector: GridVector, to endVector: GridVector) -> OctaDirection? {
    switch (endVector.x - startVector.x, endVector.y - startVector.y) {
    case (1, 0):
            .right
    case (1, -1):
            .upRight
    case (0, -1):
            .up
    case (-1, -1):
            .upLeft
    case (-1, 0):
            .left
    case (-1, 1):
            .downLeft
    case (0, 1):
            .down
    case (1, 1):
            .downRight
    default:
        nil
    }
}
