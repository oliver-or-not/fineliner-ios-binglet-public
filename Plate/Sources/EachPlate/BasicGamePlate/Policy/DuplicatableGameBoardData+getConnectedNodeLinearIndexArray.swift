// MARK: - Module Dependency

import Universe
import Spectrum

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

extension DuplicatableGameBoardData {

    public func getConnectedNodeLinearIndexArray(_ nodeLinearIndex: Int) -> [Int] {
        guard 0 <= nodeLinearIndex
                && nodeLinearIndex < Constant.gameBoardVerticalNodeCount * Constant.gameBoardHorizontalNodeCount else {
            return []
        }
        let nodePoint = nodeLinearIndex.toGridVector()
        let x = nodePoint.x
        let y = nodePoint.y
        var connectedNodeLinearIndexArray: [Int] = []
        connectedNodeLinearIndexArray.reserveCapacity(8)

        // RIGHT
        if x < Constant.gameBoardHorizontalNodeCount - 1, horizontalLinkMatrix[y][x] == .occupied {
            connectedNodeLinearIndexArray.append((nodePoint + OctaDirection.right.unitVector).toLinearIndex())
        }
        // UP-RIGHT
        if x < Constant.gameBoardHorizontalNodeCount - 1, y > 0 {
            let v = diagonalLinkMatrix[y-1][x]
            if v == .slash || v == .cross {
                connectedNodeLinearIndexArray.append((nodePoint + OctaDirection.upRight.unitVector).toLinearIndex())
            }
        }
        // UP
        if y > 0, verticalLinkMatrix[y-1][x] == .occupied {
            connectedNodeLinearIndexArray.append((nodePoint + OctaDirection.up.unitVector).toLinearIndex())
        }
        // UP-LEFT
        if x > 0, y > 0 {
            let v = diagonalLinkMatrix[y-1][x-1]
            if v == .backslash || v == .cross {
                connectedNodeLinearIndexArray.append((nodePoint + OctaDirection.upLeft.unitVector).toLinearIndex())
            }
        }
        // LEFT
        if x > 0, horizontalLinkMatrix[y][x-1] == .occupied {
            connectedNodeLinearIndexArray.append((nodePoint + OctaDirection.left.unitVector).toLinearIndex())
        }
        // DOWN-LEFT
        if x > 0, y < Constant.gameBoardVerticalNodeCount - 1 {
            let v = diagonalLinkMatrix[y][x-1]
            if v == .slash || v == .cross {
                connectedNodeLinearIndexArray.append((nodePoint + OctaDirection.downLeft.unitVector).toLinearIndex())
            }
        }
        // DOWN
        if y < Constant.gameBoardVerticalNodeCount - 1, verticalLinkMatrix[y][x] == .occupied {
            connectedNodeLinearIndexArray.append((nodePoint + OctaDirection.down.unitVector).toLinearIndex())
        }
        // DOWN-RIGHT
        if x < Constant.gameBoardHorizontalNodeCount - 1, y < Constant.gameBoardVerticalNodeCount - 1 {
            let v = diagonalLinkMatrix[y][x]
            if v == .backslash || v == .cross {
                connectedNodeLinearIndexArray.append((nodePoint + OctaDirection.downRight.unitVector).toLinearIndex())
            }
        }

        return connectedNodeLinearIndexArray
    }
}
