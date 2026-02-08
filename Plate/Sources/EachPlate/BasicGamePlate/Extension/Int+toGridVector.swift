// MARK: - Module Dependency

import Universe

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

extension Int {

    func toGridVector() ->  GridVector {
        GridVector(
            x: self % Constant.gameBoardHorizontalNodeCount,
            y: self / Constant.gameBoardHorizontalNodeCount
        )
    }
}
