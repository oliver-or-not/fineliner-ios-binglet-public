// MARK: - Module Dependency

import Spectrum

// MARK: - Body

extension GlobalEntity {

    public enum PrimeEvent {

        public protocol Interface: GlobalEntity.Interface, Sendable {

            /// 식별 수단.
            nonisolated var designation: PrimeEventDesignation { get }
            /// Prime event 에 대응되는 작업.
            nonisolated var task: BasePrimeEvent.Task { get }
        }
    }
}


