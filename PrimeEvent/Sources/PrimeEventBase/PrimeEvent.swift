// MARK: - Module Dependency

import Spectrum

// MARK: - Body

public struct BasePrimeEvent: GlobalEntity.PrimeEvent.Interface, Sendable {

    public let designation: PrimeEventDesignation
    public let task: Task

    public init(designation: PrimeEventDesignation, task: @escaping Task) {
        self.designation = designation
        self.task = task
    }

    public typealias Task = @MainActor @Sendable (
        _ primeEventDesignationWithPayload: PrimeEventDesignationWithPayload
    ) async -> Void
}
