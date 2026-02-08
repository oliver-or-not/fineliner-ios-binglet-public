// MARK: - Module Dependency

import Foundation

// MARK: - Body

enum PrimeEventDirectorConstant {

    static let windowModelThrownArrayMaxCount = 7
    static let windowModelWaitingArrayMaxCount = 7
    static let windowModelPerformingArrayMaxCount = 7
    static let windowModelCompletedArrayMaxCount = 7

    static let windowModelThrownRemovingTimeInterval: TimeInterval = 3
    static let windowModelCompletedRemovingTimeInterval: TimeInterval = 3
}
