// MARK: - Module Dependency

import Foundation

// MARK: - Body

extension CGFloat {

    public func distance(from another: CGFloat) -> CGFloat {
        abs(self - another)
    }
}

extension CGPoint {

    public func distance(from another: CGPoint) -> CGFloat {
        sqrt((x - another.x) * (x - another.x) + (y - another.y) * (y - another.y))
    }
}
