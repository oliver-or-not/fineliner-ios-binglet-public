// MARK: - Module Dependency

import Foundation

// MARK: - Body

enum PlateStackAgentLogic {

    /// Smooth.
    ///
    /// t에는 0에서 1까지의 값만 넣어야 한다.
    static func smooth(t: CGFloat) -> CGFloat {
        let t2 = t*t
        let t3 = t2*t
        return t3 * (10.0 - 15.0*t + 6.0*t2)
    }
}
