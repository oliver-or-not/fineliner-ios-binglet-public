// MARK: - Module Dependency

import Universe

// MARK: - Context

fileprivate typealias Constant = BasicGamePlateConstant

// MARK: - Body

extension GridVector {

    func toLinearIndex() ->  Int {
        self.y * Constant.gameBoardHorizontalNodeCount + self.x
    }
}
