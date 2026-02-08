// MARK: - Module Dependency

import Foundation

// MARK: - Body

enum PlateStackAgentConstant {

    static let fps: Int = 120
    static let plateCornerRadius: CGFloat = 60
    static let distanceBetweenTwoPlates: CGFloat = 1

    static let platePushDurationForFadeIn: TimeInterval =
        .init(milliseconds: 500)
    static let platePushDurationForFromTrailing: TimeInterval =
        .init(milliseconds: 400)
    static let platePushDurationForFromBottom: TimeInterval =
        .init(milliseconds: 550)

    static let platePopDurationForFadeOut: TimeInterval =
        .init(milliseconds: 500)
    static let platePopDurationForToTrailing: TimeInterval =
        .init(milliseconds: 400)
    static let platePopDurationForToBottom: TimeInterval =
        .init(milliseconds: 550)
}
