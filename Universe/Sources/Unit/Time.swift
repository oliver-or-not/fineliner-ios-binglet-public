// MARK: - Module Dependency

import Foundation

// MARK: - Body

extension TimeInterval {

    // Lifecycle

    public init(seconds: Double) {
        self = seconds
    }

    public init(milliseconds: Double) {
        self = milliseconds / 1_000
    }

    public init(microseconds: Double) {
        self = microseconds / 1_000_000
    }

    public init(nanoseconds: Double) {
        self = nanoseconds / 1_000_000_000
    }

    // Variable Interface

    public var secondsDouble: Double {
        self
    }

    public var millisecondsDouble: Double {
        self * 1_000
    }

    public var microsecondsDouble: Double {
        self * 1_000_000
    }

    public var nanosecondsDouble: Double {
        self * 1_000_000_000
    }

    public var nanosecondsUInt64: UInt64 {
        UInt64(self * 1_000_000_000)
    }
}
