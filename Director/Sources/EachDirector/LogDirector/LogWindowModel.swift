// MARK: - Module Dependency

import SwiftUI
import Spectrum

// MARK: - Body

@MainActor @Observable public final class LogWindowModel {

    public static let shared = LogWindowModel(
        isVisible: false,
        logFormArray: []
    )

    public var isVisible: Bool
    public var logFormArray: [LogForm]

    private init(
        isVisible: Bool,
        logFormArray: [LogForm]
    ) {
        self.isVisible = isVisible
        self.logFormArray = logFormArray
    }

    public struct LogForm {

        public var category: String
        public var logType: LogDirectorLogType
        public var message: String

        public init(category: String, logType: LogDirectorLogType, message: String) {
            self.category = category
            self.logType = logType
            self.message = message
        }
    }
}
